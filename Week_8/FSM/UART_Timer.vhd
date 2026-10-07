library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_Timer is
    generic (
        g_CLKS_PER_BIT : integer := 521 -- For 5 MHz clock and 9600 baud
    );
    port (
        i_Clk       : in  std_logic;  -- 50 MHz input clock
        i_Reset     : in  std_logic;  -- Hardware Reset button
        i_RX_Serial : in  std_logic;
        o_LED       : out std_logic_vector(7 downto 0)
    );
end UART_Timer;

architecture rtl of UART_Timer is

    -- Clocks
    signal clk_5MHz : std_logic;
    signal clk_1Hz  : std_logic;
    signal clk_5Hz  : std_logic;

    -- UART Signals
    type t_SM_Main is (s_Idle, s_RX_Start_Bit, s_RX_Data_Bits,
                        s_RX_Stop_Bit, s_Cleanup);
    signal r_SM_Main    : t_SM_Main := s_Idle;
    signal r_RX_Data_R  : std_logic := '0';
    signal r_RX_Data    : std_logic := '0';
    signal r_Clk_Count  : integer range 0 to g_CLKS_PER_BIT-1 := 0;
    signal r_Bit_Index  : integer range 0 to 7 := 0;
    signal r_RX_Byte    : std_logic_vector(7 downto 0) := (others => '0');
    signal r_RX_DV      : std_logic := '0';

    -- Clock Divider Component
    component ClockDiv is
        port (
            clk_in       : in  std_logic;
            reset        : in  std_logic;
            clk_out_5MHz : out std_logic;
            clk_out_1Hz  : out std_logic;
            clk_out_5Hz  : out std_logic
        );
    end component;

    -- Timer FSM Component
    component TimerFSM is
        port (
            i_Clk     : in  std_logic;
            i_Reset   : in  std_logic;
            i_RX_DV   : in  std_logic;
            i_RX_Byte : in  std_logic_vector(7 downto 0);
            i_Clk_1Hz : in  std_logic;
            i_Clk_5Hz : in  std_logic;
            o_LED     : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    ----------------------------------------------------------------
    -- Clock Divider instantiation
    ----------------------------------------------------------------
    Inst_ClockDiv : ClockDiv
        port map (
            clk_in       => i_Clk,
            reset        => i_Reset,
            clk_out_5MHz => clk_5MHz,
            clk_out_1Hz  => clk_1Hz,
            clk_out_5Hz  => clk_5Hz
        );

    ----------------------------------------------------------------
    -- UART_RX Process (clocked on 5 MHz -> 9600 baud via g_CLKS_PER_BIT)
    ----------------------------------------------------------------
    p_UART_RX : process (clk_5MHz, i_Reset)
    begin
        if i_Reset = '1' then
            r_SM_Main   <= s_Idle;
            r_RX_DV     <= '0';
            r_Clk_Count <= 0;
            r_Bit_Index <= 0;
        elsif rising_edge(clk_5MHz) then

            r_RX_Data_R <= i_RX_Serial;   -- double-flop for metastability
            r_RX_Data   <= r_RX_Data_R;

            case r_SM_Main is

                when s_Idle =>
                    r_RX_DV     <= '0';
                    r_Clk_Count <= 0;
                    r_Bit_Index <= 0;
                    if r_RX_Data = '0' then        -- Start bit detected
                        r_SM_Main <= s_RX_Start_Bit;
                    end if;

                when s_RX_Start_Bit =>
                    if r_Clk_Count = (g_CLKS_PER_BIT-1)/2 then
                        if r_RX_Data = '0' then     -- confirm still low (mid start bit)
                            r_Clk_Count <= 0;
                            r_SM_Main   <= s_RX_Data_Bits;
                        else
                            r_SM_Main <= s_Idle;    -- false start bit
                        end if;
                    else
                        r_Clk_Count <= r_Clk_Count + 1;
                    end if;

                when s_RX_Data_Bits =>
                    if r_Clk_Count < g_CLKS_PER_BIT-1 then
                        r_Clk_Count <= r_Clk_Count + 1;
                    else
                        r_Clk_Count <= 0;
                        r_RX_Byte(r_Bit_Index) <= r_RX_Data;
                        if r_Bit_Index < 7 then
                            r_Bit_Index <= r_Bit_Index + 1;
                        else
                            r_Bit_Index <= 0;
                            r_SM_Main   <= s_RX_Stop_Bit;
                        end if;
                    end if;

                when s_RX_Stop_Bit =>
                    if r_Clk_Count < g_CLKS_PER_BIT-1 then
                        r_Clk_Count <= r_Clk_Count + 1;
                    else
                        r_RX_DV     <= '1';
                        r_Clk_Count <= 0;
                        r_SM_Main   <= s_Cleanup;
                    end if;

                when s_Cleanup =>
                    r_RX_DV   <= '0';
                    r_SM_Main <= s_Idle;

                when others =>
                    r_SM_Main <= s_Idle;

            end case;
        end if;
    end process p_UART_RX;

    ----------------------------------------------------------------
    -- Timer FSM instantiation (architecture now lives in TimerFSM.vhd)
    ----------------------------------------------------------------
    Inst_TimerFSM : TimerFSM
        port map (
            i_Clk     => i_Clk,
            i_Reset   => i_Reset,
            i_RX_DV   => r_RX_DV,
            i_RX_Byte => r_RX_Byte,
            i_Clk_1Hz => clk_1Hz,
            i_Clk_5Hz => clk_5Hz,
            o_LED     => o_LED
        );

end rtl;