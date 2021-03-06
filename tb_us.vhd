library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_us is
end tb_us;

architecture test of tb_us is
--declaration des component pour uut
component telemetre_us
port(
	clk,rst_n: in std_logic;
	echo: in std_logic;
	read: in std_logic;
  chipselect: in std_logic;
  readdata: out std_logic_vector(31 downto 0);
	trig: out std_logic;
	LEDR: out std_logic_vector(7 downto 0)
);
end component;

--input
signal rst_n: std_logic:='1';
signal clk: std_logic:='0';
signal echo: std_logic:='0';
signal read: std_logic:='0';
signal chipselect: std_logic:='0';
--output
signal trig: std_logic;
signal LEDR: std_logic_vector(7 downto 0);
signal readdata: std_logic_vector(31 downto 0);
--definition de la periode de CLOCK
constant clk_periode: time:=20 ns;

begin
--Instancier uut
uut : telemetre_us port map(
	clk =>clk,
	rst_n =>rst_n,
	echo =>echo,
	read => read,
	chipselect => chipselect,
	readdata => readdata,
	trig =>trig,
	LEDR =>LEDR
);

--clock process
clk_process : process
begin
	clk<= '0';		
	wait for clk_periode/2;
	clk<= '1';
	wait for clk_periode/2;
end process;

--simu process
simulation:process
begin
	wait for 100 ns;
	rst_n <= '0';
	wait for 100 ns;
	rst_n <= '1';
	wait for 100 ns;
	--wait until trig = '1';
	--wait until trig = '0';
	wait for 1 ms;
	echo <= '1';
	wait for 2 ms; -- distance=34 cm
	echo <= '0';
	read <= '1';  -- lire la distance
	chipselect <= '1';
	wait for 4 ms;
	echo <= '1';
	wait for 1 ms; -- distance=17 cm
	echo <= '0';
	wait for 70 ms; --pas de obstacle
	echo <= '0';
	wait for 5 ms;
	echo <= '0';
	wait for 1 ms;
	echo <= '1';
	read <= '0';     --ne lit plus la distance
	chipselect <= '0';
	wait for 3 ms;  -- distance=51 cm
	echo <= '0';
	wait;
end process;
end test;

