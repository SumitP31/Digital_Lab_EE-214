library ieee;
use ieee.std_logic_1164.all;

entity dff_reset is
    port(
        D     : in  std_logic;
        clock : in  std_logic;
        reset : in  std_logic;
        Q     : out std_logic
    );
end entity dff_reset;


architecture behav of dff_reset is
begin

    dff_reset_proc : process(clock, reset)
    begin

        if (reset = '1') then
            Q <= '0';

        elsif (clock'event and clock = '1') then
            Q <= D;

        end if;

    end process dff_reset_proc;

end architecture behav;