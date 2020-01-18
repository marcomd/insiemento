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
    })
  },
  setUser({ commit }, attributes) {
    commit('SET_USER', attributes)
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
    const _user = getters.currentUser
    //return _user.user_type == 'LEGAL_PERSON' ? _user.business_name : [_user.first_name, _user.last_name].join(' ')
    return [_user.firstname, _user.lastname].join(' ')
  },
  // fullAddress: (state, getters) => {
  //   if (!!getters.currentUser.address && !!getters.currentUser.cap) {
  //     return [getters.currentUser.address, getters.currentUser.cap].join(', ')
  //   }
  // }
}
