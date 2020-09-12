<template>
  <v-container fill-height class="d-flex justify-center">

    <v-row v-if="hasCurrentUser && !isCurrentUserCompleted">
      <v-col>
        <v-alert
            type="info"
            colored-border
            color="primary lighten-2"
            elevation="2"
            border="left"
        >
          {{ $t('profile.hints.incomplete_profile') }}
          <v-btn
              text
              color="primary"
              :to='{name: "editProfile"}'
          >
            {{ $t('commons.next') }}
          </v-btn>
        </v-alert>
      </v-col>
    </v-row>

    <CourseEventsCalendar v-if="subscribed_course_events.length > 0" :course_events="subscribed_course_events" />
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
  import CourseEventsCalendar from '../components/course_events/course_events_calendar'
  import { currentUserMixin } from '../mixins/current_user_mixin'

  import { mapState, mapActions, mapGetters } from 'vuex'

  export default {
    components: {
      CourseEventsCalendar,
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
