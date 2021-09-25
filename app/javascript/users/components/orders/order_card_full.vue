<template>
  <v-card
    elevation='1'>
    <v-card-title>{{ $t('order.show.title', {id: this.order.id}) }}</v-card-title>

    <v-card-text>
      <v-row>
        <!--v-icon large>mdi-calendar</v-icon>
        <v-col>
          {{ $t('order.attributes.start_on') }}<br>
          <strong>{{ formattedDate(order.start_on) }}</strong>
        </v-col-->
        <v-col>
          <v-menu
                  ref="menu_start_on"
                  v-model="startOnPickerOpened"
                  :close-on-content-click="false"
                  :nudge-right="40"
                  :return-value.sync="start_on"
                  transition="scale-transition"
                  offset-y
                  max-width="290px"
                  min-width="290px"
          >
            <template v-slot:activator='{ on }'>
              <v-text-field
                      :value='formattedDate(start_on)'
                      :label='$t("order.attributes.start_on")'
                      prepend-icon='mdi-calendar'
                      readonly
                      v-on='on'
              />
            </template>
            <v-date-picker
                    scrollable
                    ref="start_on_picker"
                    v-model='start_on'
                    first-day-of-week='1'
                    :locale='$i18n.locale'
                    :max="max_start_on"
                    min="1900-01-01"
                    @click:date="updateStartOn"
            />
          </v-menu>
        </v-col>

        <v-icon large>mdi-currency-{{ order.currency }}</v-icon>
        <v-col>
          {{ $t('order.attributes.amount_to_pay') }}<br>
          <strong>{{ order.amount_to_pay }}</strong>
        </v-col>
      </v-row>

      <v-row v-if="order.paid_at">
        <v-icon large>mdi-human-calendar</v-icon>
        <v-col>
          {{ $t('order.attributes.paid_at') }} {{ formattedDateTime(order.paid_at) }}<br>
          <v-icon color="success">mdi-check-bold</v-icon>
        </v-col>
      </v-row>

      <v-row>
        <v-col>
          <ProductCardTiny v-for="product in order.products" :key="product.id" :product="product"/>
        </v-col>
      </v-row>
    </v-card-text>
  </v-card>
</template>

<script>
  import ProductCardTiny from '../products/product_card_tiny'
  import { utilityMixin } from '../../mixins/utility_mixin'
  import { orderMixin } from '../../mixins/order_mixin'
  import moment from 'moment'

  export default {
    components: {
      ProductCardTiny
    },
    mixins: [ utilityMixin, orderMixin ],
    props: {
      order: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        start_on: this.order.start_on,
        startOnPickerOpened: false,
        isSubmittingStartOn: false,
      }
    },
    computed: {
      max_start_on() {
        return moment().add(60,'days').format('YYYY-MM-DD')
      },
    },
    methods: {
      updateStartOn() {
        console.log(`updateStartOn order ${this.order.id} ${this.start_on}`)
        this.$refs.menu_start_on.save(this.start_on)
        // const product_ids = this.selectedProducts.map(product => product.id)
        this.$store
          .dispatch(`order/update`, {
                    order_id: this.order.id,
                    params: { order: { start_on: this.start_on } }
                  }
          )
          .then( _ => {
            console.log(`updateStartOn OK updated`)
          })
          .catch(error => {
            const message = error && error.body ? error.body : error

            this.$store.dispatch('layout/replaceAlert', {
              type: 'error',
              message: message
            })
            console.log(`Cannot update start on order ${this.order.id}`, error)
          })
      },
    }
  }
</script>

<style lang="scss" scoped>

</style>
