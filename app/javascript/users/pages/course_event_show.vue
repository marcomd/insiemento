<template>
  <v-container>
    <v-row align='center' justify='center'>
      <v-col cols='12' sm='8'>

        <CourseEventCardFull v-if="course_event && course" :course_event="course_event"/>
        <div v-else-if="loading" class="text-center">
          <v-progress-circular
            size="50"
            color="primary"
            indeterminate>
          </v-progress-circular>
        </div>
        <div v-else
             class="text-center">
          <v-btn x-large
                 color='success'
                 class='mr-2 mb-2'
                 :to='{name: "CourseEventIndex"}'>
            {{ $t('sidebar.course_events') }}
          </v-btn>
        </div>

        <CourseEventAttendeesAudit v-if="attendees.length > 0" :course_event_id="course_event.id" :attendees="attendees" />
        <div v-else-if="loading" align="center" class="mt-3">
          <v-progress-circular
              size="30"
              color="#aaaaaa"
              indeterminate>
          </v-progress-circular>
        </div>
      </v-col>
    </v-row>
    <v-row>
      <v-col class="text-center">
        <v-btn x-large
               :color="course_event.subscribed ? 'error' : 'success'"
               class=''
               :loading="submitting"
               @click="updateCourseEventSubscription"
               :disabled="isCourseEventFull && !course_event.subscribed"
        >
          {{ course_event.subscribed ? $t('course_event.unsubscribe_action') : $t('course_event.subscribe_action') }}
        </v-btn>
      </v-col>
      <v-col class="text-center">
        <v-btn x-large
               class=''
               :to='{name: "CourseEventIndex"}'>
          {{ $t('commons.go_to_list', {name: $t('course_event.list.name')}) }}
        </v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  import { mapState, mapGetters, mapActions } from 'vuex'

  import CourseEventCardFull from '../components/course_events/course_event_card_full'
  import CourseEventAttendeesAudit from '../components/course_events/course_events_attendees_audit'
  import { courseEventMixin } from '../mixins/course_event_mixin'

  export default {
    name: 'CourseEventShow',

    components: {
      CourseEventCardFull,
      CourseEventAttendeesAudit,
    },

    mixins: [courseEventMixin],

    mounted () {
      // This ensures a single web socket connection. Call it in every component that wants to use Action Cable.
      // this.websocket = this.$cable.useGlobalConnection()
      this.$cable.subscribe({
        channel: 'OrganizationChannel',
        uuid: this.currentOrganizationUuid,
      })

      // Or with an auth token: Calls your connectionUrl with a token GET-param, e.g. 'wss://www.your-app.de/cable?token=1290e42e42e5e1d68220d8de66092e75'
      // const token = this.$auth.getToken('local').replace('Bearer ', '')
      // this.websocket = this.$cable.useGlobalConnection(token)
    },

    created() {
      this.$store.dispatch('course_event/fetchCourseEvent', {id: this.$route.params.id})
        .then(course_event => {
          console.log(`course_event show id ${this.$route.params.id} course_event ${course_event.id} `)
          if (this.isTrainer) {
            console.log(`get attendees list`)
            this.getAttendees({course_event_id: course_event.id}).then(attendees => {
              this.attendees = attendees
            })
          }
        }).catch( error => {
          this.$store.dispatch('layout/replaceAlert', {
            type: 'error',
            key: 'course_event_not_found'
          })
        console.log(`Cannot fetch course_event id ${this.$route.params.id}: ${error}`)
      })
    },

    data: () => {
      return {
        attendees: [],
      }
    },

    computed: {
      ...mapState('course_event', ['course_event']),
      ...mapState('layout', ['loading', 'submitting']),
      ...mapGetters('application', ['currentOrganizationUuid']),
      ...mapGetters('profile', ['isTrainer']),
    },

    methods: {
      ...mapActions('course_event', ['getAttendees']),
      updateCourseEventSubscription() {
        console.log(`updateCourseEventSubscription ${this.course_event.id} to ${!this.course_event.subscribed}`)
        this.$store
          .dispatch(`course_event/updateSubscription`, {
                    course_event_id: this.course_event.id,
                    params: {subscribe: !this.course_event.subscribed}
                  }
          )
          .then( _ => {
            console.log(`updateCourseEventSubscription OK to ${this.course_event.subscribed}`)
          })
          .catch(error => {
            // const myObject = error && error.body ? error.body : error
            const message = error && error.body ? (error.body.errors && error.body.errors.course_event_id ? error.body.errors.course_event_id.join(', ') : error.body.error || error.body) : error
            // const message = Object.keys(myObject).map( (key, index) => myObject[key]).join(', ')

            this.$store.dispatch('layout/replaceAlert', {
              type: 'error',
              message: message
            })
            console.log(`Cannot updateCourseEventSubscription`, error)
          })
      },
      // sendMessageToChannel() {
      //   this.$cable.perform({
      //     channel: 'RoomChannel',
      //     action: 'receive',
      //     data: {
      //       content: 'This is a try message...'
      //     }
      //   });
      // }
    },

    channels: {
      OrganizationChannel: {
        connected() { console.log(`Vue connected to the OrganizationChannel ${this.currentOrganizationUuid}, olè!`) },
        rejected() { console.log(`Vue connection rejected :-(`) },
        received(data) {
          console.log(`Stream received from OrganizationChannel:`, data)
          // Per aggiornare la lista dei trainer il server dovrebbe propagare l'elenco aggiornato oltre all'oggetto course_event
          // if (data.attendees) {
          //   // this.course_event.attendees_count = this.attendees.length
          //   if (this.isTrainer) this.attendees = data.attendees
          // }
          if (data.course_event) {
            // Save the current subscription state because broadcasting doesn't know it
            // data.course_event.subscribed = this.course_event.subscribed
            this.$store.dispatch('course_event/setCourseEvent', {...data.course_event,subscribed: this.course_event.subscribed} )
          }
        },
        disconnected() { console.log(`Vue left the OrganizationChannel`) }
      }
    },
  }
</script>

<style lang="scss" scoped>
</style>
