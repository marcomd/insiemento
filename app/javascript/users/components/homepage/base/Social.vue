<template>
  <v-theme-provider :dark="dark">
    <div>
      <base-info-card
        :title="title"
        color="primary"
      >
        <slot />
      </base-info-card>

      <template v-for="({ icon, text, title: t }, i) in elements">
        <a :href="text">
          <base-avatar-card
              :key="i"
              :icon="icon"
              :outlined="false"
              :title="!dense ? t : undefined"
              color="transparent"
              horizontal
              space="0"
          >
            <!-- Do not use v-html for user -->
            <!-- provided values -->
          </base-avatar-card>
        </a>

        <v-divider
          v-if="i + 1 !== elements.length"
          :key="`divider-${i}`"
          class="my-2"
        />
      </template>
    </div>
  </v-theme-provider>
</template>

<script>
  export default {
    name: 'BaseSocial',

    props: {
      dark: Boolean,
      dense: Boolean,
      title: String,
      elements: {
        type: Array,
        required: true
      }
    },

    data: () => ({
    }),
  }
</script>
