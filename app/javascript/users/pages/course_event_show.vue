<template>
  <v-container>
    <v-row align='center' justify='center'>
      <v-col cols='12' sm='8'>

        <CourseEventCardFull v-if="course_event" :course_event="course_event"/>
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
                 :to='{name: "dashboard"}'>
            {{ $t('sidebar.dashboard') }}
          </v-btn>
        </div>
      </v-col>
    </v-row>
    <v-row>
      <v-col class="text-center">
        <v-btn x-large
               color='primary'
               class='mr-2 mb-2'
               :loading="submitting"
               @click="updateCourseEventSubscription"
               :disabled="isCourseEventFull && !course_event.subscribed"
        >
          {{ course_event.subscribed ? $t('course_event.unsubscribe_action') : $t('course_event.subscribe_action') }}
        </v-btn>
      </v-col>
      <v-col class="text-center">
        <v-btn x-large
               class='mr-2 mb-2'
               :to='{name: "dashboard"}'>
          {{ $t('commons.go_back') }}
        </v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  import { mapState } from 'vuex'

  import CourseEventCardFull from '../components/course_events/course_event_card_full'
  import { courseEventMixin } from '../mixins/course_event_mixin'

  export default {
    name: 'courseEventShow',
    components: {
      CourseEventCardFull
    },
    mixins: [courseEventMixin],
    created() {
      this.$store.dispatch('course_event/fetchCourseEvent', {id: this.$route.params.id})
        .then(course_event => {
          console.log(`course_event show id ${this.$route.params.id} course_event ${course_event.id} `)
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
      }
    },
    computed: {
      ...mapState('course_event', ['course_event']),
      ...mapState('layout', ['loading', 'submitting']),
    },
    methods: {
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
            // const message = Object.keys(myObject).map( (key, index) => myObject[key]).join(', ')
            const message = error && error.body ? (error.body.course_event_id ? error.body.course_event_id.join(', ') : error.body) : error
            this.$store.dispatch('layout/replaceAlert', {
              type: 'error',
              message: message
            })
            console.log(`Cannot updateCourseEventSubscription`, error)
          })
      },
    }
  }
</script>

<style lang="scss" scoped>
</style>
