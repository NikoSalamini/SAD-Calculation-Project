library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity SAD is
	generic (
		counter_threshold: positive := 256; -- when counter reaches this value data_valid is set to 1.
		NBit_input: positive := 8;
		NBit_output: positive := 16
	);
    port (
		clk			: in std_logic;
		rst			: in std_logic;
		en			: in std_logic;
		PA			: in std_logic_vector(NBit_input-1 downto 0); -- value of pixel A
		PB			: in std_logic_vector(NBit_input-1 downto 0); -- value of pixel B 
		sad			: out std_logic_vector(NBit_output-1 downto 0 ); -- output of |A - B|
		data_valid	: out std_logic -- set to 1 when SAD calculation is over
	);
end SAD;

architecture Structural of SAD is

-- counter
component counter is
	generic (
		NBit : positive := 8
	);
    port (
		en: in std_logic; 
		rst,clk : in std_logic;
		overflow: out std_logic;
		o: out std_logic_vector( NBit-1 downto 0 )
	);
end component;

-- subtractor

component subtractor is
	generic (
		NBit: positive := 8
	);
	
	port (
		input1: in std_logic_vector (NBit-1 downto 0);
		input2: in std_logic_vector (NBit-1 downto 0);
		abs_diff: out std_logic_vector (NBit-1 downto 0)
	);
end component;

-- DFF_N
component DFF_N is
	generic( NBit : positive := 8);
		
	port( 
		clk     : in std_logic;
		a_rst_n : in std_logic;
		en      : in std_logic;
		d       : in std_logic_vector(NBit - 1 downto 0);
		q       : out std_logic_vector(NBit - 1 downto 0)
	);
end component;

-- accumulator
component accumulator is
	generic (
		NBit: positive := 16 
	);
	
	port(
		i: in std_logic_vector(NBit-1 downto 0);
		rst,clk : in std_logic;
		en: in std_logic;
		counter_ow: in std_logic;
		o: out std_logic_vector( NBit-1 downto 0 );
		data_valid: out std_logic
	);
end component;

-- Constants
constant NBit_counter : positive := 8; 		-- Default: The counter must have 8 bits to count the sum of the differences of 16x16 = 256 pixel couples.
constant NBit_subtractor : positive := 8; 	-- Default: The subtractor works on 8 bits because the case is the subtraction of 2 unsigned integers on 8 bits.
constant NBit_DFF_N: positive := 8; 		-- Default: Each input is a number between 0 and 255, so it's 8 bits. 
constant NBit_accumulator: positive := 16; 	-- Default: The accumulator must have 16 bits because the maximum number of the total sum is 255*256.

-- padding used to format the subtractor output to the accumulator input, Default: padding is composed by 8 zeros in the default case
constant padding : std_logic_vector(NBit_accumulator-NBit_subtractor-1 downto 0) := (others => '0');

-- Signals for interconnections
signal counter_overflow: std_logic;
signal counter_output: std_logic_vector (NBit_counter-1 downto 0);
signal subtractor_output: std_logic_vector (NBit_subtractor-1 downto 0 );
signal out_PA: std_logic_vector (NBit_DFF_N-1 downto 0);
signal out_PB: std_logic_vector (NBit_DFF_N-1 downto 0);
signal accumulator_input: std_logic_vector (NBit_accumulator-1 downto 0);

begin

	COUNTER_DEF: counter 
	generic map(NBit => NBit_counter) port map(en => en, rst => rst, clk => clk, overflow => counter_overflow, o => counter_output); -- if (en = '1') clock_count = clock_count + 1
	
	PA_REG: DFF_N generic map (NBit => NBit_DFF_N) port map (clk => clk, a_rst_n => rst, en => en, d => PA, q => out_PA); -- PA
	PB_REG: DFF_N generic map (NBit => NBit_DFF_N) port map (clk => clk, a_rst_n => rst, en => en, d => PB, q => out_PB); -- PB
	
	SUBTRACTOR_DEF: subtractor generic map(NBit => NBit_subtractor) port map (input1 => out_PA, input2 => out_PB, abs_diff => subtractor_output); -- |PA - PB|
	
	ACCUMULATOR_DEF: accumulator 
	generic map(NBit => NBit_accumulator) 
	port map (i => accumulator_input, clk => clk, rst => rst, en => en, counter_ow => counter_overflow, o => sad, data_valid => data_valid); -- += |PA - PB|, data_valid 
	
	-- Process to set the padding of the subtractor output
	add_padding_process: process(subtractor_output)
	begin
	
		-- concatenating NBit_accumulator-NBit_subtractor zeros to the subtractor output
		accumulator_input <= padding & subtractor_output; 
		
	end process add_padding_process;
	
end Structural;