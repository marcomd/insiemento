<template>
    <v-card
      :class="cssClassCard"
      width="500"
      flat
      outlined
      hover
    >
      <router-link :to="{ name: 'courseEventShow', params: { id: course_event.id } }" class="no-underline">
        <v-img
          class="white--text"
          width="100%"
          max-height="200px"
          :src="require(`../../assets/images/${courseImageName}`)"
          alt="course image"
        >
        <v-card-title class="align-end fill-height"></v-card-title>
        </v-img>

        <v-card-text>
          <strong>{{ course.name }}</strong> {{ `${$t('commons.with')} ${trainer_name}` }}
          </span><br>
          <span><v-icon>mdi-calendar-arrow-right</v-icon> {{ formattedDateTime(course_event.event_date) }}</span><br>
          <span>{{ $t('course_event.attributes.attendees_count') }}: <strong>{{ course_event.attendees_count }}</strong> / <strong>{{ room.max_attendees }}</strong></span>
          <span v-if="course_event.subscribed"><strong>{{ $t('course_event.attributes.subscribed') }}</strong> <v-icon color="success">mdi-check-bold</v-icon></span>
        </v-card-text>

        <v-card-actions>
          <v-btn
            text
            color="primary"
          >
            {{ $t('course_event.list.select_action') }}
          </v-btn>
        </v-card-actions>
      </router-link>
    </v-card
      class="mx-auto ma-6">
</template>

<script>
  import { utilityMixin } from '../../mixins/utility_mixin'
  import { courseEventMixin } from '../../mixins/course_event_mixin'

  export default {
    components: {
    },
    mixins: [ utilityMixin, courseEventMixin ],
    props: {
      course_event: {
        type: Object,
        required: true
      },
      cssClassCard: {
        type: String,
        default: ''
      },
    },
    computed: {
    }
  }
</script>

<style lang="scss" scoped>
  .no-underline {
    text-decoration: none;
  }

  .v-card__title {
    text-shadow: 2px 2px #666;
  }
</style>
