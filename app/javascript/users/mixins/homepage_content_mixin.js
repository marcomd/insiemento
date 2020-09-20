import { mapState } from 'vuex'

export const homepageContentMixin = {
  computed: {
    ...mapState('application', ['current_organization']),
    isCurrentOrganizationPresent() {
      return !!this.current_organization.name
    },
    currentOrganizationName() {
      return this.current_organization.name || 'insiemento.com'
    },
    organizationHomepageData() {
      return this.current_organization.homepage
    },
    organizationEmail() {
      return this.current_organization.email || 'info@insiemento.com'
    },
    organizationLogo() {
      // if (this.current_organization.logo) console.log('ATTENZIONE: caricare il logo per la compagnia ', this.current_organization.id)
      return this.current_organization.logo || require('../../../assets/images/logo_200.png') //
    },
  },
}
