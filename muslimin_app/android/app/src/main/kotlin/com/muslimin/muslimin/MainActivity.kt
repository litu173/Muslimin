package com.muslimin.muslimin

import android.graphics.BitmapFactory
import android.net.Uri
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    /**
     * On-device text recognition (ML Kit) for photos of salat time boards.
     * `read` takes {bytes, down} and returns the lines it found as
     * [{text, x, y, w, h}], 0..1 with a top-left origin.
     */
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "muslimin/board_ocr")
            .setMethodCallHandler { call, result ->
                if (call.method != "read") return@setMethodCallHandler result.notImplemented()
                val bytes = call.argument<ByteArray>("bytes")
                    ?: return@setMethodCallHandler result.error("ocr", "no image", null)
                val down = call.argument<Boolean>("down") ?: false
                try {
                    val image = if (down) {
                        val bmp = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                        InputImage.fromBitmap(bmp, 180)
                    } else {
                        // From a file so the photo's EXIF rotation is applied.
                        val f = File.createTempFile("board", ".jpg", cacheDir)
                        f.writeBytes(bytes)
                        InputImage.fromFilePath(this, Uri.fromFile(f)).also { f.delete() }
                    }
                    val rotated = image.rotationDegrees == 90 || image.rotationDegrees == 270
                    val w = (if (rotated) image.height else image.width).toDouble()
                    val h = (if (rotated) image.width else image.height).toDouble()
                    TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)
                        .process(image)
                        .addOnSuccessListener { text ->
                            val lines = mutableListOf<Map<String, Any>>()
                            for (block in text.textBlocks) for (line in block.lines) {
                                val b = line.boundingBox ?: continue
                                lines.add(
                                    mapOf(
                                        "text" to line.text,
                                        "x" to b.left / w,
                                        "y" to b.top / h,
                                        "w" to b.width() / w,
                                        "h" to b.height() / h,
                                    ),
                                )
                            }
                            result.success(lines)
                        }
                        .addOnFailureListener { e -> result.error("ocr", e.message, null) }
                } catch (e: Exception) {
                    result.error("ocr", e.message, null)
                }
            }
    }
}
