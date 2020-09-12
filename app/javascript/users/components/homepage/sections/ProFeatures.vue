<template>
  <base-section
    id="pro-features"
  >
    <!--v-img
      :src="require('../../../../images/logo_light_48.png')"
      class="mx-auto mb-8"
      max-width="48"
    /-->

    <base-section-heading title="Soluzioni e prezzi">
      Ci piacciono le cose  <strong>semplici</strong> e proponiamo solo tre soluzioni in base al tipo di impresa.<br>
      Tutte le caratteristiche sono disponibili e la soluzione enterprise consente anche un accesso ai servizi tramite API (da sistema a sistema).
    </base-section-heading>

    <v-container>
      <v-row
        align="center"
        justify="center"
      >
        <v-col
          cols="12"
          md="7"
        >
          <v-simple-table>
            <thead>
              <tr>
                <th />
                <th class="body-1 font-weight-bold text-center">
                  Basic
                </th>
                <th class="body-1 font-weight-bold text-center">
                  Premium
                </th>
                <th class="body-1 font-weight-bold text-center">
                  Enterprise
                </th>
              </tr>
            </thead>

            <tbody class="body-1">
              <tr
                v-for="([name, one, two, three], i) in features"
                :key="i"
              >
                <td v-text="name" />

                <td class="text-center font-weight-bold">
                  <template v-if="typeof one === 'boolean'">
                    <v-icon :color="one ? 'success' : 'error'">
                      mdi-{{ one ? 'check' : 'close' }}
                    </v-icon>
                  </template>

                  <template v-else>
                    {{ one }}
                  </template>
                </td>

                <td class="text-center font-weight-bold">
                  <template v-if="typeof two === 'boolean'">
                    <v-icon :color="two ? 'success' : 'error'">
                      mdi-{{ two ? 'check' : 'close' }}
                    </v-icon>
                  </template>

                  <template v-else>
                    {{ two }}
                  </template>
                </td>

                <td class="text-center font-weight-bold">
                  <template v-if="typeof three === 'boolean'">
                    <v-icon :color="three ? 'success' : 'error'">
                      mdi-{{ three ? 'check' : 'close' }}
                    </v-icon>
                  </template>

                  <template v-else>
                    {{ three }}
                  </template>
                </td>
              </tr>
            </tbody>
          </v-simple-table>
        </v-col>

        <!--v-col
          cols="12"
          md="5"
        >
          <v-card
            elevation="16"
            class="mb-12"
          >
            <base-img
              max-width="100%"
              src="https://cdn.vuetifyjs.com/store/themes/zero/pro.png"
            />
          </v-card>

          <div class="text-center">
            <base-btn
              :tile="false"
              color="primary"
              href="https://store.vuetifyjs.com/product/zero-theme-pro/?ref=vtyd-pro-page-features"
              rounded
            >
              Buy Pro Now

              <v-icon right>
                mdi-rocket
              </v-icon>
            </base-btn>
          </div>
        </v-col-->
      </v-row>
    </v-container>
  </base-section>
</template>

<script>
  export default {
    name: 'SectionProChart',

    data: () => ({
      features: [
        ['Canone mensile'           , 'Free'      , '0,5€ x atleta' , 'Contattaci'],
        ['Atleti'                   , 10          , 'Illimitati'    , 'Illimitati'],
        ['N. utenze nel gestionale' , 1           , 'Illimitate'    , 'Illimitate'],
        ['Homepage'                 , false       , true            , true        ],
        ['Dominio terzo livello '   , false       , true            , true        ],
        ['Dominio personalizzato'   , false       , 'da 50€ annui'  , 'Contattaci'],
        ['Firma elettronica'        , false       , 'da 1€ cad'     , 'Contattaci'],
        ['Supporto funzionale'      , false       , true            , true        ],
        ['Supporto tecnico'         , false       , false           , true        ],
        ['API'                      , false       , false           , true        ],
      ],
    }),
  }
</script>
