---
title: 'Create an animated 3D book in CSS, step by step'
date: '2020-07-23'
excerpt: >-
  A couple of days ago, I created a 3D version for the book I’m writing, with
  CSS only. Because I couldn’t find an easy way to do it, I created a small 3D
  book image CSS generator. There was a lot of interest for it, and since it’s
  definitely not that complicated, here is a small tutorial to learn how to
  create your own version.
cover: /assets/posts/animated-3d-book-css/cover.webp
lang: en
tags:
  - dev
---

A couple of days ago, I created a 3D version for a book I was writing, with CSS only. Because I couldn’t find an easy way to do it (most websites offered to generate images only, and not with the best quality), I created a small [3D book image CSS generator](/3dbook) and posted it [on Hacker News](https://news.ycombinator.com/item?id=23896856). There was a lot of interest for it, and since it’s definitely not that complicated, here is a small tutorial to learn how to create your own version.

Here is what the final result will look like:

![](/assets/posts/animated-3d-book-css/book-image.webp)

Be ready, we’ll talk about 3D, geometry, animation, and shadow; what an exciting programme! Let’s go!

## Step 1 - Set up the scene

We want the HTML to be as simple as possible, i.e. not with a lot of divs and classes. The most simple solution I found was to have a `.book-container` div (which can be a link for instance) and a `.book` div, containing the cover as an `img` (until the last step it will be a div with a background so it’s more easy to see the progress).

```html
<div class="book-container">
  <div class="book">
    <!-- will be a <img> at the end -->
    <div />
  </div>
</div>
```

We give a size to the `.book-container` and a border, which is not required but makes things easier to see at first. We also make sure the elements in it (the `.book`) are centerer horizontally and vertically:

```css
.book-container {
  border: 1px solid lightgray;
  width: 500px;
  height: 400px;
  display: flex;
  align-items: center;
  justify-content: center;
}
```

The `.book` itself has a fixed size (the size of the cover), and some rounded angles:

```css
.book {
  width: 200px;
  height: 300px;
}

.book > :first-child {
  background: #0d47a1aa;
  width: 200px;
  height: 300px;
  border-top-right-radius: 3px;
  border-bottom-right-radius: 3px;
}
```

As a result, we have a first shot of our cover:

![Step 1 result: our book is still a little flat…](/assets/posts/animated-3d-book-css/step1.webp)

## Step 2 - Add some 3D

To add 3D and perspective, only some CSS properties are needed (it’s amazing what CSS makes us able to do these days…). First we set the `transform-style` and `perspective` parameters for the `.book-container` (you can adjust the perspective and see the different results), then we apply a rotation against the vertical axis (`rotateY`) to the book:

```css
.book-container {
  /* ... */
  transform-style: preserve-3d;
  perspective: 400px;
}

.book {
  /* ... */
  transform: rotateY(-30deg);
}
```

![Step 2 result: yay it’s in 3D!](/assets/posts/animated-3d-book-css/step2.webp)

## Step 3 - Add the pages

To see the pages on the side, instead of adding a new div, we’ll use the pseudo-element `::before`, which can be considered as an implicit div. As a first step, let’s just give it a size, and its default position: at the origin of the parent div (the `.book`):

```css
.book {
  /* ... */
  position: relative;
}

.book::before {
  position: absolute;
  content: ' ';
  background: #bf360caa;
  height: 300px;
  width: 50px;
}
```

![Step 3 result: our pages are here, but not really at the good place…](/assets/posts/animated-3d-book-css/step3.webp)

## Step 4 - Move the pages to the right place

Here is where it’s getting interesting. To put our pages at the right place, we need to apply them several transformations:

- first, we must translate them horizontally of the book’s width (200px), minus half the book’s thickness,
- then we rotate the pages of 90 degrees (still against the vertical axis),
- and finally we translate them again of half the book’s thickness (still against the horizontal X axis, since it was rotated by the translation as well).

These steps can seem complicated, but if you try to apply them one after the other to see the result, they really aren’t.

<!-- prettier-ignore -->
```css
.book::before {
  /* ... */
  transform: translateX(calc(200px - 50px / 2))
             rotateY(90deg)
             translateX(calc(50px / 2));
}
```

To make the pages slighly smaller than the cover, we can resize the pages, move a little their origin position, and update the first translation:

<!-- prettier-ignore -->
```css
.book::before {
  /* ... */
  height: calc(300px - 2 * 3px);
  top: 3px;
  transform: translateX(calc(200px - 50px / 2 - 3px)) /* ... */
}
```

![Step 4 result: now the pages at the good place!](/assets/posts/animated-3d-book-css/step4.webp)

## Step 5 - Add the back cover

Since we used the `::before` element for the pages, let’s use the `::after` one for the back cover. Its dimensions and origin position are the same as the front cover:

<!-- prettier-ignore -->
```css
.book::after {
  content: ' ';
  position: absolute;
  left: 0;
  width: 200px;
  height: 300px;
  background: #1b5e20aa;
}
```

Positioning it is a lot easier than the pages: we just have to apply one translation against the Z axis, of a value equal to the book’s thickness:

<!-- prettier-ignore -->
```css
.book::after {
  /* ... */
  transform: translateZ(-50px);
}
```

![Step 5 result: and there comes the back cover!](/assets/posts/animated-3d-book-css/step5.webp)

## Step 6 - Add some animation

I promised you animation, and for now our book image is still a little bit too static. Let’s fix that!

The first animation we’ll add is to rotate the book on hover. To do that, let’s specify that we want to animate the `transform` property of the `.book` via the `transition` attribute.

<!-- prettier-ignore -->
```css
.book {
  /* ... */
  transition: transform 1s ease;
}
```

Then let’s apply the rotation we want (0 degrees, so the book will pass from “rotated” to not “rotated”) in the `.book:hover` section:

<!-- prettier-ignore -->
```css
.book:hover {
  transform: rotate(0deg);
}
```

The second animation we want is when the page is loaded: we want the book to pass from non-rotated to rotated (the opposite animation). This can be done using the `animation` attribute and a `@keyframe` animation:

<!-- prettier-ignore -->
```css
.book {
  /* ... */
  animation: 1s ease 0s 1 initAnimation;
}

@keyframes initAnimation {
  0% { transform: rotateY(0deg); }
  100% { transform: rotateY(-30deg); }
}
```

![Step 6 result: this is what I call a “wow” effect!](/assets/posts/animated-3d-book-css/step6.gif)

## Step 7 - Add the image and some shadow

Now that all our elements are correctly positionned and animated, we just need to display the actual book cover instead of colored backgrounds.

```html
<div class="book-container">
  <div class="book">
    <img
      src="https://d2sofvawe08yqg.cloudfront.net/outstanding-developer/hero2x?1595108679"
    />
  </div>
</div>
```

As a nice small addition, let’s add some shadow to the book, and we’re done!

```css
.book > :first-child {
  /* ... */
  box-shadow: 5px 5px 20px #666;
}

.book::before {
  /* ... */
  background: #fff;
}

.book::after {
  /*  */
  background: #01060f;
  box-shadow: -10px 0 50px 10px #666;
}
```

Our animated 3D book is now complete! You can find the complete code of this tutorial [on CodePen](https://codepen.io/scastiel/pen/WNrmpdz), or have a look at [the generator I created](https://3d-book-css.netlify.app/) or [its source code on GitHub](https://github.com/scastiel/3d-book-image-css-generator).

Note that to make it work with Edge, I had to remove the CSS variables and the calculations (`calc(...)`) in the `transform` attribute. It’s a little sad; the first version used CSS variables so size was configurable without updating the core CSS. But at least now it works everywhere! (Okay, I haven’t tested in Internet Exporer, and I won’t 😉)

---

Hope you liked this tutorial! I’m not a CSS expert, but I enjoyed very much creating this 3D book snippet. See you soon!

_Cover photo by [Dawid Małecki](https://unsplash.com/@djmalecki)._
