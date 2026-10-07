library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(
        input_vector  : in  std_logic_vector(1 downto 0);
        output_vector : out std_logic_vector(0 downto 0)
    );
end entity DUT;


architecture DutWrap of DUT is

    component Sequence_generator_stru_dataflow is
        port(
            reset : in  std_logic;
            clock : in  std_logic;
            y     : out std_logic
        );
    end component;

begin

    sequence_generator_instance : Sequence_generator_stru_dataflow
        port map(
            reset => input_vector(1),  -- FIRST bit = reset
            clock => input_vector(0),  -- SECOND bit = clock
            y     => output_vector(0)
        );

end DutWrap;