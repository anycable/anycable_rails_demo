import React from 'react'
import { View, Text } from 'react-native'

import styles, { RED } from './styles'

export default ({text}) => (
  <View style={styles.centered}>
    <Text color={RED}>{text}</Text>
  </View>
)
