import Vue from 'vue'
import uuidv1 from 'uuid/v1'

export const namespaced = true

export const state = {
  submitting: false,
  loading: false,
  sidebarOpened: false,
  alerts: [],
  // completedCheckinSteps: {
  //   1: false,
  //   2: false,
  //   3: false,
  //   4: false
  // }
}

export const mutations = {
  SUBMITTING_REQUEST(state, submitting) {
    state.submitting = submitting
  },
  SET_LOADING(state, loading) {
    state.loading = loading
  },
  SET_SIDEBAR_STATUS(state, bolOpen) {
    state.sidebarOpened = bolOpen
  },
  ADD_ALERT(state, alertData) {
    state.alerts.push(alertData)
  },
  CLEAR_ALERTS(state) {
    state.alerts = []
  },
  REMOVE_ALERT(state, alertId) {
    state.alerts = state.alerts.filter(function(alert) {
      return alert.id !== alertId
    })
  },
  // SET_STEPS(state, steps) {
  //   state.completedCheckinSteps = steps
  // }
}

export const actions = {
  toggle_sidebar({commit, state}) {
    commit('SET_SIDEBAR_STATUS', !state.sidebarOpened)
  },
  submitting_request({ commit }, submitting) {
    commit('SUBMITTING_REQUEST', submitting)
  },
  set_loading({ commit }, loading) {
    commit('SET_LOADING', loading)
  },
  setSidebarStatus({ commit }, bolOpen) {
    commit('SET_SIDEBAR_STATUS', bolOpen)
  },
  addAlert({ commit }, alertData) {
    if (!['success', 'info', 'warning', 'error'].includes(alertData.type)) return
    if (!!alertData.key && !!alertData.message) return
    alertData['id'] = uuidv1()
    commit('ADD_ALERT', alertData)
  },
  clearAlerts({ commit }) {
    commit('CLEAR_ALERTS')
  },
  replaceAlert({ dispatch }, alertData) {
    dispatch('clearAlerts')
    dispatch('addAlert', alertData)
  },
  removeAlert({ commit }, alertId) {
    commit('REMOVE_ALERT', alertId)
  },
  // checkSteps({ commit, rootState }) {
  //   if (!!rootState.order && !!rootState.order.order && !!rootState.order.order.id) {
  //     const url = rootState.application.urls.checkin_steps.replace(':order_id', rootState.order.order.id).replace(':reservation_id', rootState.order.order.reservations[0].id)
  //     return Vue.http.get(url)
  //     .then(response => {
  //       commit('SET_STEPS', response.data)
  //       return response.data
  //     }).catch(error => {
  //       return error
  //     })
  //   }
  // }
}
