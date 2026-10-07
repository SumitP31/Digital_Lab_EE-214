library ieee; use ieee.std_logic_1164.all;
-- 4-bit 2:1 mux : sel=0 -> a, sel=1 -> b
entity mux2_4 is
  port (sel : in std_logic;
        a, b : in std_logic_vector(3 downto 0);
        y : out std_logic_vector(3 downto 0));
end entity;
architecture beh of mux2_4 is
begin
  y <= a when sel = '0' else b;
end architecture;
