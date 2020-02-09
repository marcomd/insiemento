export const accountDataMixin = {
  computed: {
    firstNameErrors() {
      const errors = []
      if (!this.$v.first_name || !this.$v.first_name.$dirty) return errors
      !!this.serverSideErrors.first_name && errors.push(this.show_error_form_field(this.serverSideErrors.first_name))
      !this.$v.first_name.required && errors.push(this.$t('errors.required'))
      return errors
    },
    lastNameErrors() {
      const errors = []
      if (!this.$v.last_name || !this.$v.last_name.$dirty) return errors
      !!this.serverSideErrors.last_name && errors.push(this.show_error_form_field(this.serverSideErrors.last_name))
      !this.$v.last_name.required && errors.push(this.$t('errors.required'))
      return errors
    },
    genderErrors() {
      const errors = []
      if (!this.$v.gender || !this.$v.gender.$dirty) return errors
      !!this.serverSideErrors.gender && errors.push(this.show_error_form_field(this.serverSideErrors.gender))
      !this.$v.gender.required && errors.push(this.$t('errors.required'))
      return errors
    },
    emailErrors() {
      const errors = []
      if (!this.$v.email || !this.$v.email.$dirty) return errors
      !this.$v.email.email && errors.push(this.$t('errors.email_invalid_format'))
      !this.$v.email.required && errors.push(this.$t('errors.email_required'))
      !!this.serverSideErrors.email && errors.push(this.show_error_form_field(this.serverSideErrors.email))
      return errors
    },
    emailConfirmationErrors() {
      const errors = []
      if (!this.$v.email_confirmation || !this.$v.email_confirmation.$dirty) return errors
      !this.$v.email_confirmation.email && errors.push(this.$t('errors.email_invalid_format'))
      !this.$v.email_confirmation.sameAsEmail && errors.push(this.$t('errors.email_confirmation_not_equal'))
      !!this.serverSideErrors.email_confirmation && errors.push(this.show_error_form_field(this.serverSideErrors.email_confirmation))
      return errors
    },
    passwordErrors() {
      const errors = []
      if (!this.$v.password.$dirty) return errors
      !!this.serverSideErrors.password && errors.push(this.show_error_form_field(this.serverSideErrors.password))
      !this.$v.password.required && errors.push(this.$t('errors.password_required'))
      !this.$v.password.minLength && errors.push(this.$t('errors.password_too_short'))
      return errors
    },
    passwordConfirmationErrors() {
      const errors = []
      if (!this.$v.password_confirmation.$dirty) return errors
      !this.$v.password_confirmation.sameAsPassword && errors.push(this.$t('errors.password_confirmation_not_equal'))
      return errors
    },
    phoneErrors() {
      const errors = []
      !!this.serverSideErrors.phone && errors.push(this.show_error_form_field(this.serverSideErrors.phone))
      !this.$v.phone.required && errors.push(this.$t('errors.required'))
      return errors
    },
    birthdateErrors() {
      const errors = []
      if (!this.$v.birthdate || !this.$v.birthdate.$dirty) return errors
      !!this.serverSideErrors.birthdate && errors.push(this.show_error_form_field(this.serverSideErrors.birthdate))
      !this.$v.birthdate.required && errors.push(this.$t('errors.required'))
      return errors
    },
  },
}
