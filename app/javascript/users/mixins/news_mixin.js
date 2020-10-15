
export const newsMixin = {
  computed: {
    organizationPublicNews() {
      return this.current_organization.news.filter(n => n.public_news)
    },
    organizationPrivateNews() {
      return this.current_organization.news.filter(n => n.private_news)
    },
    hasOrganizationNews() {
      return this.organizationNews.length > 0
    },
  },
}
