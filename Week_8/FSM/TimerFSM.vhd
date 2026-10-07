library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TimerFSM is
    port (
        i_Clk     : in  std_logic;                     -- 50 MHz main clock
        i_Reset   : in  std_logic;
        i_RX_DV   : in  std_logic;                      -- 1-cycle pulse: new UART byte ready
        i_RX_Byte : in  std_logic_vector(7 downto 0);    -- the received ASCII byte
        i_Clk_1Hz : in  std_logic;                       -- 1 Hz derived clock (countdown tick)
        i_Clk_5Hz : in  std_logic;                       -- 5 Hz derived clock (blink tick)
        o_LED     : out std_logic_vector(7 downto 0)
    );
end TimerFSM;

architecture rtl of TimerFSM is

    type t_Timer_State is (S_DIGIT_1, S_DIGIT_2, S_DIGIT_3, S_PROCEED, S_DONE);
    signal r_Timer_State : t_Timer_State := S_DIGIT_1;

    signal r_Accumulator : integer := 0;
    signal r_Timer_Count : integer range 0 to 255 := 0;
    signal r_Blink_State : std_logic := '0';

    -- helper signals (edge-detection / one-shot load flag)
    signal r_RX_DV_prev     : std_logic := '0';
    signal r_clk_1Hz_prev   : std_logic := '0';
    signal r_clk_5Hz_prev   : std_logic := '0';
    signal r_Countdown_Load : std_logic := '0';

begin

    ----------------------------------------------------------------
    -- Timer FSM Process (runs on main 50 MHz clock; slower derived
    -- clocks are sampled and edge-detected as "tick" pulses so that
    -- r_Timer_State has a single clock driving it)
    ----------------------------------------------------------------
    p_Timer_FSM : process (i_Clk, i_Reset)
    begin
        if i_Reset = '1' then
            r_Timer_State    <= S_DIGIT_1;
            r_Accumulator    <= 0;
            r_Timer_Count    <= 0;
            r_Blink_State    <= '0';
            r_RX_DV_prev     <= '0';
            r_clk_1Hz_prev   <= '0';
            r_clk_5Hz_prev   <= '0';
            r_Countdown_Load <= '0';

        elsif rising_edge(i_Clk) then

            -- register previous values of the slow signals for edge detect
            r_RX_DV_prev   <= i_RX_DV;
            r_clk_1Hz_prev <= i_Clk_1Hz;
            r_clk_5Hz_prev <= i_Clk_5Hz;

            case r_Timer_State is

                ------------------------------------------------------
                when S_DIGIT_1 =>
                    if (i_RX_DV = '1' and r_RX_DV_prev = '0') then
                        if i_RX_Byte = x"0D" then                 -- Enter
                            r_Timer_State <= S_PROCEED;
                        elsif i_RX_Byte >= x"30" and i_RX_Byte <= x"39" then
                            r_Accumulator <= to_integer(unsigned(i_RX_Byte)) - 48;
                            r_Timer_State <= S_DIGIT_2;
                        end if;
                    end if;

                ------------------------------------------------------
                when S_DIGIT_2 =>
                    if (i_RX_DV = '1' and r_RX_DV_prev = '0') then
                        if i_RX_Byte = x"0D" then                 -- Enter (1-digit number)
                            r_Timer_State <= S_PROCEED;
                        elsif i_RX_Byte >= x"30" and i_RX_Byte <= x"39" then
                            r_Accumulator <= r_Accumulator * 10 +
                                             (to_integer(unsigned(i_RX_Byte)) - 48);
                            r_Timer_State <= S_DIGIT_3;
                        end if;
                    end if;

                ------------------------------------------------------
                when S_DIGIT_3 =>
                    if (i_RX_DV = '1' and r_RX_DV_prev = '0') then
                        if i_RX_Byte = x"0D" then                 -- Enter (2 or 3-digit number)
                            r_Timer_State <= S_PROCEED;
                        elsif i_RX_Byte >= x"30" and i_RX_Byte <= x"39" then
                            -- stays in DIGIT_3; a 4th+ digit keeps multiplying,
                            -- which naturally pushes the value past 255
                            r_Accumulator <= r_Accumulator * 10 +
                                             (to_integer(unsigned(i_RX_Byte)) - 48);
                        end if;
                    end if;

                ------------------------------------------------------
                when S_PROCEED =>
                    if r_Countdown_Load = '0' then
                        -- one-shot validation on entry to PROCEED
                        if r_Accumulator > 255 then
                            r_Accumulator <= 0;
                            r_Timer_State <= S_DIGIT_1;
                        else
                            r_Timer_Count    <= r_Accumulator;
                            r_Countdown_Load <= '1';
                        end if;
                    else
                        -- countdown active: decrement once per 1 Hz tick
                        if (i_Clk_1Hz = '1' and r_clk_1Hz_prev = '0') then
                            if r_Timer_Count = 0 then
                                r_Timer_State    <= S_DONE;
                                r_Countdown_Load <= '0';
                                r_Accumulator    <= 0;
                            else
                                r_Timer_Count <= r_Timer_Count - 1;
                            end if;
                        end if;
                    end if;

                ------------------------------------------------------
                when S_DONE =>
                    -- blink all LEDs at 5 Hz indefinitely until i_Reset
                    if (i_Clk_5Hz = '1' and r_clk_5Hz_prev = '0') then
                        r_Blink_State <= not r_Blink_State;
                    end if;

                when others =>
                    r_Timer_State <= S_DIGIT_1;

            end case;
        end if;
    end process p_Timer_FSM;

    ----------------------------------------------------------------
    -- LED Output (combinational)
    ----------------------------------------------------------------
    o_LED <= std_logic_vector(to_unsigned(r_Timer_Count, 8)) when r_Timer_State = S_PROCEED else
             (others => r_Blink_State)                        when r_Timer_State = S_DONE    else
             (others => '0');

end rtl;