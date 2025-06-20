library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIR_Filter_21tap is
  generic(
    DATA_WIDTH : integer := 16  -- Largura em bits da entrada e saída (16 bits)
  );
  port(
    clk      : in  std_logic;
    reset_n  : in  std_logic;
    data_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end entity;

architecture Behavioral of FIR_Filter_21tap is
  constant N_TAPS : integer := 21;
  constant COEFF_WIDTH : integer := 16;
  -- Vetor de coeficientes quantizados em 16 bits (Q15 format,  valores de exemplo)
  type coeff_array is array(0 to N_TAPS-1) of signed(COEFF_WIDTH-1 downto 0);
  constant COEFF : coeff_array := (
    to_signed(    0, 16),  -- Coef[0]  = 0.0   (exemplo: inicio do sinc)
    to_signed(  -70, 16),  -- Coef[1]  = -0.0021 ~ -70/32768
    to_signed( -207, 16),  -- Coef[2]  = -0.0063
    to_signed( -380, 16),  -- Coef[3]  = -0.0116
    to_signed( -405, 16),  -- Coef[4]  = -0.0124
    to_signed(    0, 16),  -- Coef[5]  = ~0.0
    to_signed( 1041, 16),  -- Coef[6]  =  0.0318
    to_signed( 2668, 16),  -- Coef[7]  =  0.0814
    to_signed( 4505, 16),  -- Coef[8]  =  0.1375
    to_signed( 5968, 16),  -- Coef[9]  =  0.1821
    to_signed( 6526, 16),  -- Coef[10] =  0.1992  (coeficiente central)
    to_signed( 5968, 16),  -- Coef[11] =  0.1821
    to_signed( 4505, 16),  -- Coef[12] =  0.1375
    to_signed( 2668, 16),  -- Coef[13] =  0.0814
    to_signed( 1041, 16),  -- Coef[14] =  0.0318
    to_signed(    0, 16),  -- Coef[15] = ~0.0
    to_signed( -405, 16),  -- Coef[16] = -0.0124
    to_signed( -380, 16),  -- Coef[17] = -0.0116
    to_signed( -207, 16),  -- Coef[18] = -0.0063
    to_signed(  -70, 16),  -- Coef[19] = -0.0021
    to_signed(    0, 16)   -- Coef[20] =  0.0
  );

  -- Registrador de deslocamento para 21 amostras (delay line), inicializado em 0
  type sample_array is array(0 to N_TAPS-1) of signed(DATA_WIDTH-1 downto 0);
  signal shift_reg : sample_array := (others => (others => '0'));

  -- Largura do acumulador: 32 bits do produto + 5 bits de proteção = 37 bits
  constant ACC_WIDTH : integer := 37;
  signal acc_sum : signed(ACC_WIDTH-1 downto 0);
begin

  -- Processo síncrono de filtragem
  process(clk, reset_n)
    variable sum_var : signed(ACC_WIDTH-1 downto 0);
  begin
    if reset_n = '0' then
      -- Limpa os registros e acumulador no reset assíncrono
      shift_reg <= (others => (others => '0'));
      acc_sum   <= (others => '0');
      data_out  <= (others => '0');
    elsif rising_edge(clk) then
      -- Insere nova amostra no início do shift register
      shift_reg(0) <= signed(data_in);
      -- Desloca as amostras antigas
      for i in 1 to N_TAPS-1 loop
        shift_reg(i) <= shift_reg(i-1);
      end loop;
      -- Realiza a operação MAC: multiplica e acumula todos os taps
      sum_var := (others => '0');
      for j in 0 to N_TAPS-1 loop
        sum_var := sum_var + (shift_reg(j) * COEFF(j));
      end loop;
      acc_sum <= sum_var;  -- registra soma (opcional, aqui apenas para debug)
      -- Trunca o acumulador para 16 bits (descarta bits fracionários Q15)
      data_out <= std_logic_vector(sum_var(ACC_WIDTH-1 downto ACC_WIDTH-DATA_WIDTH));
      -- Os bits ACC_WIDTH-1 .. ACC_WIDTH-16 correspondem ao valor filtrado em 16 bits
    end if;
  end process;

end architecture;

