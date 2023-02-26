// Automatically loads and bootstraps files
// in the "./src/components/base" folder.

// Imports
// import * as Vue from 'vue'

export default function LoadHomepageComponents(app) {
  // Used in the homepage
  import upperFirst from 'lodash/upperFirst'
  import camelCase from 'lodash/camelCase'

  const requireComponent = require.context('../components/homepage/base', true, /\.vue$/)

  for (const file of requireComponent.keys()) {
    const componentConfig = requireComponent(file)
    const name = file
        .replace(/index.js/, '')
        .replace(/^\.\//, '')
        .replace(/\.\w+$/, '')
    const componentName = upperFirst(camelCase(name))

    app.component(`Base${componentName}`, componentConfig.default || componentConfig)
  }
}
