library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
entity Encoder is
port(a, b, c, d, en: in std_logic; Y1, Y2: out std_logic );
end Encoder;
Architecture struct of Encoder is
Signal s1, s2: std_logic;
Begin 
o1: OR_2 port map (a, c, s1);
a1: AND_2 port map (s1, en, Y1);
o2: OR_2 port map (a, b, s2);
a2: AND_2 port map (s2, en, Y2);
end struct;