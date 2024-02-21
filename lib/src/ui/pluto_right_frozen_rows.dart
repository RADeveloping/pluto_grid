import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid/src/helper/platform_helper.dart';

import 'ui.dart';

class PlutoRightFrozenRows extends PlutoStatefulWidget {
  final PlutoGridStateManager stateManager;

  const PlutoRightFrozenRows(
    this.stateManager, {
    super.key,
  });

  @override
  PlutoRightFrozenRowsState createState() => PlutoRightFrozenRowsState();
}

class PlutoRightFrozenRowsState
    extends PlutoStateWithChange<PlutoRightFrozenRows> {
  List<PlutoColumn> _columns = [];

  List<PlutoRow> _rows = [];

  late final ScrollController _scroll;

  @override
  PlutoGridStateManager get stateManager => widget.stateManager;

  @override
  void initState() {
    super.initState();

    _scroll = stateManager.scroll.vertical!.addAndGet();

    updateState(PlutoNotifierEventForceUpdate.instance);
  }

  @override
  void dispose() {
    _scroll.dispose();

    super.dispose();
  }

  @override
  void updateState(PlutoNotifierEvent event) {
    forceUpdate();

    _columns = stateManager.rightFrozenColumns;

    _rows = stateManager.refRows;
  }

  @override
  Widget build(BuildContext context) {
    final scrollbarConfig = stateManager.configuration.rightFrozenScrollbar;

    var listView = ListView.builder(
      controller: _scroll,
      scrollDirection: Axis.vertical,
      physics: scrollbarConfig?.verticalScrollPhysics,
      itemCount: _rows.length,
      itemExtent: stateManager.rowTotalHeight,
      itemBuilder: (ctx, i) {
        return PlutoBaseRow(
          key: ValueKey('right_frozen_row_${_rows[i].key}'),
          rowIdx: i,
          row: _rows[i],
          columns: _columns,
          stateManager: stateManager,
        );
      },
    );

    if(scrollbarConfig == null){
      return listView;
    }

    return PlutoScrollbar(
      verticalController:
      scrollbarConfig.draggableScrollbar ? _scroll : null,
      isAlwaysShown: scrollbarConfig.isAlwaysShown,
      onlyDraggingThumb: scrollbarConfig.onlyDraggingThumb,
      enableHover: PlatformHelper.isDesktop,
      enableScrollAfterDragEnd: scrollbarConfig.enableScrollAfterDragEnd,
      thickness: scrollbarConfig.scrollbarThickness,
      thicknessWhileDragging: scrollbarConfig.scrollbarThicknessWhileDragging,
      hoverWidth: scrollbarConfig.hoverWidth,
      mainAxisMargin: scrollbarConfig.mainAxisMargin,
      crossAxisMargin: scrollbarConfig.crossAxisMargin,
      scrollBarColor: scrollbarConfig.scrollBarColor,
      scrollBarTrackColor: scrollbarConfig.scrollBarTrackColor,
      radius: scrollbarConfig.scrollbarRadius,
      radiusWhileDragging: scrollbarConfig.scrollbarRadiusWhileDragging,
      longPressDuration: scrollbarConfig.longPressDuration,
      child: listView,
    );
  }
}
