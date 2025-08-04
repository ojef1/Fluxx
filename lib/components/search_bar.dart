
import 'package:Fluxx/themes/app_theme.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    

    return AnimSearchBar(
      animationDurationInMilli: 500,
      color: AppTheme.colors.hintColor,
      searchIconColor: Colors.white,
      textFieldIconColor: Colors.white,
      boxShadow: true,
      textFieldColor: AppTheme.colors.hintColor,
      closeSearchOnSuffixTap: true,
      autoFocus: true,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      width: MediaQuery.of(context).size.width * 0.75,
      rtl: true,
      textController: _searchController,
      // Limpa o campo de pesquisa ao tocar no ícone de fechar.
      onSuffixTap: () {
        setState(() {
          _searchController.clear();
        });
      },
       // Executa a pesquisa quando o usuário submete o formulário.
      onSubmitted: (_) => (),
    );
  }
}
