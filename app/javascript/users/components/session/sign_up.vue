<template>
  <v-container>
    <v-row align='center' justify='center'>
      <v-col cols='12' xs='12' md='10' lg='8'>
        <v-card elevation='1'>
          <v-toolbar flat>
            <v-toolbar-title>
              {{ $t('session.sign_up_title') }}
            </v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <v-form id='sign-up-form' @submit.prevent='signUp'>
              <v-row>
                <v-col>
                  <!--p class='ml-8'>
                    {{ $t('session.attributes.type') }}
                  </p-->
                  <v-radio-group v-model='customer_type'
                                 row
                                 :error-messages="customerTypeErrors">
                    <v-radio :label='$t("session.attributes.natural")' value='NATURAL_PERSON' />
                    <v-radio :label='$t("session.attributes.legal")' value='LEGAL_PERSON' />
                  </v-radio-group>
                </v-col>
              </v-row>

              <transition name='slide-fade'>
                <v-row>
                  <v-col cols="12" sm="6">
                    <v-text-field
                      v-model='first_name'
                      prepend-icon='mdi-account'
                      :append-outer-icon='requiredIcon("first_name")'
                      :label='labelFor(`first_name_${customer_type.toLowerCase()}`)'
                      :error-messages='firstNameErrors'
                      @input='$v.first_name.$touch()'
                      @blur='$v.first_name.$touch()'
                    />
                  </v-col>
                  <v-col>
                    <v-text-field
                      v-model='last_name'
                      prepend-icon='mdi-account'
                      :append-outer-icon='requiredIcon("last_name")'
                      :label='labelFor(`last_name_${customer_type.toLowerCase()}`)'
                      :error-messages='lastNameErrors'
                      @input='$v.last_name.$touch()'
                      @blur='$v.last_name.$touch()'
                    />
                  </v-col>
                </v-row>
              </transition>

              <transition name='slide-fade'>
                <v-row v-if='isLegal'>
                  <v-col>
                    <v-text-field
                      v-model='business_name'
                      prepend-icon='mdi-domain'
                      :append-outer-icon='requiredIcon("business_name")'
                      :label='labelFor("business_name")'
                      :error-messages='businessNameErrors'
                      @input='$v.business_name.$touch()'
                      @blur='$v.business_name.$touch()'
                    />
                  </v-col>
                </v-row>
              </transition>

              <transition name='slide-fade'>
                <v-row v-if="!isLegal">
                  <v-col>
                    <v-radio-group
                      v-model='sex'
                      row
                      :error-messages="sexErrors"
                      :prepend-icon="!!sex ? (sex == 'M' ? 'mdi-gender-male' : 'mdi-gender-female') : 'mdi-gender-male-female'"
                      @change="$v.sex.$touch()"
                      @blur="$v.sex.$touch()"
                    >
                      <!--span class='mr-4'>{{ $t('user.attributes.sex') }}</span-->
                      <v-radio
                        :label='$t("user.attributes.genders.male")'
                        value='M'
                      />
                      <v-radio
                        :label='$t("user.attributes.genders.female")'
                        value='F'
                      />
                    </v-radio-group>
                  </v-col>
                </v-row>
              </transition>

              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field required
                    v-model='email'
                    prepend-icon='mdi-at'
                    :append-outer-icon='requiredIcon("email")'
                    :label='labelFor("email")'
                    :error-messages='emailErrors'
                    @input='$v.email.$touch()'
                    @blur='$v.email.$touch()'
                    persistent-hint
                    :hint='$t("customer.hints.email")'
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
                          <v-icon key='available' v-if='showAvailabilityIcon && !$v.email.$error' color="success">mdi-check-bold</v-icon>
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
                    v-model='email_confirmation'
                    prepend-icon='mdi-at'
                    :append-outer-icon='requiredIcon("email_confirmation")'
                    :label='labelFor("email_confirmation")'
                    :error-messages='emailConfirmationErrors'
                    @input='$v.email_confirmation.$touch()'
                    @blur='$v.email_confirmation.$touch()'
                  />
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field required
                    v-model='password'
                    prepend-icon='mdi-lock-question'
                    :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                    :append-outer-icon='requiredIcon("password")'
                    :label='labelFor("password")'
                    :type="showPassword ? 'text' : 'password'"
                    :hint='$t("session.password_hint")'
                    counter
                    minlength='8'
                    :error-messages='passwordErrors'
                    @click:append="showPassword = !showPassword"
                    @input='$v.password.$touch()'
                    @blur='$v.password.$touch()'
                  />
                </v-col>
                <v-col>
                  <v-text-field required
                    v-model='password_confirmation'
                    prepend-icon='mdi-lock-question'
                    :append-icon="showPasswordConfirmation ? 'mdi-eye' : 'mdi-eye-off'"
                    :append-outer-icon='requiredIcon("password_confirmation")'
                    :label='labelFor("password_confirmation")'
                    :type="showPasswordConfirmation ? 'text' : 'password'"
                    counter
                    :error-messages='passwordConfirmationErrors'
                    @click:append="showPasswordConfirmation = !showPasswordConfirmation"
                    @input='$v.password_confirmation.$touch()'
                    @blur='$v.password_confirmation.$touch()'
                  />
                </v-col>
              </v-row>

            </v-form>
          </v-card-text>
          <v-card-actions>
            <div class='flex-grow-1'/>
            <v-btn
              type='submit'
              form='sign-up-form'
              color='primary'
              :disabled='$v.$invalid'
              :large='true'
              :loading='submitting'
              class='mr-2 mb-2'
            >
              {{ $t('session.sign_up_action') }}
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  import Vue from 'vue'
  import { validationMixin } from 'vuelidate'
  import { accountDataMixin } from '../../mixins/account_data_mixin'
  import { utilityMixin } from '../../mixins/utility_mixin'
  import { sessionMixin } from "../../mixins/session_mixin"
  import { availabilityMixin} from "../../mixins/availability_mixin"
  import { required, requiredIf, email, sameAs, minLength } from 'vuelidate/lib/validators'
  import { mapState } from 'vuex'

  export default {
    mixins: [
      validationMixin,
      accountDataMixin,
      utilityMixin,
      sessionMixin,
      availabilityMixin,
    ],
    validations() {
      return {
        first_name:     { required },
        last_name:      { required },
        sex:            { required: requiredIf(_ => { return this.isNatural }) },
        business_name:  { required: requiredIf(_ => { return this.isLegal }) },
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
        customer_type:          { required },
      }
    },
    data() {
      return {
        customer_type: 'NATURAL_PERSON',
        first_name: '',
        last_name: '',
        sex: '',
        business_name: '',
        email: '',
        email_confirmation: '',
        password: '',
        password_confirmation: '',
        showPassword: false,
        showPasswordConfirmation: false,
        serverSideErrors: {}
      }
    },
    computed: {
      isLegal() {
        return this.customer_type == 'LEGAL_PERSON'
      },
      isNatural() {
        return !this.isLegal
      },
      showForgottenPasswordHint() {
        // return !this.checkingAvailability && !!this.serverSideErrors && !!this.serverSideErrors['email']
        return !this.checkingAvailability && this.resultAvailability == false && this.resultCustomerCreatedByWeb == false
      },
      ...mapState('layout', {
        submitting: 'submitting'
      }),
    },
    methods: {
      labelsPrefix() {
        return 'session.attributes'
      },
      signUp() {
        this.$v.$touch()
        if (this.$v.$invalid) return

        if (this.isLegal) {
          this.sex = null
        } else {
          this.business_name = null
        }

        this.$store.dispatch('session/signUp', {
          customer_type: this.customer_type,
          first_name: this.first_name,
          last_name: this.last_name,
          sex: this.sex,
          business_name: this.business_name,
          email: this.email,
          email_confirmation: this.email_confirmation,
          password: this.password,
          password_confirmation: this.password_confirmation,
          pending_order_uuid: this.getUuidFromPath(this.redirectToParam)
        })
        .catch(err => {
          console.log('submit signUp', err)
          this.serverSideErrors = err.body ? err.body.errors : err
        })
      },
    }
  }
</script>

<style lang="scss" scoped>
  .fade-enter-active, .fade-leave-active {
    transition: opacity .5s;
  }
  .fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
    opacity: 0;
  }

  .slide-fade-enter {
    transform: scale(1.3);
    opacity: 0;
  }
  .slide-fade-enter-active {
    transition: all 0.3s ease-in;
  }
  .slide-fade-leave-active {
    transition: all 0s ease-out;
  }
  .slide-fade-leave-to {
    opacity: 0;
  }
</style>
