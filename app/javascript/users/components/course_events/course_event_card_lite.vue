<template>
    <v-card
      class="mx-auto ma-6"
      width="500"
      flat
      outlined
      hover
      :dark="course_event.subscribed"
    >
      <router-link :to="{ name: 'courseEventShow', params: { id: course_event.id } }" class="no-underline">
        <img
          class="white--text"
          height="250px"
          src="../../assets/images/course_zumba_600.jpg"
          alt="course image"
        >
          <v-card-title class="align-end fill-height"></v-card-title>
        </img>

        <v-card-text>
          <!--span v-html="i18n_reservation_code"></span><br>
          <span v-html="this.$t('reservation.attributes.stay_period', { from: this.formattedDate(this.order.checkin_date), to: this.formattedDate(this.order.checkout_date) })"-->
            <v-icon>mdi-calendar-arrow-right</v-icon> {{ formattedDateTime(course_event.event_date) }}
            <!--v-icon>mdi-ray-start-arrow</v-icon> {{ order.checkout_date }}-->
          </span><br>
          <span>{{ $t('course_event.attributes.course') }}: <strong>{{ course.name }}</strong></span><br>
          <span>{{ $t('course_event.attributes.room') }}: <strong>{{ room.name }}</strong></span><br>
          <span>{{ $t('course_event.attributes.trainer') }}: <strong>{{ trainer.nickname }}</strong></span><br>
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
    </v-card>
</template>

<script>
  import { utilityMixin } from '../../mixins/utility_mixin'

  export default {
    components: {

    },
    mixins: [ utilityMixin ],
    props: {
      course_event: {
        type: Object,
        required: true
      }
    },
    computed: {
      course() {
        return this.course_event.course
      },
      room() {
        return this.course_event.room
      },
      trainer() {
        return this.course_event.trainer
      },
      courseEventImage() {
        return `../../assets/images/course_${this.course.name.toLowerCase()}_600.jpg`
      },
    }
  }
</script>

<style lang="scss" scoped>
  /*.v-card {*/
  /*  margin-bottom: 20px;*/
  /*}*/

  .no-underline {
    text-decoration: none;
  }

  .v-card__title {
    text-shadow: 2px 2px #666;
  }
</style>
