import 'package:xml/xml.dart';
import 'dart:io';

// Lê e retorna os elementos XML específicos de uma tag.
// [tag] é a tag que será buscada.
// [caminho] é o caminho do arquivo XML.
Future<Iterable<XmlElement>> readSpecificTag(String tag, String caminho) async {
  try {
    // Lê o arquivo de forma assíncrona
    var file = File(caminho);
    final data = await file.readAsString();

    // Faz o parse do conteúdo do arquivo para um documento XML
    final document = XmlDocument.parse(data);

    // Encontra todos os elementos com a tag especificada
    final tagResult = document.findAllElements(tag);

    return tagResult;
  } catch (e) {
    // Trata erros de leitura de arquivo ou parsing de XML
    stdout.writeln('Erro ao ler ou processar o arquivo: $e');
    return [];
  }
}

Future<File> createFile(String? filePath) async {
  File file;
  try {
    if (filePath == null || filePath.isEmpty) {
      throw Exception('O caminho do arquivo não pode ser nulo ou vazio.');
    }

    file = File(filePath);

    // Verifica se o arquivo já existe antes de tentar excluí-lo
    if (await file.exists()) {
      await file.delete(); // Deleta o arquivo se ele existir
      stdout.writeln("Arquivo existente deletado: $filePath");
    }

    // Cria um novo arquivo
    await file.create(recursive: true);
    stdout.writeln("Arquivo criado em: $filePath");
  } catch (e) {
    // Trata erros de criação de arquivo
    stdout.writeln('Erro ao criar o arquivo: $e');
    file = File('');
  }
  return file;
}

Future<void> writeInFile(String? filePath, Iterable<XmlElement> refNFeElements,
    Iterable<XmlElement> cProdElements) async {
  try {
    File file = File(filePath ??= "");
    var writeFile = file.openWrite(mode: FileMode.writeOnlyAppend);

    var refNFeList = refNFeElements.toList();
    var cProdList = cProdElements.toList();

    for (var i = 0; i < refNFeList.length; i++) {
      var refNFeValue = refNFeList[i];
      var refNFeValueFormatted = formatInfo(refNFeValue.toString(), 35, 42);

      for (var j = 0; j < cProdList.length; j++) {
        var cProdValue = cProdList[j];
        var cProdValueFormatted = formatInfo(cProdValue.toString(), 7, 11);
        writeFile.writeln('$refNFeValueFormatted,$cProdValueFormatted;');
      }
    }

    await writeFile
        .flush(); // Assegura que todo o conteúdo escrito seja realmente salvo no arquivo
    await writeFile.close(); // Fecha arquivo
  } catch (e) {
    stdout.writeln('Erro ao escrever no arquivo: $e');
  }
}

Future<void> processDirectory(String dirPath, String? destinoArq) async {
  var directory = Directory(dirPath);

  // Lista todos os arquivos XML no diretório
  var xmlFiles = await directory
      .list()
      .where((file) => file.path.endsWith('.xml'))
      .toList();

  for (var xmlFile in xmlFiles) {
    String caminhoArq = xmlFile.path;

    // Aguarda a leitura e processamento do arquivo XML
    Iterable<XmlElement> documentoXML2 =
        await readSpecificTag("refNFe", caminhoArq);
    Iterable<XmlElement> documentoXML3 =
        await readSpecificTag("cProd", caminhoArq);

    if (documentoXML2.isNotEmpty && documentoXML3.isNotEmpty) {
      // Grava os elementos encontrados em um arquivo.
      await writeInFile(destinoArq, documentoXML2, documentoXML3);
    } else {
      stdout.writeln('Nenhum elemento encontrado em: $caminhoArq');
    }
  }
  stdout.writeln('Dados escritos no arquivo: $dirPath');
}

// Coloca apenas informações do número da nota
String formatInfo(String info, int inicioInfo, int fimInfo) {
  String text1 = info.substring(inicioInfo, fimInfo);
  String text2 = text1.replaceAll(">", "");
  String text3 = text2.replaceAll("<", "");
  return text3;
}

void main(List<String> arguments) async {
  if (arguments.length < 2) {
    stdout.writeln('Uso: <executável> <caminhoOrigem> <caminhoDestino>');
    return;
  }

  String caminhoDir = arguments[0];
  String destinoArq = arguments[1];

  await createFile(destinoArq); // Cria arquivo.

  stdout.writeln("Caminho do diretório XML: $caminhoDir");

  // Processa todos os arquivos XML no diretório
  await processDirectory(caminhoDir, destinoArq);

  // Mantém o CMD aberto
  stdout.writeln("Pressione Enter para sair...");
  stdin.readLineSync();
}
