
export const currentUserMixin = {
  computed: {
    currentUserByAdmin() {
      return !!this.currentUser && this.currentUser.origin == 'ADMIN'
    },
    isCurrentUserLegalPerson() {
      return !!this.currentUser && this.currentUser.customer_type == 'LEGAL_PERSON'
    },
    isCurrentUserCompleted() {
      return !!this.currentUser && !!this.currentUser.phone_prefix && !!this.currentUser.phone && !!this.currentUser.language
    },
    isCurrentUserForeign() {
      return !!this.currentUser && !!this.currentUser.citizenship_id && this.currentUser.citizenship_id != 119
    },
  },
}
