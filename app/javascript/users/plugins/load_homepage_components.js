// Automatically loads and bootstraps files
// in the "./src/components/base" folder.

// Imports
// import * as Vue from 'vue'

// Used in the homepage
import upperFirst from 'lodash/upperFirst'
import camelCase from 'lodash/camelCase'

export default function LoadHomepageComponents(app) {
  const requireComponent = Object.values(
      import.meta.glob('../components/homepage/base/*.vue', { eager: true })
  )

  //console.log('requireComponent', requireComponent)
  for (const file of requireComponent) {
    // const componentConfig = requireComponent(file)
    const name = file.default.__file
        .replace(/index.js/, '')
        .replace(/^\.\//, '')
        .replace(/\.\w+$/, '')
    const componentName = upperFirst(camelCase(name))

    // app.component(`Base${componentName}`, componentConfig.default || componentConfig)
    app.component(`Base${componentName}`)
  }
}
