export const namespaced = true

export const state = {
  options: {},
  urls: {},
  current_organization: {},
}

export const mutations = {
  LOAD_INITIAL_PROPS(state, initialProps) {
    for (let key in initialProps) {
      state[key] = initialProps[key]
    }
  },
}

export const actions = {
  loadInitialProps({ commit }, initialProps) {
    // console.log(`application/loadInitialProps: ${initialProps}`)
    commit('LOAD_INITIAL_PROPS', initialProps)
  }
}

export const getters = {
  currentOrganizationUuid: state => {
    return state.current_organization.uuid
  },
}
