package top.aengus.allpass.util

import android.content.Context
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StringCodec
import top.aengus.allpass.core.CHANNEL

fun createMessageChannel(context: Context, channel: String = CHANNEL): BasicMessageChannel<String> {
    val flutterLoader = FlutterInjector.instance().flutterLoader()
    flutterLoader.startInitialization(context)
    flutterLoader.ensureInitializationComplete(context, arrayOf())

    val engine = FlutterEngine(context.applicationContext)
    val entryPoint = DartExecutor.DartEntrypoint.createDefault()
    engine.dartExecutor.executeDartEntrypoint(entryPoint)
    return BasicMessageChannel(engine.dartExecutor.binaryMessenger, channel, StringCodec.INSTANCE)
}

fun createMethodChannel(context: Context, channel: String = CHANNEL): MethodChannel {
    val flutterLoader = FlutterInjector.instance().flutterLoader()
    flutterLoader.startInitialization(context)
    flutterLoader.ensureInitializationComplete(context, arrayOf())

    val engine = FlutterEngine(context.applicationContext)
    val entryPoint = DartExecutor.DartEntrypoint.createDefault()
    engine.dartExecutor.executeDartEntrypoint(entryPoint)
    return MethodChannel(engine.dartExecutor.binaryMessenger, channel)
}