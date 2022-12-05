import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as getx;
import 'package:graphview/GraphView.dart';
import 'package:league_arena/constants/controllers.dart';
import 'package:league_arena/constants/style.dart';
import 'package:league_arena/widgets/custom_text.dart';
import 'package:league_arena/widgets/match_info.dart';

class EventBrackets extends StatefulWidget {
  const EventBrackets({super.key});

  @override
  State<EventBrackets> createState() => _EventBracketsState();
}

class _EventBracketsState extends State<EventBrackets> {
  var minScale = 0.0001.obs;
  var scrollValueDy = 0.0.obs;
  var scrollValueDx = 0.0.obs;
  var zoomValue = 0.8.obs;

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    for (var node in eventController.eventMatches) {
      graph.nodes.add(Node.Id(node['id']));
    }

    for (var edge in eventController.eventMatches) {
      if (edge['parent'] != null) {
        graph.addEdge(Node.Id(edge['id']), Node.Id(edge['parent'][0]));
        graph.addEdge(Node.Id(edge['id']), Node.Id(edge['parent'][1]));
      }
    }

    builder
      ..siblingSeparation = (10)
      ..levelSeparation = (100)
      ..subtreeSeparation = (20)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_RIGHT_LEFT);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getx.Obx(
      () => eventController.eventMatches.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Listener(
                      onPointerSignal: (pointerSignal) {
                        if (pointerSignal is PointerScrollEvent) {
                          if (pointerSignal.scrollDelta.dy > -100) {
                            if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.altLeft) || RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.altRight)) {
                              zoomValue.value > 0.20000000000000015 ? zoomValue.value -= 0.1 : 0.20000000000000015;
                            } else {
                              scrollValueDy.value -= 100;
                            }
                          } else if (pointerSignal.scrollDelta.dy < 100) {
                            if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.altLeft) || RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.altRight)) {
                              zoomValue.value < 1.5 ? zoomValue.value += 0.1 : 1.5;
                            } else {
                              scrollValueDy.value += 100;
                            }
                          }
                        }
                      },
                      child: InteractiveViewer(
                          transformationController: TransformationController((Matrix4.identity()..translate(scrollValueDx.value, scrollValueDy.value)) * zoomValue.value),
                          constrained: false,
                          boundaryMargin: const EdgeInsets.all(double.infinity),
                          scaleFactor: 500,
                          panEnabled: false,
                          panAxis: PanAxis.free,
                          scaleEnabled: false,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onPanUpdate: (details) {
                              scrollValueDx.value += details.delta.dx;
                              scrollValueDy.value += details.delta.dy;
                            },
                            child: MouseRegion(
                              cursor:
                                  (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.altLeft) || RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.altRight))
                                      ? SystemMouseCursors.zoomIn
                                      : SystemMouseCursors.move,
                              onHover: (_) {
                                setState(() {});
                              },
                              child: GraphView(
                                graph: graph,
                                algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
                                paint: Paint()
                                  ..color = Colors.blue
                                  ..strokeWidth = 0.5
                                  ..style = PaintingStyle.stroke,
                                builder: (Node node) {
                                  // I can decide what widget should be shown here based on the id
                                  var a = node.key!.value as int;
                                  var pos = node.size;
                                  return MatchInfo(
                                    id: a,
                                    pos: pos,
                                  );
                                },
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Tooltip(
                        verticalOffset: -18,
                        padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
                        margin: const EdgeInsets.only(right: 50),
                        textStyle: TextStyle(fontSize: 15, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: primary),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5), color: background.withOpacity(0.6), border: Border.all(width: 0.5, color: background.withOpacity(0.7))),
                        message: 'ALT + MOUSE WHEEL',
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5), color: background.withOpacity(0.6), border: Border.all(width: 0.5, color: background.withOpacity(0.7))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.zoom_in,
                                    size: 20,
                                    color: primary,
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3), color: background.withOpacity(0.6), border: Border.all(width: 0.5, color: background.withOpacity(0.7))),
                        child: IconButton(
                          onPressed: () {
                            zoomValue.value = 0.8;
                            scrollValueDx.value = 0.0;
                            scrollValueDy.value = 0.0;
                          },
                          icon: const Icon(Icons.restart_alt),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          color: primary,
                          iconSize: 20,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  color: primary,
                  size: 70,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: "Brackets hasn't been seeded yet!",
                  size: 20,
                  color: primary,
                  weight: FontWeight.bold,
                )
              ],
            ),
    );
  }
}
