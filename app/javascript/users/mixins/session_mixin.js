export const sessionMixin = {
  computed: {
    redirectToParam() {
      return this.$route.query.redirectTo
    },
  },
  methods: {
    getUuidFromPath(path) {
      if (!path) return
      // Example: aebf8c9e-0467-43c1-838f-526e8318562e
      const result = path.match(/orders\/([a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+)/)
      if (!result) return
      return result[1]
    },
  }
}
