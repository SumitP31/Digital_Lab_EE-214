library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Flipflops.all;

entity Sequence_generator_stru_dataflow is
    port (
        reset : in  std_logic;
        clock : in  std_logic;
        y     : out std_logic
    );
end entity Sequence_generator_stru_dataflow;


architecture struct of Sequence_generator_stru_dataflow is

    signal D : std_logic_vector(2 downto 0);
    signal Q : std_logic_vector(2 downto 0);

begin

    ------------------------------------------------------------
    -- Next-state equations
    --
    -- D0 = Q2 + Q1'
    -- D1 = Q0.Q1' + Q0.Q2'
    -- D2 = Q2.Q1' + Q0'.Q1'
    ------------------------------------------------------------

    D(0) <= Q(2) or (not Q(1));

    D(1) <= (Q(0) and (not Q(1))) or
            (Q(0) and (not Q(2)));

    D(2) <= (Q(2) and (not Q(1))) or
            ((not Q(0)) and (not Q(1)));


    ------------------------------------------------------------
    -- Output = LSB
    ------------------------------------------------------------

    y <= Q(0);


    ------------------------------------------------------------
    -- Flip-flops
    --
    -- Q2 -> reset to 0
    -- Q1 -> reset to 0
    -- Q0 -> SET to 1
    --
    -- Therefore RESET state = 001
    ------------------------------------------------------------

    dff2 : dff_reset
        port map (
            D     => D(2),
            clock => clock,
            reset => reset,
            Q     => Q(2)
        );


    dff1 : dff_reset
        port map (
            D     => D(1),
            clock => clock,
            reset => reset,
            Q     => Q(1)
        );


    dff0 : dff_set
        port map (
            D     => D(0),
            clock => clock,
            set   => reset,
            Q     => Q(0)
        );

end architecture struct;