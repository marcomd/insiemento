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
          <br>
          <span><v-icon>mdi-calendar-arrow-right</v-icon> <strong>{{ formattedDateTime(course_event.event_date) }}</strong></span><br>
          <span>{{ $t('course_event.attributes.attendees_count') }}: {{ course_event.attendees_count }} / {{ room.max_attendees }}</span>
          <span v-if="course_event.subscribed">{{ $t('course_event.attributes.subscribed') }}  <v-icon color="success">mdi-check-bold</v-icon></span>
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
    </v-card>
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
