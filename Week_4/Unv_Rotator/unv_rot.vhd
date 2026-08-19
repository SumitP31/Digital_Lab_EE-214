library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;


-- ============================================================
-- 2 : 1 MUX
-- Y = S' I0 + S I1
-- ============================================================

entity mux is
port(
    I0 : in std_logic;
    I1 : in std_logic;
    S  : in std_logic;
    Y  : out std_logic
);
end mux;


Architecture struct of mux is

Signal nS : std_logic;
Signal s0 : std_logic;
Signal s1 : std_logic;

Begin

g1: INVERTER port map (S, nS);
g2: AND_2    port map (I0, nS, s0);
g3: AND_2    port map (I1, S, s1);
g4: OR_2     port map (s0, s1, Y);

end struct;



-- ============================================================
-- UNIVERSAL ROTATOR
--
-- L = 0 : Right rotate
-- L = 1 : Left rotate
--
-- b(2) : rotate by 4
-- b(1) : rotate by 2
-- b(0) : rotate by 1
--
-- Structure:
--
-- Input
--   |
-- Bit Reversal
--   |
-- Right Rotate by 4
--   |
-- Right Rotate by 2
--   |
-- Right Rotate by 1
--   |
-- Bit Reversal
--   |
-- Output
--
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;


entity universal_rotator is
port(
    L      : in  std_logic;
    b      : in  std_logic_vector(2 downto 0);
    a      : in  std_logic_vector(7 downto 0);
    output : out std_logic_vector(7 downto 0)
);
end universal_rotator;


Architecture struct of universal_rotator is

component mux is 

			port(
				 I0 : in std_logic;
				 I1 : in std_logic;
				 S  : in std_logic;
				 Y  : out std_logic
			);
end component;

-- Signals after each major block
Signal rev0 : std_logic_vector(7 downto 0);
Signal r4   : std_logic_vector(7 downto 0);
Signal r2   : std_logic_vector(7 downto 0);
Signal r1   : std_logic_vector(7 downto 0);
Signal rev1 : std_logic_vector(7 downto 0);

Begin


-- ============================================================
-- BIT REVERSAL - FIRST BLOCK
--
-- L = 0 : rev0(i) = a(i)
-- L = 1 : rev0(i) = a(7-i)
-- ============================================================

gen_rev0: for i in 0 to 7 generate

    mux_rev0: mux
    port map(
        I0 => a(i),
        I1 => a(7-i),
        S  => L,
        Y  => rev0(i)
    );

end generate gen_rev0;



-- ============================================================
-- RIGHT ROTATE BY 4
--
-- b(2) = 0 : r4(i) = rev0(i)
-- b(2) = 1 : r4(i) = rev0((i+4) mod 8)
-- ============================================================

gen_r4: for i in 0 to 7 generate

    mux_r4: mux
    port map(
        I0 => rev0(i),
        I1 => rev0((i+4) mod 8),
        S  => b(2),
        Y  => r4(i)
    );

end generate gen_r4;



-- ============================================================
-- RIGHT ROTATE BY 2
--
-- b(1) = 0 : r2(i) = r4(i)
-- b(1) = 1 : r2(i) = r4((i+2) mod 8)
-- ============================================================

gen_r2: for i in 0 to 7 generate

    mux_r2: mux
    port map(
        I0 => r4(i),
        I1 => r4((i+2) mod 8),
        S  => b(1),
        Y  => r2(i)
    );

end generate gen_r2;



-- ============================================================
-- RIGHT ROTATE BY 1
--
-- b(0) = 0 : r1(i) = r2(i)
-- b(0) = 1 : r1(i) = r2((i+1) mod 8)
-- ============================================================

gen_r1: for i in 0 to 7 generate

    mux_r1: mux
    port map(
        I0 => r2(i),
        I1 => r2((i+1) mod 8),
        S  => b(0),
        Y  => r1(i)
    );

end generate gen_r1;



-- ============================================================
-- BIT REVERSAL - FINAL BLOCK
--
-- L = 0 : output(i) = r1(i)
-- L = 1 : output(i) = r1(7-i)
-- ============================================================

gen_rev1: for i in 0 to 7 generate

    mux_rev1: mux
    port map(
        I0 => r1(i),
        I1 => r1(7-i),
        S  => L,
        Y  => output(i)
    );

end generate gen_rev1;


end struct;