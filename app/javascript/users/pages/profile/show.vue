<template>
  <v-container>
    <v-row align='center' justify='center'>
      <v-col cols='12' sm='10' lg='8'>
        <v-card elevation='1'>
          <v-toolbar flat>
            <v-toolbar-title>
              {{ $t('profile.title') }}
            </v-toolbar-title>
          </v-toolbar>
          <v-card-text if='!!currentUser'>
            <h3 class='title font-weight-black font-weight-bold mb-3'>
              {{ fullName }}
              <v-icon>
                {{ !!currentUser.gender ? (currentUser.gender == 'M' ? 'mdi-gender-male' : 'mdi-gender-female') : 'mdi-gender-male-female' }}
              </v-icon>
            </h3>
            <v-row class="info-entry mb-1" dense>
              <v-col class="info-entry__value" cols='12' sm="6">
                <v-icon>mdi-email</v-icon>
                {{ currentUser.email }}
              </v-col>
              <v-col class="info-entry__value" cols='12' sm="6" v-if="this.currentUser.phone">
                <v-icon>mdi-phone</v-icon>
                {{ phoneWithPrefix }}
              </v-col>
              <v-col class="info-entry__value" cols='12' sm="6" v-if="this.currentUser.birthdate">
                <v-icon>mdi-cake-variant</v-icon>
                {{ formattedDate(currentUser.birthdate) }}
              </v-col>
            </v-row>

            <h3 v-if="isChildAccount" class='mt-5 mb-2'>{{ $t("profile.attributes.child_account") }}</h3>
            <v-row class="info-entry mb-1" dense v-if="isChildAccount">
              <v-col class="info-entry__value" cols='12' sm="6">
                <v-icon>mdi-account-supervisor</v-icon>
                {{ `${currentUser.child_firstname} ${currentUser.child_lastname}` }}
              </v-col>
              <v-col class="info-entry__value" cols='12' sm="6" v-if="this.currentUser.child_birthdate">
                <v-icon>mdi-cake</v-icon>
                {{ formattedDate(currentUser.child_birthdate) }}
              </v-col>
            </v-row>
          </v-card-text>
          <v-card-actions>
            <div class='flex-grow-1'/>
            <v-btn
              :to='{name: "editProfile"}'
              color='primary'
              :large='true'
              class='mr-2 mb-2'
            >
              {{ $t('profile.edit_action') }}
            </v-btn>
            <div class='flex-grow-1'/>
          </v-card-actions>
          <v-card-text>
            <h3 class="text-center pb-3">{{ $t('profile.subscriptions') }}</h3>
            <SubscriptionList v-if="subscriptions && subscriptions.length > 0"
                              :subscriptions="subscriptions"></SubscriptionList>
            <div v-else-if="loading" class="text-center">
              <v-progress-circular
                  size="50"
                  color="primary"
                  indeterminate>
              </v-progress-circular>
            </div>
            <p v-else class="text-center">{{ $t('profile.no_subscription') }}</p>
            <div class="pb-10" />
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  import { mapGetters, mapState, mapActions } from 'vuex'
  import { utilityMixin } from '../../mixins/utility_mixin'
  import { currentUserMixin } from '../../mixins/current_user_mixin'
  import SubscriptionList from '../../components/subscriptions/subscriptions_list'

  export default {
    mixins: [
      utilityMixin,
      currentUserMixin,
    ],

    components: {
      SubscriptionList,
    },

    created() {
      this.fetchSubscriptions()
    },

    computed: {
      ...mapState('subscription', ['subscriptions']),
      ...mapState('layout', ['loading']),
      ...mapGetters('profile', [
        'currentUser',
        'fullName',
        'hasCurrentUser'
      ]),
      phoneWithPrefix() {
        return `+39 ${this.currentUser.phone || '--'}`
      }
      // fullAddress() {
      //   const fullAddress = this.$store.getters['profile/fullAddress']
      //   return !!fullAddress ? fullAddress : '--'
      // },
      // birthdate() {
      //   const birthdate = this.currentUser.birthdate
      //   return !!birthdate ? this.formattedDate(birthdate) : '--'
      // },
    },

    methods: {
      ...mapActions('subscription', ['fetchSubscriptions']),
    }
  }
</script>

<style lang="scss" scoped>
  $heading-height: 100px;
  $grey-dark-1: #777;
  $grey: #999;
  $grey-light-1: #b5b5b5;
  $grey-light-2: #e5e5e5;

  $font-size-small-1: 14px;
  $font-size: 16px;
  $font-size-large-1: 18px;
  $font-size-large-2: 20px;
  $font-size-large-3: 22px;

  $space-1: 5px;
  $space-2: 10px;
  $space-3: 15px;

  // .card--profile .v-toolbar {
  //   position: absolute;
  //   top: 0;
  //   left: 0;
  //   width: 100%;
  //   background: transparent;
  // }

  .v-toolbar__title {
    font-size: $font-size-small-1;
    color: $grey-dark-1;
    text-transform: uppercase;
  }

  .heading {
    display: flex;
    align-items: center;
    justify-content: center;
    height: $heading-height;
    background: $grey-light-2;
  }

  .heading .heading__icon {
    color: $grey-light-1;
    font-size: $heading-height * .8;
  }

  h3.title {
    font-size: 22px !important;
    font-weight: 500 !important;
  }

  .info-entry {
    margin-bottom: 15px;
  }

  .info-entry .v-icon {
    color: $grey-light-1;
    font-size: $font-size-large-2;
    margin-right: 5px;
  }

  .info-entry .info-entry__label {
    color: $grey;
    text-transform: uppercase;
    font-size: $font-size-small-1;
    padding-bottom: 0;
  }

  .info-entry .info-entry__value {
    font-size: $font-size;
  }
</style>
