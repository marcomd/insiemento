export const accountDataMixin = {
  computed: {
    isItaly() {
      return this.country_id == 119
    },
    customerTypeErrors() {
      const errors = []
      if (!this.$v.customer_type || !this.$v.customer_type.$dirty) return errors
      !!this.serverSideErrors.customer_type && errors.push(this.show_error_form_field(this.serverSideErrors.customer_type))
      !this.$v.customer_type.required && errors.push(this.$t('errors.required'))
      return errors
    },
    accountTypeErrors() {
      const errors = []
      if (!this.$v.account_type || !this.$v.account_type.$dirty) return errors
      !!this.serverSideErrors.account_type && errors.push(this.show_error_form_field(this.serverSideErrors.account_type))
      !this.$v.account_type.required && errors.push(this.$t('errors.required'))
      return errors
    },
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
    businessNameErrors() {
      const errors = []
      if (!this.$v.business_name || !this.$v.business_name.$dirty) return errors
      !!this.serverSideErrors.business_name && errors.push(this.show_error_form_field(this.serverSideErrors.business_name))
      !this.$v.business_name.required && errors.push(this.$t('errors.required'))
      return errors
    },
    sexErrors() {
      const errors = []
      if (!this.$v.sex || !this.$v.sex.$dirty) return errors
      !!this.serverSideErrors.sex && errors.push(this.show_error_form_field(this.serverSideErrors.sex))
      !this.$v.sex.required && errors.push(this.$t('errors.required'))
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
    // pecErrors() {
    //   const errors = []
    //   if (!this.$v.pec.$dirty) return errors
    //   !!this.serverSideErrors.pec && errors.push(this.show_error_form_field(this.serverSideErrors.pec))
    //   !this.$v.pec.email && errors.push(this.$t('errors.email_invalid_format'))
    //   !this.$v.pec.required && errors.push(this.$t('errors.email_required'))
    //   return errors
    // },
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
    documentNumberErrors() {
      const errors = []
      if (!this.$v.document_number || !this.$v.document_number.$dirty) return errors
      !!this.serverSideErrors.document_number && errors.push(this.show_error_form_field(this.serverSideErrors.document_number))
      !this.$v.document_number.required && errors.push(this.$t('errors.required'))
      return errors
    },
    fiscalCodeErrors() {
      const errors = []
      if (!this.$v.fiscal_code || !this.$v.fiscal_code.$dirty) return errors
      !!this.serverSideErrors.fiscal_code && errors.push(this.show_error_form_field(this.serverSideErrors.fiscal_code))
      !this.$v.fiscal_code.required && errors.push(this.$t('errors.required'))
      !this.$v.fiscal_code.fiscalCodeValidator && errors.push(this.$t('errors.fiscal_code_not_valid'))
      return errors
    },
    vatNumberErrors() {
      const errors = []
      if (!this.$v.vat_number || !this.$v.vat_number.$dirty) return errors
      !!this.serverSideErrors.vat_number && errors.push(this.show_error_form_field(this.serverSideErrors.vat_number))
      !this.$v.vat_number.required && errors.push(this.$t('errors.required'))
      !this.$v.vat_number.vatNumberValidator && errors.push(this.$t('errors.vat_number_not_valid'))
      return errors
    },
    companyNameErrors() {
      const errors = []
      if (!this.$v.company_name || !this.$v.company_name.$dirty) return errors
      !!this.serverSideErrors.company_name && errors.push(this.show_error_form_field(this.serverSideErrors.company_name))
      !this.$v.company_name.required && errors.push(this.$t('errors.required'))
      return errors
    },
    addressErrors() {
      const errors = []
      if (!this.$v.address || !this.$v.address.$dirty) return errors
      !!this.serverSideErrors.address && errors.push(this.show_error_form_field(this.serverSideErrors.address))
      !this.$v.address.required && errors.push(this.$t('errors.required'))
      return errors
    },
    countryIdErrors() {
      const errors = []
      if (!this.$v.country_id || !this.$v.country_id.$dirty) return errors
      !!this.serverSideErrors.country_id && errors.push(this.show_error_form_field(this.serverSideErrors.country_id))
      !this.$v.country_id.required && errors.push(this.$t('errors.required'))
      return errors
    },
    cityNameErrors() {
      const errors = []
      if (!this.$v.city_name || !this.$v.city_name.$dirty) return errors
      !!this.serverSideErrors.city_name && errors.push(this.show_error_form_field(this.serverSideErrors.city_name))
      !this.$v.city_name.required && errors.push(this.$t('errors.required'))
      return errors
    },
    cityIdErrors() {
      const errors = []
      if (!this.$v.city_id || !this.$v.city_id.$dirty) return errors
      !!this.serverSideErrors.city_id && errors.push(this.show_error_form_field(this.serverSideErrors.city_id))
      !this.$v.city_id.required && errors.push(this.$t('errors.required'))
      return errors
    },
    provinceErrors() {
      const errors = []
      if (!this.$v.province || !this.$v.province.$dirty) return errors
      !!this.serverSideErrors.province && errors.push(this.show_error_form_field(this.serverSideErrors.province))
      !this.$v.province.required && errors.push(this.$t('errors.required'))
      return errors
    },
    codiceDestinatarioSdiErrors() {
      const errors = []
      if (!this.$v.codice_destinatario_sdi || !this.$v.codice_destinatario_sdi.$dirty) return errors
      !!this.serverSideErrors.codice_destinatario_sdi && errors.push(this.show_error_form_field(this.serverSideErrors.codice_destinatario_sdi))
      !this.$v.codice_destinatario_sdi.required && errors.push(this.$t('errors.required'))
      !this.$v.codice_destinatario_sdi.codiceDestinatarioSdiValidator && errors.push(this.$t('errors.codice_destinatario_sdi_not_valid'))
      return errors
    },
    languageErrors() {
      const errors = []
      if (!this.$v.language || !this.$v.language.$dirty) return errors
      !!this.serverSideErrors.language && errors.push(this.show_error_form_field(this.serverSideErrors.language))
      !this.$v.language.required && errors.push(this.$t('errors.required'))
      return errors
    },
    phonePrefixErrors() {
      const errors = []
      !!this.serverSideErrors.phone_prefix && errors.push(this.show_error_form_field(this.serverSideErrors.phone_prefix))
      !this.$v.phone_prefix.required && errors.push(this.$t('errors.required'))
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
