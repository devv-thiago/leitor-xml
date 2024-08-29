# Projeto de Leitura e Processamento de Arquivos XML em Dart

## Visão Geral
Este projeto em Dart foi desenvolvido para ler, processar e extrair informações específicas de arquivos XML. O programa é capaz de buscar elementos específicos dentro dos arquivos XML em um diretório, formatar essas informações e escrevê-las em um arquivo de saída.

## Funcionalidades Principais

### 1. Leitura de Elementos XML Específicos
A função `readSpecificTag` lê e retorna os elementos XML correspondentes a uma tag específica em um arquivo XML. O caminho do arquivo e a tag são passados como parâmetros.

### 2. Criação de Arquivo
A função `createFile` cria um novo arquivo no caminho especificado. Se o arquivo já existir, ele será excluído antes de criar um novo.

### 3. Escrita em Arquivo
A função `writeInFile` recebe uma lista de elementos XML e os escreve no arquivo especificado. As informações são formatadas antes de serem escritas no arquivo.

### 4. Processamento de Diretório
A função `processDirectory` lista todos os arquivos XML em um diretório, lê os elementos desejados de cada arquivo, e escreve esses dados em um arquivo de saída.

### 5. Formatação de Informações
A função `formatInfo` é utilizada para extrair e formatar informações específicas dentro dos elementos XML.

## Execução do Programa
O programa é executado via linha de comando, onde o usuário deve fornecer dois argumentos: o caminho do diretório contendo os arquivos XML e o caminho do arquivo de saída.

```bash
Uso: <executável> <caminhoOrigem> <caminhoDestino>
```

Após a execução, o programa processa todos os arquivos XML no diretório especificado e grava as informações extraídas no arquivo de destino.

## Exemplo de Uso
Se o usuário deseja processar arquivos XML localizados no diretório `C:/xml_files` e gravar os resultados no arquivo `C:/output/result.txt`, ele pode executar o programa da seguinte forma:

```bash
<executável> C:/xml_files C:/output/result.txt
```

### Compilação do projeto em .EXE

```bash
dart compile exe <arquivoMain>
```

### Para facilitar uso .BAT

Para facilitar o uso, crie um arquivo .bat para ter um atalho e executar apenas, para criar arquivos BAT deixo o tutorial: [Como criar .BAT](https://meuwindows.com/arquivo-batch-como-criar-arquivos-bat-windows/#google_vignette)


