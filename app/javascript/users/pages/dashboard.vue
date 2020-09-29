<template>
  <v-container fill-height class="d-flex justify-center">

    <ProfileCompletionAlert :has-current-user="hasCurrentUser" :is-current-user-completed="isCurrentUserCompleted" />

    <CourseEventsCalendar v-if="subscribed_course_events.length > 0" :course_events="subscribed_course_events" />
    <div v-else-if="subscribed_course_events.length == 0 && !loading"
         class="text-center">
      <h3 class="subtitle">{{ $t('course_event.list.none_subscribed') }}</h3>
      <v-btn x-large
             class='text-center'
             color="primary"
             :to='{name: "CourseEventIndex"}'>
        {{ $t('commons.go_to_list', {name: $t('course_event.list.name')}) }}
      </v-btn>
    </div>
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
  import CourseEventsCalendar from '../components/course_events/course_events_calendar'
  import ProfileCompletionAlert from '../components/session/profile_completion_alert'
  import { currentUserMixin } from '../mixins/current_user_mixin'

  import { mapState, mapActions, mapGetters } from 'vuex'

  export default {
    components: {
      CourseEventsCalendar,
      ProfileCompletionAlert,
    },

    mixins: [
      currentUserMixin,
    ],

    created() {
      this.fetchCourseEvents()
    },

    computed: {
      ...mapState('course_event', ['course_events']),
      ...mapState('layout', ['loading']),
      ...mapGetters('profile', ['currentUser', 'hasCurrentUser']),
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
