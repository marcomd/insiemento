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
            <v-form id='login-form' @submit='login'>
              <v-text-field
                required
                v-model.trim='email'
                :label='$t("session.attributes.email")'
                prepend-icon='mdi-at'
                :error-messages='emailErrors'
                @input='v$.email.$touch()'
              />
              <div class="input-errors" v-for="error of v$.email.$errors" :key="error.$uid">
                <div class="error-msg">{{ error.$message }}</div>
              </div>
              <v-text-field required
                v-model='password'
                prepend-icon='mdi-lock-question'
                :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                :label='$t("session.attributes.password")'
                :type="showPassword ? 'text' : 'password'"
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
              :to='{name: "signUp", }'
            >
              {{ $t('sidebar.sign_up') }}
            </v-btn>
            <v-spacer></v-spacer>
            <v-btn large
              type='submit'
              form='login-form'
              color='primary'
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
  // import { Form, Field } from 'vee-validate'
  import { useVuelidate } from '@vuelidate/core'
  import { required, email } from '@vuelidate/validators'

  export default {
    name: "Test",

    // components: {
    //   Form,
    //   Field,
    // },
    setup () {
      return { v$: useVuelidate() }
    },

    data() {
      return {
        rememberMe: true,
        showPassword: false,
        password: '',
        email: ''
      }
    },

    validations () {
      return {
        email: { required, email },
        password: { required }, // Matches this.lastName
      }
    },

    created() {
    },

    computed: {
      emailErrors() {
        const errors = []
        if (!this.v$.email.$dirty) return errors
        if (this.v$.email.required.$invalid) {
          errors.push(this.$t('errors.email_required'))
        } else if (this.v$.email.$invalid) {
          errors.push(this.$t('errors.email_invalid_format'))
        }
        return errors
      },
    },

    methods: {
      login() {
        console.log("login")
      }
    },
  }
</script>
