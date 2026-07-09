---
title: Est-il utile d’apprendre React ?
date: '2018-10-03'
excerpt: >-
  Plusieurs tweets m’ont interpelé récemment, par rapport au fait que
  l’écosystème JavaScript s’est dégradé, car concentré autour de plus en plus
  d’outils pas forcément utiles. React en prend notamment pour son grade.
cover: /assets/posts/utile-d-apprendre-react/cover.jpg
lang: fr
tags:
  - life
---

_Note du 5 nov. 2020: cet article date un peu maintenant, mais son propos me
semble toujours valide. [Rayed Benbrahim](https://twitter.com/RayedBenbrahim) a
écrit un article très détaillé que je vous recommande, avec chiffres et conseils
à la clé:
[Est-ce qu’apprendre React est essentiel pour un développeur JavaScript en 2020?](https://practicalprogramming.fr/apprendre-react-en-2020/)_

Plusieurs tweets m’ont interpelé récemment, par rapport au fait que l’écosystème
JavaScript s’est dégradé, car concentré autour de plus en plus d’outils pas
forcément utiles. React en prend notamment pour son grade.

> Ça me rend triste quand même tout ce tooling et cette complexité pour faire
> des webapps JavaScript. Les sites ne sont pas mieux qu'à l'époque de Backbone
> mais si tu n'utilises pas moins de 5 outils et un transpileur et des types, tu
> n'es plus crédible ... M'enfin où va-t-on ?!
>
> – Ph. Charrière sur
> [Twitter](https://twitter.com/k33g_org/status/1047072836895068163)

Cela me désole un peu bien que je comprenne les arguments adressés. Voici ce que
j’en pense… (Je prends l’exemple de React, mais en fait ça peut s’appliquer à
Angular, Vue, etc.)

## Juste le nouveau framework à la mode

C’est un argument que l’on entend beaucoup: React n’est qu’un nouveau framework
comme un autre, il a l’air super à première vue, mais dans deux ans tout le
monde l’aura oublié et des heures de formation et d’expérience pourront être
jetées à la poubelle.

> Entre apprendre Elm et la programmation fonctionnelle, OU apprendre React +
> Webpack + npm + Babel +… + … qui seront tous obselètent un jour ou un autre,
> je préfère miser sur quelque chose d’utile, qui m’enrichit intellectuellement
> et qui me servira plus tard :-). Mon avis :-).
>
> – Ivan Enderlin sur [Twitter](https://twitter.com/mnt_io)

Peut-être que c’est vrai, mais pour ma part mes expériences web professionnelles
et personnelles ont suivi un chemin relativement classique: du PHP, puis du
front-end à l’aide de jQuery, puis du AngularJS, puis du React. Est-ce que pour
autant je regrette de m’être formé à PHP, jQuery et AngularJS? Heureusement non.
Je n’en serais pas au même niveau aujourd’hui si je n’avais que mes deux ans
d’expérience React derrière moi.

Ces derniers temps je suis beaucoup ce qui se passe autour de
[Reason](https://reasonml.github.io), langage qui semble apporter des réponses
élégantes à ce qu’il manque à JavaScript. Pour autant je n’abandonne pas
JavaScript. J’ai découvert la programmation fonctionnelle grâce à JavaScript, et
Reason est une bonne opportunité d’aller plus loin.

Alors peut-être que React (ou JavaScript) sera oublié dans deux ans, mais ce
sera pour quelque chose de mieux, plus moderne, plus performant, etc., mais je
ne peux pas croire que ce que l’on aura appris sur/de React sera bon à jeter.

## Trop d’outils nécessaires

Pour utiliser pleinement React (mais ça vaut aussi pour Angular, VueJS…), passer
par la case transpilation Babel est plutôt sympa. De même que builder son appli
avec un Webpack, Parcel ou autre Create React App c’est plutôt cool aussi. Et
ajouter une couche de formatage automatique avec Prettier et de lint avec
ESLint, ça peut aider aussi. Encore mieux: ajouter du typage avec TypeScript ou
Flow, ça peut sauver des heures de debug. Ça fait beaucoup d’outils. Et alors?

En quoi s’entourer de bons outils devrait-il être un mal? Vous pouvez décider de
n’en utiliser aucun (il est
[possible de faire du React sans JSX](https://reactjs.org/docs/react-without-jsx.html)),
vous passeriez à côté de fonctions bien pratiques, mais c’est possible. Et
certes d’autres langages font tout cela nativement, mais on peut se demander ce
qui se passe si on souhaite implémenter ces fonctions autrement que dans ces
langages. Au moins avec JavaScript (et donc React), vous avez le choix.

## C’était mieux avant

Avec jQuery? Quand on avait une usine à gaz de fonctions utilitaires tout ça
pour faire deux requêtes dans le DOM, et que les plugins poussaient partout sur
le web, chaque développeur ayant ses propres conventions, faisant naître un
écosystème bordélique et hétérogène?

Ou sans JavaScript? Quand le concept d’application web existait à peine, puisque
chaque chargement de données nécessitaient un rechargement de la page?

Les sites étaient sans doute aussi bien voire mieux qu’aujourd’hui (moins
pollués de trackers en tout genre), mais les web apps? Pas si sûr… Et autant du
point de vue utilisateur que de celui du développeur.

## En conclusion?

Pour moi oui il est encore utile d’apprendre React ou n’importe que framework
qui vous aidera au quotidien. Si vous souhaitez vous perfectionner dans le
JavaScript pur _(vanilla)_, c’est très bien aussi, cela vous aidera. De même si
vous souhaitez expérimenter d’autres langages pourvus d’autres avantages, ou
permettant d’autres paradigmes. Mais penser que si une technologie est
temporaire cela signifie qu’elle ne vaut pas le coup d’être apprise, ce serait
je pense une erreur. Surtout, il n’y aurait plus grand chose à apprendre…

_Note: on peut évidemment penser que mon avis est biaisé dans la mesure où
[j’écris actuellement](/assets/posts/2018-09-25-pourquoi-un-livre-sur-react/) un
[livre consacré à React](https://leanpub.com/apps-web-modernes-react). Je dirais
plutôt que je n’aurais pas ce projet si je pensais que React était déjà démodé
😉_
