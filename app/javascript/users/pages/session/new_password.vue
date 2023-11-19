<template>
  <v-container>
    <v-row align='center' justify='center'>
      <v-col cols='12' sm='8' md='6' lg='4'>
        <v-card elevation='6'>
          <v-toolbar flat>
            <v-toolbar-title>
              {{ $t('session.new_password_title') }}
            </v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <p>
              {{ $t('session.new_password_hint') }}
            </p>
            <v-form @submit.prevent='newPassword'>
              <v-text-field required
                            v-model='password'
                            prepend-icon='mdi-lock-question'
                            :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                            :label='$t("session.password_label")'
                            :type="showPassword ? 'text' : 'password'"
                            :hint='$t("session.sign_up.password_hint")'
                            counter
                            minlength='8'
                            :error-messages='passwordErrors'
                            @click:append="showPassword = !showPassword"
                            @input='touchPassword()'
                            @blur='touchPassword()'
              />
              <v-text-field required
                            v-model='passwordConfirmation'
                            prepend-icon='mdi-lock-question'
                            :append-icon="showPasswordConfirmation ? 'mdi-eye' : 'mdi-eye-off'"
                            :label='$t("session.password_confirmation_label")'
                            :type="showPasswordConfirmation ? 'text' : 'password'"
                            counter
                            :error-messages='passwordConfirmationErrors'
                            @click:append="showPasswordConfirmation = !showPasswordConfirmation"
                            @input='v$.passwordConfirmation.$touch()'
                            @blur='v$.passwordConfirmation.$touch()'
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
                   color='primary'
                   :disabled='v$.$invalid'
                   :loading='submitting'
                   class='mr-2 mb-2'
                   @click='newPassword'
            >
              {{ $t('session.new_password_action') }}
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
// import { validationMixin } from 'vuelidate'
// import { required, sameAs, minLength } from 'vuelidate/lib/validators'
import { useVuelidate } from '@vuelidate/core'
import { required, sameAs, minLength } from '@vuelidate/validators'

import { mapState } from 'vuex'

export default {
  setup () {
    return { v$: useVuelidate() }
  },

  validations() {
    return {
      password: { required, minLength: minLength(8) },
      passwordConfirmation: { sameAsPassword: sameAs('password') }
    }
  },

  data() {
    return {
      password: '',
      passwordConfirmation: '',
      showPassword: false,
      showPasswordConfirmation: false,
      serverSideErrors: {}
    }
  },

  computed: {
    ...mapState('layout', [
      'submitting'
    ]),
    passwordErrors() {
      const errors = []
      if (!this.v$.password.$dirty) return errors
      !!this.serverSideErrors.password && errors.push(this.serverSideErrors.password.join(' - '))
      !this.v$.password.required && errors.push(this.$t('errors.password_required'))
      !this.v$.password.minLength && errors.push(this.$t('errors.password_too_short'))
      return errors
    },
    passwordConfirmationErrors() {
      const errors = []
      if (!this.v$.passwordConfirmation.$dirty) return errors
      !this.v$.passwordConfirmation.sameAsPassword && errors.push(this.$t('errors.password_confirmation_not_equal'))
      return errors
    }
  },

  methods: {
    touchPassword: function() {
      this.v$.password.$touch()
      this.serverSideErrors.password = null
    },
    newPassword: function() {
      this.v$.$touch()
      if (this.v$.$invalid) return

      this.$store.dispatch('session/newPassword', {
        password: this.password,
        token: this.$route.query.reset_password_token
      })
          .catch(err => {
            this.serverSideErrors = err?.data ? err.data.errors : {}
          })
    }
  }
}
</script>