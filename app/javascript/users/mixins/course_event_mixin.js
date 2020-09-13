
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
        'kangoo_jumps', 'street', 'lab', 'brazilian_fitness', 'funzionale']
      const course_name_lowered = this.course.name.toLowerCase().replace(/\./g, '').replace(/\s/g, '_')
      return `course_${planned_courses.includes(course_name_lowered) ? course_name_lowered : planned_courses[0]}_600.jpg`
    },
    isCourseEventFull() {
      if (!this.room) return
      return this.course_event && this.course_event.attendees_count >= this.room.max_attendees
    },
  },
}
