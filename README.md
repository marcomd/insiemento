![](/app/assets/images/logo_100.png)

[![CircleCI](https://circleci.com/gh/marcomd/insiemento.svg?style=shield)](https://circleci.com/gh/marcomd/insiemento)
[![License](https://img.shields.io/github/license/RubyMoney/money.svg)](https://opensource.org/licenses/MIT)

# Insiemento

The name is a mix of italian words: Insieme (togheter) - Momento (moment)

## What is it?

Insiemento is a management application for gyms and fitness centers.
It provides a desktop graphical interface for administrators, a modern and responsive graphical interface
for users.

The first milestone has been reached: the management of fitness courses and the basic structure to allow
users to register and book courses.

The second milestone is almost completed: add multitenant management to host multiple organizations on the
same platform.
Each can have a dedicated instance which selects the ID via ENV.
Alternatively, they can be hosted on the same instance, selected via subdomain.

The third milestone is in progress: it concerns customer subscriptions and the management of products that each
organization will be able to configure. User must have a valid subscription in order to partecipate to courses.

## How does it work

Allows root administrators to manage via UI:

- Organizations
- Diagnostics
- System logs

Allows administrators of each organization to configure:

- Courses
- Trainers
- Rooms where the courses will be phisically done
- Define the program of the week: course, trainer, room, day and time
- Categories and products (to manage subscriptions)

_In progress_: users can buy products to extend their subscriptions. They create orders with choosen products, 
then pay and gain access. The goal is to create a simple ecommerce to allow users to independently extend their subscription.

An automatism:

- Every week creates the events defined in the program

Users:

- Sign up with the web app
- They choose the courses they wish to participate in (Now each user can attendee only if he own a valid subscription)
- They go to the gym

Each course has its parameters:

- From when it is possible to book, from when to cancel etc.

### Subscriptions

The administrator defines the category, for each one creates one or more products. Codes are generated for each product
that the customer buys to extend the validity of his subscription.

For example:

- Fitness category
  - Product: 30 days price 30€
    - Subscription Code 642b26d9fb1c00
    - Subscription Code 68b15041537759
    - ...
  - Product: 1 year price 300€
    - Subscription Code 7a588db36df631
    - ...
- Swimming pool category
  - Product: x days price x€
    - Subscription Code ...

When a customer redeems a code, he actually extends the validity of his account.

It is possible to have multiple valid subscriptions covering different categories.
To participate in a course, the customer must have an active subscription (not expired) and of the same category
of the course. In this way, it is possible to define multiple types of products that can be purchased separately.

Currently, only administrators can associate a subscription with a customer but it will be automated in the future.

### Things we may want to cover:

- [x] A backend with ui for admin users
- [x] A mobile responsive front end in VueJS for users
- [x] A login/sign up with confirmation and reset password, sent by sendgrid
- [x] Milestone1: Management of fitness training sessions (course events)
- [x] Milestone2: Organizations for multitenant management `v0.5.0`
- [x] Products management
- [x] Milestone3: Customers subscription management `v0.6.0`
- [ ] Milestone4: Orders and payments management, in progress `v0.12.0`
- [ ] Milestone5: Organizations fee management

## Cos'è?

Insiemento è un'applicazione gestionale per palestre e centri fitness.
Fornisce un'interfaccia grafica desktop per gli amministratori, una moderna interfaccia grafica mobile responsive
per gli utenti che utilizzano il servizio.

La prima milestone è stata raggiunta: la gestione dei corsi fitness e la struttura base per consentire
agli utenti di registrarsi e prenotarsi ai corsi.

La seconda milestone è in corso: aggiungere la gestione multitenant per ospitare più organizzazioni sulla 
stessa piattaforma.
Ognuna potrà avere un'istanza dedicata la quale seleziona l'id tramite ENV.
In alternativa potranno essere ospitate sulla stessa istanza, selezionate tramite sottodominio.

La terza milestone prevista riguarda degli abbonamenti dei clienti e la gestione dei prodotti che ogni 
organizzazione potrà configurare.

## Come funziona

Consente agli amministratori root di gestire tramite UI:

- Organizzazioni
- Log di sistema
- Diagnostica

Consente agli amministratori root di configurare tramite UI:

- Corsi
- Istruttori
- Stanze dove si terranno i corsi fisicamente
- Definire il programma della settimana: corso, istruttore, stanza, giorno e orario
- Categorie, prodotti e abbonamenti

Un automatismo:

- Ogni settimana crea gli eventi definiti nel programma

Gli utenti:

- Si registrano con la web app
- Scelgono i corsi a cui desiderano partecipare (se dispongono di un abbonamento valido)
- Si recano in palestra

Ogni corso ha i suoi parametri:

- Da quando è possibile prenotarsi, da quando disdire ecc.

### Abbonamenti

L'amministratore definisce la categoria, per ognuna crea uno o più prodotti. Per ogni prodotto vengono generati dei codici
che il cliente acquista per estendere la validità del proprio abbonamento.

Esempio:

- Categoria Fitness
  - Prodotto Mensile costo 30€
    - Codice 642b26d9fb1c00
    - Codice 68b15041537759
    - ...
  - Prodotto Annuale costo 300€
    - Codice 7a588db36df631
    - ...
- Categoria Piscina
  - Prodotto Giorni x Costo x€
    - Codice ...
    
Quando un cliente riscatta un codice, di fatto estende la validità del suo account.

E' possibile avere più abbonamenti validi che coprono categorie diverse.
Il cliente, per partecipare ad un corso, deve possedere un abbonamento attivo (non scaduto) e della stessa categoria 
del corso. In questo modo, è possibile definire più tipologie di prodotti acquistabili separatamente.

Attualmente, solo gli amministratori possono associare un abbonamento ad un cliente ma in futuro sarà automatizzato.