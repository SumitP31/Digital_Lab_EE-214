library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ClockDiv is
    port (
        clk_in       : in  std_logic;  -- 50 MHz input clock
        reset        : in  std_logic;
        clk_out_5MHz : out std_logic;
        clk_out_1Hz  : out std_logic;
        clk_out_5Hz  : out std_logic
    );
end ClockDiv;

architecture rtl of ClockDiv is

    -- 50 MHz / 5 MHz  = divide-by-10  -> toggle every 5 input cycles
    constant c_5MHZ_DIV : integer := 5;

    -- 50 MHz / 1 Hz   = divide-by-50,000,000 -> toggle every 25,000,000 cycles
    constant c_1HZ_DIV  : integer := 25000000;

    -- 50 MHz / 5 Hz   = divide-by-10,000,000 -> toggle every 5,000,000 cycles
    constant c_5HZ_DIV  : integer := 5000000;

    signal r_Count_5MHz : integer range 0 to c_5MHZ_DIV-1 := 0;
    signal r_Count_1Hz  : integer range 0 to c_1HZ_DIV-1  := 0;
    signal r_Count_5Hz  : integer range 0 to c_5HZ_DIV-1  := 0;

    signal r_Clk_5MHz : std_logic := '0';
    signal r_Clk_1Hz  : std_logic := '0';
    signal r_Clk_5Hz  : std_logic := '0';

begin

    ----------------------------------------------------------------
    -- 5 MHz Clock Generation (Baud Rate Generator source)
    ----------------------------------------------------------------
    p_Clk_5MHz : process (clk_in, reset)
    begin
        if reset = '1' then
            r_Count_5MHz <= 0;
            r_Clk_5MHz   <= '0';
        elsif rising_edge(clk_in) then
            if r_Count_5MHz = c_5MHZ_DIV-1 then
                r_Count_5MHz <= 0;
                r_Clk_5MHz   <= not r_Clk_5MHz;
            else
                r_Count_5MHz <= r_Count_5MHz + 1;
            end if;
        end if;
    end process p_Clk_5MHz;

    ----------------------------------------------------------------
    -- 1 Hz Clock Generation (Countdown Timer Tick)
    ----------------------------------------------------------------
    p_Clk_1Hz : process (clk_in, reset)
    begin
        if reset = '1' then
            r_Count_1Hz <= 0;
            r_Clk_1Hz   <= '0';
        elsif rising_edge(clk_in) then
            if r_Count_1Hz = c_1HZ_DIV-1 then
                r_Count_1Hz <= 0;
                r_Clk_1Hz   <= not r_Clk_1Hz;
            else
                r_Count_1Hz <= r_Count_1Hz + 1;
            end if;
        end if;
    end process p_Clk_1Hz;

    ----------------------------------------------------------------
    -- 5 Hz Clock Generation (Blink Rate for DONE state)
    ----------------------------------------------------------------
    p_Clk_5Hz : process (clk_in, reset)
    begin
        if reset = '1' then
            r_Count_5Hz <= 0;
            r_Clk_5Hz   <= '0';
        elsif rising_edge(clk_in) then
            if r_Count_5Hz = c_5HZ_DIV-1 then
                r_Count_5Hz <= 0;
                r_Clk_5Hz   <= not r_Clk_5Hz;
            else
                r_Count_5Hz <= r_Count_5Hz + 1;
            end if;
        end if;
    end process p_Clk_5Hz;

    ----------------------------------------------------------------
    -- Output Assignments
    ----------------------------------------------------------------
    clk_out_5MHz <= r_Clk_5MHz;
    clk_out_1Hz  <= r_Clk_1Hz;
    clk_out_5Hz  <= r_Clk_5Hz;

end rtl;