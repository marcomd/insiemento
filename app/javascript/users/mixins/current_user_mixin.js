
export const currentUserMixin = {
  computed: {
    isCurrentUserCompleted() {
      return !!this.currentUser && !!this.currentUser.phone && !!this.currentUser.birthdate
    },
    isChildAccount() {
      return !!this.currentUser && !!this.currentUser.child_lastname && this.currentUser.child_lastname.length > 0
    }
  },
}
