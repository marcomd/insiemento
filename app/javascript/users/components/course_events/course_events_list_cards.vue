<template>
  <v-container fluid>
    <h3 class="d-flex justify-center subtitle">{{ $t('course_event.list.subscribed_label') }}:</h3>
    <v-row>
      <v-col cols="12">
        <v-row align="center" justify="center">
          <CourseEventCardLite v-for="course_event in course_events" :key="course_event.id" :course_event="course_event" cssClassCard="mx-auto ma-6"/>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  // Components
  import CourseEventCardLite from './course_event_card_lite'

  export default {
    name: 'CourseEventsListCards',
    components: {
      CourseEventCardLite
    },
    props: {
      course_events: {
        type: Array,
        required: true
      }
    },
    data() {
      return {
      }
    },
    methods: {
    }
  }
</script>

<style lang="scss" scoped>

</style>
