
export const productMixin = {
  computed: {
    // The object this.user.pending_order is copied to this.user
    pending_order() {
      return this.order
    },
    selectedProducts() {
      return this.pending_order && this.pending_order.products ? this.pending_order.products : []
    },
    isSelected() {
      return !!this.selectedProducts.find(product => product.id == this.product.id)
    },
    category_name() {
      this.product.category_name.toLowerCase()
    },
    categoryImageName() {
      const planned_categories = ['fitness', 'spa', 'aquagym']
      return `category_${planned_categories.includes(this.category_name) ? this.category_name : planned_categories[0]}.jpg`
    },
  },
}
