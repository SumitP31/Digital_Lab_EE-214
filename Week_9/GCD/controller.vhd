library ieee; use ieee.std_logic_1164.all;
-- Behavioural FSM controller (S_IDLE, S_LOOP)
-- 'start' is captured on the falling clock edge (start_r) so that the
-- rising-edge behaviour never depends on the arrival order of start and
-- clock (they change together in the scan-chain / trace vectors).
entity controller is
  port (clk, rst, start : in std_logic;
        x_lt_y, y_eq_0 : in std_logic;
        ld_x, ld_y, swap_en, sub_en, ready : out std_logic);
end entity;
architecture beh of controller is
  type state_t is (S_IDLE, S_LOOP);
  signal state, next_state : state_t;
  signal start_r : std_logic;
begin
  -- Start capture on falling edge, asynchronous reset
  process(clk, rst)
  begin
    if rst = '1' then start_r <= '0';
    elsif falling_edge(clk) then start_r <= start;
    end if;
  end process;

  -- State register with asynchronous reset
  process(clk, rst)
  begin
    if rst = '1' then state <= S_IDLE;
    elsif rising_edge(clk) then state <= next_state;
    end if;
  end process;

  -- Next-state and output logic
  process(state, start_r, x_lt_y, y_eq_0)
  begin
    ld_x <= '0'; ld_y <= '0'; swap_en <= '0'; sub_en <= '0'; ready <= '0';
    next_state <= state;
    case state is
      when S_IDLE =>
        if start_r = '1' then
          ld_x <= '1'; ld_y <= '1';
          next_state <= S_LOOP;
        end if;
      when S_LOOP =>
        if y_eq_0 = '1' then          -- Case 1: GCD found
          ready <= '1';
          next_state <= S_IDLE;
        elsif x_lt_y = '1' then       -- Case 2: swap
          swap_en <= '1';
        else                          -- Case 3: X = X - Y
          sub_en <= '1';
        end if;
    end case;
  end process;
end architecture;