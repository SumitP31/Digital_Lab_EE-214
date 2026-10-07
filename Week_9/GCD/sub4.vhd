library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all;
-- 4-bit unsigned subtractor : diff = a - b
entity sub4 is
  port (a, b : in std_logic_vector(3 downto 0);
        diff : out std_logic_vector(3 downto 0));
end entity;
architecture beh of sub4 is
begin
  diff <= std_logic_vector(unsigned(a) - unsigned(b));
end architecture;
