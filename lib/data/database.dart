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
  //--------------------------INICIO -> CRIAR BANCO-----------------------------------------------
  static Future<sql.Database> dataBase() async {
    final dbPath = await sql.getDatabasesPath();
    // await sql.deleteDatabase(path.join(dbPath, 'Fluxx.db'));

    return await sql.openDatabase(
      path.join(dbPath, 'Fluxx.db'),
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
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
          'is_active INTEGER NOT NULL DEFAULT 1, ' // 1 = ativa, 0 = desativada
          'isPublic INTEGER, '
          'FOREIGN KEY (start_month_id) REFERENCES ${Tables.months} (id), '
          'FOREIGN KEY (end_month_id) REFERENCES ${Tables.months} (id))',
        );

        //criar a tabela de categorias
        await db.execute(
          'CREATE TABLE ${Tables.category} ('
          'id TEXT PRIMARY KEY, '
          'name TEXT)',
        );

        await constValues(db); // preenche as tabelas que terão valores fixos
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 20) {
          await db.transaction((txn) async {
            // 1️⃣ Criar nova tabela months com month_number
            await txn.execute('''
        CREATE TABLE months_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          month_number INTEGER NOT NULL,
          year_id INTEGER NOT NULL,
          FOREIGN KEY (year_id) REFERENCES years (id)
        )
      ''');

            // 2️⃣ Buscar meses antigos
            final oldMonths = await txn.query('months');

            // 3️⃣ Mapa seguro de nome → número
            final monthMap = {
              'Janeiro': 1,
              'Fevereiro': 2,
              'Março': 3,
              'Abril': 4,
              'Maio': 5,
              'Junho': 6,
              'Julho': 7,
              'Agosto': 8,
              'Setembro': 9,
              'Outubro': 10,
              'Novembro': 11,
              'Dezembro': 12,
            };

            // 4️⃣ Migrar mantendo o MESMO ID
            for (final month in oldMonths) {
              final String name = month['name'] as String;
              final int monthNumber = monthMap[name]!;

              await txn.insert(
                'months_new',
                {
                  'id': month['id'], // mantém o ID!
                  'name': name,
                  'month_number': monthNumber,
                  'year_id': month['year_id'],
                },
              );
            }

            // 5️⃣ Dropar tabela antiga
            await txn.execute('DROP TABLE months');

            // 6️⃣ Renomear tabela nova
            await txn.execute('ALTER TABLE months_new RENAME TO months');
          });
        }
      },
      version: 20,
    );
  }

  static Future<void> constValues(sql.Database db) async {
    _insertYear(DateTime.now().year);

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
      return await _insertYear(year);
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
      return await _insertMonth(month, yearId);
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

  static Future<List<Map<String, dynamic>>> getPublicRevenues(
      int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT * FROM ${Tables.revenue}
      WHERE isPublic = 1
        AND start_month_id <= ?
        AND (end_month_id >= ? OR end_month_id IS NULL)
    ''', [monthId, monthId]);

      return result;
    } catch (e) {
      throw Exception('Erro ao consultar as receitas públicas: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getExclusiveRevenues(
      int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT * FROM ${Tables.revenue}
      WHERE isPublic = 0
        AND start_month_id <= ?
        AND end_month_id >= ?
        
    ''', [monthId, monthId]);

      return result;
    } catch (e) {
      throw Exception('Erro ao consultar as receitas exclusivas: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await Db.dataBase();
    try {
      final result = await db.query(Tables.category);
      return result;
    } catch (e) {
      throw Exception('Erro ao consultar as categorias: $e');
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
      debugPrint("Erro ao buscar renda mais usada: $e");
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

  static Future<int> _insertYear(int yearValue) async {
    final db = await Db.dataBase();
    try {
      int result = await db.insert(
        Tables.years,
        {'value': yearValue},
        conflictAlgorithm: sql.ConflictAlgorithm.ignore,
      );

      for (final month in AppMonths.all) {
        await _insertMonth(month.monthNumber!, result);
      }

      return result;
    } catch (e) {
      throw Exception('Erro ao inserir ano: $e');
    }
  }

  static _insertMonth(int monthNumber, int yearId) async {
    final db = await Db.dataBase();
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
      throw Exception("Erro ao adicionar a renda: $e");
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
  static Future<int> deactivateRevenue(String revenueId, int endMonth) async {
    final db = await Db.dataBase();

    try {
      int result = await db.update(
        Tables.revenue,
        {
          'is_active': 0,
          'end_month_id': endMonth,
        },
        where: 'id = ?',
        whereArgs: [revenueId],
      );

      return result;
    } catch (e) {
      throw Exception('Erro ao desativar a renda: $e');
    }
  }

  static Future<int> deleteCategory(String categoryId) async {
    final db = await Db.dataBase();
    try {
      int result = await db.delete(
        Tables.category,
        where: 'id = ?',
        whereArgs: [categoryId],
      );
      return result;
    } catch (e) {
      throw Exception('Erro ao remover a renda: $e');
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
      throw Exception('Erro ao atualizar a renda: $e');
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
      throw Exception('Erro ao atualizar a renda: $e');
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
