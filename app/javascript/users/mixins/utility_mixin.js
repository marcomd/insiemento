import moment from 'moment'

export const utilityMixin = {
  methods: {
    formattedDate(date) {
      return !!date ? moment(date, 'YYYY-MM-DD').format('L') : null
    },
    formattedTime(time, outFormat='HH:mm') {
      return !!time ? moment(time).format(outFormat) : ''
    },
    formattedDateTime(datetime, outFormat='LLLL') {
      return !!datetime ? moment(datetime).format(outFormat) : null
    },
    // Used to show translated error below the form's field
    show_error_form_field(errors) {
      //return errors.map(error => this.isObject(error) ? this.$t(`errors.${error.error}`) : this.$t(`errors.${error}`) ).join(' - ')
      return errors.map(error => this.isObject(error) ? error.error : error ).join(' - ')
    },
    notEmptyObject(someObject) {
      return Object.keys(someObject).length === 0
    },
    isString(value) {
      return typeof value === 'string' || value instanceof String
    },
    isSymbol(value) {
      return typeof value === 'symbol'
    },
    isArray(value) {
      return value && typeof value === 'object' && value.constructor === Array
    },
    isFunction(value) {
      return typeof value === 'function'
    },
    isObject(value) {
      return value && typeof value === 'object' && value.constructor === Object
    },
    isNull(value) {
      return value === null
    },
    isUndefined(value) {
      return typeof value === 'undefined'
    },
    isDate(value) {
      return value instanceof Date
    },
    labelsPrefix() {
      return 'commons.labels' // override in component if needed
    },
    labelFor(field) {
      return this.$t(this.labelsPrefix() + '.' + field)
    },
    requiredIcon(field, forceRequired) {
      if (forceRequired ||
        // Se presente il campo in vuelidate, possono esistere diversi oggetti in percorsi diversi e la scelta di quello
        // corretto purtroppo complica il codice che segue...
        (!!this.$v && !!this.$v[field] && (!!this.$v[field].$params.required &&
          (this.$v[field].$params.required.type == 'required' ||
            (this.$v[field].$params.required.type == 'requiredIf' && this.$v[field].$params.required.prop() ))))) {
        return 'mdi-asterisk'
      }
    }
  }
}
