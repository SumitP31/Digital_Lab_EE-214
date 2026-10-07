library ieee;
use ieee.std_logic_1164.all;

entity dff_set is
    port(
        D     : in  std_logic;
        clock : in  std_logic;
        set   : in  std_logic;
        Q     : out std_logic
    );
end entity dff_set;


architecture behav of dff_set is
begin

    dff_set_proc : process(clock, set)
    begin

        if (set = '1') then
            Q <= '1';

        elsif (clock'event and clock = '1') then
            Q <= D;

        end if;

    end process dff_set_proc;

end architecture behav;