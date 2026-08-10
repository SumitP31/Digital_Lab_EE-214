library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
entity Encoder_8to3 is
port(a, b, c, d, e, f, g, h, en: in std_logic; Y1, Y2, Y3: out std_logic );
end Encoder_8to3;
Architecture struct of Encoder_8to3 is
Signal s0, s1, s2, s3, s4, s5, s6: std_logic;

component Encoder is
port(a, b, c, d, en: in std_logic; Y1, Y2: out std_logic );
end component;

Begin 

e1: Encoder port map (a, b, c, d, en, s0, s1);
e2: Encoder port map (e, f, g, h, en, s2, s3);

o1: OR_2 port map (s0, s2, Y2);
o2: OR_2 port map (s1, s3, Y1);

o3: OR_2 port map (a, b, s4);
o4: OR_2 port map (c, d, s5);
o5: OR_2 port map (s4, s5, s6);

e3: Encoder port map (s6, '0', '0', '0', en, Y3, open);

end struct;