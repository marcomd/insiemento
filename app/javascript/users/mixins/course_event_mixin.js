
export const courseEventMixin = {
  computed: {
    courseEvent() {
      return  null //this.$store.state.order.order || null
    },
    support_email() {
      return this.order && this.order.support_email
    },
  },
}
