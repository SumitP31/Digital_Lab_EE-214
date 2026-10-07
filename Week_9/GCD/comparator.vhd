library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;
-- Generates x_lt_y (X<Y) and y_eq_0 (Y=0)
entity comparator is
  port (x, y : in std_logic_vector(3 downto 0);
        x_lt_y, y_eq_0 : out std_logic);
end entity;
architecture beh of comparator is
begin
  x_lt_y <= '1' when unsigned(x) < unsigned(y) else '0';
  y_eq_0 <= '1' when unsigned(y) = 0 else '0';
end architecture;
