library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.standard.boolean;

entity Telemetre_us is 
port(
	clk: in std_logic; --50MHz
	rst_n: in std_logic; --active en '0'
	echo: in std_logic;
	read: in std_logic;
  chipselect: in std_logic;
  readdata: out std_logic_vector(31 downto 0);
	trig: out std_logic;
	LEDR: out std_logic_vector(7 downto 0)
);
end Telemetre_us;

architecture Behav of Telemetre_us is
	signal cpt_trig: integer:= 0;
	signal cpt_echo: integer:= 0;
	signal s_trig: std_logic :='0'; --signal trig
	signal dis: unsigned(31 downto 0); --distance
	signal dis_tmp: unsigned(31 downto 0);
	 
begin
--periode de clk de 0.02us 
--pour le signal de 10us cpt_10us = 500
--pour le signal de 60ms cpt_60ms = 3000000
process(rst_n,clk)
	begin
		if rst_n = '0' then
      s_trig <= '0';
			cpt_trig<= 0;
		elsif rising_edge(clk) then
		  cpt_trig <= cpt_trig +1;
		  if cpt_trig < 500 then  --quand le signal trig ne sont pas encore durer de 10us
		    s_trig <= '1';
		  elsif cpt_trig < 3000000 then  --quand l'envoie du signal trig n'a pas encore passer la limite: 60ms
		    s_trig <='0';
		  else -- si 60ms
		    cpt_trig <= 0;
		  end if;
		end if;
end process;

trig <= s_trig;
  
  
calcul:process(rst_n,clk)
begin
  if rst_n = '0' then
    dis <= (others => '0');
    cpt_echo <= 0;
	elsif rising_edge(clk) then
		--si on a detecte un obstacle
		if echo = '1' then
		  cpt_echo <= cpt_echo +1;
		   --si cpt_echo est egale a 2938 = 1cm pour aller-retour
		  if cpt_echo = 2938 then
		     dis <= dis +1;
		     cpt_echo <= 0;  
		  end if;
		  dis_tmp <= dis;
	  elsif echo='0' then --si echo est fini
		  cpt_echo <= 0;
		  dis <= (others => '0');
		end if; 
  end if;
end process;

LEDR <= std_logic_vector(dis_tmp(7 downto 0));

registre:process(clk, rst_n)
begin
	if rst_n = '0' then 
		readdata <= (others => '0');
	elsif rising_edge(clk) then 	
		if (chipselect = '1') and (read = '1') then 
			readdata <= std_logic_vector(dis_tmp);
		end if; 
	end if; 
end process;
end Behav;
