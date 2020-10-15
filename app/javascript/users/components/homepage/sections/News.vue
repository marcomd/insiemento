<template>
  <section id="news">
    <v-carousel v-if="hasOrganizationNews"
                cycle
                show-arrows-on-hover>
      <v-carousel-item
          v-for="(item,i) in organizationNews"
          :key="i"
      >
        <!--v-card
            class="ma-auto"
            max-width="800"
            height="400"
            :dark="item.dark_style"
            :light="!item.dark_style"
            :color="getColor(item, item.dark_style)"
        >
          <v-card-title>
            <div class="display-1" :style="`width: 100%; text-align: center; color: ${getColor(item, !item.dark_style)}`">
              {{ item.title }} <v-icon x-large :color="getColor(item, !item.dark_style)"  >{{ item.icon }}</v-icon>
            </div>
          </v-card-title>

          <v-divider />

          <v-card-text class="headline font-weight-bold" :style="`width: 100%; text-align: center; color: ${getColor(item, !item.dark_style)}`">
            {{ item.body }}
          </v-card-text>
        </v-card-->
        <v-sheet :color="getColor(item, item.dark_style)" :dark="item.dark_style" :light="!item.dark_style" height="100%">
          <v-row
              class="fill-height pa-5"
              align="center"
              justify="center"
          >
            <div>
              <div class="display-2 text-center" :style="`width: 100%; color: ${getColor(item, !item.dark_style)}`">
                {{ item.title }} <v-icon x-large :color="getColor(item, !item.dark_style)">{{ item.icon }}</v-icon>
              </div>
              <v-divider />
              <div class="text-center">
                {{ item.body }}
              </div>
            </div>
          </v-row>
        </v-sheet>
      </v-carousel-item>
    </v-carousel>
  </section>
</template>

<script>
  import { homepageContentMixin } from '../../../mixins/homepage_content_mixin'
  import { newsMixin } from '../../../mixins/news_mixin'

  export default {
    name: 'SectionNews',

    provide: {
      theme: { isDark: true },
    },

    mixins: [
      homepageContentMixin,
      newsMixin,
    ],

    computed: {
      organizationNews() { return this.organizationPublicNews }
    },

    methods: {
      // getColor(item, dark) { return dark ? item.color : `${item.color} lighten-4` },
      getColor(item, dark) { return dark ? item.color : null },
    },
  }
</script>

