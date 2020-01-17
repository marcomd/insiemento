export const sessionMixin = {
  computed: {
    redirectToParam() {
      return this.$route.query.redirectTo
    },
  },
  methods: {
  }
}
