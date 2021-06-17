import React, { useState, useEffect } from 'react'
import { StatusBar } from 'expo-status-bar'
import { NavigationContainer } from '@react-navigation/native'
import { createStackNavigator } from '@react-navigation/stack'
import { ApolloClient, InMemoryCache, ApolloProvider } from '@apollo/client'
import AsyncStorage from '@react-native-community/async-storage'

import { persistCache } from 'apollo3-cache-persist'
import { WebSocketLink } from '@apollo/client/link/ws'

import { AppLoading } from 'expo'

import HomeScreen from './src/HomeScreen'
import WorkspaceScreen from './src/WorkspaceScreen'
import { screenOptions } from './src/styles'

const Stack = createStackNavigator()

const cache = new InMemoryCache()

const wsLink = new WebSocketLink({
  uri: 'ws://localhost:8080/graphql',
  options: {
    reconnect: true,
    connectionParams: {
      user_token: 'apollo/42',
    },
  }
});

const client = new ApolloClient({
  link: wsLink,
  cache,
  defaultOptions: { watchQuery: { fetchPolicy: 'cache-and-network' } },
})

export default function App() {
  const [loadingCache, setLoadingCache] = useState(true)

  useEffect(() => {
    persistCache({
      cache,
      storage: AsyncStorage,
    }).then(() => setLoadingCache(false))
  }, [])

  if (loadingCache) {
    return <AppLoading />
  }

  return (
    <ApolloProvider client={client}>
      <NavigationContainer>
        <Stack.Navigator initialRouteName="Home" screenOptions={screenOptions}>
          <Stack.Screen
            name="Home"
            component={HomeScreen}
            options={{ title: 'AnyWork' }}
          />
          <Stack.Screen
            name="Workspace"
            component={WorkspaceScreen}
            options={({
              route: {
                params: { id },
              },
            }) => ({
              title: id,
              gestureResponseDistance: { horizontal: 500 },
            })}
          />
        </Stack.Navigator>
        <StatusBar style="light" />
      </NavigationContainer>
    </ApolloProvider>
  )
}
