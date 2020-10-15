
<script>
  // Extensions
  import View from '../components/homepage/homepage_sections'

  // Mixins
  import LoadSections from '../mixins/homepage-load-sections'

  export default {
    name: 'Home',

    metaInfo: { title: 'Home' },

    extends: View,

    mixins: [
      // All the sections expected in the home page
			// Then the section could be reduced
      LoadSections([
        'hero',
        'app-features',
        'news',
        'carousel',
        // 'features',
        'contact-us',
        'affiliates',
        // 'social-media',
        // 'keep-in-touch',
        // 'newsletter',
        'pro-features',
        'info',
      ]),
    ],

    props: {
      id: {
        type: String,
        default: 'home',
      },
    },
  }
</script>
