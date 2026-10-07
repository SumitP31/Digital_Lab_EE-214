library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART is
    generic (
        g_CLKS_PER_BIT : integer := 521
    );
    port (
        i_Clk       : in  std_logic;
        i_RX_Serial : in  std_logic;
        o_LED       : out std_logic_vector(7 downto 0)
    );
end entity UART;

architecture rtl of UART is

    signal clk_5MHz : std_logic;
    signal clk_2Hz  : std_logic;

    signal rx_dv   : std_logic;
    signal rx_byte : std_logic_vector(7 downto 0);

    signal r_N_Limit : integer range 1 to 9 := 9;
    signal r_Counter : integer range 0 to 15 := 0;

    component ClockDiv is
        port(
            clk_in       : in  std_logic;
            reset        : in  std_logic;
            clk_out_5MHz : out std_logic;
            clk_out_2Hz  : out std_logic
        );
    end component;

    component UART_Rx is
        generic (
            g_CLKS_PER_BIT : integer := 435
        );
        port(
            i_Clk       : in  std_logic;
            i_RX_Serial : in  std_logic;
            o_RX_DV     : out std_logic;
            o_RX_Byte   : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    -- 50 MHz -> 5 MHz and 2 Hz
    u_clk_div : ClockDiv
        port map(
            clk_in       => i_Clk,
            reset        => '0',
            clk_out_5MHz => clk_5MHz,
            clk_out_2Hz  => clk_2Hz
        );

    -- 5 MHz UART clock, 9600 baud: approximately 521 clocks/bit
    u_uart_rx : UART_Rx
        generic map(
            g_CLKS_PER_BIT => g_CLKS_PER_BIT
        )
        port map(
            i_Clk       => clk_5MHz,
            i_RX_Serial => i_RX_Serial,
            o_RX_DV     => rx_dv,
            o_RX_Byte   => rx_byte
        );

    -- Decode ASCII '1' through '9'
    p_SET_LIMIT : process(clk_5MHz)
    begin
        if rising_edge(clk_5MHz) then
            if rx_dv = '1' then
                case rx_byte is
                    when x"31" => r_N_Limit <= 1; -- '1'
                    when x"32" => r_N_Limit <= 2; -- '2'
                    when x"33" => r_N_Limit <= 3; -- '3'
                    when x"34" => r_N_Limit <= 4; -- '4'
                    when x"35" => r_N_Limit <= 5; -- '5'
                    when x"36" => r_N_Limit <= 6; -- '6'
                    when x"37" => r_N_Limit <= 7; -- '7'
                    when x"38" => r_N_Limit <= 8; -- '8'
                    when x"39" => r_N_Limit <= 9; -- '9'
                    when others => null;
                end case;
            end if;
        end if;
    end process p_SET_LIMIT;

    -- Modulo-N counter at 2 Hz
    p_COUNTER : process(clk_2Hz)
    begin
        if rising_edge(clk_2Hz) then
            if r_Counter >= r_N_Limit - 1 then
                r_Counter <= 0;
            else
                r_Counter <= r_Counter + 1;
            end if;
        end if;
    end process p_COUNTER;

    -- 8-bit LED output
    o_LED <= std_logic_vector(to_unsigned(r_Counter, 8));

end architecture rtl;
