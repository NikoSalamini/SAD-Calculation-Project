
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity subtractor_tb is
end subtractor_tb;

architecture beh of subtractor_tb is

	--const def
	constant NBit : positive := 8;

	--component dut
	component subtractor
		generic (
			NBit: positive := 8
		);
		
		port (
			input1: in std_logic_vector (NBit-1 downto 0);
			input2: in std_logic_vector (NBit-1 downto 0);
			abs_diff: out std_logic_vector (NBit-1 downto 0)
		);
	end component;

	--signal of testbench
	signal input1_ext : std_logic_vector(NBit-1 downto 0) := b"00000001";
	signal input2_ext : std_logic_vector(NBit-1 downto 0) := b"00000010";
	signal abs_diff_ext : std_logic_vector(NBit-1 downto 0);
	signal testing : boolean := true;
	
	--testbench
	begin
		
		--component instantiation
		dut: subtractor
		port map(
			input1 => input1_ext,
			input2 => input2_ext,
			abs_diff => abs_diff_ext
		);
		
		stimulus: process 
		begin
			wait for 10 ns;
			input1_ext <= b"00001000";
			input2_ext <= b"00010100";
			wait for 10 ns;
			testing <= false; 
		end process;
end beh;