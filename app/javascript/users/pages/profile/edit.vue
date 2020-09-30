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
                    :error-messages="genderErrors"
                    :prepend-icon="!!gender ? (gender == 'M' ? 'mdi-gender-male' : (gender == 'F' ? 'mdi-gender-female' : 'mdi-android')) : 'mdi-gender-male-female'"
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
                    <v-radio
                        :label='$t("profile.attributes.genders.robot")'
                        value='R'
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
                  <v-checkbox v-model="child_account"
                              :label='labelFor("child_account")'
                              persistent-hint
                              :hint='$t("session.hints.child_account")'
                              @input='$v.child_account.$touch()'
                              @blur='$v.child_account.$touch()'>
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
                        :error-messages='childFirstNameErrors'
                        @input='$v.child_firstname.$touch()'
                        @blur='$v.child_firstname.$touch()'
                    />
                  </v-col>
                  <v-col cols='12' sm='6'>
                    <v-text-field
                        v-model='child_lastname'
                        prepend-icon='mdi-account-supervisor'
                        :label='labelFor("child_lastname")'
                        :error-messages='childLastNameErrors'
                        @input='$v.child_lastname.$touch()'
                        @blur='$v.child_lastname.$touch()'
                    />
                  </v-col>
                  <v-col cols='12' sm='6' v-if="child_account">
                    <v-menu
                        ref="menu_child_birthdate"
                        v-model="childBirthdatePickerOpened"
                        :close-on-content-click="false"
                        :nudge-right="40"
                        :return-value.sync="child_birthdate"
                        transition="scale-transition"
                        offset-y
                        max-width="290px"
                        min-width="290px"
                    >
                      <template v-slot:activator='{ on }'>
                        <v-text-field
                            :value='formattedDate(child_birthdate)'
                            :label='labelFor("child_birthdate")'
                            prepend-icon='mdi-calendar'
                            :error-messages="childBirthdateErrors"
                            readonly
                            v-on='on'
                        />
                      </template>
                      <v-date-picker
                          scrollable
                          ref="child_birthday_picker"
                          v-model='child_birthdate'
                          first-day-of-week='1'
                          :locale='$i18n.locale'
                          :max="new Date().toISOString().substr(0, 10)"
                          min="1900-01-01"
                          @input="$v.child_birthdate.$touch()"
                          @blur="$v.child_birthdate.$touch()"
                          @click:date="$refs.menu_child_birthdate.save(child_birthdate)"
                      />
                    </v-menu>
                  </v-col>
                </v-row>
              </v-expand-transition>

              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model='phone'
                    :label='labelFor("phone")'
                    prepend-icon='mdi-phone'
                    persistent-hint
                    :hint='$t("profile.hints.phone")'
                    :error-messages='phoneErrors'
                    @input='$v.phone.$touch()'
                    @blur='$v.phone.$touch()'
                    :disabled="disableForm"
                  />
                </v-col>
                <v-col cols='12' sm='6'>
                  <v-text-field
                          v-model.trim='email'
                          prepend-icon='mdi-at'
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
      return {
        firstname:       { required },
        lastname:        { required },
        gender:          { required },
        email:           { required, email },
        phone:           { required },
        birthdate:       { required,
          ageValidator(value) {
            // console.log(`ageValidator value: ${value} age:${this.calculateAge(value)}`)
            return this.calculateAge(value) >= 14
          }
        },
        child_account:          { required: requiredIf(_ => { return false }) },
        child_firstname:        { required: requiredIf(_ => { return this.child_account }) },
        child_lastname:         { required: requiredIf(_ => { return this.child_account }) },
        child_birthdate:        {
          required: requiredIf(_ => { return this.child_account }) ,
          childAgeValidator(value) {
            // console.log(`ageValidator value: ${value} age:${this.calculateAge(value)}`)
            return this.calculateAge(value) < 18
          }
        },
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
        child_account: !!currentUser.child_lastname && currentUser.child_lastname.length > 0,
        child_firstname: currentUser.child_firstname,
        child_lastname: currentUser.child_lastname,
        child_birthdate: currentUser.child_birthdate,
        childBirthdatePickerOpened: false,
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
      // ...mapState('mappings', [
      //   'phonePrefixes'
      // ]),
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
          child_firstname: this.child_account ? this.child_firstname : null,
          child_lastname: this.child_account ? this.child_lastname : null,
          child_birthdate: this.child_account ? this.child_birthdate : null,
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
