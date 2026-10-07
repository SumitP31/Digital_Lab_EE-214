library ieee;
use ieee.std_logic_1164.all;

entity ClockDiv is
    port(
        clk_in       : in  std_logic;
        reset        : in  std_logic;
        clk_out_5MHz : out std_logic;
        clk_out_2Hz  : out std_logic
    );
end entity ClockDiv;

architecture behavioral of ClockDiv is
    signal clk5 : std_logic := '0';
    signal clk2 : std_logic := '0';

    signal count5 : integer range 1 to 5 := 1;
    signal count2 : integer range 1 to 12500000 := 1;
begin

    process(clk_in, reset)
    begin
        if reset = '1' then
            clk5 <= '0';
            clk2 <= '0';
            count5 <= 1;
            count2 <= 1;

        elsif rising_edge(clk_in) then

            -- 50 MHz -> 5 MHz
            if count5 = 5 then
                count5 <= 1;
                clk5 <= not clk5;
            else
                count5 <= count5 + 1;
            end if;

            -- 50 MHz -> 2 Hz
            if count2 = 12500000 then
                count2 <= 1;
                clk2 <= not clk2;
            else
                count2 <= count2 + 1;
            end if;

        end if;
    end process;

    clk_out_5MHz <= clk5;
    clk_out_2Hz  <= clk2;

end architecture behavioral;
