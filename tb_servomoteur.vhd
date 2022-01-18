library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_servomoteur is
end tb_servomoteur;

architecture test of tb_servomoteur is
component servomoteur
port(
  clk,Reset_n : in std_logic:= '0';  --Reset_n actif a l'etat bas
  address, chipselect, write_n: in std_logic;
  --position: in std_logic_vector(7 downto 0);
  position: in std_logic_vector(3 downto 0);
  commande: out std_logic :='0' 
);
end component;

--input
signal clk: std_logic:='0';
signal Reset_n: std_logic:='0';
signal address: std_logic:='0';
signal chipselect: std_logic:='0';
signal write_n: std_logic:='1';
--signal position: std_logic_vector(7 downto 0):= (others =>'0');
signal position: std_logic_vector(3 downto 0):= (others =>'0');
--output
signal commande: std_logic;
--definition de la periode de CLOCK
constant clk_periode: time:= 20 ns;

begin 
-- Instancier uut
uut: servomoteur port map(
  clk =>clk,
  Reset_n =>Reset_n,
  address => address,
  chipselect => chipselect, 
  write_n => write_n,
  position =>position,
  commande => commande
);

--clock process
clock_process: process
begin
  clk <= '0';
  wait for clk_periode/2;
  clk <= '1';
  wait for clk_periode/2;
end process;

--simu process
simulation: process
begin
  wait for 100 ns;
  Reset_n <= '1';
  wait for 100 ns;
  Reset_n <= '0';
  wait for 100 ns;
  Reset_n <= '1';
  wait for 0.5 ms;
  address <= '1';
  chipselect <= '1'; 
  write_n <= '0';
  wait for 1 ms;
  --position <= "01110001"; --80 degree
  position <= "1111"; --180 degree
  wait for 20 ms;
  --position <= "01010100"; --59 degree
  position <= "1010"; -- 120 degree
  wait for 20 ms;
  --position <= "00011011"; --19 degree
  position <= "1000"; -- 96 degree
  wait for 20 ms;
  address <= '0';
  wait for 1 ms;
  position <= "1111"; --180 degree (pas de résultat)
  wait for 20 ms;
  address <= '1';
  chipselect <= '0';
  wait for 1 ms;
  position <= "1010"; -- 120 degree (pas de résultat)
  wait for 20 ms;
  chipselect <= '1';
  write_n <= '1';
  wait for 1 ms;
  position <= "1000"; -- 96 degree (pas de résultat)
  wait for 20 ms;
  write_n <= '0';
  wait for 1 ms;
  position <= "0010"; -- 24 degree 
  
  wait;
  
end process;
end test;
  