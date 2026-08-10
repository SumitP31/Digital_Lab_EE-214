library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity AND_GATE is
    port(
        A : in std_logic;
        B : in std_logic;
        Y : out std_logic
    );
end AND_GATE;

architecture Structural of AND_GATE is
    signal n1 : std_logic;
begin

    G1 : NAND_2 port map(A=>A, B=>B, Y=>n1);
    G2 : NAND_2 port map(A=>n1, B=>n1, Y=>Y);

end Structural;