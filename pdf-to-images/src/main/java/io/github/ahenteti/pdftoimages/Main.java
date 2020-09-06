package io.github.ahenteti.pdftoimages;

import org.apache.commons.io.FilenameUtils;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.tools.imageio.ImageIOUtil;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;

public class Main {
    public static void main(String[] args) {
        Path pdfPath = getPdfPath(args);
        try (final PDDocument document = PDDocument.load(pdfPath.toFile())) {
            PDFRenderer pdfRenderer = new PDFRenderer(document);
            for (int page = 0; page < document.getNumberOfPages(); ++page) {
                BufferedImage bim = pdfRenderer.renderImageWithDPI(page, 300, ImageType.RGB);
                String pdfFileName = pdfPath.getFileName().toString();
                String pdfFileNameWithoutExt = FilenameUtils.removeExtension(pdfFileName);
                String imageFilename = pdfFileNameWithoutExt + ".page-" + page + ".png";
                ImageIOUtil.writeImage(bim, imageFilename, 300);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static Path getPdfPath(String[] args) {
        if (args.length != 1) {
            throw new RuntimeException("pdf path is mandatory");
        }
        return Paths.get(args[0]);
    }
}
