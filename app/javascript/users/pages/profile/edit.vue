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
                    v-model='firstname'
                    prepend-icon='mdi-account-outline'
                    :append-outer-icon='requiredIcon("firstname")'
                    :label='labelFor("firstname")'
                    :error-messages='firstNameErrors'
                    @input='$v.firstname.$touch()'
                    @blur='$v.firstname.$touch()'
                    :disabled="disableForm"
                  />
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model='lastname'
                    prepend-icon='mdi-account'
                    :append-outer-icon='requiredIcon("lastname")'
                    :label='labelFor("lastname")'
                    :error-messages='lastNameErrors'
                    @input='$v.lastname.$touch()'
                    @blur='$v.lastname.$touch()'
                    :disabled="disableForm"
                  />
                </v-col>
              </v-row>

              <v-row>
                <v-col cols='12' sm='6'>
                  <v-radio-group
                    v-model='gender'
                    row
                    :error-messages="genderErrors"
                    :prepend-icon="!!gender ? (gender == 'M' ? 'mdi-gender-male' : 'mdi-gender-female') : 'mdi-gender-male-female'"
                    @change="$v.gender.$touch()"
                    @blur="$v.gender.$touch()"
                    :disabled="disableForm"
                  >
                    <!--span class='mr-4'>{{ $t('user.attributes.gender') }}</span-->
                    <v-radio
                      :label='$t("profile.attributes.genders.male")'
                      value='M'
                    />
                    <v-radio
                      :label='$t("profile.attributes.genders.female")'
                      value='F'
                    />
                  </v-radio-group>
                </v-col>
                <v-col cols='12' sm='6'>
                  <v-menu
                          ref="menu_birthdate"
                          v-model="birthdatePickerOpened"
                          :close-on-content-click="false"
                          :nudge-right="40"
                          :return-value.sync="birthdate"
                          transition="scale-transition"
                          offset-y
                          max-width="290px"
                          min-width="290px"
                  >
                    <template v-slot:activator='{ on }'>
                      <v-text-field
                              :value='formattedDate(birthdate)'
                              :append-outer-icon='requiredIcon("birthdate")'
                              :label='labelFor("birthdate")'
                              prepend-icon='mdi-calendar'
                              :error-messages="birthdateErrors"
                              readonly
                              v-on='on'
                      />
                    </template>
                    <v-date-picker
                            scrollable
                            ref="birthday_picker"
                            v-model='birthdate'
                            first-day-of-week='1'
                            :locale='$i18n.locale'
                            :max="new Date().toISOString().substr(0, 10)"
                            min="1900-01-01"
                            @input="$v.birthdate.$touch()"
                            @blur="$v.birthdate.$touch()"
                            @click:date="$refs.menu_birthdate.save(birthdate)"
                    />
                  </v-menu>
                </v-col>
              </v-row>

              <v-row>
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
                <v-col cols='12' sm='6'>
                  <v-text-field
                          v-model='email'
                          prepend-icon='mdi-at'
                          :append-outer-icon='requiredIcon("email")'
                          :label='labelFor("email")'
                          :error-messages='emailErrors'
                          @input='$v.email.$touch()'
                          @blur='$v.email.$touch()'
                          persistent-hint
                          :hint='$t("profile.hints.email")'
                          :disabled="disableForm"
                  />
                </v-col>
              </v-row>

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
        firstname:       { required },
        lastname:        { required },
        gender:          { required },
        email:           { required, email },
        phone:           { required },
        birthdate:       { required: requiredIf(_ => { return false }) }
      }
    },
    data() {
      const currentUser = this.$store.getters['profile/currentUser']

      return {
        serverSideErrors: {},
        initialCurrentUserCompleted: !!currentUser.phone,
        firstname: currentUser.firstname,
        lastname: currentUser.lastname,
        gender: currentUser.gender,
        email: currentUser.email,
        phone: currentUser.phone,
        birthdate: currentUser.birthdate,
        birthdatePickerOpened: false,
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
      phoneErrors() {
        const errors = []
        !!this.serverSideErrors.phone && errors.push(this.show_error_form_field(this.serverSideErrors.phone))
        !this.$v.phone.required && errors.push(this.$t('errors.required'))
        return errors
      },
      disableForm() {
        return false
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
          firstname: this.firstname,
          lastname: this.lastname,
          gender: this.gender,
          email: this.email,
          phone: this.phone,
          birthdate: this.birthdate,
        })
          .then(_ => {
            if (!this.initialCurrentUserCompleted) {
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