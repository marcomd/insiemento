<template>
  <base-section
    id="features"
    class="secondary"
  >
    <v-responsive
      class="mx-auto"
      max-width="1350"
    >
      <v-container fluid>
        <v-row>
          <v-col
            v-for="card in cards"
            :key="card.title"
            cols="12"
            sm="4"
            md="3"
          >
            <base-info-card
              align="center"
              dark
              v-bind="card"
            />
          </v-col>
        </v-row>
      </v-container>
    </v-responsive>
  </base-section>
</template>

<script>
  export default {
    name: 'SectionFeatures',

    data: () => ({
      cards: [
        {
          icon: 'mdi-server',
          title: 'Affidabilità',
          text: "Ci affidiamo ad un'architettura sicura che garantisce continuità e prestazioni sempre all'altezza. Siamo in costante ricerca di nuove tecnologie che possano migliorare il servizio.",
        },
        {
          icon: 'mdi-text-box-multiple-outline',
          title: 'Disponibilità documenti',
          text: "Garantiamo la disponibilità dei tuoi documenti online, per te e i firmatari, che potranno essere recuperati online in autonomia per almeno 10 anni dalla creazione della pratica.",
        },
        {
          icon: 'mdi-help-circle-outline',
          title: 'Supporto tecnico italiano',
          text: 'Se hai bisogno di supporto tecnico per la soluzione enterprise ti risponderanno direttamente gli sviluppatori del software della sede di Milano, mai un call center extra UE.',
        },
        {
          icon: 'mdi-keyboard-outline',
          title: 'Trendy',
          text: "Il nostro team di grafici ha fatto un ottimo lavoro e i tuoi clienti che useranno il nostro servizio percepiranno la qualità della tua impresa con la modernità che merita.",
        },
      ],
    }),
  }
</script>
