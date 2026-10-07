-- A DUT entity is used to wrap your design.
--  This version wraps the GCD design.
--  Trace file format:
--   input_vector  = < reset clock start A3 A2 A1 A0 B3 B2 B1 B0 >   (11 bits)
--   output_vector = < ready Y3 Y2 Y1 Y0 >                           (5 bits)

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
   port(input_vector: in std_logic_vector(10 downto 0);
       	output_vector: out std_logic_vector(4 downto 0));
end entity;

architecture DutWrap of DUT is
	-- Instantiate your own top Module component in place of ALU_1

component gcd is
port(reset, clock, start : in std_logic;
     A, B : in std_logic_vector(3 downto 0);
     ready : out std_logic;
     Y : out std_logic_vector(3 downto 0));
end component;

begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   add_instance: gcd port map (reset => input_vector(10),
                               clock => input_vector(9),
                               start => input_vector(8),
                               A     => input_vector(7 downto 4),
                               B     => input_vector(3 downto 0),
                               ready => output_vector(4),
                               Y     => output_vector(3 downto 0));

end DutWrap;

