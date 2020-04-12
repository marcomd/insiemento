<template>
  <transition name='slide-fade'>
    <v-container v-if='showAlert'>
      <v-row align='center' justify='center'>
        <v-col cols='12' xs='12' md='10' lg='8'>
          <v-alert
            v-for="(groupedAlertType, aIndex) in groupedAlertTypes"
            :key='aIndex'
            :type='groupedAlertType.type'
            colored-border
            border='bottom'
            elevation='6'
            dismissible
            @input="removeAlert(groupedAlertType.alertIds)"
          >
            <ul class='alert-messages'>
              <li v-for="(message, mIndex) in alertText(groupedAlertType.type)" :key='mIndex'>
                {{ message }}
              </li>
            </ul>
          </v-alert>
        </v-col>
      </v-row>
    </v-container>
  </transition>
</template>

<script>
  import { mapState } from 'vuex'
  import { utilityMixin } from '../../mixins/utility_mixin'

  export default {
    mixins: [ utilityMixin ],
    computed: {
      ...mapState('layout', [
        'alerts'
      ]),
      showAlert() {
        return this.alerts.length > 0
      },
      groupedAlertTypes() {
        let alertTypes = []
        this.alerts.forEach((alert) => {
          let typeAlreadyAdded = alertTypes.find((alertType) => {
            return alertType.type === alert.type
          })
          if (typeAlreadyAdded) {
            typeAlreadyAdded.alertIds.push(alert.id)
          } else {
            alertTypes.push({
              type: alert.type,
              alertIds: [alert.id]
            })
          }
        })
        return alertTypes
      }
    },
    methods: {
      alertText(alertType) {
        const messages = []

        this.alerts.forEach(alert => {
          if (alert.type !== alertType) return
          const resource = alert.resource || 'alerts'

          if (!!alert.key) {
            messages.push(this.$t(`${resource}.${alert.key}`, alert.i18n_attributes))
          } else if (!!alert.fields) {
            // Example:
            //    field         errors
            //                   error key:  error label
            // { "city_name": [ { "error": "blank" } ] }
            // { "account_type": [ { "error": "inclusion", "value": "natural" } ] }
            for(const [field, errors] of Object.entries(alert.fields)) {
              for(const [i, error] of Object.entries(errors)) {
                let message = ''
                if (error.error) {
                  // Server returns labels...
                  switch (error.error) {
                    // Add here only exceptional errors which need a particular management
                    case 'inclusion':
                      message = `${this.$t(`${resource}.attributes.${field}`)} ${this.$t(`errors.${error.error}`, {value: error.value})}`
                      break
                    default:
                      message = `${this.$t(`${resource}.attributes.${field}`)} ${this.$t(`errors.${error.error}`)}`
                  }
                } else {
                  // Server returns the localized description
                  message = `${this.$t(`${resource}.attributes.${field}`)} ${error}`
                }
                messages.push(message)
              }
            }
          } else if (!!alert.keys) {
            // "create": [ "invoice_account_already_exists" ]
            alert.keys.forEach(label => messages.push(this.$t(`${resource}.${label}`)))
          } else {
            messages.push(alert.message)
          }
        })

        return messages
      },
      removeAlert(alertIds) {
        alertIds.forEach(id => this.$store.dispatch('layout/removeAlert', id))
      }
    }
  }
</script>

<style lang='scss' scoped>
  .close-icon {
    position: absolute;
    top: 12px;
    right: 13px;
  }

  .slide-fade-enter {
    transform: translateY(-15px);
    opacity: 0;
  }
  .slide-fade-enter-active,
  .slide-fade-leave-active {
    transition: all 0.2s ease;
  }
  .slide-fade-leave-to {
    transform: translateY(-15px);
    opacity: 0;
  }

  ul.alert-messages {
    margin-bottom: 5px;
    padding-right: 35px;
    font-size: 15px;
    list-style-type: none;
  }
</style>
