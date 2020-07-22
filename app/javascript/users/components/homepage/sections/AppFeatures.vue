<template>
  <base-section id="features">
    <base-section-heading title="Caratteristiche">
      OTP Service è un servizio innovativo per tutte le imprese, adatto anche a quelle più tradizionali che desiderano
      fornire ai loro clienti un servizio facile da usare ma anche attento ai dettagli.
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
          text: "Vuoi evitare ai tuoi clienti di venire a firmare un noiso contratto cartaceo? Puoi usare il nostro servizio di firma elettronica.",
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
          text: "Grazie alla rubrica dei tuoi clienti, alla ricerca rapida e al nostro team di esperti che ha lavorato molto sui dettagli, il tuo lavoro sarà agevolato. Inoltre, il software è in continuo miglioramento e se vorrai potrai dare il tuo contributo per migliorarlo.",
        },
        {
          title: 'Prezzi chiari e a consumo',
          icon: 'mdi-ice-pop',
          text: "Carichi il tuo credito e paghi solo quando usi il servizio senza costi nascosti.",
        },
        {
          title: 'Gestionale adatto a tutti',
          icon: 'mdi-account-supervisor-circle',
          text: "Forniamo due interfacce: una UI per chi lo usa regolarmente, veloce e mobile ready, e una per gli amministratori, che privilegia il desktop e offre più controllo.",
        },
      ],
    }),
  }
</script>
