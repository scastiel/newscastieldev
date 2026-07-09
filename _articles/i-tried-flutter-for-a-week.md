---
title: I tried Flutter for a week and made an app
date: '2020-04-20'
excerpt: >-
  It’s been some time that I hear about Flutter, the UI library by Google
  supposed to be a concurrent for React. I’m a huge fan of React, and on the
  paper Flutter has all the arguments. And that made me want to try, so last
  week I decided to learn Flutter by making a small iOS application.
cover: /assets/posts/i-tried-flutter-for-a-week/cover.jpg
lang: en
tags:
  - dev
---

It’s been some time that I hear about Flutter, the UI library by Google supposed
to be a concurrent for React. I’m a huge fan of React, and on the paper Flutter
has all the arguments: it can be used for the web or for the mobile (generating
native views of course), it provides a good list of components out of the box,
and everything is optimized for a great development workflow. And that made me
want to try, so last week I decided to learn Flutter by making a small iOS
application.

_TL;DR: it’s a portfolio app to keep an eye on the price and value of the
cryptoassets you own. What I wanted and couldn’t find in existing apps was to be
able to display the prices in USD but my holdings value in CAD. The app and its
source code are available [here](https://scastiel.github.io/portfolio-app/)._

This article is not a tutorial to learn Flutter, but more a return on experience
on what I liked or not about Flutter. Keep in mind that I just had one side
project with it, not any professional project. Also, I have a lot of experience
with React (web and native), and the feedback is definitely influenced by that.

## Nice: the resources to get started

Naturally if you start learning Flutter, you go to
[its official website](https://flutter.dev/). On it you can find a
[“Getting started”](https://flutter.dev/docs/get-started/install) guide to
install everything, and more interesting a list of
[“Codelabs”](https://flutter.dev/docs/codelabs) that will teach you the basics
of writing you first Flutter app. This is pretty nice, I never felt lost because
of the lack of explanations on a tool to install or some syntax. And the basic
setup is very quick. In a few minutes you start your first application. Which
brings me to the developer experience.

![Codelabs on Flutter website are a very good start!](/assets/posts/i-tried-flutter-for-a-week/flutter-codelab.png)

## Great: the developer experience

If you’re used to [Expo](https://expo.io/) or
[Create-React-App](https://github.com/facebook/create-react-app) for React, you
expect to be able, with only a couple of commands, to start an application with
all its dependencies and some basic tooling. Well Flutter provides the same
experience. With it’s command `flutter` you can do pretty much everything,
including starting your app, build it or upgrade its dependencies.

Also, the extension for VSCode takes care of everything. Start your application
by pressing F5, and debug with breakpoints directly in VSCode without
configuring anything else. This is quite impressing.

![VSCode is perfect to develop with Flutter](/assets/posts/i-tried-flutter-for-a-week/vscode.png)

## Awesome: the available components

A very big advantage of Flutter over React is the components available out of
the box. Of course this is a question of philosophy since React has never
intended to provide any component, but it’s so cool that Flutter provides that
many components by default, and especially all the
[Material Design components](https://flutter.dev/docs/development/ui/widgets/material).

If like me you’re a developer and not a UX/UI designer, you know it’s not that
easy to create beautiful UIs (if you don’t agree, I’m sorry to inform you that
you UIs are ugly for anyone else but you 😉). Well using Material components by
keeping things as simple as possible (using default rendering settings) and if
possible respecting [Material Design guidelines](https://material.io/), you can
create a _good-enough-looking_ app without too much effort.

![A lot of Material components out of the box](/assets/posts/i-tried-flutter-for-a-week/material.png)

## Meh: the language: Dart

Flutter doesn’t use JavaScript or TypeScript, but this language everybody forgot
before Flutter (at least I did): [Dart](https://dart.dev/). I think the goal of
this language was similar to TypeScript: offer strict type checking to
JavaScript, and other features such as classes with private members. But where
TypeScript is a superset to JavaScript (meaning that JavaScript code is valid
TypeScript), Dart is to completely new language.

Okay Dart is very easy to learn if you know JavaScript, and even more if you
experienced TypeScript. But something disappointed me a lot with Dart: it
clearly followed the direction of object-oriented languages. For instance, an
object not only can but must inherit from a class! So you create and use classes
for everything.

With JavaScript I enjoyed being freed from OO languages constraints that made
the code very heavy and noisy. With TypeScript I found the perfect compromise to
introduce strict validations into JavaScript without sacrificing the
readibility. I’m afraid Dart feels to me like a step back. And it has
consequences on the way you write code in Flutter…

## Passable: the Flutter API

In its philosophy, Flutter is again very similar to React. Where React talks
about _components_, Flutter talks about _widgets_. That’s it. Pretty much the
same thing.

But as you may have guessed from the previous section, I’m disappointed of the
noise introduced by Dart to do simple things. For example, to specify some
border radius in TypeScript you could write:

```ts
borderRadius: 5
```

Well in Flutter you would write:

```dart
borderRadius: BorderRadius.all(Radius.circular(5))
```

In general Flutter relies more on object-oriented programming, where React
follows more the functional programming concepts. More a question of preference,
but as a big fan of FP, I would have prefered less OOP and more FP in Flutter
(where are the hooks?).

Fortunately again, VSCode integration provides all the intellisense features,
and even code snippets so the code is still easy to write and looks clean. Just…
noisy. And one thing that could remove some noise in unfortunately not here:
JSX.

## Finally: the lack of JSX

JSX, this syntax brought by React, feels very intuitive after some years spent
writing code in React. So intuitive that you forget it. But try not to use it
for a while to write components, and you’ll miss it a lot.

Of course I’m not the first one to think about
[using JSX with Flutter and Dart](https://github.com/flutter/flutter/issues/11609),
but it doesn’t seem to be coming in a near future. It could really make Flutter
even more enjoyable to use.

## In conclusion: is it a go?

I enjoyed trying Flutter a lot. It is still young, there is not a lot of
third-party libraries, but when you try to achieve something particular, you’ll
usually find an article or a video explaining how to do it.

The fact that all Material Design components are available out of the box is
probably the biggest advantage for me. I often create apps for fun (mobile or
web), and being able to quickly bootstrap a beautiful application to focus more
on the logic and the behavior is really a big plus.

I would be curious to know how Flutter deals with bigger apps. For instance, I
have only used basic local states and contexts to handle my application state. I
don’t even know if there’s a equivalent of Redux, or even if you can use Redux
with Flutter.

My disappointment comes more from Dart than Flutter itself. What I would like is
being able to use Flutter with TypeScript instead, but even then I’m afraid
Flutter relies way to much on Dart object-oriented programming to offer an
experience as nice as React. Definitely a question of preference though.

So in conclusion, I would probably still choose React and TypeScript for my
personal projects (and if I can, my professional ones too), but occasionnaly I
wouldn’t mind using Flutter for a small app. And definitely it wouldn’t be a
absolute refusal if one offers me a Flutter opportunity (I would still try to
convince them to use React though 😉).

_Cover photo by [Erwan Hesry](https://unsplash.com/@erwanhesry)._
