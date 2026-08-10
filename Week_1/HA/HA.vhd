library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity HALF_ADD is
    port(
        A     : in std_logic;
        B     : in std_logic;
        SUM   : out std_logic;
        CARRY : out std_logic
    );
end HALF_ADD;

architecture Structural of HALF_ADD is

signal n1,n2,n3 : std_logic;

begin

    -- XOR

    G1 : NAND_2 port map(A=>A,B=>B,Y=>n1);
    G2 : NAND_2 port map(A=>A,B=>n1,Y=>n2);
    G3 : NAND_2 port map(A=>B,B=>n1,Y=>n3);
    G4 : NAND_2 port map(A=>n2,B=>n3,Y=>SUM);

    -- Carry = A AND B

    G5 : NAND_2 port map(A=>n1,B=>n1,Y=>CARRY);

end Structural;