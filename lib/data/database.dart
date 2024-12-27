import 'package:Fluxx/data/tables.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sql.dart';

class Db {
  static Future<sql.Database> dataBase() async {
    final dbPath = await sql.getDatabasesPath();
    // await sql.deleteDatabase(path.join(dbPath, 'Fluxx.db'));

    return await sql.openDatabase(
      path.join(dbPath, 'Fluxx.db'),
      onCreate: (db, version) async {
        await db.execute(
          // Criar tabela de meses
          'CREATE TABLE ${Tables.months} (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
        // Criar tabela de contas
        await db.execute(
          'CREATE TABLE ${Tables.bills} ('
          'id TEXT PRIMARY KEY, '
          'month_id INTEGER, '
          'category_id INTEGER, '
          'name TEXT, '
          'price REAL, '
          'isPayed INTEGER, '
          'FOREIGN KEY (month_id) REFERENCES ${Tables.months} (id), '
          'FOREIGN KEY (category_id) REFERENCES ${Tables.category} (id))',
        );
        //criar a tabela do usuário
        await db.execute(
          'CREATE TABLE ${Tables.user} ('
          'name TEXT, '
          'salary REAL, '
          'picture TEXT)',
        );

        //criar  a tabela de receitas
        await db.execute(
          'CREATE TABLE ${Tables.revenue} ('
          'id TEXT PRIMARY KEY, '
          'name TEXT, '
          'value REAL, '
          'month_id INTEGER, '
          'isPublic INTEGER, '
          'FOREIGN KEY (month_id) REFERENCES ${Tables.months} (id))',
        );

        await constValues(db); // preenche as tabelas que terão valores fixos
      },
      version: 9,
    );
  }

  static Future<void> constValues(sql.Database db) async {
    // Inserir os 12 meses fixos
    await db.insert(Tables.months, {'id': 1, 'name': 'Janeiro'});
    await db.insert(Tables.months, {'id': 2, 'name': 'Fevereiro'});
    await db.insert(Tables.months, {'id': 3, 'name': 'Março'});
    await db.insert(Tables.months, {'id': 4, 'name': 'Abril'});
    await db.insert(Tables.months, {'id': 5, 'name': 'Maio'});
    await db.insert(Tables.months, {'id': 6, 'name': 'Junho'});
    await db.insert(Tables.months, {'id': 7, 'name': 'Julho'});
    await db.insert(Tables.months, {'id': 8, 'name': 'Agosto'});
    await db.insert(Tables.months, {'id': 9, 'name': 'Setembro'});
    await db.insert(Tables.months, {'id': 10, 'name': 'Outubro'});
    await db.insert(Tables.months, {'id': 11, 'name': 'Novembro'});
    await db.insert(Tables.months, {'id': 12, 'name': 'Dezembro'});

    // Caminho da imagem padrão
    String defaultImagePath = 'assets/images/default_user.jpeg';
    // Inserir o as informações iniciais do usuário
    await db.insert(Tables.user,
        {'name': 'usuário', 'salary': 0.0, 'picture': defaultImagePath});
  }

  static Future<int> insertBill(String table, BillModel data) async {
    final db = await Db.dataBase();
    final billData = data.toJson();

    if (billData['month_id'] == null) {
      throw Exception(
          "O campo 'month_id' é obrigatório para inserir uma conta.");
    }

    if (billData['category_id'] == null) {
      throw Exception(
          "O campo 'category_id' é obrigatório para inserir uma conta.");
    }

    try {
      int result = await db.insert(
        table,
        billData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Erro ao adicionar a conta: $e");
    }
  }

  static Future<int> deleteBill(
    String table,
    String billId,
  ) async {
    final db = await Db.dataBase();
    try {
      int result = await db.delete(
        table,
        where: 'id = ?',
        whereArgs: [billId],
      );
      return result;
    } catch (e) {
      throw Exception("Erro ao remover a conta: $e");
    }
  }

  static Future<int> updateBill(
      String table, String billId, BillModel newData) async {
    final db = await Db.dataBase();
    final updatedData = newData.toJson();

    try {
      int result = await db.update(
        table,
        updatedData,
        where: 'id = ?',
        whereArgs: [billId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Erro ao atualizar a conta: $e");
    }
  }

  static Future<int> updateUser(UserModel user) async {
    final db = await Db.dataBase();
    final updatedUser = user.toJson();

    try {
      int result = await db.update(
        Tables.user,
        updatedUser,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Erro ao atualizar o perfil : $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = await Db.dataBase();
    return db.query(Tables.user);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await Db.dataBase();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getBillsByMonth(
      String table, int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.query(
        table,
        where: 'month_id = ?',
        whereArgs: [monthId],
      );
      return result;
    } catch (e) {
      debugPrint("Erro ao consultar contas: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getBillsByMonthAndCategory(
      String table, int monthId, int categoryId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.query(
        table,
        where: 'month_id = ? AND category_id = ?',
        whereArgs: [monthId, categoryId],
      );
      return result;
    } catch (e) {
      debugPrint("Erro ao consultar contas: $e");
      return [];
    }
  }

  static Future<double> sumPricesByMonth(int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery(
        'SELECT SUM(price) as total FROM ${Tables.bills} WHERE month_id = ?',
        [monthId],
      );

      if (result.isNotEmpty && result[0]['total'] != null) {
        return result[0]['total'] as double;
      } else {
        return 0.0; // Se não houver contas, retorna 0
      }
    } catch (e) {
      debugPrint("Erro ao calcular a soma dos preços: $e");
      return 0.0;
    }
  }

  static Future<double> sumPricesByMonthPayed(int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery(
        'SELECT SUM(price) as total FROM ${Tables.bills} WHERE month_id = ? AND isPayed = 1',
        [monthId],
      );

      if (result.isNotEmpty && result[0]['total'] != null) {
        return result[0]['total'] as double;
      } else {
        return 0.0; // Se não houver contas pagas, retorna 0
      }
    } catch (e) {
      debugPrint("Erro ao calcular a soma dos preços pagos: $e");
      return 0.0;
    }
  }

  static Future<List<Map<String, dynamic>>> getTotalByCategory(
      int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT category_id, SUM(price) AS total
      FROM ${Tables.bills}
      WHERE month_id = ?
      GROUP BY category_id
    ''', [monthId]);

      return result;
    } catch (e) {
      debugPrint("Erro ao obter totais por categoria: $e");
      return [];
    }
  }

  static Future<int> insertRevenue(RevenueModel data) async {
    final db = await Db.dataBase();
    final revenueData = data.toJson();

    try {
      int result = await db.insert(
        Tables.revenue,
        revenueData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Erro ao adicionar a renda: $e");
    }
  }

  static Future<int> deleteRevenue(String revenueId) async {
    final db = await Db.dataBase();
    try {
      int result = await db.delete(
        Tables.revenue,
        where: 'id = ?',
        whereArgs: [revenueId],
      );
      return result;
    } catch (e) {
      throw Exception('Erro ao remover a renda: $e');
    }
  }

  static Future<int> updateRevenue(
      String revenueId, RevenueModel newData) async {
    final db = await Db.dataBase();
    final updatedData = newData.toJson();
    try {
      int result = await db.update(
        Tables.revenue,
        updatedData,
        where: 'id = ?',
        whereArgs: [revenueId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception('Erro ao atualizar a renda: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getPublicRevenues() async {
    final db = await Db.dataBase();

    try {
      final result = await db.query(
        Tables.revenue,
        where: 'isPublic = 1',
      );
      return result;
    } catch (e) {
      throw Exception('Erro ao consultar as receitas públicas : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getExclusiveRevenues(int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.query(
        Tables.revenue,
        where: 'isPublic = 0 AND month_id = ?',
        whereArgs: [monthId],
      );
      return result;
    } catch (e) {
      throw Exception('Erro ao consultar as receitas exclusivas : $e');
    }
  }
}
