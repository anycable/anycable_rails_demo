import { StyleSheet } from 'react-native'

export const RED = '#ff5e5e'

export const screenOptions = {
  headerStyle: {
    backgroundColor: RED,
  },
  headerTintColor: '#fff',
}

export default StyleSheet.create({
  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  item: {
    paddingTop: 16,
    paddingBottom: 16,
    paddingLeft: 20,
    paddingRight: 20,
    borderBottomWidth: 1,
    borderBottomColor: '#cccccc',
  },
  input: {
    paddingTop: 16,
    paddingBottom: 16,
    paddingLeft: 20,
    paddingRight: 20,
    borderBottomWidth: 1,
    borderBottomColor: '#cccccc',
  },
  header: {
    fontWeight: 'bold',
    fontSize: 32,
    textAlign: 'center',
    marginTop: 10,
    marginBottom: 10,
  },
  listHeader: {
    padding: 4,
    fontSize: 24,
    marginTop: 10,
  },
  item: {
    fontSize: 16,
    paddingLeft: 8,
    paddingTop: 4,
    paddingBottom: 4,
  },
  subheader: {
    paddingTop: 10,
  },
  button: {
    color: RED,
  }
})
