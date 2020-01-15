<template>
  <v-footer v-if='showFooter'>
    <v-container class="text-center">
      <!-- In valutazione... -->
      <!--v-row class="itw-footer">
        <v-col v-for="section in []" class="text-left">
          <div class="text-uppercase">
            {{ section.name }}
          </div>
          <v-row v-for="item in section.items">
            <v-col>
              <v-btn
                text
                small
                :href="item.href"><v-icon left>{{ item.icon }}</v-icon> {{ item.name }}</v-btn>
            </v-col>
          </v-row>
        </v-col>
      </v-row-->
      <!--v-row class="itw-footer">
        <v-col>
          <v-btn
            v-for="social in socials"
            :key="social.icon"
            class="mx-4"
            icon
            :href="social.href"
            :title="social.hint"
          >
            <v-icon size="24px">mdi-{{ social.icon }}</v-icon>
          </v-btn>
        </v-col>
      </v-row>
      <v-row class="itw-footer">
        <v-col v-for="office in offices">
          <strong>{{ office.name }}:</strong> {{ office.address }}
        </v-col>
      </v-row-->
    </v-container>
  </v-footer>
</template>

<script>
//  import { orderMixin } from '../../mixins/order_mixin'

  export default {
    mixins: [ ],
    computed: {
      // Ho abbozzato qualcosa di vicino al sito principale ma è troppo diverso, conviene qualcosa di minimal e un link al sito
      // sections() {
      //   return [
      //     { name: this.$t('customer.type_business'),
      //       items: [
      //         { name: this.$t('footer.who_we_are'), href: 'https://info.italianway.house/chi-siamo/', icon: 'mdi-domain' },
      //         { name: this.$t('footer.work_with_us'), href: 'https://info.italianway.house/chi-siamo/', icon: 'mdi-briefcase-outline' },
      //       ] }
      //   ]
      // },
      // offices() {
      //   return [
      //     { name: this.$t('footer.offices.operational'), address: 'Via Carlo Goldoni 32 - 20129 Milano' },
      //     { name: this.$t('footer.offices.registered'), address: 'Via Carlo de Cristoforis 2 - 20124 Milano' },
      //     { name: 'Italianway S.p.A', address: this.$t('footer.vat', { vat: '08839180968' }) },
      //   ]
      // },
      // socials() {
      //   return [
      //     { icon: 'facebook', href: 'https://it-it.facebook.com/italianway.house/' },
      //     { icon: 'instagram', href: 'https://www.instagram.com/italianwayhouse' },
      //     { icon: 'twitter', href: 'https://twitter.com/italianwayhouse' },
      //     { icon: 'linkedin', href: 'https://www.linkedin.com/company/italianway-srl/' },
      //     { icon: 'email-outline', hint: this.$t('footer.hints.at'), href: 'https://www.italianway.house/' },
      //   ]
      // },
      showFooter() {
        // don't show footer in checkin steps
        // return !['checkinGuests', 'checkinContract', 'checkinInvoice', 'checkinSummary'].includes(this.$route.name)
        return false // hide footer
      }
    }
  }
</script>

<style lang="scss">
  .itw-footer {
    color: #999;
  }
</style>
