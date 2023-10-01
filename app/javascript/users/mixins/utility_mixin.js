import moment from 'moment'

export const utilityMixin = {
  computed: {
    tomorrowDate() {
      return moment().add(1,'days')
    },
    todayTimestamp() {
      return moment().unix()
    },
  },
  methods: {
    // formattedDateToISO(date, outFormat='YYYY-MM-DD') {
    //   return !!date ? moment(date, outFormat) : null
    // },
    formattedDate(date) {
      return !!date ? moment(date, 'YYYY-MM-DD').format('L') : null
    },
    formattedTime(time, outFormat='HH:mm') {
      return !!time ? moment(time).format(outFormat) : ''
    },
    formattedDateTime(datetime, outFormat='LLLL') {
      return !!datetime ? moment(datetime).format(outFormat) : null
    },
    calculateAge(datetime) {
      return moment().diff(datetime, 'years')
    },
    subtractFromDate(inDate, { quantity=1, period='days' }={}) {
      const date = inDate ? moment(inDate) : moment()
      return date.subtract(quantity, period)
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
    // Params:
    // validation_field: pass the key used in vuelidate if it does not match with the label (ex: user vs user_id)
    // required: if true and the field is required, a * after the label is appended
    // optional: if true and the field is not required, a [optional] after the label is appended (the tag is localized)
    labelFor(field, {validation_field=field, required=false, optional=false} = {}) {
      let label = this.$t(this.labelsPrefix() + '.' + field)
      if (this.isRequired(validation_field)) {
        if (required) label += ' *'
      } else {
        if (optional) label += ` [${this.$t('commons.optional')}]`
      }
      return label
    },
    isRequired(field) {
      // If the field in vuelidate is present, different objects may exist in different paths and
      // the choice of the correct one unfortunately complicates the following code ...
      // console.log(field, this.v$[field])
      if (!!this.v$ && !!this.v$[field] && (!!this.v$[field].required &&
        (this.v$[field].required.$params.type == 'required' ||
          (this.v$[field].required.$params.type == 'requiredIf' && this.v$[field].required.$params.prop() )))) {
        return true
      } else {
        return false
      }
    },
  }
}
