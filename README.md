# Relatório Assignment 3 – Filtro FIR Digital em VHDL

**Aluno**: Marcelo Santos
**Email**: [a79433@ualg.pt](mailto:a79433@ualg.pt)
**Unidade Curricular**: Computação Reconfigurável
**Instituição**: Universidade do Algarve

---

## 📘 Objetivo do Projeto

O objetivo deste trabalho é implementar e validar a operação de um filtro FIR (Finite Impulse Response) digital, usando linguagem VHDL e simulação no ModelSim, como parte da UC de Computação Reconfigurável. O projeto explora os conceitos de:

* Filtros digitais passa-baixo em arquitetura direta (Direct Form)
* Multiplicação-acumulação sequencial com coeficientes em ponto fixo (Q15)
* Testbench com leitura/escrita de arquivos e estímulo temporal realista
* Visualização gráfica da resposta ao sinal de entrada

---

## ⚙️ Implementação

### Filtro FIR

O filtro FIR foi implementado com **21 coeficientes** definidos no domínio do tempo, obtidos através da ferramenta [T-Filter](http://t-filter.engineerjs.com/), e posteriormente quantizados para 16 bits (formato **Q15**, ou seja, ponto fixo com 15 bits fracionários e 1 de sinal).

A arquitetura utilizada é **forma direta** com registradores de deslocamento e operação de MAC (Multiply and Accumulate), sincronizada por clock. O filtro recebe uma nova amostra por ciclo e acumula o resultado completo da convolução em um registrador de 37 bits, com a saída truncada de volta para 16 bits.

### Testbench

Foi desenvolvido um testbench (`tb_fir.vhd`) que:

* Lê os dados de entrada a partir de `src/input_vectors.txt`
* Aplica os dados ao filtro com um ciclo de clock por amostra
* Escreve os resultados da filtragem em `src/output_results.txt`
* Imprime no transcript os pares entrada/saída a cada ciclo

---

## 🧪 Estímulo e Simulação

Para validação funcional, foi aplicado ao filtro um **sinal senoidal de 100 Hz** (amostrado a 2 kHz), com amplitude de 0,5 (Q15: ±16384). Esse sinal foi usado por estar **dentro da banda passante** do filtro projetado, e permite avaliar o comportamento do sistema em regime permanente.

O sinal de entrada encontra-se em `src/input_vectors.txt`, e a saída gerada pela simulação está em `src/output_results.txt`.

---

## 📈 Resultados

Os gráficos abaixo foram gerados com o script `plot_fir.py`, e representam visualmente o comportamento do filtro:

### 🎵 Entrada (src/input.png)

![input.png](src/input.png)

* Sinal senoidal puro com frequência constante e sem distorções.
* Amplitude corresponde a \~50% da escala Q15 (±16384).

### 🔉 Saída (src/output.png)

![output.png](src/output.png)

* Sinal filtrado suavizado, com leve atenuação nas bordas, típico da resposta de um FIR com janelamento.
* Confirma que a **frequência de 100 Hz está dentro da banda passante** do filtro FIR projetado.

---

## ✅ Conclusões

O filtro FIR implementado demonstrou comportamento consistente com o especificado:

* Resposta coerente com a teoria (resposta ao degrau e impulso testadas)
* Arquitetura síncrona compatível com FPGA
* Suporte a entrada e saída via arquivos para visualização em ferramentas externas

A validação via simulação e gráficos confirma a funcionalidade do filtro FIR digital com os coeficientes fornecidos, e serve como base sólida para posterior síntese e implementação em hardware reconfigurável.
