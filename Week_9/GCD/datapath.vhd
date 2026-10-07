library ieee; use ieee.std_logic_1164.all;
-- Structural datapath
entity datapath is
  port (clk, rst : in std_logic;
        ld_x, ld_y, swap_en, sub_en : in std_logic;
        a, b : in std_logic_vector(3 downto 0);
        x_lt_y, y_eq_0 : out std_logic;
        gcd : out std_logic_vector(3 downto 0));
end entity;
architecture struct of datapath is
  component reg4 is
    port (clk, rst, en : in std_logic;
          d : in std_logic_vector(3 downto 0);
          q : out std_logic_vector(3 downto 0));
  end component;
  component mux2_4 is
    port (sel : in std_logic;
          a, b : in std_logic_vector(3 downto 0);
          y : out std_logic_vector(3 downto 0));
  end component;
  component sub4 is
    port (a, b : in std_logic_vector(3 downto 0);
          diff : out std_logic_vector(3 downto 0));
  end component;
  component comparator is
    port (x, y : in std_logic_vector(3 downto 0);
          x_lt_y, y_eq_0 : out std_logic);
  end component;

  signal x, y, diff, x_d0, x_d, y_d : std_logic_vector(3 downto 0);
  signal x_en, y_en : std_logic;
begin
  -- X input: ld_x ? A : (swap_en ? Y : X-Y)
  SUB  : sub4   port map (a => x, b => y, diff => diff);
  MUX1 : mux2_4 port map (sel => swap_en, a => diff, b => y, y => x_d0);
  MUX2 : mux2_4 port map (sel => ld_x,    a => x_d0, b => a, y => x_d);
  -- Y input: ld_y ? B : X   (X is used only when swapping)
  MUX3 : mux2_4 port map (sel => ld_y,    a => x,    b => b, y => y_d);

  x_en <= ld_x or swap_en or sub_en;
  y_en <= ld_y or swap_en;

  REGX : reg4 port map (clk => clk, rst => rst, en => x_en, d => x_d, q => x);
  REGY : reg4 port map (clk => clk, rst => rst, en => y_en, d => y_d, q => y);

  CMP  : comparator port map (x => x, y => y, x_lt_y => x_lt_y, y_eq_0 => y_eq_0);

  gcd <= x;
end architecture;
