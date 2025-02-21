FROM python:3.12-slim

# Atualiza pip e instala dependências de build, incluindo cmake
RUN pip install --upgrade pip && \
    apt-get update && apt-get install -y \
      build-essential \
      gfortran \
      libopenblas-dev \
      curl \
      libssl-dev \
      autoconf \
      automake \
      libtool \
      pkg-config \
      cmake && \
    rm -rf /var/lib/apt/lists/*

# Baixa o código-fonte do scipy 1.12.0 e extrai
RUN pip download scipy==1.12.0 --no-binary :all: && \
    tar -xzf scipy-1.12.0.tar.gz && \
    rm scipy-1.12.0.tar.gz

# Patch opcional, se necessário (exemplo)
WORKDIR scipy-1.12.0
# RUN patch -p1 < fix.patch

# Instala o scipy customizado
RUN pip install .

# Volta para o diretório raiz e limpa
WORKDIR /
RUN rm -rf scipy-1.12.0

# Instala o google-meridian (que depende do scipy 1.12.0)
RUN pip install --default-timeout=600 --upgrade google-meridian
RUN pip install notebook

CMD ["/bin/bash", "-c", "python -c \"import meridian; print('Meridian instalado com sucesso!')\" && jupyter notebook --ip=0.0.0.0 --no-browser --allow-root"]
