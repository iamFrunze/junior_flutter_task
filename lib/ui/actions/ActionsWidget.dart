import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:junior_test/blocs/actions/ActionsItemQueryBloc.dart';
import 'package:junior_test/blocs/base/bloc_provider.dart';
import 'package:junior_test/model/RootResponse.dart';
import 'package:junior_test/model/actions/PromoItem.dart';
import 'package:junior_test/resources/api/RootType.dart';
import 'package:junior_test/tools/CustomNetworkImageLoader.dart';
import 'package:junior_test/tools/MyColors.dart';
import 'package:junior_test/tools/MyDimens.dart';
import 'package:junior_test/tools/Strings.dart';
import 'package:junior_test/ui/actions/item/ActionsItemWidget.dart';
import 'package:junior_test/ui/base/NewBasePageState.dart';

class ActionsWidget extends StatefulWidget {
  const ActionsWidget({Key key}) : super(key: key);
  static String TAG = 'ActionWidget';

  @override
  State<ActionsWidget> createState() => _ActionsWidgetState();
}

class _ActionsWidgetState extends NewBasePageState<ActionsWidget> {
  ActionsItemQueryBloc bloc;

  _ActionsWidgetState() {
    bloc = ActionsItemQueryBloc();
  }

  var page = 0;
  var count = 2;
  final List<PromoItem> promos = [];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActionsItemQueryBloc>(
      bloc: bloc,
      child: getBaseQueryStream(bloc.shopItemContentStream),
    );
  }

  @override
  Widget onSuccess(RootTypes event, RootResponse response) {
    var actionInfo = response.serverResponse.body.promo;
    promos.addAll(actionInfo.list);
    return getNetworkAppBar(
      actionInfo.item.imgFull,
      _getBody(promos),
      Strings.actions,
      brightness: Brightness.light,
    );
  }

  @override
  void runOnWidgetInit() {
    bloc.loadActions(0, 4);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Если прокрутили до конца списка, загружаем новую порцию данных
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      bloc.loadActions(page++, count);
    }
  }

  Widget _getBody(List<PromoItem> items) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StaggeredGridView.countBuilder(
          controller: _scrollController,
          crossAxisCount: 2,
          itemCount: items.length,
          itemBuilder: (_, int index) {
            return _Item(
              key: ValueKey(items[index].id),
              id: items[index].id,
              imagePath: items[index].imgFull,
              text: items[index].name,
            );
          },
          staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    Key key,
    this.imagePath,
    this.text,
    this.id,
  });

  final int id;
  final String imagePath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActionsItemWidget(
              actionId: id,
            ),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomNetworkImageLoader(
            imagePath,
            Container(),
            true,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MyDimens.subtitleBig,
                color: MyColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
