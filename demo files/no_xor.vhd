library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
entity no_xor is
port(a, b: in std_logic; output: out std_logic );
end no_xor;
Architecture struct of no_xor is
Signal s1, s2, s3, s4, s5: std_logic;
Begin 
g1: NOR_2 port map (a, a, s1 );
g2: NOR_2 port map (s1, b, s2 );
g3: NOR_2 port map (b, b, s3);
g4: NOR_2 port map (s3, a, s4 );
g5: NOR_2 port map (s2, s4, s5 );
g6: NOR_2 port map (s5, s5, output);
end struct;