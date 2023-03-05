import axios from "axios"

export const namespaced = true

export const state = {
  orders: [],
  order: {
    products: []
  },
}

export const mutations = {
  SET_ORDERS(state, orders) {
    state.orders = orders
  },
  SET_ORDER(state, order) {
    state.order = order
  },
  ADD_PRODUCT(state, product) {
    // I have to initialize the array into the object
    // if (!state.order.products) {
    //   state.order.products = []
    // }
    state.order.products.push(product)
  },
  REMOVE_PRODUCT(state, id) {
    let indexToRemove = state.order.products.findIndex(product => product.id == id)
    if (indexToRemove != -1) {
      state.order.products.splice(indexToRemove, 1)
    }
  },
  // After updates use this mutation to refresh the single item into the cache
  REFRESH_ORDER_IN_ORDERS(state, order=state.order) {
    console.log('Refresh orders, currently items:', state.orders.length)
    let indexToReplace = state.orders.findIndex(obj => obj.id == order.id)
    if (indexToReplace != -1) {
      console.log(' - replace old with newest, id', order.id)
      state.orders[indexToReplace] = order
      //this is for vue reaction
      state.orders.push({})
      state.orders.splice(-1, 1)
    } else {
      state.orders.push(order)
    }
    // console.log('  - replaced! New items:', state.orders.length)
  },
}

export const actions = {
  fetchOrders({ commit, dispatch, rootState }, state_param = 'active') {
    return new Promise((resolve, reject) => {
      dispatch('layout/set_loading', true, { root: true })
      // console.log(`fetchOrders rootState ${rootState.application.urls.orders_index}`)
      let url = `${rootState.application.urls.orders}?state=${state_param}`
      axios.get(url, null, {
        responseType: 'json',
      }).then(response => {
        let orders = response.data
        commit('SET_ORDERS', orders)
        dispatch('layout/set_loading', false, { root: true })
        resolve(orders)
      }).catch(error => {
        dispatch('layout/set_loading', false, { root: true })
        console.log('fetchOrders There was an error:', error.response ? error.response : error)
        reject(error)
      })
    })
  },
  fetchOrder({ commit, dispatch, getters, rootState }, {id, fresh=false}) {
    return new Promise((resolve, reject) => {
      console.log(`order/fetchOrder id ${id} fresh ${fresh}`)
      let order
      if (!fresh) {
        order = getters.getOrderById(id)
        console.log(`  - order retrieved from cache`, order)
      }
      if (order) {
        // Rimpiazziamo order con quello dell'id ricercato
        commit('SET_ORDER', order)
        resolve(order)
      } else {
        dispatch('layout/set_loading', true, { root: true })
        let url = rootState.application.urls.order.replace(':id', id)
        return axios.get(url, null, {
          responseType: 'json',
          }).then(response => {
            order = response.data
            commit('SET_ORDER', order)
            commit('REFRESH_ORDER_IN_ORDERS', order)
            dispatch('layout/set_loading', false, { root: true })
            resolve(order)
          })
          .catch(error => {
            console.log('fetchOrder There was an error:', error.response ? error.response : error)
            dispatch('layout/set_loading', false, { root: true })
            reject(error)
          })
      }
    })
  },
  setOrder({ commit }, attributes) {
    commit('SET_ORDER', attributes)
  },
  create({ commit, dispatch, rootState }, params) {
    dispatch('layout/submitting_request', true, { root: true })
    return new Promise((resolve, reject) => {
      const url = rootState.application.urls.orders

      return refreshOrder({ url, params, commit, f: axios.post })
    })
  },
  update({ commit, dispatch, rootState }, { order_id, params }) {
    const url = rootState.application.urls.order.replace(':id', order_id)

    return refreshOrder({ url, params, commit, f: axios.put })
  },
  addProductToCart({ commit }, product) {
    commit('ADD_PRODUCT', product)
  },
  removeProductFromCart({ commit }, product_id) {
    commit('REMOVE_PRODUCT', product_id)
  },
  addProductToOrder({ commit, dispatch, rootState }, { order_id, product_id, params }) {
    const url = rootState.application.urls.order_add_product.replace(':id', order_id).replace(':product_id', product_id)

    return refreshOrder({ url, params, commit, f: axios.put })
  },
}

const refreshOrder = ({ url, params, commit, f }) => {
  dispatch('layout/submitting_request', true, { root: true })

  return f(url, params)
      .then(response => {
        const order = response.data
        //console.log(`refresh order`, order, f)
        commit('SET_ORDER', order)
        commit('REFRESH_ORDER_IN_ORDERS', order)
        resolve(response)
      }, error => {
        reject(error)
      })
      .finally(() => (dispatch('layout/submitting_request', false, { root: true })))
}

export const getters = {
  getOrderById: state => id => {
    return state.orders.find(order => order.id == id)
  },
  getCartProductById: state => id => {
    return state.order.products && state.order.products.find(product => product.id == id)
  },
}
