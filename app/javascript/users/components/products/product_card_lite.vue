<template>
    <v-card
      class="mx-auto ma-6"
      width="500"
      flat
      outlined
      hover
    >
      <router-link :to="{ name: 'ProductShow', params: { id: product.id } }" class="no-underline">
        <v-img
          class="white--text"
          width="100%"
          max-height="200px"
          :src="require(`../../assets/images/${categoryImageName}`)"
          alt="course image"
        >
        <v-card-title class="align-end fill-height"></v-card-title>
        </v-img>

        <v-card-text>
          <strong>{{ product.name }}</strong> <v-icon>mdi-currency-{{ product.currency || 'eur' }}</v-icon> {{ product.price }}<br>
          <span>{{ category_name }}</span>
          <span v-if="isSelected"><strong>{{ $t('product.is_selected') }}</strong> <v-icon color="success">mdi-check-bold</v-icon></span>
        </v-card-text>

        <v-card-actions>
          <v-btn
            text
            color="primary"
          >
            {{ $t('product.show_action') }}
          </v-btn>
        </v-card-actions>
      </router-link>
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
  /*.v-card {*/
  /*  margin-bottom: 20px;*/
  /*}*/

  .no-underline {
    text-decoration: none;
  }

  .v-card__title {
    text-shadow: 2px 2px #666;
  }
</style>
