import 'package:Fluxx/blocs/user_cubit/user_cubit.dart';
import 'package:Fluxx/blocs/user_cubit/user_state.dart';
import 'package:Fluxx/components/user_avatar.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final version = await getVersion();
    if (mounted) setState(() => _version = version);
  }

  // Fecha o drawer antes de abrir a tela, para que ao voltar a Home esteja sem o drawer aberto
  void _navigate(void Function() navigate) {
    Navigator.pop(context);
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Drawer(
      width: mediaQuery.width * .8,
      backgroundColor: AppTheme.colors.appBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _Header(
              onTap: () => _navigate(
                () => Navigator.pushNamed(context, AppRoutes.profilePage),
              ),
            ),
            const SizedBox(height: 20),
            _DrawerItem(
              title: 'Contas',
              icon: Icons.receipt_long_rounded,
              onTap: () =>
                  _navigate(() => goToMonthBillsPage(context: context)),
            ),
            _DrawerItem(
              title: 'Cartões',
              icon: Icons.credit_card_rounded,
              onTap: () =>
                  _navigate(() => goToCardsListPage(context: context)),
            ),
            _DrawerItem(
              title: 'Meses',
              icon: Icons.calendar_month_rounded,
              onTap: () =>
                  _navigate(() => goToMonthListPage(context: context)),
            ),
            _DrawerItem(
              title: 'Categorias',
              icon: Icons.category_outlined,
              onTap: () =>
                  _navigate(() => goToCategoryListPage(context: context)),
            ),
            _DrawerItem(
              title: 'Receitas',
              icon: Icons.attach_money_rounded,
              onTap: () =>
                  _navigate(() => goToRevenuesListPage(context: context)),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 1,
              color: AppTheme.colors.hintTextColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Versão : $_version',
                style: AppTheme.textStyles.secondaryTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onTap;
  const _Header({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: GetIt.I(),
      builder: (context, state) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: const BoxDecoration(
            color: Color(0xFF0B2A4A),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          child: Row(
            children: [
              UserAvatar(
                picture: state.user?.picture,
                name: state.user?.name,
                size: 70,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  state.user?.name ?? 'Usuário',
                  maxLines: 2,
                  style: AppTheme.textStyles.bodyTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF0B2A4A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.colors.primaryTextColor),
            ),
            const SizedBox(width: 16),
            Text(title, style: AppTheme.textStyles.bodyTextStyle),
          ],
        ),
      ),
    );
  }
}
