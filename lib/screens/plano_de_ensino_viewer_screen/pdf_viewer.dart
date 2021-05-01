import 'package:estuda_maua/widgets/pdf_viewer_with_future.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PdfViewer extends StatelessWidget {
  PdfViewer(this.assetName);

  static const scale = 100.0 / 72.0;
  static const margin = 4.0;
  static const padding = 1.0;
  static const wmargin = (margin + padding) * 2;

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return PdfDocumentLoader(
      assetName: assetName,
      documentBuilder: (context, pdfDocument, pageCount) => LayoutBuilder(
        builder: (context, constraints) => ListView.builder(
          itemCount: pageCount,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.all(margin),
            padding: EdgeInsets.all(padding),
            color: Colors.black12,
            child: PdfPageView(
              pdfDocument: pdfDocument,
              pageNumber: index + 1,
              // calculateSize is used to calculate the rendering page size
              calculateSize: (pageWidth, pageHeight, aspectRatio) => Size(
                  constraints.maxWidth - wmargin,
                  (constraints.maxWidth - wmargin) / aspectRatio),
            ),
          ),
        ),
      ),
    );
  }
}
