// A screen that calls Kron: drop it in as App.js of a React Native app.
import React, { useEffect, useState } from 'react';
import { SafeAreaView, Text, TextInput } from 'react-native';
import Kron from './Kron';

export default function App() {
  const [name, setName] = useState('Ada');
  const [line, setLine] = useState('');
  const [sum, setSum] = useState(0);

  useEffect(() => {
    Kron.add(40, 2).then(setSum);
  }, []);
  useEffect(() => {
    Kron.greet(name).then(setLine);
  }, [name]);

  return (
    <SafeAreaView style={{ padding: 24 }}>
      <Text>40 + 2 in Kron: {sum}</Text>
      <TextInput value={name} onChangeText={setName}
                 style={{ borderWidth: 1, marginVertical: 12, padding: 8 }} />
      <Text>{line}</Text>
    </SafeAreaView>
  );
}
