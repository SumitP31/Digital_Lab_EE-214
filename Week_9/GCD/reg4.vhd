library ieee; use ieee.std_logic_1164.all;
-- 4-bit register, asynchronous reset, synchronous enable
entity reg4 is
  port (clk, rst, en : in std_logic;
        d : in std_logic_vector(3 downto 0);
        q : out std_logic_vector(3 downto 0));
end entity;
architecture beh of reg4 is
begin
  process(clk, rst)
  begin
    if rst = '1' then q <= (others => '0');
    elsif rising_edge(clk) then
      if en = '1' then q <= d; end if;
    end if;
  end process;
end architecture;
