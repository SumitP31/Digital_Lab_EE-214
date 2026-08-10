library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(
        input_vector  : in std_logic_vector(1 downto 0);
        output_vector : out std_logic_vector(0 downto 0)
    );
end entity;

architecture DutWrap of DUT is

    component AND_GATE
        port(
            A, B   : in std_logic;
            Y : out std_logic
        );
    end component;

begin

    AND1 : AND_GATE
        port map(
            A      => input_vector(0),
            B      => input_vector(1),
            Y => output_vector(0)
        );

end DutWrap;