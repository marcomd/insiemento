
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
    courseImageName() {
      const planned_courses = ['zumba', 'yoga']
      const course_name_lowered = this.course.name.toLowerCase()
      return `course_${planned_courses.includes(course_name_lowered) ? course_name_lowered : planned_courses[0]}_600.jpg`
    },
  },
}
