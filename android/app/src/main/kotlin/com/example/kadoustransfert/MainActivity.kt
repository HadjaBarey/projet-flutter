package com.example.kadoustransfert

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    private val PERMISSION_REQUEST_CODE = 1
    private val SIM_SELECTION_REQUEST_CODE = 2
    private var pendingPhoneNumber: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Votre logique d'initialisation ici
    }

    private fun checkCallPermission() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE)
            != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CALL_PHONE), PERMISSION_REQUEST_CODE)
        } else {
            // La permission est déjà accordée, lancez l'activité de sélection de la carte SIM
            launchSimSelection()
        }
    }

    private fun launchSimSelection() {
        val intent = Intent(this, ChooseSimActivity::class.java)
        startActivityForResult(intent, SIM_SELECTION_REQUEST_CODE)
    }

    private fun callNumber(number: String?, simSlot: Int) {
        if (!number.isNullOrEmpty()) {
            val ussdCode = Uri.encode(number)
            Log.d("USSD", "Calling number: $ussdCode using SIM slot: $simSlot")
            val intent = Intent(Intent.ACTION_CALL)
            intent.data = Uri.parse("tel:$ussdCode")
            intent.putExtra("com.android.phone.extra.slot", simSlot) // Indiquer le slot SIM
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED) {
                startActivity(intent)
            } else {
                Log.d("USSD", "Permission not granted")
                checkCallPermission()
            }
        } else {
            Log.d("USSD", "Number is empty or null")
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                launchSimSelection()
            } else {
                Log.d("USSD", "Permission denied")
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == SIM_SELECTION_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            val selectedSim = data?.getIntExtra("selectedSim", -1)
            if (selectedSim != null && selectedSim != -1) {
                callNumber(pendingPhoneNumber, selectedSim)
            }
        }
    }

    // Méthode à appeler depuis Flutter
    private fun initiateCall(phoneNumber: String) {
        Log.d("MainActivity", "Calling number: $phoneNumber")
        val intent = Intent(Intent.ACTION_CALL, Uri.parse("tel:$phoneNumber"))
        startActivity(intent)
    }
}
