import stringSimilarity from 'string-similarity'
import moment from "moment";

export const courseEventMixin = {
  computed: {
    course() {
      return this.course_event && this.course_event.course
    },
    room() {
      return this.course_event && this.course_event.room
    },
    trainer() {
      return this.course_event && this.course_event.trainer
    },
    trainer_name() {
      if (!this.trainer) return
      return `${this.trainer.firstname} ${this.trainer.lastname}`
      // if (this.trainer.nickname && this.trainer.nickname.length > 0) {
      //   return `${this.trainer.firstname} ${this.trainer.lastname} aka ${this.trainer.nickname}`
      // } else {
      //   return `${this.trainer.firstname} ${this.trainer.lastname}`
      // }
    },
    courseImageName() {
      const planned_courses = ['zumba', 'yoga', 'pilates', 'total_body', 'pole_dance', 'gag',
        'kangoo_jumps', 'street', 'dancehall', 'brasilian_fitness', 'funzionale']
      const course_name_lowered = this.course.name.toLowerCase().replace(/\./g, '').replace(/\s/g, '_')
      const matches = stringSimilarity.findBestMatch(course_name_lowered, planned_courses)
      // console.log(`Searching ${course_name_lowered}... `, matches)
      const planned_course = matches ? planned_courses[matches.bestMatchIndex] : planned_courses[0]
      return `course_${planned_course}_600.jpg`
    },
    isCourseEventFull() {
      if (!this.room) return
      return this.course_event && this.course_event.attendees_count >= this.room.max_attendees
    },
    cancelBookingUntil() {
      return this.subtractFromDate(this.course_event.event_date, { quantity: this.course.end_booking_minutes, period: "minutes" })
    },
    isCourseEventUncancelable() {
      const result = moment().diff(this.cancelBookingUntil, 'minutes')
      //console.log('isCourseEventCancelable', result)
      return result > 0
    },
  },
}
