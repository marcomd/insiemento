![](/app/assets/images/logo_100.png)

[![CircleCI](https://circleci.com/gh/marcomd/insiemento.svg?style=svg)](https://circleci.com/gh/marcomd/insiemento)

# Insiemento

The name is a mix of italian words: Insieme (togheter) - Momento (moment)

## What is it?

Insiemento is a management application for gyms and fitness centers.
It provides a desktop graphical interface for administrators, a modern and responsive graphical interface
for users.

The first milestone has been reached: the management of fitness courses and the basic structure to allow
users to register and book courses.

The second milestone is in progress: add multitenant management to host multiple organizations on the
same platform.
Each can have a dedicated instance which selects the ID via ENV.
Alternatively, they can be hosted on the same instance, selected via subdomain.

The third milestone planned concerns customer subscriptions and the management of products that each
organization will be able to configure.

## How does it work

Allows administrators to configure via UI:

- Organizations
- Courses
- Trainers
- Rooms where the courses will be phisically done
- Define the program of the week: course, trainer, room, day and time

An automatism:

- Every week creates the events defined in the program

Users:

- Sign up with the web app
- They choose the courses they wish to participate in
- They go to the gym

Each course has its parameters:

- From when it is possible to book, from when to cancel etc.

Things we may want to cover:

- [x] A backend with ui for admin users
- [x] A mobile responsive front end in VueJS for users
- [x] A login/sign up with confirmation and reset password, sent by sendgrid
- [x] Milestone1: Management of fitness training sessions (course events)
- [x] Milestone2: Organizations for multitenant management `v0.5.0`
- [ ] Products management
- [ ] Milestone3: Customers subscription management
- [ ] Milestone4: Organizations fee management

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

Consente agli amministratori di configurare tramite UI:

- Organizzazioni
- Corsi
- Istruttori
- Stanze dove si terranno i corsi fisicamente
- Definire il programma della settimana: corso, istruttore, stanza, giorno e orario

Un automatismo:

- Ogni settimana crea gli eventi definiti nel programma

Gli utenti:

- Si registrano con la web app
- Scelgono i corsi a cui desiderano partecipare
- Si recano in palestra

Ogni corso ha i suoi parametri:

- Da quando è possibile prenotarsi, da quando disdire ecc.