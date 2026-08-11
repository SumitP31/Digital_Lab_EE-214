library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
entity Fibonacci is
port(a, b, c, d, e: in std_logic; Y1: out std_logic );
end Fibonacci;
Architecture struct of Fibonacci is
Signal an, bn, cn, dn, en: std_logic;
Signal s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11: std_logic;
Begin 
-- A', B', C', D', E' = an, bn, cn, dn, en
n1: INVERTER port map (a, an);
n2: INVERTER port map (b, bn);
n3: INVERTER port map (c, cn);
n4: INVERTER port map (d, dn);
n5: INVERTER port map (e, en);

-- A'B'C' = s2
a1: AND_2 port map (an, cn, s1);
a2: AND_2 port map (bn, s1, s2);

-- A'C'D'E' = s4
a3: AND_2 port map (dn, en, s3);
a4: AND_2 port map (s3, s1, s4);

--  B'CD'E = s7
a5: AND_2 port map (bn, dn, s5);
a6: AND_2 port map (c, e, s6);
a7: AND_2 port map (s5, s6, s7);

-- A'CD'E = s8
a8: AND_2 port map (an, dn, s8);
a9: AND_2 port map (s8, s6, s9);

-- A'B'C' + A'C'D'E' + B'CD'E + A'CD'E = Y1
o1: OR_2 port map (s2, s4, s10);
o2: OR_2 port map (s9, s7, s11);
o3: OR_2 port map (s10, s11, Y1);

end struct;