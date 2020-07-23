<template>
  <base-section id="features">
    <base-section-heading title="Caratteristiche">
      Insiemento è un software open source sviluppato da Marco Mastrodonato per gestire prenotazioni di corsi.
      E' un software giovane ma già ricco di funzioni.
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
  export default {
    name: 'SectionFeatures',

    data: () => ({
      features: [
        {
          title: 'Contratto elettronico',
          icon: 'mdi-fountain-pen-tip',
          text: "Vuoi evitare ai tuoi clienti la scomodità di un contratto cartaceo? Puoi usare il nostro servizio di firma elettronica.",
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
          text: "Rubrica  clienti, ricerca rapida ed altre caratteristiche esclusive come la homepage. Inoltre, il software è in continuo miglioramento e se vorrai potrai dare il tuo contributo per migliorarlo.",
        },
        {
          title: 'Prezzi chiari',
          icon: 'mdi-ice-pop',
          text: "Paghi in base al numero di atleti, solo 50 centesimi al mese per ognuno.",
        },
        {
          title: 'Gestionale adatto a tutti',
          icon: 'mdi-account-supervisor-circle',
          text: "Forniamo due interfacce: una per chi utilizza il servizio, veloce e mobile ready, e una per gli amministratori del gestionale, ottimizzato per il desktop.",
        },
      ],
    }),
  }
</script>
