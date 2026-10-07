library ieee;
use ieee.std_logic_1164.all;

package Flipflops is

    component dff_set is
        port(
            D, clock, set : in std_logic;
            Q             : out std_logic
        );
    end component;

    component dff_reset is
        port(
            D, clock, reset : in std_logic;
            Q               : out std_logic
        );
    end component;

end package Flipflops;
