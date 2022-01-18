library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity servomoteur is
  port(
    clk,Reset_n : in std_logic;  --Reset_n actif a l'etat bas
    address, chipselect, write_n: in std_logic;
    position: in std_logic_vector(7 downto 0);
    --position: in std_logic_vector(3 downto 0);
    commande: out std_logic
  );
end servomoteur;

architecture behav of servomoteur is
  signal cpt_periode: integer:=1;
  signal angle:unsigned(7 downto 0);
  --signal angle:unsigned(3 downto 0);
  signal duree: integer:= 0;
  signal impulse: integer:= 0;
begin 
 
  angleprocess : process(clk,Reset_n,position)
  begin
  if Reset_n= '0' then  --actif l'etat bas
    duree <= 50000;--position initiale au 0 degre soit 1ms de l'impulsion
  elsif clk'event and clk = '1' then
    if chipselect = '1' and write_n = '0' then
      angle <= unsigned(position); -- convertir la position en angle
                                  -- valeur maximale est 15 pour 4 sw, 255 pour 8 sw
      duree <= (to_integer(angle)*1960+50000);
      --or 180 degre corresponde a 100000 clk, alors la proportion est 196
		  --duree <= (to_integer(angle)*3333+50000);--pour la carte avec 4 sw soit 15 � 180 degre
      if duree > 100000 then
       impulse <= 100000;
     else
        impulse <= duree;
      end if;
    else
      impulse <= 0;
    end if;
  end if;
end process; 

Interval_process : process(clk,Reset_n)
    begin
      if Reset_n = '0' then
         cpt_periode <= 1;
       elsif clk'event and clk = '1' then
         if cpt_periode > 1000000 then--une periode de 20ms
            cpt_periode <= 1;
        else
          cpt_periode <= cpt_periode + 1;
        end if;
      end if;
    end process;
      
  Commandeprocess : process(clk,Reset_n)
  begin 
    if Reset_n = '0' then
      commande <= '0';
    elsif clk'event and clk = '1' then
      if cpt_periode < impulse then 
        commande <= '1';
        else 
          commande <= '0';
          end if;
    end if;
  end process;
end behav;