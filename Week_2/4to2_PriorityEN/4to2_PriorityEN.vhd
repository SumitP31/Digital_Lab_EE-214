library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
entity PriorityEn is
port(a, b, c, d: in std_logic; Y1, Y2, V: out std_logic );
end PriorityEn;
Architecture struct of PriorityEn is
Signal s1, s2, s3, s4: std_logic;
Begin 
n1: INVERTER port map (b, s1);
a1: AND_2 port map (c, s1, s2);
o1: OR_2 port map (a, s2, Y1);

o2: OR_2 port map (a, b, Y2);

a2: OR_2 port map (a, b, s3);
a3: OR_2 port map (c, d, s4);
a4: OR_2 port map (s4, s3, V);
end struct;