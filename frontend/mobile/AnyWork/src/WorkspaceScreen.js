import React from 'react'
import { View, Text, SafeAreaView, SectionList, Switch } from 'react-native'
import { gql, useSubscription } from '@apollo/client'

import styles from './styles'
import Loading from './Loading'
import Error from './Error'

const WORKSPACE_QUERY = gql`
  subscription subscribeToWorkspace($id: ID!) {
    workspaceUpdated(id: $id) {
      workspace {
        id
        name
        lists {
          id
          name
          items {
            id
            description
            completed
          }
        }
      }
    }
  }
`

const Item = ({description, checked}) => (
  <View style={styles.item}>
    <Switch disabled="true" value={checked} />
    <Text>
      {description}
    </Text>
  </View>
)

export default ({ route }) => {
  const { data, loading, error } = useSubscription(WORKSPACE_QUERY, {
    variables: { id: route.params.id },
  })

  if (loading) {
    return <Loading />
  }

  if (error) {
    return <Error text={error.graphQLErrors.map( err => err.message ).join(', ')}/>
  }

  console.log(data)

  if (!data) {
    return <Error text="Not found" />
  }

  const workspace = data.workspaceUpdated.workspace;

  if (!workspace) {
    return <Error text="Not found" />
  }

  const lists = workspace.lists.map( ({name, items}) => ({name, data: items}) )

  return (
    <SafeAreaView>
      <Text style={styles.header}>
        {workspace.name}
      </Text>
      <SectionList
        sections={lists}
        keyExtractor={(item, index) => item + index}
        renderItem={({item}) => (
          <Text style={styles.item}>
            {item.completed ? "✅" : "     "}
            {item.description}
          </Text>
        )}
        renderSectionHeader={({ section: { name } }) => (
          <Text style={styles.listHeader}>{name}</Text>
        )}
      />
  </SafeAreaView>
  )
}
