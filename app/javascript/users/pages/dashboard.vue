<template>
  <v-container fill-height class="d-flex justify-center">

    <CourseEventsTable :course_events="course_events" @select-course_event="setCourseEvent"/>
    <h3 v-if="course_events.length == 0 && !loading"
        class="d-flex justify-center subtitle">{{ $t('course_event.list.none') }}</h3>

    <CourseEventsListCards v-if="subscribed_course_events.length > 0" :course_events="subscribed_course_events" />
    <h3 v-else-if="subscribed_course_events.length == 0 && !loading"
        class="d-flex justify-center subtitle">{{ $t('course_event.list.none_subscribed') }}</h3>
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
  import CourseEventsTable from '../components/course_events/course_events_table'

  import { mapState, mapActions } from 'vuex'

  export default {
    created() {
      this.fetchCourseEvents()
    },
    components: {
      CourseEventsListCards,
      CourseEventsTable,
    },
    data() {
      return {
      }
    },
    computed: {
      ...mapState('course_event', ['course_events']),
      ...mapState('layout', ['loading']),
      subscribed_course_events() {
        return this.course_events.filter(course_event => course_event.subscribed )
      }
    },
    methods: {
     ...mapActions('course_event', ['fetchCourseEvents']),
      setCourseEvent({course_event}) {
        console.log(' dashboard setCourseEvent', course_event)
        this.$router.push({ name: 'courseEventShow', params: { id: course_event.id } })
      }
    },
  }
</script>

<style lang="scss">

</style>
