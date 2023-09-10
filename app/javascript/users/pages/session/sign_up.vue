<template>
  <v-container>
    <v-row align='center' justify='center'>
      <v-col cols='12' xs='12' md='10' lg='8'>
        <v-card elevation='1'>
          <v-toolbar flat>
            <v-toolbar-title>
              {{ $t('session.sign_up.title') }}
            </v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <v-form id='sign-up-form' @submit.prevent='signUp'>

              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model.trim='firstname'
                    prepend-icon='mdi-account'
                    :label='labelFor("firstname")'
                    :error-messages='firstNameErrors'
                    @input='v$.firstname.$touch()'
                    @blur='v$.firstname.$touch()'
                  />
                </v-col>
                <v-col>
                  <v-text-field
                    v-model.trim='lastname'
                    prepend-icon='mdi-account'
                    :label='labelFor("lastname")'
                    :error-messages='lastNameErrors'
                    @input='v$.lastname.$touch()'
                    @blur='v$.lastname.$touch()'
                  />
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12" sm="6">
                  <v-radio-group
                    v-model='gender'
                    :error-messages="genderErrors"
                    :prepend-icon="!!gender ? (gender == 'M' ? 'mdi-gender-male' : (gender == 'F' ? 'mdi-gender-female' : 'mdi-android')) : 'mdi-gender-male-female'"
                    @change="v$.gender.$touch()"
                    @blur="v$.gender.$touch()"
                  >
                    <v-radio
                      :label='$t("profile.attributes.genders.male")'
                      value='M'
                    />
                    <v-radio
                      :label='$t("profile.attributes.genders.female")'
                      value='F'
                    />
                    <v-radio
                      :label='$t("profile.attributes.genders.robot")'
                      value='R'
                    />
                  </v-radio-group>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-checkbox v-model="child_account"
                              :label='labelFor("child_account")'
                              persistent-hint
                              :hint='$t("session.hints.child_account")'
                              @input='v$.child_account.$touch()'
                              @blur='v$.child_account.$touch()'>
                  </v-checkbox>
                </v-col>
              </v-row>

              <v-expand-transition>
                <v-row v-if="child_account">
                    <v-col cols="12" sm="6">
                      <v-text-field
                          v-model='child_firstname'
                          prepend-icon='mdi-account-supervisor'
                          :label='labelFor("child_firstname")'
                          :error-messages='firstNameErrors'
                          @input='v$.child_firstname.$touch()'
                          @blur='v$.child_firstname.$touch()'
                      />
                    </v-col>
                    <v-col cols='12' sm='6'>
                      <v-text-field
                          v-model='child_lastname'
                          prepend-icon='mdi-account-supervisor'
                          :label='labelFor("child_lastname")'
                          :error-messages='lastNameErrors'
                          @input='v$.child_lastname.$touch()'
                          @blur='v$.child_lastname.$touch()'
                      />
                    </v-col>
                </v-row>
              </v-expand-transition>

              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field required
                    v-model.trim='email'
                    prepend-icon='mdi-at'
                    :label='labelFor("email")'
                    :error-messages='emailErrors'
                    @input='v$.email.$touch()'
                    @blur='v$.email.$touch()'
                    persistent-hint
                    :hint='$t("profile.hints.email")'
                  >
                    <template v-slot:append>
                      <v-fade-transition leave-absolute group>
                        <v-progress-circular
                          key='progress'
                          v-if="checkingAvailability"
                          size="24"
                          color="info"
                          indeterminate
                        />
                        <div v-else key='result'>
                          <v-icon key='available' v-if='showAvailabilityIcon && !v$.email.$error' color="success">mdi-check-bold</v-icon>
                          <v-icon key='not-available' v-if='showNotAvailabilityIcon' color="error">mdi-alert-circle-outline</v-icon>
                        </div>
                      </v-fade-transition>
                    </template>
                  </v-text-field>
                  <v-alert
                    border="top"
                    colored-border
                    type="info"
                    elevation="2"
                    v-if="showForgottenPasswordHint"
                  >
                    {{ $t('session.email_already_exists_hints') }}
                    <v-btn
                      text
                      color="primary"
                      :to='{name: "passwordReset"}'
                    >
                      {{ $t('session.email_already_exists_get_password') }}
                    </v-btn>
                  </v-alert>
                </v-col>
                <v-col>
                  <v-text-field required
                    v-model.trim='email_confirmation'
                    prepend-icon='mdi-at'
                    :label='labelFor("email_confirmation")'
                    :error-messages='emailConfirmationErrors'
                    @input='v$.email_confirmation.$touch()'
                    @blur='v$.email_confirmation.$touch()'
                  />
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field required
                    v-model='password'
                    prepend-icon='mdi-lock-question'
                    :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                    :label='labelFor("password")'
                    :type="showPassword ? 'text' : 'password'"
                    :hint='$t("session.sign_up.password_hint")'
                    counter
                    minlength='8'
                    :error-messages='passwordErrors'
                    @click:append="showPassword = !showPassword"
                    @input='v$.password.$touch()'
                    @blur='v$.password.$touch()'
                  />
                </v-col>
                <v-col>
                  <v-text-field required
                    v-model='password_confirmation'
                    prepend-icon='mdi-lock-question'
                    :append-icon="showPasswordConfirmation ? 'mdi-eye' : 'mdi-eye-off'"
                    :label='labelFor("password_confirmation")'
                    :type="showPasswordConfirmation ? 'text' : 'password'"
                    counter
                    :error-messages='passwordConfirmationErrors'
                    @click:append="showPasswordConfirmation = !showPasswordConfirmation"
                    @input='v$.password_confirmation.$touch()'
                    @blur='v$.password_confirmation.$touch()'
                  />
                </v-col>
              </v-row>

              <v-checkbox v-model="terms_and_conditions"
                          @input='v$.terms_and_conditions.$touch()'
                          @blur='v$.terms_and_conditions.$touch()'>
                <template v-slot:label>
                  <div>
                    {{ $t('commons.accept') }}
                    <v-tooltip bottom>
                      <template v-slot:activator="{ on }">
                        <a
                            target="_blank"
                            href="/users/terms_and_conditions"
                            @click.stop
                            v-on="on"
                        >
                          {{ $t('session.sign_up.terms') }}
                        </a>
                      </template>
                      {{ $t('session.sign_up.terms_hint') }}
                    </v-tooltip>
                  </div>
                </template>
              </v-checkbox>

            </v-form>
          </v-card-text>
          <v-card-actions>
            <div class='flex-grow-1'/>
            <v-btn
              type='submit'
              form='sign-up-form'
              color='primary'
              :disabled='v$.$invalid || !terms_and_conditions'
              :large='true'
              :loading='submitting'
              class='mr-2 mb-2'
            >
              {{ $t('session.sign_up.action') }}
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  // import { validationMixin } from 'vuelidate'
  // import { required, requiredIf, email, sameAs, minLength } from 'vuelidate/lib/validators'
  import { useVuelidate } from '@vuelidate/core'
  import { required, requiredIf, email, sameAs, minLength } from '@vuelidate/validators'
  import { accountDataMixin } from '../../mixins/account_data_mixin'
  import { utilityMixin } from '../../mixins/utility_mixin'
  import { sessionMixin } from "../../mixins/session_mixin"
  import { availabilityMixin} from "../../mixins/availability_mixin"
  import { mapState } from 'vuex'

  export default {
    mixins: [
      accountDataMixin,
      utilityMixin,
      sessionMixin,
      availabilityMixin,
    ],

    setup () {
      return { v$: useVuelidate() }
    },

    validations() {
      return {
        // organization:  { required: requiredIf(_ => { return !this.current_organization }) },
        firstname:     { required },
        lastname:      { required },
        gender:        { required },
        email: {
          required,
          email,
          isAvailable(value) {
            // no need to check availability via API if email is not present or invalid
            this.resultAvailability = null
            if (!required(value) || !email(value)) return true
            return this.checkEmailAvailability(value)
          }
        },
        email_confirmation:     { required, email, sameAsEmail: sameAs('email') },
        password:               { required, minLength: minLength(8) },
        password_confirmation:  { required, sameAsPassword: sameAs('password') },
        terms_and_conditions:   { required },
        child_account:          { required: requiredIf(_ => { return false }) },
        child_firstname:        { required: requiredIf(_ => { return this.child_account }) },
        child_lastname:         { required: requiredIf(_ => { return this.child_account }) },
      }
    },

    data() {
      return {
        firstname: '',
        lastname: '',
        gender: '',
        email: '',
        email_confirmation: '',
        password: '',
        password_confirmation: '',
        terms_and_conditions: false,
        child_account: false,
        child_firstname: '',
        child_lastname: '',
        // organization: null,
        showPassword: false,
        showPasswordConfirmation: false,
        serverSideErrors: {}
      }
    },

    computed: {
      showForgottenPasswordHint() {
        // return !this.checkingAvailability && !!this.serverSideErrors && !!this.serverSideErrors['email']
        return !this.checkingAvailability && this.resultAvailability == false && this.resultCustomerCreatedByWeb == false
      },
      ...mapState('layout', ['submitting']),
      // ...mapState('application', ['current_organization']),
    },

    methods: {
      labelsPrefix() {
        return 'session.attributes'
      },
      signUp() {
        this.v$.$touch()
        if (this.v$.$invalid) return

        this.$store.dispatch('session/signUp', {
          firstname: this.firstname,
          lastname: this.lastname,
          gender: this.gender,
          email: this.email,
          email_confirmation: this.email_confirmation,
          password: this.password,
          password_confirmation: this.password_confirmation,
          child_firstname: this.child_account ? this.child_firstname : null,
          child_lastname: this.child_account ? this.child_lastname : null,
        }).then(_ => {
          this.$router.push({ name: 'signedUp' })
          this.$store.dispatch('layout/addAlert', {
            type: 'success',
            key: 'signed_up'
          }, { root: true })
        }).catch(error => {
          console.log('submit signUp', error)
          if (!!error && ![500, 401].includes(error.status)) {
            this.$store.dispatch('layout/replaceAlert', {
              type: 'error',
              key: 'sign_up_error'
            }, { root: true })
            this.serverSideErrors = error.data ? error.data.errors : error
          }
        })
      },
    }
  }
</script>

<style lang="scss" scoped>
</style>
