//package com.mbasuscriber.clientapp
//
//import io.flutter.plugin.common.PluginRegistery
//
//object FirebaseCloudMessagingPlugin {
//    fun registerWith(pluginRegistery: PluginRegistery){
//       if(alreadyRegisteredWIth(pluginRegistery)) return
//        registerWith(pluginRegistery)
//    }
//
//    private fun alreadyRegisteredWith(pluginRegistery: PluginRegistery): Boolean{
//        val key = FirebaseCloudMessagingPlugin::class.java.canonicalName
//        if (pluginRegistery.hasPlugin(key)) return true
//        pluginRegistery.registerFor(key)
//        return false
//    }
//}