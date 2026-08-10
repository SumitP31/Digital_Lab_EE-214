library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity FULL_ADDER is
    port(
        A     : in std_logic;
        B     : in std_logic;
        Cin   : in std_logic;
        SUM   : out std_logic;
        CARRY : out std_logic
    );
end FULL_ADDER;

architecture Structural of FULL_ADDER is

signal n1,n2,n3 : std_logic;
signal xab : std_logic;
signal n4,n5,n6 : std_logic;

begin

    -- First XOR (A XOR B)

    G1 : NAND_2 port map(A=>A,B=>B,Y=>n1);
    G2 : NAND_2 port map(A=>A,B=>n1,Y=>n2);
    G3 : NAND_2 port map(A=>B,B=>n1,Y=>n3);
    G4 : NAND_2 port map(A=>n2,B=>n3,Y=>xab);

    -- Second XOR (xab XOR Cin)

    G5 : NAND_2 port map(A=>xab,B=>Cin,Y=>n4);
    G6 : NAND_2 port map(A=>xab,B=>n4,Y=>n5);
    G7 : NAND_2 port map(A=>Cin,B=>n4,Y=>n6);
    G8 : NAND_2 port map(A=>n5,B=>n6,Y=>SUM);

    -- Carry = AB + Cin(A XOR B)

    G9 : NAND_2 port map(A=>n1,B=>n4,Y=>CARRY);

end Structural;