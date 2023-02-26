<template>
  <base-section
    id="affiliates"
    class="grey lighten-4"
    space="36"
  >
    <v-container>
      <base-section-heading title="Chi sta usando Insiemento?" />

      <v-slide-group>
        <template v-for="(affiliate, index) in affiliates" :key="index">
          <v-slide-item
            class="align-self-center"
          >
            <a :href="affiliate.url">
              <base-img
                  :src="require(`../../../assets/images/logo-affiliate-${affiliate.name}.png`)"
                  color="grey"
                  contain
                  :height="affiliate.height"
                  :width="affiliate.width"
              />
            </a>

          </v-slide-item>

          <v-responsive
            v-if="index < 6"
            :key="`divider-${index}`"
            class="text-center"
            height="56"
            width="48"
          >
            <v-divider vertical v-if="index+1 < affiliates.length"/>
          </v-responsive>
        </template>
      </v-slide-group>
    </v-container>
  </base-section>
</template>

<script>
  export default {
    name: 'SectionAffiliates',
    computed: {
      affiliates() {
        return [
          { name: 'fitness' , height: '50', width: '120', url: null },
          { name: 'dsm'     , height: '100', width: '100', url: 'https://www.dsmdanceschool.it' },
          { name: 'victor'  , height: '70', width: '70', url: null },
        ]
      },
    }
  }
</script>
