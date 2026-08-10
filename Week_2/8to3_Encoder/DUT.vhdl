-- A DUT entity is used to wrap your design.
--  This example shows how you can do this for the
--  Full-adder.

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
   port(input_vector: in std_logic_vector(8 downto 0);
       	output_vector: out std_logic_vector(2 downto 0));
end entity;

architecture DutWrap of DUT is
	-- Instantiate your own top Module component in place of ALU_1
	
component Encoder_8to3 is
port(a,b,c,d,e,f,g,h,en : in std_logic; Y1,Y2,Y3 : out std_logic);
end component;

begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   add_instance: Encoder_8to3 port map (a => input_vector(8), 
                                       b => input_vector(7), 
                                       c => input_vector(6), 
                                       d => input_vector(5), 
                                       e => input_vector(4),
                                       f => input_vector(3),
                                       g => input_vector(2),
                                       h => input_vector(1),
                                       en => input_vector(0),
											Y1 => output_vector(2), 
                                 Y2 => output_vector(1), 
                                 Y3 => output_vector(0));

end DutWrap;

