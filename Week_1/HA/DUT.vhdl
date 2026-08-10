library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(
        input_vector  : in std_logic_vector(1 downto 0);
        output_vector : out std_logic_vector(1 downto 0)
    );
end entity;

architecture DutWrap of DUT is

    component HALF_ADD
        port(
            A, B   : in std_logic;
            SUM : out std_logic;
				CARRY : out std_logic
        );
    end component;

begin

    HA1 : HALF_ADD
        port map(
            A      => input_vector(0),
            B      => input_vector(1),
            SUM => output_vector(0),
				CARRY => output_vector(1)
        );

end DutWrap;