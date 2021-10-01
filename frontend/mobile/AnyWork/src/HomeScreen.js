import React, { useState } from 'react'
import { View, TextInput, Button, FlatList, Pressable, Text } from 'react-native'
import { gql, useQuery } from '@apollo/client'
import styles from './styles'
import Loading from './Loading'
import Error from './Error'

const WORKSPACES_QUERY = gql`
  query getWorkspaces {
    workspaces: randomWorkspaces {
      id
      name
    }
  }
`

const WorkspaceItem = ({ workspace, onPress }) => {
  const { name } = workspace

  return (
    <Pressable style={styles.item} onPress={onPress}>
      <Text>{name}</Text>
    </Pressable>
  )
}

export default ({ navigation }) => {
  const [text, setText] = useState('')
  const { data, loading, error } = useQuery(WORKSPACES_QUERY)

  if (loading) {
    return <Loading />
  }

  if (error) {
    return <Error text={error.graphQLErrors.map( err => err.message ).join(', ')}/>
  }

  return (
    <View>
      <TextInput
        placeholder="Workspace ID"
        autoCapitalize="none"
        style={styles.input}
        defaultValue={text}
        onChangeText={text => setText(text)}
      ></TextInput>
      <Button
        title="Open"
        style={styles.button}
        onPress={() => navigation.navigate('Workspace', {id: text})}
      ></Button>
      <Text style={styles.subheader}>Random workspaces</Text>
      <FlatList
        data={data.workspaces}
        renderItem={({ item }) => (
          <WorkspaceItem
            workspace={item}
            onPress={() => navigation.navigate('Workspace', { id: item.id })}
          />
        )}
        keyExtractor={(workspace) => workspace.id}
      />
    </View>
  )
}
