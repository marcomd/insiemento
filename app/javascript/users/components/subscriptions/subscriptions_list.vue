<template>
	<v-list three-line>
		<SubscriptionCard v-for="subscription in subscriptions" :key="subscription.id" :subscription="subscription"></SubscriptionCard>
	</v-list>
</template>

<script>
	import SubscriptionCard from './subscription_card'

  export default {
    props: {
			subscriptions: {
			  type: Array,
				required: true
			}
    },

		components: {
      SubscriptionCard,
		},
	}
</script>