enum Categorys { casa, transporte, saude, lazer, alimentacao}

extension CategoryExtension on Categorys {
  int toInt() {
    switch (this) {
      case Categorys.casa:
        return 0;
      case Categorys.transporte:
        return 1;
      case Categorys.saude:
        return 2;
      case Categorys.lazer:
        return 3;
      case Categorys.alimentacao:
        return 4;
      default:
        return 0;
    }
  }

  static int fromNameToInt(String name) {
    switch (name) {
      case 'Casa':
        return 0;
      case "Transporte":
        return 1;
      case "Saúde":
        return 2;
      case "Lazer":
        return 3;
      case "Alimentação":
        return 4;
      default:
        return 0;
    }
  }

  static String fromIntToString(int num){
    switch (num) {
      case 0:
        return "Casa";
      case 1:
        return "Transporte";
      case 2:
        return "Saúde";
      case 3:
        return "Lazer";
      case 4:
        return "Alimentação";
      default:
        return "Categorias";
    }
  }

  static Categorys toEnum(int num) {
    switch (num) {
      case 0:
        return Categorys.casa;
      case 1:
        return Categorys.transporte;
      case 2:
        return Categorys.saude;
      case 3:
        return Categorys.lazer;
      case 4:
        return Categorys.alimentacao;
      default:
        return Categorys.casa;
    }
  }
}
