
export const currentUserMixin = {
  computed: {
    isCurrentUserCompleted() {
      return !!this.currentUser && !!this.currentUser.phone && !!this.currentUser.birthdate
    },
  },
}
