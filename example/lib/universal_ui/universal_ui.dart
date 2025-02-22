library universal_ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/models/documents/nodes/leaf.dart' as leaf;
import 'package:flutter_quill/widgets/responsive_widget.dart';
import 'package:universal_html/html.dart' as html;

import 'fake_ui.dart' if (dart.library.html) 'real_ui.dart' as ui_instance;

class PlatformViewRegistryFix {
  void registerViewFactory(dynamic x, dynamic y) {
    if (kIsWeb) {
      ui_instance.PlatformViewRegistry.registerViewFactory(
        x,
        y,
      );
    }
  }
}

class UniversalUI {
  PlatformViewRegistryFix platformViewRegistry = PlatformViewRegistryFix();
}

var ui = UniversalUI();

Widget defaultEmbedBuilderWeb(BuildContext context, leaf.Embed node) {
  switch (node.value.type) {
    case 'image':
      String imageUrl = node.value.data;
      Size size = MediaQuery.of(context).size;
      UniversalUI().platformViewRegistry.registerViewFactory(
          imageUrl, (int viewId) => html.ImageElement()..src = imageUrl);
      return Padding(
        padding: EdgeInsets.only(
          right: ResponsiveWidget.isMediumScreen(context)
              ? size.width * 0.5
              : (ResponsiveWidget.isLargeScreen(context))
                  ? size.width * 0.75
                  : size.width * 0.2,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: HtmlElementView(
            viewType: imageUrl,
          ),
        ),
      );

    default:
      throw UnimplementedError(
          'Embeddable type "${node.value.type}" is not supported by default embed '
          'builder of QuillEditor. You must pass your own builder function to '
          'embedBuilder property of QuillEditor or QuillField widgets.');
  }
}
