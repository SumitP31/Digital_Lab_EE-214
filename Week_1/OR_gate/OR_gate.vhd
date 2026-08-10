library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity OR_GATE is
    port(
        A : in std_logic;
        B : in std_logic;
        Y : out std_logic
    );
end OR_GATE;

architecture Structural of OR_GATE is

signal n1,n2 : std_logic;

begin

    G1 : NAND_2 port map(A=>A,B=>A,Y=>n1);
    G2 : NAND_2 port map(A=>B,B=>B,Y=>n2);
    G3 : NAND_2 port map(A=>n1,B=>n2,Y=>Y);

end Structural;