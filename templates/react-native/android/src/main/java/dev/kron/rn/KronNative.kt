package dev.kron.rn

// The Kron library: libkron.so, built from kron_rn.kr. Each external fun is
// a function kron_rn.kr exports as Java_dev_kron_rn_KronNative_<name>.
object KronNative {
    init {
        System.loadLibrary("kron")
    }

    @JvmStatic external fun add(a: Int, b: Int): Int
    @JvmStatic external fun fib(n: Int): Long
    @JvmStatic external fun greet(name: String): String
}
