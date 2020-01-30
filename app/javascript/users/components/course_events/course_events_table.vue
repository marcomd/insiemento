<template>
    <v-row>
        <v-col>
            <h3 class="d-flex justify-center subtitle">{{ $t('course_event.list.select_label') }}:</h3><br>
            <v-data-table
                    :headers="headers"
                    :items="course_events"
                    :items-per-page="5"
                    class="elevation-1"
                    @click:row="selectRow"
                    :multi-sort="true"
            >
                <template v-slot:item.event_date="{ item }">
                    {{ formattedDateTime(item.event_date, 'dddd D MMMM H:mm') }}
                </template>
                <template v-slot:item.subscribed="{ item }">
                    <v-chip :color="item.subscribed ? 'green' : '#cccccc'" dark>{{ item.subscribed ? $t('commons.say_yes') : $t('commons.say_no') }}</v-chip>
                </template>
            </v-data-table>
        </v-col>
    </v-row>
</template>

<script>
    import { utilityMixin } from '../../mixins/utility_mixin'
    import { courseEventMixin } from "../../mixins/course_event_mixin"

    export default {
    name: 'CourseEventsTable',
    props: {
      course_events: {
        type: Array,
        required: true
      }
    },
    mixins: [
      utilityMixin,
      courseEventMixin,
    ],
    data() {
      return {
        headers: [
          { text: 'ID', value: 'id' },
          { text: this.$t('course_event.attributes.course'), value: 'course.name' },
          { text: this.$t('course_event.attributes.room'), value: 'room.name' },
          { text: this.$t('course_event.attributes.trainer'), value: 'trainer.nickname' },
          { text: this.$t('course_event.attributes.event_date'), value: 'event_date' },
          { text: this.$t('course_event.attributes.subscribed'), value: 'subscribed' },
        ]
      }
    },
    methods: {
      selectRow(course_event) {
        this.$emit('select-course_event', {
          // id: course_event.id,
          // course: course_event.course,
          // room: course_event.room,
          // trainer: course_event.trainer,
          // event_date: course_event.event_date,
          course_event: course_event
        })
      }
    }
  }
</script>

<style lang="scss" scoped></style>