package com.example.kadoustransfert

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val REQUEST_CALL_PERMISSION = 1
    private val CHANNEL = "com.example.kadoustransfert/call"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger as BinaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "initiateCall") {
                val number = call.argument<String>("number")
                if (number != null) {
                    initiateCall(number)
                    result.success("Calling $number")
                } else {
                    result.error("INVALID_NUMBER", "Le numéro est null ou invalide", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun initiateCall(number: String) {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CALL_PHONE), REQUEST_CALL_PERMISSION)
            return
        }
        val ussdCode = number.replace("#", Uri.encode("#"))
        val intent = Intent(Intent.ACTION_CALL, Uri.parse("tel:$ussdCode"))
        startActivity(intent)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CALL_PERMISSION) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Réessayer l'appel si nécessaire
            } else {
                // Gérer le cas de refus de permission
            }
        }
    }
}
