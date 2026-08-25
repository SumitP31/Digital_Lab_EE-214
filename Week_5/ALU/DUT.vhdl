-- A DUT entity is used to wrap your ALU design.

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(
        input_vector  : in  std_logic_vector(9 downto 0);
        output_vector : out std_logic_vector(7 downto 0)
    );
end entity DUT;


architecture DutWrap of DUT is

    component alu_beh is
        port(
            S : in  std_logic_vector(1 downto 0);
            A : in  std_logic_vector(3 downto 0);
            B : in  std_logic_vector(3 downto 0);
            Y : out std_logic_vector(7 downto 0)
        );
    end component;

begin



    alu_instance: alu_beh
        port map(
            S => input_vector(9 downto 8),
            A => input_vector(7 downto 4),
            B => input_vector(3 downto 0),
            Y => output_vector
        );

end DutWrap;