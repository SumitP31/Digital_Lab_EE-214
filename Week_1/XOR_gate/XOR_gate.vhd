library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity XOR_GATE is
    port(
        A : in std_logic;
        B : in std_logic;
        Y : out std_logic
    );
end XOR_GATE;

architecture Structural of XOR_GATE is

signal n1,n2,n3,n4 : std_logic;

begin

    G1 : NAND_2 port map(A=>A,B=>A,Y=>n1);
    G2 : NAND_2 port map(A=>B,B=>B,Y=>n2);
    G3 : NAND_2 port map(A=>n1,B=>B,Y=>n3);
    G4 : NAND_2 port map(A=>A,B=>n2,Y=>n4);
	 G5 : NAND_2 port map(A=>n3,B=>n4,Y=>Y);

end Structural;