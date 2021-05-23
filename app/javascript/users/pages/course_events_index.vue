<template>
  <v-container fill-height class="d-flex justify-center">

    <ProfileCompletionAlert :has-current-user="hasCurrentUser" :is-current-user-completed="isCurrentUserCompleted" />

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
  import ProfileCompletionAlert from '../components/session/profile_completion_alert'
  import { currentUserMixin } from '../mixins/current_user_mixin'

  import { mapState, mapActions, mapGetters } from 'vuex'

  export default {
    components: {
      CourseEventsListCards,
      CourseEventsTable,
      ProfileCompletionAlert,
    },

    mixins: [
      currentUserMixin,
    ],

    mounted () {
      this.$cable.subscribe({
        channel: 'OrganizationChannel',
        uuid: this.currentOrganizationUuid,
      })
    },

    created() {
      this.fetchCourseEvents()
    },

    computed: {
      ...mapState('course_event', ['course_events']),
      ...mapState('layout', ['loading']),
      ...mapGetters('application', ['currentOrganizationUuid']),
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

    channels: {
      OrganizationChannel: {
        connected() { console.log(`Vue connected to the OrganizationChannel ${this.currentOrganizationUuid}, olè!`) },
        rejected() { console.log(`Vue connection rejected :-(`) },
        received(data) {
          console.log(`Stream received from OrganizationChannel:`, data)
          if (data.course_event) {
            this.$store.dispatch('course_event/refreshCourseEvents', data.course_event)
          }
        },
        disconnected() { console.log(`Vue left the OrganizationChannel`) }
      }
    },
  }
</script>

<style lang="scss">

</style>
