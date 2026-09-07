import 'package:flutter/material.dart';
import 'package:jobish_task/style/colors.dart';

abstract class BaseStatefulWidgetState<T extends StatefulWidget>
    extends State<T> {
  late ThemeData theme;
  late Size screenSize;

  bool isProgressVisible = false;
  bool useSafeArea = false;
  bool avoidBottomInset = true;
  bool extendBodyBehindAppBar = true;
  static bool isBackGesture = true;

  Color? scaffoldBackgroundColor;
  FloatingActionButtonLocation? fabLocation;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
    screenSize = MediaQuery.of(context).size;
  }

  @override
  Widget build(final BuildContext context) => GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: avoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor:
          scaffoldBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar(context),
      body: _buildBodyWrapper(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
      floatingActionButton: buildFab(context),
      floatingActionButtonLocation: fabLocation,
    ),
  );

  Widget _buildBodyWrapper(final BuildContext context) {
    final content = buildBody(context);
    return useSafeArea ? SafeArea(child: content) : content;
  }

  Widget buildProgressIndicator() => isProgressVisible
      ? const Center(child: CircularProgressIndicator())
      : const SizedBox.shrink();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    cleanUp();
    super.dispose();
  }

  @protected
  void initialize() {}

  @protected
  void cleanUp() {}

  @protected
  Widget buildBody(final BuildContext context);

  @protected
  PreferredSizeWidget? buildAppBar(final BuildContext context) => null;

  @protected
  Widget? buildBottomNavigationBar(final BuildContext context) => null;

  @protected
  Widget? buildFab(final BuildContext context) => null;

  @protected
  void updateState(final void Function() stateUpdater) {
    if (mounted) setState(stateUpdater);
  }

  Widget heightBox(final double height) => SizedBox(height: height);

  Widget widthBox(final double width) => SizedBox(width: width);

  Widget divider({final double thickness = 1.0, final Color? color}) =>
      Divider(thickness: thickness, color: color);
}
