<template>
  <v-container>
    <v-row align='center' justify='center'>
      <v-col cols='12' sm='8' md='6' lg='4'>
        <v-card elevation='1'>
          <v-toolbar flat>
            <v-toolbar-title>
              {{ $t('session.login_title') }}
            </v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <v-form id='login-form' @submit.prevent='login'>
              <v-text-field required
                v-model.trim='email'
                :label='$t("session.attributes.email")'
                prepend-icon='mdi-at'
                :error-messages='emailErrors'
                @input='$v.email.$touch()'
                @blur='$v.email.$touch()'
              />
              <v-text-field required
                v-model='password'
                prepend-icon='mdi-lock-question'
                :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                :label='$t("session.attributes.password")'
                :type="showPassword ? 'text' : 'password'"
                :error-messages='passwordErrors'
                @click:append="showPassword = !showPassword"
                @input='$v.password.$touch()'
                @blur='$v.password.$touch()'
              />
              <v-checkbox
                v-model='rememberMe'
                :label='$t("session.attributes.remember_me")'
              />
              <p>
                <router-link :to='{name: "passwordReset"}'>
                  {{ $t("session.password_forgotten") }}
                </router-link>
                <br/>
                <router-link :to='{name: "confirmationEmail"}'>
                  {{ $t("session.resend_confirmation_email") }}
                </router-link>
              </p>
            </v-form>
          </v-card-text>
          <v-card-actions>
            <v-btn large
              class='ml-2 mb-2'
              :to='{name: "signUp", query: {redirectTo: redirectToParam}}'
            >
              {{ $t('sidebar.sign_up') }}
            </v-btn>
            <v-spacer></v-spacer>
            <v-btn large
              type='submit'
              form='login-form'
              color='primary'
              :disabled='$v.$invalid'
              :loading='submitting'
              class='mr-2 mb-2'
            >
              {{ $t('session.login_action') }}
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  import { validationMixin } from 'vuelidate'
  import { sessionMixin } from "../../mixins/session_mixin";
  import { required, email } from 'vuelidate/lib/validators'
  import { mapState } from 'vuex'

  export default {
    mixins: [ validationMixin, sessionMixin ],
    validations() {
      return {
        password: { required },
        email: { required, email },
      }
    },
    data() {
      return {
        rememberMe: true,
        showPassword: false,
        password: '',
        email: ''
      }
    },
    created() {
      if (this.$route.query.confirmed === 'true') {
        this.$store.dispatch('layout/addAlert', {
          type: 'success',
          key: 'email_confirmed'
        })
      }
    },
    computed: {
      ...mapState('layout', {
        submitting: 'submitting'
      }),
      emailErrors() {
        const errors = []
        if (!this.$v.email.$dirty) return errors
        !this.$v.email.email && errors.push(this.$t('errors.email_invalid_format'))
        !this.$v.email.required && errors.push(this.$t('errors.email_required'))
        return errors
      },
      passwordErrors() {
        const errors = []
        if (!this.$v.password.$dirty) return errors
        !this.$v.password.required && errors.push(this.$t('errors.password_required'))
        return errors
      },
    },
    methods: {
      login: function() {
        this.$v.$touch()
        if (this.$v.$invalid) return

        this.$store.dispatch('session/login', {
          email: this.email,
          password: this.password,
          rememberMe: this.rememberMe
        })
        .then( (responseBody) => {
          // let redirectTo = this.$route.query.redirectTo
          if (responseBody.customer && !responseBody.customer.phone) {
            this.$router.push({name: 'editProfile'})
          } else if (this.redirectToParam !== undefined) {
            this.$router.push({path: this.redirectToParam})
          } else {
            this.$router.push({ name: 'dashboard'})
          }
          this.$store.dispatch('layout/addAlert', {
            type: 'success',
            key: 'login_success'
          })
        }, error => {
          console.log('login error', error)
          let message = error
          const body = error?.data
          if (body) {
            if (body.errors) {
              if (body.errors.user_authentication) {
                message = body.errors.user_authentication
              } else {
                message = body.errors
              }
            } else {
              message = body
            }
          }
          if (!!error && ![500].includes(error.status)) {
            this.$store.dispatch('layout/replaceAlert', {
              type: 'error',
              message: message
            })
          }
        })
      }
    },
  }
</script>
