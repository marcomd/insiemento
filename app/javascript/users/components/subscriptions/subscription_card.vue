<template>
	<div>
		<v-subheader
				:key="`header${subscription.id}`"
				v-text="subscription.category_name"
		></v-subheader>

		<v-list-item
				:key="`body${subscription.id}`"
				@click.stop="dialog = true"
		>
			<v-list-item-avatar>
				<v-icon	:class="subscription.state == 'active' ? 'green' : 'grey'"></v-icon>
			</v-list-item-avatar>

			<v-list-item-content>
				<v-list-item-title>{{ subscription.product.name }}</v-list-item-title>
				<v-list-item-subtitle>{{ $t('profile.validity_range', {from: formattedDate(subscription.start_on), to: formattedDate(subscription.end_on)}) }}</v-list-item-subtitle>
				<v-list-item-subtitle v-if="subscription.max_accesses_number">{{ $t('commons.usage') }} {{ subscription.attendees_count }} / {{ subscription.max_accesses_number }}</v-list-item-subtitle>
			</v-list-item-content>
		</v-list-item>

		<v-divider
				:key="`divider${subscription.id}`"
				inset
		></v-divider>

		<div class="text-center">
			<v-dialog
					v-model="dialog"
					width="500"
			>
				<v-card>
					<v-card-title class="headline grey lighten-2">
						{{ subscription.code }}
					</v-card-title>

					<v-card-text>
						<v-list v-if="subscription.attendees && subscription.attendees.length > 0">
							<v-list-item v-for="attendee in subscription.attendees"
													 :key="attendee.id">
								<v-list-item-content>
									<v-list-item-title>{{ formattedDateTime(attendee.course_event.event_date) }}</v-list-item-title>
									<v-list-item-subtitle>{{ attendee.course_event.course }} con {{ attendee.course_event.trainer }}</v-list-item-subtitle>
								</v-list-item-content>
							</v-list-item>
						</v-list>
						<p class="text-center pt-9" v-else>
							{{ $t('profile.no_attendees') }}
						</p>
					</v-card-text>

					<v-divider></v-divider>

					<v-card-actions>
						<v-spacer></v-spacer>
						<v-btn
								color="primary"
								text
								@click="dialog = false"
						>
							{{ $t('commons.close') }}
						</v-btn>
					</v-card-actions>
				</v-card>
			</v-dialog>
		</div>
	</div>
</template>

<script>
  import { utilityMixin } from '../../mixins/utility_mixin'

  export default {
    props: {
      subscription: {
        type: Object,
        required: true
      }
    },

		mixins: [
      utilityMixin,
		],

    data() {
      return {
        dialog: null,
      }
    }
  }
</script>