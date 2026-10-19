// The Kron module, from JavaScript. Every call returns a promise.
//
//   import Kron from './Kron';
//   const sum = await Kron.add(2, 3);          // 5
//   const big = await Kron.fib(80);            // 23416728348467685
//   const text = await Kron.greet('Ada');      // "Hello, Ada, from Kron"
import { NativeModules } from 'react-native';

const { Kron } = NativeModules;

export default {
  add: (a, b) => Kron.add(a, b),
  fib: (n) => Kron.fib(n),
  greet: (name) => Kron.greet(name),
};
