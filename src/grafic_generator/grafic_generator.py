from pathlib import Path
from typing import List
import matplotlib.pyplot as plt


def carregar_dados(arq: str | Path) -> List[int]:
    """
    Lê 'arq' (um valor decimal por linha) e devolve lista de inteiros.

    >>> valores = carregar_dados("input_vectors.txt")
    """
    caminho = Path(arq)
    if not caminho.is_file():
        raise FileNotFoundError(f"Arquivo '{arq}' não encontrado.")
    with caminho.open() as f:
        # ignora linhas vazias e converte para int
        return [int(l.strip()) for l in f if l.strip()]


def plotar_sinal(dados: List[int], titulo: str, arq_png: str | Path) -> None:
    """
    Plota 'dados' e salva a figura em 'arq_png' (.png).

    >>> plotar_sinal(valores, "Sinal de entrada", "entrada.png")
    """
    plt.figure(figsize=(10, 4))
    plt.plot(dados, linewidth=1.4)
    plt.title(titulo)
    plt.xlabel("Índice da amostra")
    plt.ylabel("Amplitude (Q15)")
    plt.grid(True, linestyle="--", alpha=0.4)
    plt.tight_layout()
    plt.savefig(arq_png, dpi=300)
    plt.close()
    print(f"Figura salva em: {arq_png}")


# ---------------------------------------------------------------------------
if __name__ == "__main__":
    # Arquivos padrão (mesma pasta do script)
    in_file  = Path("input_vectors.txt")
    out_file = Path("output_results.txt")

    # Gera gráficos somente se os arquivos existirem
    if in_file.exists():
        dados_in = carregar_dados(in_file)
        plotar_sinal(dados_in, "Sinal de ENTRADA (input_vectors)", "input.png")
    else:
        print(f"[AVISO] '{in_file}' não encontrado — gráfico de entrada não gerado.")

    if out_file.exists():
        dados_out = carregar_dados(out_file)
        plotar_sinal(dados_out, "Sinal de SAÍDA filtrada (output_results)", "output.png")
    else:
        print(f"[AVISO] '{out_file}' não encontrado — gráfico de saída não gerado.")
