<template>
  <v-container fluid>
    <h3 class="d-flex justify-center subtitle">{{ $t('course_event.attendees.audit.title') }}:</h3>
    <v-row>
      <v-col cols="12" align="center">
        <v-row align="center" justify="center">
          <v-checkbox v-model="presences"
                      v-for="attendee in attendees"
                      :key="attendee.id"
                      :label="attendee.user_name"
                      :value="attendee.id"
                      class="attendee-element"
          />
        </v-row>
      </v-col>
    </v-row>
    <v-row align="center" justify="center">
      <v-col cols="12" align="center">
        <v-btn v-show="changed" @click="submitAudit" color="success">Ok</v-btn>
        <v-btn v-show="changed" @click="undo">Annulla</v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  export default {
    name: 'CourseEventsAteendeesAudit',
    props: {
      attendees: {
        type: Array,
        required: true
      },
      course_event_id: {
        type: Number,
        required: true
      }
    },
    data() {
      return {
        presences: [],
        presences_before_changes: [],
      }
    },
    created() {
      this.presences = this.attendees.filter(attendee => attendee.presence).map(attendee => attendee.id)
      this.presences_before_changes = this.presences
    },
    computed: {
      changed() {
        return this.presences_before_changes !== this.presences
      }
    },
    methods: {
      undo() {
        this.presences = this.presences_before_changes
      },
      // foo() {
      //   const paramPresences = { }
      //   this.presences.map(x => {
      //     paramPresences[`${x}`] = true
      //   })
      //   this.attendees.map(x => x.id).filter(x => !this.presences.includes(x)).map(x => {
      //     paramPresences[`${x}`] = false
      //   })
      //   return paramPresences
      // },
      submitAudit() {
        const paramPresences = { }
        this.presences.map(x => {
          paramPresences[`${x}`] = true
        })
        this.attendees.map(x => x.id).filter(x => !this.presences.includes(x)).map(x => {
          paramPresences[`${x}`] = false
        })
        console.log(`submitAudit course_event ${this.course_event_id}`, paramPresences)
        this.$store
            .dispatch(`course_event/updatePresences`, {
                  course_event_id: this.course_event_id,
                  params: {presences: paramPresences}
                }
            )
            .then( _ => {
              console.log(`submitAudit OK`)
              this.presences_before_changes = this.presences
            })
            .catch(error => {
              // const myObject = error && error.body ? error.body : error
              const message = error && error.body ? (error.body.errors && error.body.errors.course_event_id ? error.body.errors.course_event_id.join(', ') : error.body.error || error.body) : error
              // const message = Object.keys(myObject).map( (key, index) => myObject[key]).join(', ')

              this.$store.dispatch('layout/replaceAlert', {
                type: 'error',
                message: message
              })
              console.log(`Cannot submitAudit`, error)
            })
      },
    },
  }
</script>

<style lang="scss" scoped>
.attendee-element {
  margin-right: 2em;
}
</style>
