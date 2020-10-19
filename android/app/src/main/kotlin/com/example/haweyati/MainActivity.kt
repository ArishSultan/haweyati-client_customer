package com.example.haweyati

import android.os.Bundle
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

class MainActivity: FlutterActivity()//, PluginRegistry.PluginRegistrantCallback
 {
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        FlutterFirebaseMessagingService.setPluginRegistrant(this)
//    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

//    override fun registerWith(registry: PluginRegistry?) {
//        FirebaseCloudMessagingPluginRegistrant.registerWith(registry!!)
//    }
}
