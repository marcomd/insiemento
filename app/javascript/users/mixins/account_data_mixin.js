export const accountDataMixin = {
  computed: {
    firstNameErrors() {
      const errors = []
      if (!this.$v.firstname || !this.$v.firstname.$dirty) return errors
      !!this.serverSideErrors.firstname && errors.push(this.show_error_form_field(this.serverSideErrors.firstname))
      !this.$v.firstname.required && errors.push(this.$t('errors.required'))
      return errors
    },
    lastNameErrors() {
      const errors = []
      if (!this.$v.lastname || !this.$v.lastname.$dirty) return errors
      !!this.serverSideErrors.lastname && errors.push(this.show_error_form_field(this.serverSideErrors.lastname))
      !this.$v.lastname.required && errors.push(this.$t('errors.required'))
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
      !this.$v.email.email && this.email.includes(' ') && errors.push(this.$t('errors.email_invalid_format_spaces'))
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
      if (!this.$v.phone || !this.$v.phone.$dirty) return errors
      !!this.serverSideErrors.phone && errors.push(this.show_error_form_field(this.serverSideErrors.phone))
      !this.$v.phone.required && errors.push(this.$t('errors.required'))
      return errors
    },
    birthdateErrors() {
      const errors = []
      if (!this.$v.birthdate || !this.$v.birthdate.$dirty) return errors
      !!this.serverSideErrors.birthdate && errors.push(this.show_error_form_field(this.serverSideErrors.birthdate))
      !this.$v.birthdate.required && errors.push(this.$t('errors.required'))
      !this.$v.birthdate.ageValidator && errors.push(this.$t('errors.age_not_valid'))
      return errors
    },
    childFirstNameErrors() {
      const errors = []
      if (!this.$v.child_firstname || !this.$v.child_firstname.$dirty) return errors
      !!this.serverSideErrors.child_firstname && errors.push(this.show_error_form_field(this.serverSideErrors.child_firstname))
      !this.$v.child_firstname.required && errors.push(this.$t('errors.required'))
      return errors
    },
    childLastNameErrors() {
      const errors = []
      if (!this.$v.child_lastname || !this.$v.child_lastname.$dirty) return errors
      !!this.serverSideErrors.child_lastname && errors.push(this.show_error_form_field(this.serverSideErrors.child_lastname))
      !this.$v.child_lastname.required && errors.push(this.$t('errors.required'))
      return errors
    },
    childBirthdateErrors() {
      const errors = []
      if (!this.$v.child_birthdate || !this.$v.child_birthdate.$dirty) return errors
      !!this.serverSideErrors.child_birthdate && errors.push(this.show_error_form_field(this.serverSideErrors.child_birthdate))
      !this.$v.child_birthdate.required && errors.push(this.$t('errors.required'))
      !this.$v.child_birthdate.childAgeValidator && errors.push(this.$t('errors.child_age_not_valid'))
      return errors
    },
  },
}
