
export const courseEventMixin = {
  computed: {
    course() {
      return this.course_event.course
    },
    room() {
      return this.course_event.room
    },
    trainer() {
      return this.course_event.trainer
    },
    support_email() {
      return ''
    },
  },
}
