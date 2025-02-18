import 'package:xml/xml.dart';
import 'dart:io';

void main() {
  print('Esse programa cria uma tag dentro de um XML já existente');

  final inputDir = Directory('C:/xml');
  final outputDir = Directory('C:/meus-xmls/processados');

  if (!inputDir.existsSync()) {
    print('Crie um diretório em C:/xml para iniciar o processamento');
    stdout.writeln("Pressione Enter para sair...");
    stdin.readLineSync();
    return;
  }

  // Cria o diretório de saída, se não existir
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  // Itera por todos os arquivos XML do diretório
  for (var file in inputDir.listSync()) {
    if (file is File && file.path.endsWith('.xml')) {
      processXml(file, outputDir);
    }
  }
}

void processXml(File file, Directory outputDir) {
  final xmlString = file.readAsStringSync();
  final document = XmlDocument.parse(xmlString);

  // Localiza a tag <efiEpi>
  final efiEpi = document.findAllElements('efiEpi').firstOrNull;

  if (efiEpi != null) {
    // Cria a nova tag <epi> com o conteúdo desejado
    final novaTag = XmlElement(XmlName('epi'), [], [
      XmlElement(XmlName('docAval'), [], [XmlText('13030')])
    ]);

    // Adiciona a nova tag logo após </efiEpi>
    efiEpi.parent?.children.insert(
      efiEpi.parent!.children.indexOf(efiEpi) + 1,
      novaTag,
    );

    print('Tag <epi> adicionada em: ${file.uri.pathSegments.last}');
  } else {
    print('Tag <efiEpi> não encontrada em: ${file.uri.pathSegments.last}');
  }

  // Salva o arquivo modificado no diretório de saída
  final outputFile = File('${outputDir.path}/${file.uri.pathSegments.last}');
  outputFile.writeAsStringSync(document.toXmlString(pretty: true));
}
