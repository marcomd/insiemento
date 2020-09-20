<template>
    <v-container fluid>
        <v-card>
            <v-card-title>
                <v-row>
                    <v-col cols="12" sm="12" md="4">
                        <v-select
                            v-model="search"
                            :items="courses"
                            :label="$t('course_event.list.select_label')"
                            hide-details
                            cache-items
                            clearable
                        ></v-select>
                    </v-col>
                    <v-col v-if="$vuetify.breakpoint.smAndUp">
                        <v-spacer></v-spacer>
                    </v-col>
                    <v-col cols="12" sm="12" md="4">
                        <v-text-field
                            v-model="search"
                            append-icon="mdi-magnify"
                            :label="$t('commons.search')"
                            hide-details
                            clearable
                        ></v-text-field>
                    </v-col>
                </v-row>
            </v-card-title>
            <v-data-table
                    :headers="headers"
                    :items="course_events"
                    :search="search"
                    :items-per-page="itemsPerPage"
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
                <template v-slot:item.full="{ item }">
                    <v-chip v-if="isFullThis(item)" color="orange" dark>{{ $t('course_event.list.full') }}</v-chip>
                    <v-chip v-if="isSuspendedThis(item)" color="red" dark>{{ $t('course_event.attributes.states.suspended') }}</v-chip>
                </template>
            </v-data-table>
        </v-card>
    </v-container>
</template>

<script>
    import { utilityMixin } from '../../mixins/utility_mixin'
    import { courseEventMixin } from "../../mixins/course_event_mixin"
    import { mapActions } from 'vuex'

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
    created() {
      this.search = this.$store.state.layout.search
    },
    data() {
      return {
        search: '',
        selectedCourse: null,
        headers: [
          // { text: 'ID', value: 'id' },
          { text: this.$t('course_event.attributes.course'), value: 'course.name' },
          { text: this.$t('course_event.attributes.event_date'), value: 'event_date' },
          { text: this.$t('course_event.attributes.subscribed'), value: 'subscribed' },
          { text: this.$t('course_event.attributes.trainer'), value: 'trainer.nickname' },
          { text: this.$t('course_event.attributes.room'), value: 'room.name' },
          { text: 'Info', value: 'full' },
        ]
      }
    },
    computed: {
      courses() {
        return Array.from(new Set(this.course_events.map(course_event => course_event.course.name)))
      },
      itemsPerPage() {
        return this.$vuetify.breakpoint.xsOnly ? 1 : (this.$vuetify.breakpoint.mdAndUp ? 15 : 5)
      },
    },
    methods: {
      ...mapActions('layout', ['setSearch']),
      selectRow(course_event) {
        this.$emit('select-course_event', {
          course_event: course_event
        })
      },
      isFullThis(course_event) {
        if (!course_event || !course_event.room) return null
        return course_event.attendees_count >= course_event.room.max_attendees
      },
      isSuspendedThis(course_event) {
          if (!course_event) return null
          return course_event.state == 'suspended'
      },
    },
    watch: {
      search(value) {
        // console.log('watch search', value)
        this.setSearch(value)
      },
    },
  }
</script>

<style lang="scss" scoped></style>