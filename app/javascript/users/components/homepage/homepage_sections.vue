<template>
	<section :id="id">
		<v-row no-gutters>
			<v-col cols="12">
				<component
						:is="`section-${section}`"
						v-for="section in showed_sections"
						:key="section"
				/>
			</v-col>
		</v-row>
	</section>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    name: 'BaseView',

    props: {
      id: {
        type: String,
        default: 'view',
      },
    },

    data: () => ({ sections: [] }),

		// created() {
    //   console.log(`BaseView sections:`, this.sections)
		// },
    computed: {
      ...mapState('application', ['current_organization']),
      showed_sections() {
        if (this.current_organization.homepage) {
          return this.sections.filter(x => !['affiliates', 'pro-features'].includes(x))
        } else {
          return this.sections
        }
      },
    },
  }
</script>
