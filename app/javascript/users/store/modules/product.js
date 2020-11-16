import Vue from 'vue'

export const namespaced = true

export const state = {
  products: [],
  product: {},
  search: null,
  listOptions: {
    page: null,
    perPage: null,
  },
}

export const mutations = {
  SET_PRODUCTS(state, products) {
    state.products = products
  },
  SET_PRODUCT(state, product) {
    state.product = product
  },
  // After updates use this mutation to refresh the single item into the cache
  REFRESH_PRODUCT_IN_PRODUCTS(state, product=state.product) {
    console.log('Refresh products, currently items:', state.products.length)
    let indexToReplace = state.products.findIndex(obj => obj.id == product.id)
    if (indexToReplace != -1) {
      console.log(' - replace old with newest, id', product.id)
      state.products[indexToReplace] = product
      //this is for vue reaction
      state.products.push({})
      state.products.splice(-1, 1)
    } else {
      state.products.push(product)
    }
    // console.log('  - replaced! New items:', state.products.length)
  },
  SET_SEARCH(state, search) {
    state.search = search
  },
  SET_LIST_OPTIONS(state, options) {
    state.listOptions = options
  },
}

export const actions = {
  fetchProducts({ commit, dispatch, rootState }, state_param = 'active') {
    return new Promise((resolve, reject) => {
      dispatch('layout/set_loading', true, { root: true })
      // console.log(`fetchProducts rootState ${rootState.application.urls.products_index}`)
      let url = `${rootState.application.urls.products_index}?state=${state_param}`
      Vue.http.get(url, null, {
        responseType: 'json',
      }).then(response => {
        let products = response.data
        commit('SET_PRODUCTS', products)
        dispatch('layout/set_loading', false, { root: true })
        resolve(products)
      }).catch(error => {
        dispatch('layout/set_loading', false, { root: true })
        console.log('fetchProducts There was an error:', error.response ? error.response : error)
        reject(error)
      })
    })
  },
  fetchProduct({ commit, dispatch, getters, rootState }, {id, fresh=false}) {
    return new Promise((resolve, reject) => {
      console.log(`product/fetchProduct id ${id} fresh ${fresh}`)
      let product
      if (!fresh) {
        product = getters.getProductById(id)
        console.log(`  - product retrieved from cache`, product)
      }
      if (product) {
        // Rimpiazziamo product con quello dell'id ricercato
        commit('SET_PRODUCT', product)
        resolve(product)
      } else {
        dispatch('layout/set_loading', true, { root: true })
        let url = rootState.application.urls.product_show.replace(':id', id)
        return Vue.http.get(url, null, {
          responseType: 'json',
          }).then(response => {
            product = response.data
            commit('SET_PRODUCT', product)
            commit('REFRESH_PRODUCT_IN_PRODUCTS', product)
            dispatch('layout/set_loading', false, { root: true })
            resolve(product)
          })
          .catch(error => {
            console.log('fetchProduct There was an error:', error.response ? error.response : error)
            dispatch('layout/set_loading', false, { root: true })
            reject(error)
          })
      }
    })
  },
  setSearch({ commit }, search) {
    commit('SET_SEARCH', search)
  },
  setListOptions({ commit }, options) {
    commit('SET_LIST_OPTIONS', options)
  },
}

export const getters = {
  getProductById: state => id => {
    return state.products.find(product => product.id == id)
  },
}
