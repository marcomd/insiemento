<template>
  <v-card elevation='2' class="mt-2">
    <v-list-item three-line>
      <v-list-item-content>
        <div class="overline mb-4">#{{ product.id }}</div>
        <v-list-item-title class="headline mb-1">{{ product.name }}</v-list-item-title>
        <v-list-item-subtitle>{{ product.category_name }}</v-list-item-subtitle>
      </v-list-item-content>
    </v-list-item>

    <v-divider class="mx-4"></v-divider>

    <v-card-text>
      <v-row>
        <v-col>
          {{ $t('product.attributes.price') }}<br>
          <strong><v-icon>mdi-currency-{{ product.currency || 'eur' }}</v-icon> {{ product.price }}</strong>
        </v-col>
        <v-col>
          {{ $t('product.attributes.days') }}<br>
          <strong>{{ product.days }}</strong>
        </v-col>
      </v-row>

      <v-row v-if="product.description">
        <v-col>
          {{ product.description }}
        </v-col>
      </v-row>
    </v-card-text>
  </v-card>
</template>

<script>
  import { utilityMixin } from '../../mixins/utility_mixin'
  import { productMixin } from '../../mixins/product_mixin'

  export default {
    components: {
    },
    mixins: [ utilityMixin, productMixin ],
    props: {
      product: {
        type: Object,
        required: true
      }
    },
    computed: {
    }
  }
</script>

<style lang="scss" scoped>

</style>
