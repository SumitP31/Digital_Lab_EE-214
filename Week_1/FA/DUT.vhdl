library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(
        input_vector  : in  std_logic_vector(2 downto 0);
        output_vector : out std_logic_vector(1 downto 0)
    );
end entity;

architecture DutWrap of DUT is

    component FULL_ADDER
        port(
            A     : in std_logic;
            B     : in std_logic;
            Cin   : in std_logic;
            SUM   : out std_logic;
            CARRY : out std_logic
        );
    end component;

begin

    FA1 : FULL_ADDER
        port map(
            A     => input_vector(2),
            B     => input_vector(1),
            Cin   => input_vector(0),
            SUM   => output_vector(1),
            CARRY => output_vector(0)
        );

end DutWrap;