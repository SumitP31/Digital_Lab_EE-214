library std;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;

entity Testbench is
end entity;

architecture Behave of Testbench is

    ----------------------------------------------------------------
    -- Number of Inputs/Outputs
    ----------------------------------------------------------------
    constant number_of_inputs  : integer := 3;
    constant number_of_outputs : integer := 2;
    ----------------------------------------------------------------

    component DUT is
        port(
            input_vector  : in std_logic_vector(number_of_inputs-1 downto 0);
            output_vector : out std_logic_vector(number_of_outputs-1 downto 0)
        );
    end component;

    signal input_vector  : std_logic_vector(number_of_inputs-1 downto 0);
    signal output_vector : std_logic_vector(number_of_outputs-1 downto 0);

    ----------------------------------------------------------------
    -- Utility Functions
    ----------------------------------------------------------------

    function to_string(x: string) return string is
        variable ret_val: string(1 to x'length);
        alias lx : string(1 to x'length) is x;
    begin
        ret_val := lx;
        return(ret_val);
    end;

    function to_std_logic_vector(x: bit_vector)
        return std_logic_vector is
        alias lx: bit_vector(1 to x'length) is x;
        variable ret_val: std_logic_vector(1 to x'length);
    begin
        for i in 1 to x'length loop
            if lx(i)='1' then
                ret_val(i):='1';
            else
                ret_val(i):='0';
            end if;
        end loop;
        return ret_val;
    end;

    function to_bit_vector(x: std_logic_vector)
        return bit_vector is
        alias lx: std_logic_vector(1 to x'length) is x;
        variable ret_val: bit_vector(1 to x'length);
    begin
        for i in 1 to x'length loop
            if lx(i)='1' then
                ret_val(i):='1';
            else
                ret_val(i):='0';
            end if;
        end loop;
        return ret_val;
    end;

begin

    DUT_INSTANCE : DUT
        port map(
            input_vector  => input_vector,
            output_vector => output_vector
        );

    process

        variable err_flag : boolean := false;

        file INFILE  : text open read_mode  is "TRACEFILE.txt";
        file OUTFILE : text open write_mode is "outputs.txt";

        variable input_vector_var  : bit_vector(number_of_inputs-1 downto 0);
        variable output_vector_var : bit_vector(number_of_outputs-1 downto 0);
        variable output_mask_var   : bit_vector(number_of_outputs-1 downto 0);

        variable output_comp_var :
            std_logic_vector(number_of_outputs-1 downto 0);

        constant ZZZZ :
            std_logic_vector(number_of_outputs-1 downto 0)
            := (others => '0');

        variable INPUT_LINE  : line;
        variable OUTPUT_LINE : line;

        variable LINE_COUNT : integer := 0;

    begin

        while not endfile(INFILE) loop

            LINE_COUNT := LINE_COUNT + 1;

            readline(INFILE, INPUT_LINE);

            read(INPUT_LINE, input_vector_var);
            read(INPUT_LINE, output_vector_var);
            read(INPUT_LINE, output_mask_var);

            input_vector <= to_std_logic_vector(input_vector_var);

            wait for 15 ns;

            output_comp_var :=
                (to_std_logic_vector(output_mask_var) and
                (output_vector xor to_std_logic_vector(output_vector_var)));

            if(output_comp_var /= ZZZZ) then
                write(OUTPUT_LINE,to_string("ERROR : Line "));
                write(OUTPUT_LINE,LINE_COUNT);
                writeline(OUTFILE,OUTPUT_LINE);
                err_flag := true;
            end if;

            write(OUTPUT_LINE,to_bit_vector(input_vector));
            write(OUTPUT_LINE,to_string(" "));
            write(OUTPUT_LINE,to_bit_vector(output_vector));
            writeline(OUTFILE,OUTPUT_LINE);

        end loop;

        if err_flag=false then
            report "SUCCESS! Simulation Passed." severity note;
        else
            report "FAILED! Errors Found." severity error;
        end if;

        wait;

    end process;

end Behave;