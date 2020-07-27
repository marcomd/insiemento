import { mapState } from 'vuex'

export const homepageContentMixin = {
  computed: {
    ...mapState('application', ['current_organization']),
    organizationHomepageData() {
      return this.current_organization.homepage
    },
    organizationEmail() {
      return this.current_organization.email || 'support@insiemento.com'
    },
  },
}
