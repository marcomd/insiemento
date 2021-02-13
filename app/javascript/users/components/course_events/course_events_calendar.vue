<template>
  <v-row class="fill-height">
    <v-col>
      <v-sheet height="64">
        <v-toolbar flat color="white">
          <v-btn outlined class="mr-4" color="grey darken-2" @click="setToday">
            {{ $t('calendar.today') }}
          </v-btn>
          <v-btn fab text small color="grey darken-2" @click="prev">
            <v-icon small>mdi-chevron-left</v-icon>
          </v-btn>
          <v-btn fab text small color="grey darken-2" @click="next">
            <v-icon small>mdi-chevron-right</v-icon>
          </v-btn>
          <v-toolbar-title>{{ title }}</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-menu bottom right>
            <template v-slot:activator="{ on }">
              <v-btn
                      outlined
                      color="grey darken-2"
                      v-on="on"
              >
                <span>{{ typeToLabel[type] }}</span>
                <v-icon right>mdi-menu-down</v-icon>
              </v-btn>
            </template>
            <v-list>
              <v-list-item @click="type = 'day'">
                <v-list-item-title>{{ $t('calendar.day') }}</v-list-item-title>
              </v-list-item>
              <v-list-item @click="type = 'week'">
                <v-list-item-title>{{ $t('calendar.week') }}</v-list-item-title>
              </v-list-item>
              <v-list-item @click="type = 'month'">
                <v-list-item-title>{{ $t('calendar.month') }}</v-list-item-title>
              </v-list-item>
              <v-list-item @click="type = '4day'">
                <v-list-item-title>{{ $t('calendar.four_days') }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </v-toolbar>
      </v-sheet>
      <v-sheet height="600">
        <v-calendar
                ref="calendar"
                v-model="focus"
                color="primary"
                :weekdays="[1, 2, 3, 4, 5, 6, 0]"
                :locale='$i18n.locale'
                :events="events"
                :event-color="getEventColor"
                :now="today"
                :type="type"
                @click:event="showEvent"
                @click:more="viewDay"
                @click:date="viewDay"
                @change="updateRange"
        ></v-calendar>
        <v-menu
                v-model="selectedOpen"
                :close-on-content-click="false"
                :activator="selectedElement"
                offset-x
        >
          <v-card
                  color="grey lighten-4"
                  min-width="350px"
                  flat
          >
            <v-toolbar
                    :color="selectedEvent.color"
                    dark
            >
              <v-toolbar-title v-html="selectedEvent.name"></v-toolbar-title>
              <v-spacer></v-spacer>
              <v-btn icon @click="selectedOpen = false">
                <v-icon>mdi-window-close</v-icon>
              </v-btn>
            </v-toolbar>
            <v-card-text>
              <CourseEventCardLite :course_event="selectedEvent.object"></CourseEventCardLite>
            </v-card-text>
            <!--v-card-actions>
              <v-btn
                      text
                      color="secondary"
                      @click="selectedOpen = false"
              >
                {{ $t('commons.close') }}
              </v-btn>
            </v-card-actions-->
          </v-card>
        </v-menu>
      </v-sheet>
    </v-col>
  </v-row>
</template>

<script>
  import dayjs from 'dayjs'
  // import { utilityMixin } from '../../mixins/utility_mixin'
  import CourseEventCardLite from './course_event_card_lite'

  export default {
    props: {
      course_events: {
        type: Array,
        required: true
      }
    },
    components: {
      CourseEventCardLite,
    },
    data: () => ({
      focus: '',
      type: 'month',
      start: null,
      end: null,
      selectedEvent: {},
      selectedElement: null,
      selectedOpen: false,
      events: [],
      courses: [],
      // names: ['Zumba', 'Pilates', 'Yoga', 'AquaGym', 'Spa'],
    }),
    computed: {
      title () {
        const { start, end } = this
        if (!start || !end) {
          return ''
        }

        const startMonth = this.monthFormatter(start)
        const endMonth = this.monthFormatter(end)
        const suffixMonth = startMonth === endMonth ? '' : endMonth

        const startYear = start.year
        const endYear = end.year
        const suffixYear = startYear === endYear ? '' : endYear

        const startDay = start.day + this.nth(start.day)
        const endDay = end.day + this.nth(end.day)

        switch (this.type) {
          case 'month':
            return `${startMonth} ${startYear}`
          case 'week':
          case '4day':
            return `${startMonth} ${startDay} ${startYear} - ${suffixMonth} ${endDay} ${suffixYear}`
          case 'day':
            return `${startMonth} ${startDay} ${startYear}`
        }
        return ''
      },
      monthFormatter () {
        return this.$refs.calendar.getFormatter({
          timeZone: 'UTC', month: 'long',
        })
      },
      today() {
        return dayjs().format("YYYY-MM-DD")
      },
      typeToLabel() {
        return {
          month: this.$t('calendar.month'),
          week: this.$t('calendar.week'),
          day: this.$t('calendar.day'),
          '4day': this.$t('calendar.four_days'),
        }
      },
      colors() {
        return ['primary', 'secondary', 'primary darken-2', 'secondary darken-2', 'indigo', 'gray']
      }
    },
    mounted () {
      this.$refs.calendar.checkChange()
    },
    methods: {
      viewDay ({ date }) {
        this.focus = date
        this.type = 'day'
      },
      getEventColor (event) {
        return event.color
      },
      setToday () {
        this.focus = this.today
      },
      prev () {
        this.$refs.calendar.prev()
      },
      next () {
        this.$refs.calendar.next()
      },
      showEvent ({ nativeEvent, event }) {
        const open = () => {
          this.selectedEvent = event
          this.selectedElement = nativeEvent.target
          setTimeout(() => this.selectedOpen = true, 10)
        }

        if (this.selectedOpen) {
          this.selectedOpen = false
          setTimeout(open, 10)
        } else {
          open()
        }

        nativeEvent.stopPropagation()
      },
      updateRange ({ start, end }) {
        const events = []

        const min = new Date(`${start.date}T00:00:00`)
        const max = new Date(`${end.date}T23:59:59`)

        // Random data
        // const days = (max.getTime() - min.getTime()) / 86400000
        // const eventCount = this.rnd(days, days + 20)
        // for (let i = 0; i < eventCount; i++) {
        //   const allDay = this.rnd(0, 3) === 0
        //   const firstTimestamp = this.rnd(min.getTime(), max.getTime())
        //   const first = new Date(firstTimestamp - (firstTimestamp % 900000))
        //   const secondTimestamp = this.rnd(2, allDay ? 288 : 8) * 900000
        //   const second = new Date(first.getTime() + secondTimestamp)
        //
        //   events.push({
        //     name: this.names[this.rnd(0, this.names.length - 1)],
        //     start: this.formatDate(first, !allDay),
        //     end: this.formatDate(second, !allDay),
        //     color: this.colors[this.rnd(0, this.colors.length - 1)],
        //   })
        // }

        this.course_events.filter(ce => {
          const event_date = new Date(ce.event_date)
          return ce.subscribed && event_date >= min && event_date <= max
        }).forEach(ce => {
          const name = ce.course.name
          console.log(`updateRange Add event ${name} ${ce.event_date}`)
          const eventDateStart = new Date(ce.event_date)
          // const durationTimestamp = this.rnd(2, 8) * 900000
          const durationTimestamp =  3600000 // 4 * 900000 -> 1 = Quarter of hour * 4 * 900.000
          const eventDateEnd = new Date(eventDateStart.getTime() + durationTimestamp)
          events.push({
            name: name,
            start: this.formatDate(eventDateStart, true),
            end: this.formatDate(eventDateEnd, true),
            color: this.getCourseColor(name),
            object: ce,
          })
        })

        this.start = start
        this.end = end
        this.events = events
      },
      nth (d) {
        return d > 3 && d < 21
                ? 'th'
                : ['th', 'st', 'nd', 'rd', 'th', 'th', 'th', 'th', 'th', 'th'][d % 10]
      },
      // rnd (a, b) {
      //   return Math.floor((b - a + 1) * Math.random()) + a
      // },
      formatDate (a, withTime) {
        return withTime
                ? `${a.getFullYear()}-${a.getMonth() + 1}-${a.getDate()} ${a.getHours()}:${a.getMinutes()}`
                : `${a.getFullYear()}-${a.getMonth() + 1}-${a.getDate()}`
      },
      getCourseColor(name) {
        if (!this.courses.includes(name)) {
          this.courses.push(name)
        }
        const indexCourse = this.courses.findIndex(course => course == name)
        const indexColor = indexCourse > this.colors.length ? this.colors.length : indexCourse
        return this.colors[indexColor]
      },
    },
  }
</script>

<style lang="scss" scoped>

</style>
