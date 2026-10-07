library ieee; use ieee.std_logic_1164.all;


entity gcd is
  port (reset, clock, start : in std_logic;
        A, B : in std_logic_vector(3 downto 0);
        ready : out std_logic;
        Y : out std_logic_vector(3 downto 0));
end entity;

architecture struct of gcd is
  component datapath is
    port (clk, rst : in std_logic;
          ld_x, ld_y, swap_en, sub_en : in std_logic;
          a, b : in std_logic_vector(3 downto 0);
          x_lt_y, y_eq_0 : out std_logic;
          gcd : out std_logic_vector(3 downto 0));
  end component;
  
  component controller is
    port (clk, rst, start : in std_logic;
          x_lt_y, y_eq_0 : in std_logic;
          ld_x, ld_y, swap_en, sub_en, ready : out std_logic);
  end component;

  signal ld_x, ld_y, swap_en, sub_en, x_lt_y, y_eq_0, ready_i : std_logic;

  signal gcd_x : std_logic_vector(3 downto 0);

  begin
  DP : datapath port map (clk => clock, rst => reset, ld_x => ld_x, ld_y => ld_y,
         swap_en => swap_en, sub_en => sub_en, a => A, b => B,
         x_lt_y => x_lt_y, y_eq_0 => y_eq_0, gcd => gcd_x);
  CU : controller port map (clk => clock, rst => reset, start => start,
         x_lt_y => x_lt_y, y_eq_0 => y_eq_0, ld_x => ld_x, ld_y => ld_y,
         swap_en => swap_en, sub_en => sub_en, ready => ready_i);

  ready <= ready_i;
  
  Y <= gcd_x when ready_i = '1' else "0000";  -- result visible only when ready

end architecture;
