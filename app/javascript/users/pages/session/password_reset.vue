<template>
  <v-container>
    <v-row align='center' justify='center'>
      <v-col cols='12' sm='8' md='6' lg='4'>
        <v-card elevation='6'>
          <v-toolbar flat>
            <v-toolbar-title>
              {{ $t('session.password_reset_title') }}
            </v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <p>
              {{ $t('session.password_reset_hint') }}
            </p>
            <v-form id='password-reset-form' @submit.prevent='passwordReset'>
              <v-text-field required
                v-model='email'
                :label='$t("session.attributes.email")'
                prepend-icon='mdi-at'
                :error-messages='emailErrors'
                @input='touchEmail()'
                @blur='touchEmail()'
              />
            </v-form>
          </v-card-text>
          <v-card-actions>
            <v-btn large
              class='ml-2 mb-2'
              :to='{name: "login"}'
            >
              {{ $t('commons.cancel') }}
            </v-btn>
            <div class='flex-grow-1'/>
            <v-btn large
              type='submit'
              form='password-reset-form'
              color='primary'
              :disabled='v$.$invalid'
              :loading='submitting'
              class='mr-2 mb-2'
            >
              {{ $t('session.password_reset_action') }}
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  // import { validationMixin } from 'vuelidate'
  // import { required, email } from 'vuelidate/lib/validators'
  import { useVuelidate } from '@vuelidate/core'
  import { required, email } from '@vuelidate/validators'

  import { mapState } from 'vuex'

  export default {
    setup () {
      return { v$: useVuelidate() }
    },

    validations() {
      return {
        email: { required, email },
      }
    },

    data() {
      return {
        email: '',
        serverSideErrors: {}
      }
    },

    computed: {
      ...mapState('layout', {
        submitting: 'submitting'
      }),
      emailErrors() {
        const errors = []
        if (!this.v$.email.$dirty) return errors
        !!this.serverSideErrors.email && errors.push(this.serverSideErrors.email.join(' - '))
        !this.v$.email.email && errors.push(this.$t('errors.email_invalid_format'))
        !this.v$.email.required && errors.push(this.$t('errors.email_required'))
        return errors
      }
    },

    methods: {
      touchEmail: function() {
        this.v$.email.$touch()
        this.serverSideErrors.email = null
      },
      passwordReset: function() {
        this.v$.$touch()
        if (this.v$.$invalid) return

        this.$store.dispatch('session/passwordReset', this.email)
        //  Redirect spostata nell'action
        // .then(() => {
        //   this.$router.push({ name: 'login' })
        // })
        .catch(err => {
          this.serverSideErrors = err?.data ? err.data.errors : {}
        })
      }
    },

    created() {
      if (this.$route.query.error === 'invalid_token') {
        this.$store.dispatch('layout/addAlert', {
          type: 'error',
          key: 'invalid_token'
        })
      }
    }
  }
</script>
