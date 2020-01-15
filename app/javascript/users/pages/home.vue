<template>
  <v-container>
    <v-row cols='12' sm='8' md='6' lg='4'>
      <v-col>
        <v-carousel
          show-arrows-on-hover
          cycle
          interval="3000"
          hide-delimiter-background
          height="400px"
        >
          <v-carousel-item
            v-for="slide in slides"
            :key="slide.color"
          >
            <v-sheet
              :color="slide.color"
              height="100%"
              tile
            >
              <v-row
                class="fill-height"
                align="center"
                justify="center"
              >
                <div class="display-3">{{ slide.title }}</div>
              </v-row>
            </v-sheet>
          </v-carousel-item>
        </v-carousel>
      </v-col>
    </v-row>
    <AuthenticationButtons>
      <v-btn x-large
             color='success'
             class='mr-2 mb-2'
             :to='{name: "dashboard"}'>
        {{ $t('sidebar.dashboard') }}
      </v-btn>
    </AuthenticationButtons>
  </v-container>
</template>

<script>
  import AuthenticationButtons from '../components/session/authentication_buttons'
  import { mapGetters } from 'vuex'

  export default {
    components: {
      AuthenticationButtons
    },
    data () {
      return {
      }
    },
    computed: {
      slides() {
        return [
          { color: 'primary', title: this.$t('home.step1') },
          { color: 'secondary', title: this.$t('home.step2') },
          { color: 'orange', title: this.$t('home.step3') },
        ]
      },
      ...mapGetters('session', [
        'isLoggedIn'
      ])
    }
  }
</script>
