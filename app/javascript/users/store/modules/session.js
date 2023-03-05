import router from '../../router'
// import axios from "axios"
const axios = require('axios').default

export const namespaced = true

export const state = {
  options: {},
  urls: {},
  authToken: localStorage.getItem('authToken') || null
}

export const mutations = {
  LOGIN_SUCCESS(state, authToken) {
    state.authToken = authToken
  },
  LOGOUT(state) {
    state.authToken = null
    localStorage.removeItem('authToken')
    axios.defaults.headers.common['X-Auth-Token'] = null
  }
}

export const actions = {
  login({ commit, dispatch, rootState }, credentials) {
    dispatch('layout/submitting_request', true, { root: true })
    return new Promise((resolve, reject) => {
      axios
        .post(rootState.application.urls.login, credentials)
        .then(response => {
          //console.log('login response', response)
          const body = response.data
          const authToken = body.auth_token
          const userAttributes = body.user
          if (credentials.rememberMe) localStorage.setItem('authToken', authToken)
          axios.defaults.headers.common['X-Auth-Token'] = 'Bearer ' + authToken
          commit('LOGIN_SUCCESS', authToken)
          if (!!userAttributes) {
            dispatch('profile/setUser', userAttributes, { root: true })
          } else {
            // ...se per qualche motivo non si dovessero ricevere i dati del user dalla authenticate
            // si tenta una chiamata specifica
            dispatch('profile/fetchUser', null, { root: true })
          }
          resolve(body)
        }, error => {
          commit('LOGOUT')
          reject(error.response)
        })
        .finally(() => (dispatch('layout/submitting_request', false, { root: true })))
    })
  },
  logout({ commit, dispatch }, force) {
    commit('LOGOUT')
    alert = force === true ? { type: 'error', key: 'force_logout'} : { type: 'success', key: 'logout' }
    router.push({ name: 'login' })
    dispatch('layout/replaceAlert', alert, { root: true })
  },
  signUp({ commit, dispatch, rootState }, userData) {
    dispatch('layout/submitting_request', true, { root: true })
    return new Promise((resolve, reject) => {
      axios.post(rootState.application.urls.signUp, {
        user: userData
      }).then(response => {
        resolve(response)
      }, error => {
        reject(error.response)
      }).finally(() => (dispatch('layout/submitting_request', false, { root: true })))
    })
  },
  passwordReset({ commit, dispatch, rootState }, email) {
    dispatch('layout/submitting_request', true, { root: true })
    return new Promise((resolve, reject) => {
      axios.post(rootState.application.urls.passwordReset, {
        user: { email: email }
      }).then(response => {
        router.push({ name: 'login' })
        dispatch('layout/addAlert', {
          type: 'success',
          key: 'password_reset_sent'
        }, { root: true })
        resolve(response)
      }, error => {
        dispatch('layout/replaceAlert', {
          type: 'error',
          key: 'password_reset_error'
        }, { root: true })
        reject(error.response)
      }).finally(() => (dispatch('layout/submitting_request', false, { root: true })))
    })
  },
  newPassword({ commit, dispatch, rootState }, data) {
    dispatch('layout/submitting_request', true, { root: true })
    return new Promise((resolve, reject) => {
      axios.put(rootState.application.urls.passwordReset, {
        user: {
          password: data.password,
          reset_password_token: data.token
        }
      }).then(response => {
        router.push({ name: 'login' })
        dispatch('layout/addAlert', {
          type: 'success',
          key: 'new_password_saved'
        }, { root: true })
        resolve(response)
      }, error => {
        dispatch('layout/replaceAlert', {
          type: 'error',
          key: 'new_password_error'
        }, { root: true })
        reject(error.response)
      }).finally(() => (dispatch('layout/submitting_request', false, { root: true })))
    })
  },
  sendConfirmationEmail({ commit, dispatch, rootState }, email) {
    dispatch('layout/submitting_request', true, { root: true })
    return new Promise((resolve, reject) => {
      axios.post(rootState.application.urls.confirmationEmail, {
        user: { email: email }
      }).then(response => {
        router.push({ name: 'login' })
        dispatch('layout/addAlert', {
          type: 'success',
          key: 'confirmation_email_sent'
        }, { root: true })
        resolve(response)
      }, error => {
        dispatch('layout/replaceAlert', {
          type: 'error',
          key: 'confirmation_email_error'
        }, { root: true })
        reject(error.response)
      }).finally(() => (dispatch('layout/submitting_request', false, { root: true })))
    })
  }
}

export const getters = {
  isLoggedIn: state => {
    return !!state.authToken
  }
}
