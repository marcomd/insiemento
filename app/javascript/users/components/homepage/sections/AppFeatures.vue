<template>
  <base-section id="features">
    <base-section-heading :title="primaryFeaturesTitle">
      {{ primaryFeaturesSummary }}
    </base-section-heading>

    <v-container>
      <v-row>
        <v-col
          v-for="(feature, i) in features"
          :key="i"
          cols="12"
          md="6"
        >
          <base-avatar-card
            v-bind="feature"
            align="left"
            horizontal
          >
            {{ feature.text }}
          </base-avatar-card>
        </v-col>
      </v-row>
    </v-container>
  </base-section>
</template>

<script>
  import { homepageContentMixin } from '../../../mixins/homepage_content_mixin'

  export default {
    name: 'SectionFeatures',

    mixins: [
      homepageContentMixin,
    ],

    data: () => ({
    }),

    computed: {
      primaryFeaturesTitle() {
        return this.organizationHomepageData ? this.organizationHomepageData.homepage_features_title : "Caratteristiche"
      },
      primaryFeaturesSummary() {
        return this.organizationHomepageData ? this.organizationHomepageData.homepage_features_summary : "Insiemento è un gestionale open source per gestire prenotazioni di qualunque tipo di corsi. E' un software giovane ma già ricco di funzioni. Potete scaricarlo ed utilizzarlo a piacimento. Acquistando questo servizio invece contribuirete allo sviluppo del software."
      },
      features() {
        return this.organizationHomepageData ? this.organizationHomepageData.homepage_features : this.applicationFeatures
      },
      applicationFeatures() {
        return [
          {
            title: 'Firma elettronica',
            icon: 'mdi-fountain-pen-tip',
            text: "Dimentica la carta e usa il nostro servizio di firma elettronica! Contratto, autocertificazione covid-19 ogni 14 giorni, ecc. Configura il tuo documento e lo faremo firmare per te.",
          },
          {
            title: 'Adatto anche su dispositivi mobile',
            icon: 'mdi-cellphone',
            text: "Abbiamo realizzato un'interfaccia web moderna che si adatta in automatico a tutti i tipi di dispositivi.",
          },
          {
            title: 'Personalizzabile',
            color: 'primary',
            dark: true,
            icon: 'mdi-pencil-box-outline',
            text: "Le email che invieremo ai tuoi clienti avranno il tuo logo e i tuoi colori, che potrai gestire in autonomia.",
          },
          {
            title: 'Ricco di funzioni',
            icon: 'mdi-star-circle-outline',
            text: "Rubrica  clienti, lista presenze ed altre caratteristiche esclusive come la homepage. Inoltre, il software è in continuo miglioramento e se vorrai potrai dare il tuo contributo per migliorarlo.",
          },
          {
            title: 'Prezzi chiari',
            icon: 'mdi-ice-pop',
            text: "Paghi in base al numero di atleti, solo 50 centesimi al mese per ognuno. I servizi extra invece, come la firma elettronica, li paghi solo se li utilizzi.",
          },
          {
            title: 'Gestionale adatto a tutti',
            icon: 'mdi-account-supervisor-circle',
            text: "Forniamo due interfacce: una per chi utilizza il servizio, veloce e mobile ready, e una per gli amministratori del gestionale, ottimizzato per il desktop.",
          },
        ]
      },
    },
  }
</script>
