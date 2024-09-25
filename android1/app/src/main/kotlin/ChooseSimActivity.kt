// package apps.kadous.kadoustransfert

// import android.app.Activity
// import android.content.Intent
// import android.os.Bundle
// import android.widget.Button

// class ChooseSimActivity : Activity() {
//     override fun onCreate(savedInstanceState: Bundle?) {
//         super.onCreate(savedInstanceState)
//         setContentView(R.layout.activity_choose_sim)

//         val buttonSim1 = findViewById<Button>(R.id.button_sim1)
//         val buttonSim2 = findViewById<Button>(R.id.button_sim2)

//         buttonSim1.setOnClickListener {
//             selectSim(1)
//         }

//         buttonSim2.setOnClickListener {
//             selectSim(2)
//         }
//     }

//     private fun selectSim(simId: Int) {
//         val resultIntent = Intent()
//         resultIntent.putExtra("selectedSim", simId)
//         setResult(Activity.RESULT_OK, resultIntent)
//         finish()
//     }
// }
