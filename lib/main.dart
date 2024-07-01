import 'package:dotenv/dotenv.dart';
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
    file = File(filePath!); // cria arquivo baseado na variável .ENV
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
  var env = DotEnv(includePlatformEnvironment: true)..load();
  String? caminhoDir = env['ORIGEM'];
  String? destinoArq = env['DESTINO'];
  await createFile(destinoArq); // Cria arquivo.

  // Validação se o caminho do diretório está vazio
  if (caminhoDir == null) {
    stdout.writeln("Caminho do diretório XML vazio, validar arquivo .ENV.");
  } else {
    stdout.writeln("Caminho do diretório XML encontrado.");
    // Processa todos os arquivos XML no diretório
    await processDirectory(caminhoDir, destinoArq);
  }
}
