import Vue from 'vue'

export const namespaced = true

export const state = {
  course_events: [],
  course_event: {},
  search: null,
  listOptions: {
    page: null,
    perPage: null,
  },
}

export const mutations = {
  SET_COURSE_EVENTS(state, course_events) {
    state.course_events = course_events
  },
  SET_COURSE_EVENT(state, course_event) {
    state.course_event = course_event
  },
  // After updates use this mutation to refresh the single item into the cache
  REFRESH_COURSE_EVENT_IN_COURSE_EVENTS(state, course_event=state.course_event) {
    console.log('Refresh course_events, currently items:', state.course_events.length)
    let indexToReplace = state.course_events.findIndex(obj => obj.id == course_event.id)
    if (indexToReplace != -1) {
      console.log(' - replace old with newest, id', course_event.id)
      state.course_events[indexToReplace] = course_event
      //this is for vue reaction
      state.course_events.push({})
      state.course_events.splice(-1, 1)
    } else {
      state.course_events.push(course_event)
    }
    // console.log('  - replaced! New items:', state.course_events.length)
  },
  SET_SEARCH(state, search) {
    state.search = search
  },
  SET_LIST_OPTIONS(state, options) {
    state.listOptions = options
  },
}

export const actions = {
  fetchCourseEvents({ commit, dispatch, rootState }, state_param = 'active') {
    return new Promise((resolve, reject) => {
      dispatch('layout/set_loading', true, { root: true })
      // console.log(`fetchCourseEvents rootState ${rootState.application.urls.course_events_index}`)
      let url = `${rootState.application.urls.course_events_index}?state=${state_param}`
      Vue.http.get(url, null, {
        responseType: 'json',
      }).then(response => {
        let course_events = response.data
        commit('SET_COURSE_EVENTS', course_events)
        dispatch('layout/set_loading', false, { root: true })
        resolve(course_events)
      }).catch(error => {
        dispatch('layout/set_loading', false, { root: true })
        console.log('fetchCourseEvents There was an error:', error.response ? error.response : error)
        reject(error)
      })
    })
  },
  fetchCourseEvent({ commit, dispatch, getters, rootState }, {id, fresh=false}) {
    return new Promise((resolve, reject) => {
      console.log(`course_event/fetchCourseEvent id ${id} fresh ${fresh}`)
      let course_event
      if (!fresh) {
        course_event = getters.getCourseEventById(id)
        console.log(`  - course_event retrieved from cache`, course_event)
      }
      if (course_event) {
        // Rimpiazziamo course_event con quello dell'id ricercato
        commit('SET_COURSE_EVENT', course_event)
        resolve(course_event)
      } else {
        dispatch('layout/set_loading', true, { root: true })
        let url = rootState.application.urls.course_event_show.replace(':id', id)
        return Vue.http.get(url, null, {
          responseType: 'json',
          }).then(response => {
            course_event = response.data
            commit('SET_COURSE_EVENT', course_event)
            commit('REFRESH_COURSE_EVENT_IN_COURSE_EVENTS', course_event)
            dispatch('layout/set_loading', false, { root: true })
            resolve(course_event)
          })
          .catch(error => {
            console.log('fetchCourseEvent There was an error:', error.response ? error.response : error)
            dispatch('layout/set_loading', false, { root: true })
            reject(error)
          })
      }
    })
  },
  updateSubscription({ commit, dispatch, rootState }, { course_event_id, params }) {
    dispatch('layout/submitting_request', true, { root: true })
    return new Promise((resolve, reject) => {
      const url = rootState.application.urls.course_event_subscribe.replace(':id', course_event_id)
      let course_event
      Vue.http.put(url, params)
        .then(response => {
          course_event = response.body
          console.log(`updateSubscription course_event`, course_event)
          commit('SET_COURSE_EVENT', course_event)
          commit('REFRESH_COURSE_EVENT_IN_COURSE_EVENTS', course_event)
          resolve(response)
        }, error => {
          reject(error)
        })
        .finally(() => (dispatch('layout/submitting_request', false, { root: true })))
    })
  },
  getAttendees({ commit, dispatch, rootState }, { course_event_id }) {
    dispatch('layout/set_loading', true, { root: true })
    return new Promise((resolve, reject) => {
      const url = rootState.application.urls.course_event_attendees.replace(':id', course_event_id)
      let course_event
      Vue.http.get(url, null, {
        responseType: 'json',
      }).then(response => {
        let attendees = response.data
        // commit('SET_ATTENDEES', attendees)
        dispatch('layout/set_loading', false, { root: true })
        resolve(attendees)
      }).catch(error => {
        dispatch('layout/set_loading', false, { root: true })
        console.log('getAttendees There was an error:', error.response ? error.response : error)
        reject(error)
      })
    })
  },
  updatePresences({ commit, dispatch, rootState }, { course_event_id, params }) {
    dispatch('layout/submitting_request', true, { root: true })
    return new Promise((resolve, reject) => {
      const url = rootState.application.urls.course_event_audit.replace(':id', course_event_id)
      let course_event
      Vue.http.put(url, params)
        .then(response => {
          course_event = response.body
          console.log(`updateSubscription course_event`, course_event)
          resolve(response)
        }, error => {
          reject(error)
        })
        .finally(() => (dispatch('layout/submitting_request', false, { root: true })))
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
  getCourseEventById: state => id => {
    return state.course_events.find(course_event => course_event.id == id)
  },
}
