// Automatically loads and bootstraps files
// in the "./src/components/base" folder.

// Imports
import Vue from 'vue'

// Used in the homepage
import upperFirst from 'lodash/upperFirst'
import camelCase from 'lodash/camelCase'

const requireComponent = Object.values(
    import.meta.glob('../components/homepage/base/*.vue', { eager: true })
)
// console.log('Loading base components globally', requireComponent)

for (const file of requireComponent) {
  const name = file.default.name
  const componentName = upperFirst(camelCase(name))

  // console.log(componentName, file.default)
  Vue.component(componentName, file.default)
}