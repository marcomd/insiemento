import Vue from 'vue'

export const namespaced = true

export const state = {
  subscriptions: [],
  subscription: {},
}

export const mutations = {
  SET_SUBSCRIPTIONS(state, subscriptions) {
    state.subscriptions = subscriptions
  },
  SET_SUBSCRIPTION(state, subscription) {
    state.subscription = subscription
  },
  // After updates use this mutation to refresh the single item into the cache
  REFRESH_SUBSCRIPTION_IN_SUBSCRIPTIONS(state, subscription=state.subscription) {
    console.log('Refresh subscriptions, currently items:', state.subscriptions.length)
    let indexToReplace = state.subscriptions.findIndex(obj => obj.id == subscription.id)
    if (indexToReplace != -1) {
      console.log(' - replace old with newest, id', subscription.id)
      state.subscriptions.splice(indexToReplace, 1)
    }
    state.subscriptions.push(subscription)
    // console.log('  - replaced! New items:', state.subscriptions.length)
  },
}

export const actions = {
  fetchSubscriptions({ commit, dispatch, rootState }, state_param = null) {
    return new Promise((resolve, reject) => {
      dispatch('layout/set_loading', true, { root: true })
      // console.log(`fetchSubscriptions rootState ${rootState.application.urls.subscriptions_index}`)
      let url = rootState.application.urls.subscriptions_index
      if (state_param) url += `?state=${state_param}`
      Vue.http.get(url, null, {
        responseType: 'json',
      }).then(response => {
        let subscriptions = response.data
        commit('SET_SUBSCRIPTIONS', subscriptions)
        dispatch('layout/set_loading', false, { root: true })
        resolve(subscriptions)
      }).catch(error => {
        dispatch('layout/set_loading', false, { root: true })
        console.log('fetchSubscriptions There was an error:', error.response ? error.response : error)
        reject(error)
      })
    })
  },
  fetchSubscription({ commit, dispatch, getters, rootState }, {id, fresh=false}) {
    return new Promise((resolve, reject) => {
      console.log(`subscription/fetchSubscription id ${id} fresh ${fresh}`)
      let subscription
      if (!fresh) {
        subscription = getters.getSubscriptionById(id)
        console.log(`  - subscription retrieved from cache`, subscription)
      }
      if (subscription) {
        // Rimpiazziamo subscription con quello dell'id ricercato
        commit('SET_SUBSCRIPTION', subscription)
        resolve(subscription)
      } else {
        dispatch('layout/set_loading', true, { root: true })
        let url = rootState.application.urls.subscription_show.replace(':id', id)
        return Vue.http.get(url, null, {
          responseType: 'json',
          }).then(response => {
            subscription = response.data
            commit('SET_SUBSCRIPTION', subscription)
            commit('REFRESH_SUBSCRIPTION_IN_SUBSCRIPTIONS', subscription)
            dispatch('layout/set_loading', false, { root: true })
            resolve(subscription)
          })
          .catch(error => {
            console.log('fetchSubscription There was an error:', error.response ? error.response : error)
            dispatch('layout/set_loading', false, { root: true })
            reject(error)
          })
      }
    })
  },
}

export const getters = {
  getSubscriptionById: state => id => {
    return state.subscriptions.find(subscription => subscription.id == id)
  },
}
