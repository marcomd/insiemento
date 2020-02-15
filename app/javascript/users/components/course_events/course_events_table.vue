<template>
    <v-container fluid>
        <v-card>
            <v-card-title>
                <v-select
                        v-model="search"
                        :items="courses"
                        :label="$t('course_event.list.select_label')"
                        hide-details
                        cache-items
                        clearable
                ></v-select>
                <v-spacer></v-spacer>
                <v-text-field
                        v-model="search"
                        append-icon="mdi-magnify"
                        :label="$t('commons.search')"
                        single-line
                        hide-details
                        clearable
                        v-if="$vuetify.breakpoint.smAndUp"
                ></v-text-field>
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
            </v-data-table>
        </v-card>
    </v-container>
</template>

<script>
    import { utilityMixin } from '../../mixins/utility_mixin'
    import { courseEventMixin } from "../../mixins/course_event_mixin"
    import { mapState, mapActions } from 'vuex'

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
        ]
      }
    },
    computed: {
      courses() {
        return Array.from(new Set(this.course_events.map(course_event => course_event.course.name)))
      },
      itemsPerPage() {
        return this.$vuetify.breakpoint.xsOnly ? 1 : (this.$vuetify.breakpoint.mdAndUp ? 15 : 5)
      }
    },
    methods: {
      ...mapActions('layout', ['setSearch']),
      selectRow(course_event) {
        this.$emit('select-course_event', {
          course_event: course_event
        })
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