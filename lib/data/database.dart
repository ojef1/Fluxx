import 'dart:developer';

import 'package:Fluxx/data/tables.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/category_model.dart';
import 'package:Fluxx/models/credit_card_model.dart';
import 'package:Fluxx/models/invoice_bill_model.dart';
import 'package:Fluxx/models/invoice_model.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/models/user_model.dart';
import 'package:Fluxx/services/credit_card_services.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

part 'transactions.dart';

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
        log(
          'versão antiga > $oldVersion, nova: $newVersion',
        );
        if (oldVersion < 28) {
          //criar a tabela de cartões de crédito
          await db.execute(
            'CREATE TABLE IF NOT EXISTS ${Tables.creditCards} ('
            'id TEXT PRIMARY KEY, '
            'name TEXT NOT NULL, '
            'total_limit REAL NOT NULL, '
            'closing_day INTEGER, '
            'bank_id INTEGER, '
            'network_id INTEGER, '
            'last_digits TEXT, '
            'due_day INTEGER,'
            'is_active INTEGER NOT NULL DEFAULT 1 )',
          );

          //criar a tabela de contas do cartão de crédito
          await db.execute(
            'CREATE TABLE IF NOT EXISTS ${Tables.creditCardsBills} ('
            'id TEXT PRIMARY KEY, '
            'credit_card_id TEXT NOT NULL, '
            'category_id TEXT NOT NULL, '
            'name TEXT, '
            'description TEXT, '
            'price REAL, '
            'date TEXT, '
            'invoice_id TEXT, '
            'installment_number INTEGER NOT NULL, '
            'installment_total INTEGER NOT NULL, '
            'installment_group_id TEXT NOT NULL, '
            'FOREIGN KEY (invoice_id) REFERENCES ${Tables.creditCardsInvoices} (id), '
            'FOREIGN KEY (category_id) REFERENCES ${Tables.category} (id) ON DELETE RESTRICT, '
            'FOREIGN KEY (credit_card_id) REFERENCES ${Tables.creditCards} (id) ON DELETE SET NULL)',
          );

          //criar a tabela de faturas de cartão de crédito
          await db.execute(
            'CREATE TABLE IF NOT EXISTS ${Tables.creditCardsInvoices} ('
            'id TEXT PRIMARY KEY, '
            'credit_card_id TEXT , '
            'category_id TEXT NOT NULL, '
            'payment_id TEXT NULL, '
            'month_id INTEGER NOT NULL, '
            'due_date TEXT NOT NULL, '
            'start_date TEXT NOT NULL, '
            'end_date TEXT NOT NULL, '
            'price REAL, '
            'is_paid INTEGER, '
            'FOREIGN KEY (credit_card_id) REFERENCES ${Tables.creditCards} (id) ON DELETE RESTRICT, '
            'FOREIGN KEY (category_id) REFERENCES ${Tables.category} (id) ON DELETE RESTRICT, '
            'FOREIGN KEY (payment_id) REFERENCES ${Tables.revenue} (id) ON DELETE SET NULL, '
            'FOREIGN KEY (month_id) REFERENCES ${Tables.months} (id))',
          );

          //Categoria padrão para faturas do cartão
          final CategoryModel invoiceCategory = CategoryModel(
            id: Constants.creditCardCategoryId,
            categoryName: 'Cartão de crédito',
            endMonthId: null,
            isMonthly: 1,
            startMonthId: 1,
          );
          await db.insert(
            Tables.category,
            invoiceCategory.toJson(),
            conflictAlgorithm: sql.ConflictAlgorithm.replace,
          );
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
          'name TEXT, '
          'start_month_id INTEGER, '
          'end_month_id INTEGER, '
          'is_monthly INTEGER, '
          'FOREIGN KEY (start_month_id) REFERENCES ${Tables.months} (id), '
          'FOREIGN KEY (end_month_id) REFERENCES ${Tables.months} (id))',
        );

        //criar a tabela de cartões de crédito
        await db.execute(
          'CREATE TABLE ${Tables.creditCards} ('
          'id TEXT PRIMARY KEY, '
          'name TEXT NOT NULL, '
          'total_limit REAL NOT NULL, '
          'closing_day INTEGER, '
          'bank_id INTEGER, '
          'network_id INTEGER, '
          'last_digits TEXT, '
          'due_day INTEGER, '
          'is_active INTEGER NOT NULL DEFAULT 1 )',
        );

        //criar a tabela de contas do cartão de crédito
        await db.execute(
          'CREATE TABLE ${Tables.creditCardsBills} ('
          'id TEXT PRIMARY KEY, '
          'credit_card_id TEXT NOT NULL, '
          'category_id TEXT NOT NULL, '
          'name TEXT, '
          'description TEXT, '
          'price REAL, '
          'date TEXT, '
          'invoice_id TEXT, '
          'installment_number INTEGER NOT NULL, '
          'installment_total INTEGER NOT NULL, '
          'installment_group_id TEXT NOT NULL, '
          'FOREIGN KEY (invoice_id) REFERENCES ${Tables.creditCardsInvoices} (id), '
          'FOREIGN KEY (category_id) REFERENCES ${Tables.category} (id) ON DELETE RESTRICT, '
          'FOREIGN KEY (credit_card_id) REFERENCES ${Tables.creditCards} (id) ON DELETE SET NULL)',
        );

        //criar a tabela de faturas de cartão de crédito
        await db.execute(
          'CREATE TABLE ${Tables.creditCardsInvoices} ('
          'id TEXT PRIMARY KEY, '
          'credit_card_id TEXT NOT NULL, '
          'category_id TEXT NOT NULL, '
          'payment_id TEXT NULL, '
          'month_id INTEGER NOT NULL, '
          'due_date TEXT NOT NULL, '
          'start_date TEXT NOT NULL, '
          'end_date TEXT NOT NULL, '
          'price REAL, '
          'is_paid INTEGER, '
          'FOREIGN KEY (credit_card_id) REFERENCES ${Tables.creditCards} (id) ON DELETE RESTRICT, '
          'FOREIGN KEY (category_id) REFERENCES ${Tables.category} (id) ON DELETE RESTRICT, '
          'FOREIGN KEY (payment_id) REFERENCES ${Tables.revenue} (id) ON DELETE SET NULL, '
          'FOREIGN KEY (month_id) REFERENCES ${Tables.months} (id))',
        );

        await constValues(db); // preenche as tabelas que terão valores fixos
      },
      version: 31,
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

    //Categoria padrão para faturas do cartão
    final CategoryModel invoiceCategory = CategoryModel(
      id: Constants.creditCardCategoryId,
      categoryName: 'Cartão de crédito',
      endMonthId: null,
      isMonthly: 1,
      startMonthId: 1,
    );
    await db.insert(
      Tables.category,
      invoiceCategory.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    log('inseriu a categoria $invoiceCategory');
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

  static Future<List<MonthModel>> getMonths(int year) async {
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

    final result = await db.rawQuery('''
    WITH all_bills AS (
        -- contas normais
        SELECT price, category_id, payment_id AS revenue_id, month_id 
        FROM ${Tables.bills}
    
        UNION ALL
    
        -- contas de cartão de crédito, pegando o payment_id da fatura
        SELECT cb.price, cb.category_id, ci.payment_id AS revenue_id, ci.month_id
        FROM ${Tables.creditCardsBills} cb
        JOIN ${Tables.creditCardsInvoices} ci ON ci.id = cb.invoice_id
    ),
    category_count AS (
        SELECT month_id, category_id, COUNT(*) AS cnt
        FROM all_bills
        GROUP BY month_id, category_id
    ),
    revenue_count AS (
        SELECT ab.month_id, ab.revenue_id, COUNT(*) AS cnt
        FROM all_bills ab
        JOIN revenue r ON r.id = ab.revenue_id
        WHERE r.start_month_id <= ab.month_id
          AND (r.end_month_id IS NULL OR r.end_month_id >= ab.month_id)
        GROUP BY ab.month_id, ab.revenue_id
    )
    SELECT
        m.id,
        m.year_id,
        m.name,
        m.month_number,
        COALESCE((
            SELECT SUM(price) FROM all_bills ab WHERE ab.month_id = m.id
        ), 0) AS total_spent,
        (
            SELECT c.name
            FROM category_count cc
            JOIN ${Tables.category} c ON c.id = cc.category_id
            WHERE cc.month_id = m.id
            ORDER BY cc.cnt DESC
            LIMIT 1
        ) AS most_used_category,
        (
            SELECT r.name
            FROM revenue_count rc
            JOIN ${Tables.revenue} r ON r.id = rc.revenue_id
            WHERE rc.month_id = m.id
            ORDER BY rc.cnt DESC
            LIMIT 1
        ) AS most_used_revenue
    FROM ${Tables.months} m
    WHERE m.year_id = ?
    ORDER BY m.month_number
  ''', [yearId]);

    return result.map((json) => MonthModel.fromJson(json)).toList();
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

  static Future<Map<String, dynamic>?> getInvoiceBillById(String billId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT ${Tables.creditCardsBills}.*, 
             ${Tables.category}.name AS category_name
      FROM ${Tables.creditCardsBills}
      LEFT JOIN ${Tables.category} 
        ON ${Tables.creditCardsBills}.category_id = ${Tables.category}.id
      WHERE ${Tables.creditCardsBills}.id = ? 
      LIMIT 1
    ''', [billId]);

      // Retorna o primeiro item encontrado ou null se não houver resultado
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      debugPrint("Erro ao consultar conta pelo ID e mês: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getCreditCardById(String id) async {
    final db = await Db.dataBase();

    try {
      final result = await db.query(
        Tables.creditCards,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      return result.isEmpty ? null : result.first;
    } catch (e) {
      debugPrint("Erro ao consultar cartão pelo ID : $e");
      return null;
    }
  }

  static Future<InvoiceModel?> getCreditCardInvoice({
    required CreditCardModel creditCard,
    required DateTime referenceDate,
  }) async {
    final db = await Db.dataBase();

    //Buscar cartão
    final cardResult = await getCreditCardById(creditCard.id!);

    if (cardResult == null || cardResult.isEmpty) {
      throw Exception('Cartão não encontrado');
    }

    final closingDay = cardResult['closing_day'] as int;

    //Calcular período
    final period = calculateInvoicePeriod(
      date: referenceDate,
      closingDay: closingDay,
    );

    final yearId = await getYearId(period.end.year);
    final monthId = await getMonthId(
      yearId: yearId,
      month: period.end.month,
    );

    //Buscar fatura por cartão + mês
    final existing = await db.query(
      Tables.creditCardsInvoices,
      where: '''
      credit_card_id = ?
      AND month_id = ?
    ''',
      whereArgs: [creditCard.id, monthId],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      final invoice = InvoiceModel.fromJson(existing.first);
      return invoice;
    } else {
      final newInvoice = InvoiceModel(
        id: codeGenerate(),
        creditCardId: creditCard.id!,
        categoryId: Constants.creditCardCategoryId,
        paymentId: null,
        monthId: monthId,
        dueDate: creditCard.dueDay.toString(),
        startDate: period.start.toIso8601String(),
        endDate: period.end.toIso8601String(),
        price: 0.0,
        isPaid: 0,
      );

      await _insertCreditCardInvoice(newInvoice);

      return newInvoice;
    }
  }

  static Future<List<Map<String, dynamic>>> getInvoicesByMonth(
      int monthId) async {
    final db = await Db.dataBase();

    try {
      final result = db.query(
        Tables.creditCardsInvoices,
        where: 'month_id = ?',
        whereArgs: [monthId],
      );
      return result;
    } catch (e) {
      throw Exception('Não foi possível pegas as faturas do mês $monthId');
    }
  }

  static Future<List<Map<String, dynamic>>> getInvoiceBills(String id) async {
    final db = await Db.dataBase();

    try {
      final result = await db.rawQuery('''
      SELECT ${Tables.creditCardsBills}.*,
             ${Tables.category}.name AS category_name
      FROM ${Tables.creditCardsBills}
      LEFT JOIN ${Tables.category}
        ON ${Tables.creditCardsBills}.category_id = ${Tables.category}.id
      WHERE ${Tables.creditCardsBills}.invoice_id = ?
      ''', [id]);

      return result;
    } catch (e) {
      log('$e', name: 'getInvoiceBills');
      throw Exception('Não foi possível pegar as contas da fatura');
    }
  }

  static Future<double> getInvoicePrice({required String invoiceId}) async {
    final db = await Db.dataBase();

    try {
      final result = await db.query(
        Tables.creditCardsInvoices,
        where: 'id = ?',
        whereArgs: [invoiceId],
        limit: 1,
      );
      if (result.isEmpty) return 0.0;
      final price = result.first['price'];

      return (price as num?)?.toDouble() ?? 0.0;
    } catch (e) {
      log('e', name: 'getInvoicePrice');
      throw Exception('não foi possível pegar o valor da fatura');
    }
  }

  static Future<double> getCreditCardAvailableLimite(
      {required CreditCardModel card}) async {
    final db = await Db.dataBase();

    try {
      final invoiceResult = await db.rawQuery('''
      SELECT SUM(price) as total
      FROM ${Tables.creditCardsInvoices}
      WHERE credit_card_id = ?
        AND is_paid = 0
    ''', [card.id]);

      final double totalOpenInvoices =
          (invoiceResult.first['total'] as num?)?.toDouble() ?? 0.0;

      // Calcular limite disponível
      final double availableLimit = card.creditLimit! - totalOpenInvoices;

      // Segurança: nunca retornar negativo
      return availableLimit < 0 ? 0.0 : availableLimit;
    } catch (e) {
      throw Exception('Erro ao calcular limite disponível: $e');
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

  static Future<List<Map<String, dynamic>>> getMonthlyCategories(
      int monthId) async {
    final db = await Db.dataBase();
    try {
      final result = await db.rawQuery('''
      SELECT * FROM ${Tables.category}
      WHERE is_monthly = 1
        AND start_month_id <= ?
        AND (end_month_id >= ? OR end_month_id IS NULL)
        AND id != '${Constants.creditCardCategoryId}'
    ''', [monthId, monthId]);

      return result;
    } catch (e) {
      throw Exception('Erro ao consultar as categorias públicas: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getSingleCategories(
      int monthId) async {
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

  static Future<List<Map<String, dynamic>>> getCreditActiveCards() async {
    final db = await Db.dataBase();
    try {
      return await db.query(Tables.creditCards, where: 'is_active = 1');
    } catch (e) {
      throw Exception('Não foi possível encontrar os cartões : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getCreditAllCards() async {
    final db = await Db.dataBase();
    try {
      return await db.query(
        Tables.creditCards,
      );
    } catch (e) {
      throw Exception('Não foi possível encontrar os cartões : $e');
    }
  }

  static Future<List<Map<String, dynamic>>?> getCreditCardsBills(
      String invoiceId) async {
    final db = await Db.dataBase();

    try {
      final result = await db.query(
        Tables.creditCardsBills,
        where: 'invoice_id = ?',
        whereArgs: [invoiceId],
      );

      return result;
    } catch (e) {
      debugPrint("Erro ao consultar contas da fatura : $e");
      return [];
    }
  }

  //---------------------------FIM -> PEGAR-------------------------

  //---------------------------INICIO -> PEGAR TOTAL-------------------------
  static Future<double> getTotalByMonth(int monthId) async {
    final db = await Db.dataBase();

    try {
      final billsResult = await db.rawQuery('''
    SELECT SUM(price) AS total
    FROM ${Tables.bills}
    WHERE month_id = ?
    ''', [monthId]);

      final invoicesResult = await db.rawQuery('''
      SELECT SUM(price) AS total
      FROM ${Tables.creditCardsInvoices}
      WHERE month_id = ?
    ''', [monthId]);

      final billsTotal = (billsResult.first['total'] as double?) ?? 0.0;

      final invoicesTotal = (invoicesResult.first['total'] as double?) ?? 0.0;

      return billsTotal + invoicesTotal;
    } catch (e) {
      debugPrint("Erro ao obter total do mês: $e");
      return 0.0;
    }
  }

  static Future<Map<String, double>> getTotalUsedByPaymentId(
    int monthId,
  ) async {
    final db = await Db.dataBase();

    final result = await db.rawQuery('''
    SELECT payment_id, SUM(value) AS total_used
    FROM (
      SELECT payment_id, price AS value
      FROM ${Tables.bills}
      WHERE month_id = ? AND payment_id IS NOT NULL

      UNION ALL

      SELECT payment_id, price AS value
      FROM ${Tables.creditCardsInvoices}
      WHERE month_id = ? AND payment_id IS NOT NULL
    )
    GROUP BY payment_id
  ''', [monthId, monthId]);

    return {
      for (final row in result)
        row['payment_id'] as String: (row['total_used'] as double?) ?? 0.0
    };
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

  static Future<int> insertInvoiceBill(InvoiceBillModel bill) async {
    final db = await Db.dataBase();
    final data = bill.toJson();
    try {
      return await db.transaction(
        (txn) async {
          // 1. Insere a conta
          final int result = await txn.insert(
            Tables.creditCardsBills,
            data,
            conflictAlgorithm: sql.ConflictAlgorithm.replace,
          );

          if (result <= 0) {
            throw Exception('Erro ao inserir conta');
          }

          // 2. Atualiza o valor da fatura
          await _updateInvoiceTotalTx(
            txn: txn,
            invoiceId: bill.invoiceId!,
          );

          return result;
        },
      );
    } catch (e) {
      log('$e', name: 'insertInvoiceBill');
      throw Exception('Erro ao adicionar a conta');
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

  static Future<int> insertCreditCard(CreditCardModel creditCard) async {
    final db = await Db.dataBase();
    final dataJson = creditCard.toJson();
    final now = DateTime.now();
    return await db.transaction(
      (txn) async {
        try {
          final result = await txn.insert(
            Tables.creditCards,
            dataJson,
            conflictAlgorithm: sql.ConflictAlgorithm.replace,
          );

          if (result <= 0) {
            throw Exception('Falha ao inserir cartão');
          }

          // Calcular período da fatura
          final period = calculateInvoicePeriod(
            date: now,
            closingDay: creditCard.closingDay!,
          );

          final yearId = await _getYearIdTx(txn: txn, year: period.end.year);
          final monthId = await _getMonthIdTx(
            txn: txn,
            yearId: yearId,
            month: period.end.month,
          );

          // Garantia extra (embora em criação não devesse existir)
          final existing = await txn.query(
            Tables.creditCardsInvoices,
            where: 'credit_card_id = ? AND month_id = ?',
            whereArgs: [creditCard.id, monthId],
            limit: 1,
          );

          if (existing.isEmpty) {
            final newInvoice = InvoiceModel(
              id: codeGenerate(),
              creditCardId: creditCard.id!,
              categoryId: Constants.creditCardCategoryId,
              paymentId: null,
              monthId: monthId,
              dueDate: creditCard.dueDay.toString(),
              startDate: period.start.toIso8601String(),
              endDate: period.end.toIso8601String(),
              price: 0.0,
              isPaid: 0,
            );
            log('invoice : $newInvoice');
            await txn.insert(
              Tables.creditCardsInvoices,
              newInvoice.toJson(),
            );
          }

          return result;
        } catch (e) {
          // qualquer erro aqui cancela tudo
          rethrow;
        }
      },
    );
  }

  static Future<int> _insertCreditCardInvoice(InvoiceModel invoice) async {
    final db = await Db.dataBase();
    final dataJson = invoice.toJson();

    try {
      int result = await db.insert(
        Tables.creditCardsInvoices,
        dataJson,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      log('Fatura inserida $invoice');
      return result;
    } catch (e) {
      throw Exception('Erro ao inserir Fatura do Cartão : $e');
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

  static Future<int> deleteInvoiceBill({
    required String billId,
    required String invoiceId,
  }) async {
    final db = await Db.dataBase();
    try {
      return await db.transaction(
        (txn) async {
          // 1. Remove a conta
          final int result = await txn.delete(
            Tables.creditCardsBills,
            where: 'id = ?',
            whereArgs: [billId],
          );
          if (result <= 0) {
            throw Exception('Erro ao remover a compra');
          }

          // 2. Atualiza o valor da fatura
          await _updateInvoiceTotalTx(
            txn: txn,
            invoiceId: invoiceId,
          );
          return result;
        },
      );
    } catch (e) {
      throw Exception("Erro ao remover a compra: $e");
    }
  }

  static Future<int> disableCreditCard(String id) async {
    final db = await Db.dataBase();
    try {
      final result = await db.update(
        Tables.creditCards,
        {'is_active': 0},
        where: 'id = ?',
        whereArgs: [id],
      );
      return result;
    } catch (e) {
      throw Exception('Erro ao remover o cartão : $e');
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

  static Future<int> updateInvoiceBill(InvoiceBillModel newData) async {
    final db = await Db.dataBase();
    final updatedData = newData.toJson();

    try {
      return await db.transaction(
        (txn) async {
          // 1. Atualiza a conta
          final int result = await txn.update(
            Tables.creditCardsBills,
            updatedData,
            where: 'id = ?',
            whereArgs: [newData.id],
            conflictAlgorithm: sql.ConflictAlgorithm.replace,
          );
          if (result <= 0) {
            throw Exception('Erro ao atualizar conta');
          }
          // 2. Atualiza o valor da fatura
          await _updateInvoiceTotalTx(
            txn: txn,
            invoiceId: newData.invoiceId!,
          );
          return result;
        },
      );
    } catch (e) {
      throw Exception("Erro ao atualizar a compra: $e");
    }
  }

  static Future<int> updateCreditCard(CreditCardModel creditCard) async {
    final db = await Db.dataBase();
    final cardId = creditCard.id!;
    final updatedData = creditCard.toJson();

    try {
      int result = await db.update(
        Tables.creditCards,
        updatedData,
        where: 'id = ?',
        whereArgs: [cardId],
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception('Erro ao atualizar o cartão : $e');
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

  static Future<int> updateInvoicePaymentStatus(
      {required String invoiceId, required String paymentId}) async {
    final db = await Db.dataBase();
    try {
      return await db.update(
        Tables.creditCardsInvoices,
        {
          'is_paid': 1,
          'payment_id': paymentId,
        },
        where: 'id = ?',
        whereArgs: [invoiceId],
      );
    } catch (e) {
      throw Exception('Erro ao atualizar o status da fatura : $e');
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
