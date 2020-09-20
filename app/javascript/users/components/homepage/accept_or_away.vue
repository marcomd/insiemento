<template>
    <div class="text-center">
      <v-btn :to='{name: "home"}' color="primary">Si, accetto</v-btn>
      <v-btn href="https://www.google.it">Non accetto</v-btn>
      <div class="mb-30"></div>
    </div>
</template>

<script>
  export default {
  }
</script>

<style lang="scss" scoped>
  .mb-30 { margin-bottom: 120px; }
</style>
