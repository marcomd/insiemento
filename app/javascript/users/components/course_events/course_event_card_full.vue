<template>
  <v-card
    elevation='1'>
    <v-card-title>{{ $t('course_event.attributes.course') }}</v-card-title>

    <v-card-text>
      <v-row>
        <v-icon large>mdi-calendar</v-icon>
        <v-col>
          {{ $t('course_event.attributes.event_date') }}<br>
          <strong>{{ formattedDateTime(course_event.event_date) }}</strong>
        </v-col>

        <v-icon large>mdi-yoga</v-icon>
        <v-col>
          {{ $t('course_event.attributes.course') }}<br>
          <strong>{{ course.name }}</strong>
        </v-col>
      </v-row>

      <v-row>
        <v-icon large>mdi-google-classroom</v-icon>
        <v-col>
          {{ $t('course_event.attributes.room') }}<br>
          <v-tooltip top>
            <template v-slot:activator="{ on, attrs }">
              <v-icon small
                      v-bind="attrs"
                      v-on="on">mdi-information-outline</v-icon>
              <strong>{{ room.name }}</strong>
            </template>
            {{ room.description || '🙂' }}
          </v-tooltip>
        </v-col>
        <v-icon large>mdi-teach</v-icon>
        <v-col>
          {{ $t('course_event.attributes.trainer') }}<br>
          <v-tooltip top>
            <template v-slot:activator="{ on, attrs }">
               <v-icon small
                       v-bind="attrs"
                       v-on="on">mdi-information-outline</v-icon>
              <strong>{{ trainer_name || '🙂' }}</strong>
            </template>
            {{ trainer.bio }}
          </v-tooltip>
        </v-col>
      </v-row>

      <v-row>
        <v-icon large>mdi-account-multiple</v-icon>
        <v-col>
          {{ $t('course_event.attributes.attendees_count') }}<br>
          <span :class="isCourseEventFull ? 'red--text' : ''"><strong>{{ course_event.attendees_count }}</strong> / <strong>{{ room.max_attendees }}</strong></span>
        </v-col>
        <v-icon large>mdi-human-greeting</v-icon>
        <v-col v-if="course_event.subscribed">
          {{ $t('course_event.attributes.subscribed') }}<br>
          <v-icon color="success">mdi-check-bold</v-icon>
        </v-col>
        <v-col v-else>

        </v-col>
      </v-row>
    </v-card-text>

    <v-divider class="mx-4"></v-divider>

    <v-card-text>
      {{ course.description || '🙂' }}
    </v-card-text>
  </v-card>
</template>

<script>
  import { utilityMixin } from '../../mixins/utility_mixin'
  import { courseEventMixin } from '../../mixins/course_event_mixin'


  export default {
    components: {
    },
    mixins: [ utilityMixin, courseEventMixin ],
    props: {
      course_event: {
        type: Object,
        required: true
      }
    },
    computed: {
    }
  }
</script>

<style lang="scss" scoped>

</style>
