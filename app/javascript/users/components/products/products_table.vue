<template>
    <v-container fluid>
        <v-card>
            <v-card-title>
                <v-select
                        v-model="search"
                        :items="categories"
                        :label="$t('product.list.select_category_label')"
                        hide-details
                        cache-items
                        clearable
                ></v-select>
                <v-spacer></v-spacer>
                <v-text-field
                        v-model="search"
                        append-icon="mdi-magnify"
                        :label="$t('commons.search')"
                        single-line
                        hide-details
                        clearable
                        v-if="$vuetify.breakpoint.smAndUp"
                ></v-text-field>
            </v-card-title>
            <v-data-table
                    :headers="headers"
                    :items="products"
                    :search="search"
                    :items-per-page="itemsPerPage"
                    class="elevation-1"
                    @click:row="selectRow"
                    :multi-sort="true"
            >
                <template v-slot:item.event_date="{ item }">
                    {{ formattedDateTime(item.event_date, 'dddd D MMMM H:mm') }}
                </template>
                <template v-slot:item.selected="{ item }">
                    <v-chip :color="item.selected ? 'green' : '#cccccc'" dark>{{ item.selected ? $t('commons.say_yes') : $t('commons.say_no') }}</v-chip>
                </template>
            </v-data-table>
        </v-card>
    </v-container>
</template>

<script>
    import { utilityMixin } from '../../mixins/utility_mixin'
    import { productMixin } from "../../mixins/product_mixin"
    import { mapActions } from 'vuex'

    export default {
    props: {
      products: {
        type: Array,
        required: true
      }
    },
    mixins: [
      utilityMixin,
      productMixin,
    ],
    created() {
      this.search = this.$store.state.layout.search
    },
    data() {
      return {
        search: '',
        selectedCourse: null,
        headers: [
          // { text: 'ID', value: 'id' },
          { text: this.$t('product.attributes.category'), value: 'category_name' },
          { text: this.$t('product.attributes.name'), value: 'name' },
          { text: this.$t('product.attributes.price'), value: 'price' },
          { text: this.$t('product.attributes.days'), value: 'days' },
        ]
      }
    },
    computed: {
      categories() {
        return Array.from(new Set(this.products.map(product => product.category_name)))
      },
      itemsPerPage() {
        return this.$vuetify.breakpoint.xsOnly ? 1 : (this.$vuetify.breakpoint.mdAndUp ? 15 : 5)
      },
    },
    methods: {
      ...mapActions('layout', ['setSearch']),
      selectRow(product) {
        this.$emit('select-product', {
          product: product
        })
      },
    },
    watch: {
      search(value) {
        // console.log('watch search', value)
        this.setSearch(value)
      },
    },
  }
</script>

<style lang="scss" scoped></style>