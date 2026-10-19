package dev.kron.rn

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.uimanager.ViewManager

// NativeModules.Kron in JavaScript: each method calls the Kron library.
class KronModule(context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {
    override fun getName() = "Kron"

    @ReactMethod
    fun add(a: Int, b: Int, promise: Promise) = promise.resolve(KronNative.add(a, b))

    @ReactMethod
    fun fib(n: Int, promise: Promise) = promise.resolve(KronNative.fib(n).toDouble())

    @ReactMethod
    fun greet(name: String, promise: Promise) = promise.resolve(KronNative.greet(name))
}

class KronPackage : ReactPackage {
    override fun createNativeModules(context: ReactApplicationContext): List<NativeModule> =
        listOf(KronModule(context))

    override fun createViewManagers(context: ReactApplicationContext): List<ViewManager<*, *>> =
        emptyList()
}
