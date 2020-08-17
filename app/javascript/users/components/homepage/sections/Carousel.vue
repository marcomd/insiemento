<template>
  <section id="carousel">
    <v-carousel v-if="organizationImages">
      <v-carousel-item
          v-for="(item,i) in organizationImages"
          :key="i"
          :src="item"
          reverse-transition="fade-transition"
          transition="fade-transition"
      ></v-carousel-item>
    </v-carousel>
  </section>
</template>

<script>
  import { homepageContentMixin } from '../../../mixins/homepage_content_mixin'

  export default {
    name: 'SectionCarousel',

    provide: {
      theme: { isDark: true },
    },

    mixins: [
      homepageContentMixin,
    ],

    computed: {
      organizationImages() {
        return this.current_organization.images
      },
    },
  }
</script>
