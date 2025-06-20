### Como usar o gerador de gráficos

1. Abra o ficheiro`grafic_generator.py`.
2. Coloque `input_vectors.txt` e `output_results.txt` na mesma pasta (ou ajuste os nomes no bloco `__main__`).
3. Execute:

```bash
python grafic_generator.py
```

Serão gerados dois arquivos PNG:

* **input.png**  → visualização do sinal aplicado ao filtro
* **output.png** → visualização do sinal filtrado

Caso só um dos arquivos texto exista, apenas o gráfico correspondente será criado; o script avisa no console se algum arquivo faltar.
