import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'pdf_render.dart';

/// Function definition to calculate rendering page size.
/// [pageWidth], [pageHeight] indicates the original page size in pt. (72-dpi).
/// [aspectRatio] is width/height ratio.
typedef Size PdfPageCalculateSize(
    double pageWidth, double pageHeight, double aspectRatio);

/// Function definition to build widget tree for a PDF document.
/// [pdfDocument] is the PDF document and it is valid until the corresponding
/// [PdfDocumentLoader] is in the widget tree.
/// [pageCount] indicates the number of pages in it.
typedef Widget PdfDocumentBuilder(
    BuildContext context, PdfDocument pdfDocument, int pageCount);

/// Function to customize PDF page widget.
/// [page] is the widget corresponding to the rendered PDF page and [size] contains
/// its size. Please note that [page]/[size] may be null if called during loading phase.
typedef Widget PdfPageCustomizer(BuildContext context, Widget page, Size size);

/// The implementation assumes that the device pixel ratio is same on every context.
final _pixelRatioCompleter = Completer<double>();

class PdfDocumentLoader extends StatefulWidget {
  // only one of [filePath], [assetName], or [data] have to be specified.
  final String filePath;
  final String assetName;
  final Uint8List data;
  //final String password;
  /// Function to build widget tree corresponding to PDF document.
  final PdfDocumentBuilder documentBuilder;

  /// Page number of the page to render if only one page should be shown.
  /// Could not be used with [documentBuilder].
  final int pageNumber;

  /// Calculate rendering size based on page width/height (in pt.; 72-dpi) or page aspect ratio. Mutually exclusive with [pageFit].
  /// Could not be used with [documentBuilder].
  final PdfPageCalculateSize calculateSize;

  /// Page fit configuration. Mutually exclusive with [calculateSize].
  /// Could not be used with [documentBuilder].
  final PdfPageFit pageFit;

  /// Whether to fill background before rendering actual page content or not.
  /// The page content may not have background fill and if the flag is false, it may be rendered with transparent background.
  /// Could not be used with [documentBuilder].
  final bool backgroundFill;

  /// Pixel density for rendering page image. If it is null, the value is obtained by calling `MediaQuery.of(context).devicePixelRatio`.
  /// Could not be used with [documentBuilder].
  final double renderingPixelRatio;

  /// Function to customize PDF page widget.
  /// Could not be used with [documentBuilder].
  final PdfPageCustomizer customizer;

  /// For multiple pages, use [documentBuilder] with [PdfPageView].
  /// For single page use, you must specify [pageNumber] and, optionally [calculateSize].
  PdfDocumentLoader(
      {Key key,
      this.filePath,
      this.assetName,
      this.data,
      this.documentBuilder,
      this.pageNumber,
      this.calculateSize,
      this.pageFit,
      this.backgroundFill = true,
      this.renderingPixelRatio,
      this.customizer})
      : super(key: key);

  @override
  _PdfDocumentLoaderState createState() => _PdfDocumentLoaderState();
}

class _PdfDocumentLoaderState extends State<PdfDocumentLoader> {
  PdfDocument _doc;

  /// _lastPageSize is important to keep consistency on unform page size on
  /// a PDF document.
  Size _lastPageSize;
  List<Size> _cachedPageSizes;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _setPageSize(int pageNumber, Size size) {
    _lastPageSize = size;
    if (pageNumber > 0 && pageNumber <= _doc.pageCount) {
      if (_cachedPageSizes == null)
        _cachedPageSizes = List<Size>(_doc.pageCount);
      _cachedPageSizes[pageNumber - 1] = size;
    }
  }

  Size _getPageSize(int pageNumber) {
    Size size;
    if (_cachedPageSizes != null &&
        pageNumber > 0 &&
        pageNumber <= _doc.pageCount) {
      size = _cachedPageSizes[pageNumber - 1];
    }
    size ??= _lastPageSize;
    return size;
  }

  @override
  void didUpdateWidget(PdfDocumentLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath ||
        oldWidget.assetName != widget.assetName ||
        oldWidget.data != widget.data) {
      _release();
      _init();
    }
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }

  Future<void> _init() async {
    if (widget.filePath != null) {
      _doc = await PdfDocument.openFile(widget.filePath);
    } else if (widget.assetName != null) {
      _doc = await PdfDocument.openAsset(widget.assetName);
    } else if (widget.data != null) {
      _doc = await PdfDocument.openData(widget.data);
    } else {
      _doc = null;
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _release() {
    _doc?.dispose();
    _doc = null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.pageNumber != null
        ? PdfPageView(
            pdfDocument: _doc,
            pageNumber: widget.pageNumber,
            calculateSize: widget.calculateSize,
            pageFit: widget.pageFit,
            backgroundFill: widget.backgroundFill,
            renderingPixelRatio: widget.renderingPixelRatio,
            customizer: widget.customizer,
          )
        : widget.documentBuilder != null
            ? widget.documentBuilder(context, _doc, _doc?.pageCount ?? 0)
            : Container();
  }
}

class PdfPageFit {
  /// Width of the area which PDF page fit into.
  final double width;

  /// Height of the area which PDF page fit into.
  final double height;

  /// Fit method.
  final BoxFit fit;

  /// Define how the page fit into the area.
  PdfPageFit({this.width, this.height, this.fit});

  /// [aspectRatio] is width/height ratio.
  Size calculateSize(double pageWidth, double pageHeight, double aspectRatio) {
    switch (fit) {
      case BoxFit.contain:
        return _sizeByRatio(
            pageWidth, pageHeight, min(width / pageWidth, height / pageHeight));
      case BoxFit.cover:
        return _sizeByRatio(
            pageWidth, pageHeight, max(width / pageWidth, height / pageHeight));
      case BoxFit.fill:
        return Size(width, height);
      case BoxFit.fitWidth:
        return Size(width, width / aspectRatio);
      case BoxFit.fitHeight:
        return Size(height * aspectRatio, height);
      case BoxFit.none:
        return Size(pageWidth, pageHeight);
      case BoxFit.scaleDown:
        return (pageWidth < width && pageHeight < height)
            ? Size(pageWidth, pageHeight)
            : _sizeByRatio(pageWidth, pageHeight,
                min(width / pageWidth, height / pageHeight));
      default:
        throw Exception('Unknown BoxFit value: $fit');
    }
  }

  Size _sizeByRatio(double pageWidth, double pageHeight, double ratio) {
    return Size(pageWidth * ratio, pageHeight * ratio);
  }

  @override
  bool operator ==(Object other) {
    return other is PdfPageFit &&
        other.width == width &&
        other.height == height &&
        other.fit == fit;
  }

  @override
  int get hashCode => width.hashCode ^ height.hashCode ^ fit.hashCode;
}

/// Widget to render a page of PDF document. Normally used in combination with [PdfDocumentLoader].
class PdfPageView extends StatefulWidget {
  /// [PdfDocument] to render. If it is null, the actual document is obtained by locating ansestor [PdfDocumentLoader] widget.
  final PdfDocument pdfDocument;

  /// Page number of the page to render if only one page should be shown.
  final int pageNumber;

  /// Calculate rendering size based on page width/height (in pt.; 72-dpi) or page aspect ratio. Mutually exclusive with [pageFit].
  final PdfPageCalculateSize calculateSize;

  /// Page fit configuration. Mutually exclusive with [calculateSize].
  final PdfPageFit pageFit;

  /// Whether to fill background before rendering actual page content or not.
  /// The page content may not have background fill and if the flag is false, it may be rendered with transparent background.
  final bool backgroundFill;

  /// Pixel density for rendering page image. If it is null, the value is obtained by calling `MediaQuery.of(context).devicePixelRatio`.
  final double renderingPixelRatio;

  /// Function to customize the behavior/appearance of the PDF page.
  final PdfPageCustomizer customizer;

  /// Although, the view uses Flutter's [Texture] to render the PDF content by default, you can disable it by setting the value to true.
  /// Please note that on iOS Simulator, it always use non-[Texture] rendering pass.
  final bool dontUseTexture;

  PdfPageView(
      {Key key,
      this.pdfDocument,
      @required this.pageNumber,
      this.calculateSize,
      this.pageFit,
      this.backgroundFill = true,
      this.renderingPixelRatio,
      this.customizer,
      this.dontUseTexture})
      : super(key: key);

  @override
  _PdfPageViewState createState() => _PdfPageViewState();
}

class _PdfPageViewState extends State<PdfPageView> {
  PdfDocument _doc;
  PdfPage _page;
  Size _size;
  PdfPageImageTexture _texture;
  PdfPageImage _image;
  bool _isIosSimulator;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(PdfPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pdfDocument != widget.pdfDocument ||
        oldWidget.pageNumber != widget.pageNumber ||
        oldWidget.calculateSize != widget.calculateSize ||
        oldWidget.pageFit != widget.pageFit ||
        oldWidget.backgroundFill != widget.backgroundFill) {
      _release();
      _init();
    }
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }

  Future<void> _init() async {
    _isIosSimulator = await _determineWhetherIOSSimulatorOrNot();

    final docLoaderState = _getPdfDocumentLoaderState();
    _size = docLoaderState?._getPageSize(widget.pageNumber);
    _doc = widget.pdfDocument ?? docLoaderState._doc;
    if (_doc == null) {
      _page = null;
      if (mounted) {
        setState(() {});
      }
      return;
    }
    _page = await _doc.getPage(widget.pageNumber);
    if (_page == null) {
      _release();
      _size = docLoaderState?._getPageSize(widget.pageNumber);
    } else {
      _size = widget.calculateSize != null
          ? widget.calculateSize(
              _page.width, _page.height, _page.width / _page.height)
          : widget.pageFit != null
              ? widget.pageFit.calculateSize(
                  _page.width, _page.height, _page.width / _page.height)
              : Size(_page.width, _page.height);
      if (docLoaderState != null)
        docLoaderState?._setPageSize(widget.pageNumber, _size);
      if (mounted) {
        setState(() {});
      }
      // NOTE: rendering size is different from widget size because of the pixel density
      final size = _size *
          (widget.renderingPixelRatio ?? await _pixelRatioCompleter.future);

      if (widget.dontUseTexture == true || _isIosSimulator) {
        _image = await _page.render(
            width: size.width.toInt(),
            height: size.height.toInt(),
            fullWidth: size.width,
            fullHeight: size.height,
            backgroundFill: widget.backgroundFill);
      } else {
        if (_texture == null ||
            _texture.pdfDocument.docId != _doc.docId ||
            _texture.pageNumber != widget.pageNumber) {
          _texture?.dispose();
          _texture = await PdfPageImageTexture.create(
              pdfDocument: _doc, pageNumber: widget.pageNumber);
        }
        await _texture.updateRect(
            width: size.width.toInt(),
            height: size.height.toInt(),
            texWidth: size.width.toInt(),
            texHeight: size.height.toInt(),
            fullWidth: size.width,
            fullHeight: size.height,
            backgroundFill: widget.backgroundFill);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  _PdfDocumentLoaderState _getPdfDocumentLoaderState() =>
      context.ancestorStateOfType(const TypeMatcher<_PdfDocumentLoaderState>());

  void _release() {
    _doc = null;
    _page = null;
    _size = null;
    _texture?.dispose();
    _texture = null;
    _image?.dispose();
    _image = null;
  }

  @override
  Widget build(BuildContext context) {
    final page = _buildPage(context);
    return widget.customizer?.call(context, page, _size) ?? page;
    return FutureBuilder(
      future: _init(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 100,
            width: double.infinity,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildPage(BuildContext context) {
    if (_pixelRatioCompleter?.isCompleted == false) {
      _pixelRatioCompleter.complete(MediaQuery.of(context).devicePixelRatio);
    }

    if (_doc == null ||
        widget.pageNumber == null ||
        widget.pageNumber < 1 ||
        widget.pageNumber > _doc.pageCount ||
        _page == null ||
        (_texture == null && _image == null)) {
      return Container(width: _size?.width, height: _size?.height);
    }

    Widget contentWidget = _texture != null
        ? Texture(textureId: _texture.texId)
        : RawImage(image: _image.image);

    contentWidget = Container(
        width: _size.width,
        height: _size.height,
        color: Colors.black,
        child: contentWidget);

    if (_isIosSimulator) {
      contentWidget = Stack(
        children: <Widget>[
          contentWidget,
          const Text(
              'Warning: on iOS Simulator, pdf_render works differently to physical device.',
              style: TextStyle(color: Colors.redAccent))
        ],
      );
    }

    return contentWidget;
  }

  static Future<bool> _determineWhetherIOSSimulatorOrNot() async {
    if (!Platform.isIOS) {
      return false;
    }
    final info = await DeviceInfoPlugin().iosInfo;
    return !info.isPhysicalDevice;
  }
}
