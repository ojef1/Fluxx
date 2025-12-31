import 'package:Fluxx/data/tables.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/models/user_model.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class Db {
  static sql.Database? _db;

  //--------------------------INICIO -> CRIAR BANCO-----------------------------------------------
  static Future<sql.Database> dataBase() async {
    if (_db != null) return _db!;

    final dbPath = await sql.getDatabasesPath();
    // await sql.deleteDatabase(path.join(dbPath, 'Fluxx.db'));

    _db = await sql.openDatabase(
      path.join(dbPath, 'Fluxx.db'),
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 21) {
          await db.transaction((txn) async {
            // =======================
            // 🔁 REVENUE
            // =======================
            await txn.execute('''
        CREATE TABLE revenue_new (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          value REAL NOT NULL,
          start_month_id INTEGER,
          end_month_id INTEGER,
          is_monthly INTEGER,
          FOREIGN KEY (start_month_id) REFERENCES months (id),
          FOREIGN KEY (end_month_id) REFERENCES months (id)
        )
      ''');

            final oldRevenues = await txn.query('revenue');

            for (final revenue in oldRevenues) {
              await txn.insert(
                'revenue_new',
                {
                  'id': revenue['id'],
                  'name': revenue['name'],
                  'value': revenue['value'],
                  'start_month_id': revenue['start_month_id'],
                  'end_month_id': revenue['end_month_id'],
                  'is_monthly': 1, // valor padrão
                },
              );
            }

            await txn.execute('DROP TABLE revenue');
            await txn.execute('ALTER TABLE revenue_new RENAME TO revenue');

            // =======================
            // ➕ CATEGORY
            // =======================
            await txn.execute('''
        CREATE TABLE category_new (
          id TEXT PRIMARY KEY,
          name TEXT,
          start_month_id INTEGER,
          end_month_id INTEGER,
          is_monthly INTEGER,
          FOREIGN KEY (start_month_id) REFERENCES months (id),
          FOREIGN KEY (end_month_id) REFERENCES months (id)
        )
      ''');

            final oldCategories = await txn.query('category');

            for (final category in oldCategories) {
              await txn.insert(
                'category_new',
                {
                  'id': category['id'],
                  'name': category['name'],
                  'start_month_id': null,
                  'end_month_id': null,
                  'is_monthly': 1, // valor padrão
                },
              );
            }

            await txn.execute('DROP TABLE category');
            await txn.execute('ALTER TABLE category_new RENAME TO category');
          });
        }
      },
      onCreate: (db, version) async {
        await db.execute('PRAGMA foreign_keys = ON');
        await db.execute(
          //Criar tabela de anos
          'CREATE TABLE ${Tables.years} (id INTEGER PRIMARY KEY AUTOINCREMENT,value INTEGER NOT NULL)',
        );
        await db.execute(
          // Criar tabela de meses
          'CREATE TABLE ${Tables.months} ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT, '
          'month_number INTEGER NOT NULL, '
          'year_id INTEGER NOT NULL, '
          'FOREIGN KEY (year_id) REFERENCES ${Tables.years} (id))',
        );
        // Criar tabela de contas
        await db.execute(
          'CREATE TABLE ${Tables.bills} ('
          'id TEXT PRIMARY KEY, '
          'name TEXT, '
          'price REAL, '
          'paymentDate TEXT, '
          'description TEXT, '
          'category_id TEXT NOT NULL, '
          'payment_id TEXT NULL, '
          'month_id INTEGER, '
          'isPayed INTEGER, '
          'FOREIGN KEY (month_id) REFERENCES ${Tables.months} (id), '
          'FOREIGN KEY (payment_id) REFERENCES ${Tables.revenue} (id) ON DELETE SET NULL, '
          'FOREIGN KEY (category_id) REFERENCES ${Tables.category} (id) ON DELETE RESTRICT)',
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
          'name TEXT NOT NULL, '
          'value REAL NOT NULL, '
          'start_month_id INTEGER, '
          'end_month_id INTEGER, '
          'is_monthly INTEGER, '
          'FOREIGN KEY (start_month_id) REFERENCES ${Tables.months} (id), '
          'FOREIGN KEY (end_month_id) REFERENCES ${Tables.months} (id))',
        );

        //criar a tabela de categorias
        await db.execute(
          'CREATE TABLE ${Tables.category} ('
          'id TEXT PRIMARY KEY, '
          'name TEXT)'
          'start_month_id INTEGER, '
          'end_month_id INTEGER, '
          'is_monthly INTEGER, '
          'FOREIGN KEY (start_month_id) REFERENCES ${Tables.months} (id), '
          'FOREIGN KEY (end_month_id) REFERENCES ${Tables.months} (id))',
        );

        await constValues(db); // preenche as tabelas que terão valores fixos
      },
      version: 21,
    );
    return _db!;
  }

  static Future<void> constValues(sql.Database db) async {
    await _insertYear(db, DateTime.now().year);

    // Caminho da imagem padrão
    String defaultImagePath = 'assets/images/default_user.jpeg';
    // Inserir o as informações iniciais do usuário
    await db.insert(Tables.user,
        {'name': 'usuário', 'salary': 0.0, 'picture': defaultImagePath});
  }
  //---------------------------FIM -> CRIAR BANCO-------------------------

  //---------------------------INICIO -> PEGAR-------------------------
  static Future<int> getYearId(int year) async {
    final db = await Db.dataBase();
    final result = await db.query(
      Tables.years,
      where: 'value = ?',
      whereArgs: [year],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      // Se o ano não existir, insere um novo ano e retorna o ID
      return await _insertYear(db, year);
    }
  }

  static Future<int> getMonthId({
    required int yearId,
    required int month,
  }) async {
    final db = await Db.dataBase();

    final result = await db.query(
      Tables.months,
      where: 'year_id = ? AND month_number = ?',
      whereArgs: [yearId, month],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return await _insertMonth(db, month, yearId);
    }
  }

  static Future<List<Map<String, dynamic>>> getYears() async {
    final db = await Db.dataBase();
    return db.query(Tables.years);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await Db.dataBase();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getMonths(int year) async {
    final db = await Db.dataBase();

    // Busca o id do ano atual na tabela 'years'
    final yearResult = await db.query(
      Tables.years,
      where: 'value = ?',
      whereArgs: [year],
      limit: 1,
    );

    // Se o ano não for encontrado, retorna lista vazia
    if (yearResult.isEmpty) return [];

    final yearId = yearResult.first['id'] as int;

    // Busca os meses que pertencem ao ano atual
    return await db.query(
      Tables.months,
      where: 'year_id = ?',
      whereArgs: [yearId],
    );
  }

  static Future<Map<String, dynamic>?> getMonthById(int monthId) async {
    final db = await Db.dataBase();

    final result = await db.query(
      Tables.months,
      where: 'id = ?',
      whereArgs: [monthId],
      limit: 1,
    );

    return result.isEmpty ? null : result.first;
  }

  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = await Db.dataBase();
    return db.query(Tables.user);
  }

  static Future<List<Map<String, dynamic>>> getBillsByMonth(int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT ${Tables.bills}.*, 
             ${Tables.category}.name AS category_name, 
             ${Tables.revenue}.name AS payment_name
      FROM ${Tables.bills}
      LEFT JOIN ${Tables.category} 
        ON ${Tables.bills}.category_id = ${Tables.category}.id
      LEFT JOIN ${Tables.revenue} 
        ON ${Tables.bills}.payment_id = ${Tables.revenue}.id
      WHERE ${Tables.bills}.month_id = ?
    ''', [monthId]);

      return result;
    } catch (e) {
      debugPrint("Erro ao consultar contas com joins: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getBillById(
      String billId, int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT ${Tables.bills}.*, 
             ${Tables.category}.name AS category_name, 
             ${Tables.revenue}.name AS payment_name
      FROM ${Tables.bills}
      LEFT JOIN ${Tables.category} 
        ON ${Tables.bills}.category_id = ${Tables.category}.id
      LEFT JOIN ${Tables.revenue} 
        ON ${Tables.bills}.payment_id = ${Tables.revenue}.id
      WHERE ${Tables.bills}.id = ? AND ${Tables.bills}.month_id = ?
      LIMIT 1
    ''', [billId, monthId]);

      // Retorna o primeiro item encontrado ou null se não houver resultado
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      debugPrint("Erro ao consultar conta pelo ID e mês: $e");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getMonthlyRevenues(
      int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT * FROM ${Tables.revenue}
      WHERE is_monthly = 1
        AND start_month_id <= ?
        AND (end_month_id >= ? OR end_month_id IS NULL)
    ''', [monthId, monthId]);

      return result;
    } catch (e) {
      throw Exception('Erro ao consultar as receitas públicas: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getSingleRevenues(
      int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT * FROM ${Tables.revenue}
      WHERE is_monthly = 0
        AND start_month_id <= ?
        AND end_month_id >= ?
        
    ''', [monthId, monthId]);

      return result;
    } catch (e) {
      throw Exception('Erro ao consultar as receitas exclusivas: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getMonthlyCategories(int monthId) async{
    final db = await Db.dataBase();
    try {
      final result = await db.rawQuery('''
      SELECT * FROM ${Tables.category}
      WHERE is_monthly = 1
        AND start_month_id <= ?
        AND (end_month_id >= ? OR end_month_id IS NULL)
    ''', [monthId, monthId]);

      return result;
    } catch (e) {
      throw Exception('Erro ao consultar as categorias públicas: $e');
    }
  } 

  static Future<List<Map<String, dynamic>>> getSingleCategories(int monthId) async {
    final db = await Db.dataBase();
    try {
      final result = await db.rawQuery('''
      SELECT * FROM ${Tables.category}
      WHERE is_monthly = 0
        AND start_month_id <= ?
        AND end_month_id >= ?
    ''', [monthId, monthId]);

      return result;
    } catch (e) {
      throw Exception('Erro ao consultar as categorias exclusivas: $e');
    }
  }

  static Future<String?> getMostUsedCategoryByMonth(int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT c.name, SUM(b.price) as total
      FROM ${Tables.bills} b
      JOIN ${Tables.category} c ON b.category_id = c.id
      WHERE b.month_id = ?
      GROUP BY c.name
      ORDER BY total DESC
      LIMIT 1
    ''', [monthId]);

      return result.isNotEmpty ? result.first['name'] as String : null;
    } catch (e) {
      debugPrint("Erro ao buscar categoria mais usada: $e");
      return null;
    }
  }

  static Future<String?> getMostUsedRevenueByMonth(int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT r.name, SUM(b.price) as total
      FROM ${Tables.bills} b
      JOIN ${Tables.revenue} r ON b.payment_id = r.id
      WHERE b.month_id = ?
      GROUP BY r.name
      ORDER BY total DESC
      LIMIT 1
    ''', [monthId]);

      return result.isNotEmpty ? result.first['name'] as String : null;
    } catch (e) {
      debugPrint("Erro ao buscar receita mais usada: $e");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getTotalByCategory(
      int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT c.name AS category_name, SUM(b.price) AS total
      FROM ${Tables.bills} b
      INNER JOIN ${Tables.category} c ON b.category_id = c.id
      WHERE b.month_id = ?
      GROUP BY b.category_id, c.name
    ''', [monthId]);

      return result;
    } catch (e) {
      debugPrint("Erro ao obter totais por categoria: $e");
      return [];
    }
  }

  //---------------------------FIM -> PEGAR-------------------------

  //---------------------------INICIO -> PEGAR TOTAL-------------------------
  static Future<double> getTotalByMonth(int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
    SELECT SUM(price) AS total
    FROM ${Tables.bills}
    WHERE month_id = ?
    ''', [monthId]);

      return result.isNotEmpty
          ? (result.first['total'] as double? ?? 0.0)
          : 0.0;
    } catch (e) {
      debugPrint("Erro ao obter total do mês: $e");
      return 0.0;
    }
  }

  static Future<double> getBoundBillsTotalByMonth(int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT SUM(price) AS total
      FROM ${Tables.bills}
      WHERE month_id = ? AND payment_id IS NOT NULL
    ''', [monthId]);

      return result.isNotEmpty
          ? (result.first['total'] as double? ?? 0.0)
          : 0.0;
    } catch (e) {
      debugPrint("Erro ao obter total de gastos vinculados: $e");
      return 0.0;
    }
  }
  //---------------------------FIM -> PEGAR TOTAL-------------------------

  //---------------------------INICIO -> INSERIR-------------------------

  static Future<int> _insertYear(sql.Database db, int yearValue) async {
    try {
      int result = await db.insert(
        Tables.years,
        {'value': yearValue},
        conflictAlgorithm: sql.ConflictAlgorithm.ignore,
      );

      for (final month in AppMonths.all) {
        await _insertMonth(db, month.monthNumber!, result);
      }

      return result;
    } catch (e) {
      throw Exception('Erro ao inserir ano: $e');
    }
  }

  static _insertMonth(sql.Database db, int monthNumber, int yearId) async {
    try {
      final monthName = AppMonths.all
          .firstWhere((month) => month.monthNumber == monthNumber)
          .name;
      int result = await db.insert(
        Tables.months,
        {
          'name': monthName,
          'month_number': monthNumber,
          'year_id': yearId,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.ignore,
      );
      return result;
    } catch (e) {
      throw Exception('Erro ao inserir mês: $e');
    }
  }

  static Future<int> insertRevenue(RevenueModel data) async {
    final db = await Db.dataBase();
    final revenueData = data.toJson();

    try {
      int result = await db.insert(
        Tables.revenue,
        revenueData,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Erro ao adicionar a receita: $e");
    }
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
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Erro ao adicionar a conta: $e");
    }
  }

  static Future<int> insertCategory(CategoryModel data) async {
    final db = await Db.dataBase();
    final dataJson = data.toJson();

    try {
      int result = await db.insert(
        Tables.category,
        dataJson,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception('Erro ao inserir categoria: $e');
    }
  }
  //---------------------------FIM -> INSERIR-------------------------

  //---------------------------INICIO -> DELETAR-------------------------
  static Future<int> disableRevenue(String revenueId, int endMonth) async {
    final db = await Db.dataBase();

    try {
      int result = await db.update(
        Tables.revenue,
        {
          'end_month_id': endMonth,
        },
        where: 'id = ?',
        whereArgs: [revenueId],
      );

      return result;
    } catch (e) {
      throw Exception('Erro ao desativar a receita: $e');
    }
  }

  static Future<int> disableCategory(String categoryId, int endMonth) async {
    final db = await Db.dataBase();

    try {
      int result = await db.update(
        Tables.category,
        {
          'end_month_id': endMonth,
        },
        where: 'id = ?',
        whereArgs: [categoryId],
      );

      return result;
    } catch (e) {
      throw Exception('Erro ao desativar a receita: $e');
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

  //---------------------------FIM -> DELETAR-------------------------

  //---------------------------INICIO -> ATUALIZAR-------------------------
  static Future<int> updateRevenue(RevenueModel newData) async {
    final db = await Db.dataBase();
    final revenueId = newData.id;
    final updatedData = newData.toJson();
    try {
      int result = await db.update(
        Tables.revenue,
        updatedData,
        where: 'id = ?',
        whereArgs: [revenueId],
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception('Erro ao atualizar a receita: $e');
    }
  }

  static Future<int> updateCategory(CategoryModel newData) async {
    final db = await Db.dataBase();
    final categoryId = newData.id;
    final updatedData = newData.toJson();
    try {
      int result = await db.update(
        Tables.category,
        updatedData,
        where: 'id = ?',
        whereArgs: [categoryId],
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception('Erro ao atualizar a receita: $e');
    }
  }

  static Future<int> updateUser(UserModel user) async {
    final db = await Db.dataBase();
    final updatedUser = user.toJson();

    try {
      int result = await db.update(
        Tables.user,
        updatedUser,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Erro ao atualizar o perfil : $e");
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
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Erro ao atualizar a conta: $e");
    }
  }

  static Future<int> updatePaymentStatus(String billId, int status) async {
    final db = await Db.dataBase();
    try {
      return await db.update(
        Tables.bills,
        {'isPayed': status},
        where: 'id = ?',
        whereArgs: [billId],
      );
    } catch (e) {
      throw Exception('Erro ao atualizar o status da conta : $e');
    }
  }

  //---------------------------FIM -> ATUALIZAR-------------------------

  //---------------------------INICIO -> SOMAS-------------------------
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

  //---------------------------FIM -> SOMAS-------------------------
}
