library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;            -- Para operações de arquivo (leitura/escrita)
use ieee.std_logic_textio.all; -- Para ler/escrever std_logic_vector como texto

entity tb_FIR_Filter_21tap is
  -- Testbench não tem portas
end entity;

architecture TB of tb_FIR_Filter_21tap is

  -- Component do filtro FIR a ser testado
  component FIR_Filter_21tap 
    generic( DATA_WIDTH : integer := 16 );
    port(
      clk      : in  std_logic;
      reset_n  : in  std_logic;
      data_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
  end component;

  -- Sinais internos para conectar ao DUT (Device Under Test)
  signal clk     : std_logic := '0';
  signal reset_n : std_logic := '0';
  signal data_in : std_logic_vector(15 downto 0) := (others => '0');
  signal data_out: std_logic_vector(15 downto 0);

  -- Parâmetros do clock de simulação
  constant CLOCK_PERIOD : time := 20 ns;

  -- Configuração de arquivos de I/O
  file file_in  : text open read_mode is "input_vectors.txt";
  file file_out : text open write_mode is "output_results.txt";

begin
  -- Instancia o filtro FIR (DUT)
  DUT: FIR_Filter_21tap 
    port map(
      clk      => clk,
      reset_n  => reset_n,
      data_in  => data_in,
      data_out => data_out
    );

  -- Geração do clock (onda quadrada)
  clk_process: process
  begin
    clk <= '0';
    wait for CLOCK_PERIOD/2;
    clk <= '1';
    wait for CLOCK_PERIOD/2;
  end process;

  -- Processo principal de estímulos
  stim_process: process
    variable line_in    : line;
    variable sample_val : integer;
    variable line_out   : line;
    variable out_val    : integer;
  begin
    -- Inicializa reset
    reset_n <= '0';
    wait for 50 ns;
    reset_n <= '1';  -- libera reset após 50 ns

    -- Aguarda duas bordas de clock para sincronismo pós-reset
    wait for CLOCK_PERIOD * 2;

    -- Leitura do arquivo de entrada linha a linha
    while not endfile(file_in) loop
      readline(file_in, line_in);
      -- Lê um inteiro (pode ler também em formato binário/hex se o arquivo for assim)
      read(line_in, sample_val);
      -- Aplica a amostra lida na entrada, convertendo para 16-bit signed
      data_in <= std_logic_vector(to_signed(sample_val, 16));

      -- Espera um ciclo de clock para processar a amostra (posedge e negedge)
      wait for CLOCK_PERIOD;  -- aplica um ciclo de clock por amostra:contentReference[oaicite:8]{index=8}

      -- Converte saída para inteiro (signed) para registro
      out_val := to_integer(signed(data_out));
      -- Escreve o valor de saída no arquivo de resultados
      write(line_out, out_val);
      writeline(file_out, line_out);
      -- Imprime entrada e saída no console (transcript)
      report "Entrada = " & integer'image(sample_val) & 
             ", Saida = " & integer'image(out_val) & 
             " (clock time = " & time'image(now) & ")";

    end loop;

    -- Fecha os arquivos
    file_close(file_in);
    file_close(file_out);

    -- Finaliza simulação
    wait for CLOCK_PERIOD;
    report "Fim da simulação. Resultados gravados em output_results.txt";
    wait;
  end process;

end architecture;

