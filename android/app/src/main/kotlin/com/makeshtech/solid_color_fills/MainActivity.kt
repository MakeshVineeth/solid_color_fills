package com.makeshtech.solid_color_fills

import android.content.Context
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.FlutterShellArgs
import io.flutter.embedding.engine.dart.DartExecutor
import java.lang.ref.WeakReference

class MainActivity : FlutterActivity() {
    companion object {
        private const val ENGINE_ID = "solid_color_fills_engine"
        private val engineLock = Any()
        private var activeOwner: WeakReference<MainActivity>? = null
    }

    private var usesCachedEngine: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        synchronized(engineLock) {
            val currentOwner = activeOwner?.get()
            if (currentOwner != null && currentOwner !== this) {
                usesCachedEngine = false
                return super.provideFlutterEngine(context)
            }

            val cache = FlutterEngineCache.getInstance()
            var engine = cache.get(ENGINE_ID)
            if (engine == null) {
                engine = FlutterEngine(
                    context.applicationContext,
                    FlutterShellArgs.fromIntent(intent).toArray(),
                )
                engine.dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault(),
                )
                cache.put(ENGINE_ID, engine)
            }
            activeOwner = WeakReference(this)
            usesCachedEngine = true
            return engine
        }
    }

    override fun shouldDestroyEngineWithHost(): Boolean = !usesCachedEngine

    override fun onDestroy() {
        val keepForRelaunch = usesCachedEngine && isChangingConfigurations
        super.onDestroy()
        synchronized(engineLock) {
            if (usesCachedEngine && activeOwner?.get() === this) {
                activeOwner = null
                if (!keepForRelaunch) {
                    val cache = FlutterEngineCache.getInstance()
                    cache.get(ENGINE_ID)?.let { engine ->
                        cache.remove(ENGINE_ID)
                        engine.destroy()
                    }
                }
            }
        }
    }
}
