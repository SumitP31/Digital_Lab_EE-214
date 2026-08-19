-- A DUT entity is used to wrap your design.
-- This wrapper connects the trace-file input vector
-- to the Universal Rotator.

library ieee;
use ieee.std_logic_1164.all;


entity DUT is
    port(
        input_vector  : in  std_logic_vector(11 downto 0);
        output_vector : out std_logic_vector(7 downto 0)
    );
end entity;


architecture DutWrap of DUT is

    -- Instantiate your Universal Rotator here
    component universal_rotator is
        port(
            L      : in  std_logic;
            b      : in  std_logic_vector(2 downto 0);
            a      : in  std_logic_vector(7 downto 0);
            output : out std_logic_vector(7 downto 0)
        );
    end component;


begin


    rotator_instance: universal_rotator
        port map(
            L      => input_vector(11),

            b(2)   => input_vector(10),
            b(1)   => input_vector(9),
            b(0)   => input_vector(8),

            a(7)   => input_vector(7),
            a(6)   => input_vector(6),
            a(5)   => input_vector(5),
            a(4)   => input_vector(4),
            a(3)   => input_vector(3),
            a(2)   => input_vector(2),
            a(1)   => input_vector(1),
            a(0)   => input_vector(0),

            output(7) => output_vector(7),
            output(6) => output_vector(6),
            output(5) => output_vector(5),
            output(4) => output_vector(4),
            output(3) => output_vector(3),
            output(2) => output_vector(2),
            output(1) => output_vector(1),
            output(0) => output_vector(0)
        );


end DutWrap;