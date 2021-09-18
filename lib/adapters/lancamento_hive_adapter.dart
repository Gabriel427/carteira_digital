import 'package:carteira_digital/models/lancamento.dart';
import 'package:hive/hive.dart';

class LancamentoHiveAdapter extends TypeAdapter<Lancamento> {
  @override
  final typeId = 0;

  @override
  Lancamento read(BinaryReader reader) {
    return Lancamento(
      id: reader.readInt(),
      titulo: reader.readString(),
      descricao: reader.readString(),
      categoria: reader.readString(),
      imagem: reader.readString(),
      valor: reader.readDouble(),
      data: reader.readString(),
      uid: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Lancamento obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.titulo);
    writer.writeString(obj.descricao);
    writer.writeString(obj.categoria);
    writer.writeString(obj.imagem);
    writer.writeDouble(obj.valor);
    writer.writeString(obj.data);
    writer.writeString(obj.data);
  }
}
