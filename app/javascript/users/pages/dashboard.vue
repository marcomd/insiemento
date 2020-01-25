<template>
  <v-container fill-height class="d-flex justify-center">

    <CourseEventsListCards v-if="course_events.length > 0" :course_events="course_events" />
    <h3 v-else-if="course_events.length == 0 && !loading"
        class="d-flex justify-center subtitle">{{ $t('course_event.list.none') }}</h3>
    <v-card v-else
            elevation="0"
            class="mb-12">
      <v-progress-circular
        color="primary"
        size="50"
        indeterminate>
      </v-progress-circular>
    </v-card>
  </v-container>
</template>

<script>
  // Components
  import CourseEventsListCards from '../components/course_events/course_events_list_cards'

  import { mapState, mapActions } from 'vuex'

  export default {
    created() {
      this.fetchCourseEvents()
    },
    components: {
      CourseEventsListCards
    },
    data() {
      return {
      }
    },
    computed: {
      ...mapState('course_event', ['course_events']),
      ...mapState('layout', ['loading']),
    },
    methods: {
     ...mapActions('course_event', ['fetchCourseEvents'])
    },
  }
</script>

<style lang="scss">

</style>
