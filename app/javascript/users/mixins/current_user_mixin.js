
export const currentUserMixin = {
  computed: {
    isCurrentUserCompleted() {
      return !!this.currentUser && !!this.currentUser.phone_prefix && !!this.currentUser.phone
    },
  },
}
