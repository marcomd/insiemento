<template>
  <v-container>
    <v-row align='center' justify='center'>
      <v-col cols='12' xs='12' md='10' lg='8'>
        <v-card elevation='1' v-if='hasCurrentUser'>
          <v-toolbar flat>
            <v-toolbar-title>
              {{ isCurrentUserCompleted ? $t('profile.edit_title') : $t('profile.completing_title') }}
            </v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <v-alert
              type="info"
              colored-border
              dense
              color="primary lighten-2"
              elevation="2"
              border="left"
              v-if="disableForm"
            >
              {{ $t('profile.hints.disabled_form') }}
            </v-alert>
            <v-form id='edit-profile-form' @submit.prevent='updateProfile'>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model='first_name'
                    prepend-icon='mdi-account-outline'
                    :append-outer-icon='requiredIcon("first_name")'
                    :label='labelFor("first_name")'
                    :error-messages='firstNameErrors'
                    @input='$v.first_name.$touch()'
                    @blur='$v.first_name.$touch()'
                    :disabled="disableForm"
                  />
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model='last_name'
                    prepend-icon='mdi-account'
                    :append-outer-icon='requiredIcon("last_name")'
                    :label='labelFor("last_name")'
                    :error-messages='lastNameErrors'
                    @input='$v.last_name.$touch()'
                    @blur='$v.last_name.$touch()'
                    :disabled="disableForm"
                  />
                </v-col>
              </v-row>

              <v-row v-if='isLegal'>
                <v-col >
                  <v-text-field
                    v-model='business_name'
                    prepend-icon='mdi-domain'
                    :append-outer-icon='requiredIcon("business_name")'
                    :label='labelFor("business_name")'
                    :error-messages='businessNameErrors'
                    @input='$v.business_name.$touch()'
                    @blur='$v.business_name.$touch()'
                    :disabled="disableForm"
                  />
                </v-col>
              </v-row>

              <v-row v-if="!isLegal">
                <v-col cols='12' sm='6'>
                  <v-radio-group
                    v-model='sex'
                    row
                    :error-messages="sexErrors"
                    :prepend-icon="!!sex ? (sex == 'M' ? 'mdi-gender-male' : 'mdi-gender-female') : 'mdi-gender-male-female'"
                    @change="$v.sex.$touch()"
                    @blur="$v.sex.$touch()"
                    :disabled="disableForm"
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
                <v-col cols='12' sm='6' v-if="!isCurrentUserForeign">
                  <v-text-field
                    v-model='fiscal_code'
                    :append-outer-icon='requiredIcon("fiscal_code")'
                    :label='labelFor("fiscal_code")'
                    :error-messages='fiscalCodeErrors'
                    @input='$v.fiscal_code.$touch()'
                    @blur='$v.fiscal_code.$touch()'
                    prepend-icon='mdi-account-badge'
                    persistent-hint
                    :hint="$t('profile.hints.fiscal_code')"
                    :disabled="disableForm"
                  />
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12" sm="6">
                  <v-autocomplete
                    v-model='phone_prefix'
                    :items='phonePrefixes'
                    item-text='label'
                    item-value='phone_prefix'
                    :append-outer-icon='requiredIcon("phone_prefix")'
                    :label='labelFor("phone_prefix")'
                    prepend-icon='mdi-earth'
                    persistent-hint
                    clearable
                    :hint='$t("profile.phone_prefix_hint")'
                    :search-input.sync="phonePrefixSearch"
                    :loading="phonePrefixesLoading"
                    hide-no-data
                    :error-messages='phonePrefixErrors'
                    @input='$v.phone_prefix.$touch()'
                    @blur='$v.phone_prefix.$touch()'
                    :disabled="disableForm"
                  />
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model='phone'
                    :label='labelFor("phone")'
                    :append-outer-icon='requiredIcon("phone")'
                    prepend-icon='mdi-phone'
                    persistent-hint
                    :hint='$t("profile.phone_hint")'
                    :error-messages='phoneErrors'
                    @input='$v.phone.$touch()'
                    @blur='$v.phone.$touch()'
                    :disabled="disableForm"
                  />
                </v-col>
              </v-row>

              <v-row>
                <v-col>
                  <v-text-field
                    v-model='email'
                    prepend-icon='mdi-at'
                    :append-outer-icon='requiredIcon("email")'
                    :label='labelFor("email")'
                    :error-messages='emailErrors'
                    @input='$v.email.$touch()'
                    @blur='$v.email.$touch()'
                    persistent-hint
                    :hint='$t("customer.hints.email")'
                    :disabled="disableForm"
                  />
                </v-col>

                <v-col>
                  <v-select
                    v-model='language'
                    :items="surveyLanguages"
                    item-text='name'
                    item-value='value'
                    :label='labelFor("language")'
                    prepend-icon="mdi-forum-outline"
                    :append-outer-icon='requiredIcon("language")'
                    @input="$v.language.$touch()"
                    @blur="$v.language.$touch()"
                    :error-messages='languageErrors'
                  />
                </v-col>
              </v-row>

              <!-- <v-text-field
                v-model='address'
                :label='labelFor("address")'
              />
              <v-text-field
                v-model='cap'
                :label='labelFor("cap")'
              />
              <v-text-field required
                v-model='fiscal_code'
                :label='labelFor("fiscal_code")'
                :error-messages='fiscalCodeErrors'
                @input='$v.fiscal_code.$touch()'
                @blur='$v.fiscal_code.$touch()'
              />
              <v-text-field required
                v-model='document_number'
                :label='labelFor("document_number")'
                :error-messages='documentNumberErrors'
                @input='$v.document_number.$touch()'
                @blur='$v.document_number.$touch()'
              />
              <v-dialog
                ref='dialog'
                v-model='birthdatePickerOpened'
                :return-value.sync='birthdate'
                persistent
                width='290px'
              >
                <template v-slot:activator='{ on }'>
                  <v-text-field
                    :value='formattedDate(birthdate)'
                    :label='labelFor("birthdate")'
                    readonly
                    v-on='on'
                  />
                </template>
                <v-date-picker
                  v-model='birthdate'
                  first-day-of-week='1'
                  :locale='$i18n.locale'
                  scrollable
                >
                  <v-btn text @click='birthdatePickerOpened = false'>
                    {{ $t('commons.cancel') }}
                  </v-btn>
                  <div class='flex-grow-1'></div>
                  <v-btn text color='primary' @click='$refs.dialog.save(birthdate)'>
                    {{ $t('commons.confirm') }}
                  </v-btn>
                </v-date-picker>
              </v-dialog>
              <v-radio-group v-model='sex' row>
                <span class='mr-4'>{{ $t('profile.attributes.sex') }}</span>
                <v-radio :label='$t("profile.attributes.male")' value='M'/>
                <v-radio :label='$t("profile.attributes.female")' value='F'/>
              </v-radio-group> -->

            </v-form>
          </v-card-text>
          <v-card-actions class='mt-2'>
            <v-btn large
              class='ml-2 mb-2'
              :to='{name: "showProfile"}'
            >
              {{ $t('commons.cancel') }}
            </v-btn>
            <div class='flex-grow-1'/>
            <v-btn
              type='submit'
              form='edit-profile-form'
              color='primary'
              :disabled='$v.$invalid || disableForm'
              :large='true'
              :loading='submitting'
              class='mr-2 mb-2'
            >
              {{ isCurrentUserCompleted ? $t('profile.update_action') : $t('profile.completing_action') }}
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  import { validationMixin } from 'vuelidate'
  import { required, requiredIf, email } from 'vuelidate/lib/validators'
  import { mapState, mapGetters } from 'vuex'
  import { accountDataMixin } from '../../mixins/account_data_mixin'
  import { currentUserMixin } from '../../mixins/current_user_mixin'
  import { utilityMixin } from '../../mixins/utility_mixin'

  export default {
    mixins: [
      validationMixin,
      accountDataMixin,
      utilityMixin,
      currentUserMixin,
    ],
    validations() {
      const fiscalCodeRequired = false
      return {
        first_name:      { required: requiredIf(_ => { return !this.isLegal }) },
        last_name:       { required: requiredIf(_ => { return !this.isLegal }) },
        business_name:   { required: requiredIf(_ => { return this.isLegal }) },
        sex:             { required: requiredIf(_ => { return !this.isLegal }) },
        email:           { required, email },
        phone:           { required },
        phone_prefix:    { required },
        language:        { required },
        fiscal_code: {
          required: requiredIf(_ => { return fiscalCodeRequired }),
          fiscalCodeValidator(value) {
            if (!value || value == '') return true
            return /^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$/i.test(value)
          },
        },
      }
    },
    data() {
      const currentUser = this.$store.getters['profile/currentUser']

      return {
        serverSideErrors: {},
        phonePrefixesLoading: false,
        initialCurrentUserCompleted: !!currentUser.phone && !!currentUser.phone_prefix && !!currentUser.language,
        business_name: currentUser.business_name,
        first_name: currentUser.first_name,
        last_name: currentUser.last_name,
        sex: currentUser.sex,
        email: currentUser.email,
        phone_prefix: currentUser.phone_prefix,
        phonePrefixSearch: currentUser.phone_prefix,
        phone: currentUser.phone,
        // address: currentUser.address,
        // birthdate: currentUser.birthdate,
        // cap: currentUser.cap,
        // document_number: currentUser.document_number,
        fiscal_code: currentUser.fiscal_code,
        // sex: currentUser.sex,
        // serverSideErrors: {},
        // birthdatePickerOpened: false,
        language: currentUser.language,
      }
    },
    created() {
      if (!this.hasCurrentUser) {
        this.$router.replace({ name: 'showProfile' })
      }
    },
    computed: {
      ...mapState('layout', [
        'submitting'
      ]),
      ...mapGetters('profile', [
        'currentUser',
        'hasCurrentUser'
      ]),
      ...mapState('mappings', [
        'phonePrefixes'
      ]),
      isLegal() {
        return this.currentUser.customer_type == 'LEGAL_PERSON'
      },
      isNatural() {
        return !this.isLegal
      },
      hasPhonePrefix() {
        return !!this.phone_prefix
      },
      hasPhone() {
        return !!this.phone
      },
      surveyLanguages() {
        return [
          { value: 'it', name: 'Italiano' },
          { value: 'en', name: 'English' },
          { value: 'de', name: 'Deutsch' },
          { value: 'fr', name: 'Français' },
          { value: 'es', name: 'Español' },
        ]
      },
      // phonePrefixErrors() {
      //   const errors = []
      //   !!this.serverSideErrors.phone_prefix && errors.push(this.show_error_form_field(this.serverSideErrors.phone_prefix))
      //   !this.$v.phone_prefix.required && errors.push(this.$t('errors.required'))
      //   return errors
      // },
      // phoneErrors() {
      //   const errors = []
      //   !!this.serverSideErrors.phone && errors.push(this.show_error_form_field(this.serverSideErrors.phone))
      //   !this.$v.phone.required && errors.push(this.$t('errors.required'))
      //   return errors
      // },
      disableForm() {
        return this.currentUserByAdmin && this.isLegal
      },
    },
    methods: {
      labelsPrefix() {
        return 'profile.attributes'
      },
      updateProfile: function() {
        this.$v.$touch()
        if (this.$v.$invalid) return

        this.$store.dispatch('profile/update', {
          business_name: this.business_name,
          first_name: this.first_name,
          last_name: this.last_name,
          sex: this.sex,
          email: this.email,
          phone_prefix: this.phone_prefix,
          phone: this.phone,
          // address: this.address,
          // birthdate: this.birthdate,
          // cap: this.cap,
          // document_number: this.document_number,
          fiscal_code: this.fiscal_code,
          // sex: this.sex
          language: this.language,
        })
          .then(_ => {
            if (this.currentUser.pending_order_uuid) {
              this.$router.push({ name: 'orderShow', params: { id: this.currentUser.pending_order_uuid } })
            } else if (!this.initialCurrentUserCompleted) {
              this.$router.push({ name: 'dashboard' })
              this.$store.dispatch('layout/addAlert', {
                type: 'success',
                key: 'profile_completed'
              })
            } else {
              this.$router.push({ name: 'showProfile' })
              this.$store.dispatch('layout/addAlert', {
                  type: 'success',
                  key: 'profile_updated'
                })
            }
          })
          .catch(error => {
            if (error.status !== 401) {
              this.$store
                .dispatch('layout/replaceAlert', {
                  type: 'error',
                  key: 'profile_error'
                })
            }
            this.serverSideErrors = error.body ? error.body.errors : {}
          })
      }
    },
    watch: {
      phonePrefixSearch: {
        immediate: true,
        handler: function(search) {
          if (!search) return
          if (this.phonePrefixesLoading) return
          this.phonePrefixesLoading = true

          this.$store
            .dispatch('mappings/fetchPhonePrefixes', { name: search })
            .catch(err => {
              this.$store.dispatch('layout/replaceAlert', {
                type: 'error',
                message: err
              })
            })
            .finally(() => (this.phonePrefixesLoading = false))
        }
      }
    },
  }
</script>

<style lang="scss" scoped>
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
