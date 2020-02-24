![](/app/assets/images/logo_100.png)

[![CircleCI](https://circleci.com/gh/marcomd/insiemento.svg?style=svg)](https://circleci.com/gh/marcomd/insiemento)

# Insiemento

It's a mix of italian words: Insieme (togheter) - Momento (moment)

## What is it?

Insiemento is a management application for gyms and fitness centers.
It provides a desktop graphical interface for administrators and a responsive mobile graphical interface
for users.
The first milestone of the project is the management of fitness courses, nextly it will be able to manage customer subscriptions.
Allows administrators to configure:

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

- When it is possible to book, how long to cancel

Things we may want to cover:

- [x] A backend with ui for admin users
- [x] A mobile responsive front end in VueJS for users
- [x] A login/sign up with confirmation and reset password, sent by sendgrid
- [x] Management of fitness training sessions (course events)
- [ ] Customers subscription management

## Cos'è?

Insiemento è un'applicazione gestionale per palestre e centri fitness.
Fornisce un'interfaccia grafica desktop per gli amministratori e un'interfaccia grafica mobile responsive
per gli utenti che fruiscono del servizio.
La prima milestone del progetto è la gestione dei corsi fitness, successivamente potrà gestire gli abbonamenti dei clienti.
Consente agli amministratori di configurare:

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

- Quando è possibile prenotarsi, quanto tempo per disdire ecc.