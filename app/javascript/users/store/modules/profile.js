import Vue from 'vue'

export const namespaced = true

export const state = {
  user: {}
}

export const mutations = {
  SET_USER(state, user) {
    state.user = user
  }
}

export const actions = {
  fetchUser({ commit, dispatch, rootState }) {
    Vue.http.get(rootState.application.urls.profile)
    .then(response => {
      commit('SET_USER', response.body)
      const orderAttributes = response.body.pending_order
      if (!!orderAttributes) {
        dispatch('order/setOrder', orderAttributes, { root: true })
      }
    })
  },
  setUser({ commit, dispatch }, attributes) {
    commit('SET_USER', attributes)
    const orderAttributes = attributes.pending_order
    if (!!orderAttributes) {
      dispatch('order/setOrder', orderAttributes, { root: true })
    }
  },
  update({ commit, dispatch, rootState }, payload) {
    return new Promise((resolve, reject) => {
      Vue.http.put(rootState.application.urls.profile, { user: payload })
      .then(response => {
        commit('SET_USER', response.body)
        resolve(response)
      }, error => {
        reject(error)
      })
    })
  }
}

export const getters = {
  currentUser: (state, getters, rootState, rootGetters) => {
    if (!rootGetters['session/isLoggedIn']) return {}
    // TBD
    return state.user
  },
  hasCurrentUser: (state, getters) => {
    // checking email to detect if currentUser is an empty object
    return getters.currentUser.email !== undefined
  },
  // isCurrentUserCompleted: (state, getters) => {
  //   return !!getters.currentUser.language
  // },
  fullName: (state, getters) => {
    const user = getters.currentUser
    const child_name = user.child_firstname && user.child_firstname.length > 0 ? ` (${user.child_firstname})` : ''
    return `${user.firstname} ${user.lastname}${child_name}`
  },
  isTrainer: (state, getters) => {
    return !!getters.currentUser.trainer_id
  },
  // fullAddress: (state, getters) => {
  //   if (!!getters.currentUser.address && !!getters.currentUser.cap) {
  //     return [getters.currentUser.address, getters.currentUser.cap].join(', ')
  //   }
  // }
}
