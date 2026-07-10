---
title: Create a React hook to add dark theme to your app
date: '2019-10-14'
excerpt: >-
  Thanks to a recent evolution in mobile and desktop operating systems, it is
  more and more common for users to expect two UI themes for apps and websites:
  a light one and a dark one. In this article we’ll see how it is possible to
  offer two themes in your React application, using the one the user prefers by
  default.
cover: /assets/posts/a-react-hook-for-dark-theme/cover.webp
lang: en
---

Thanks to a recent evolution in mobile and desktop operating systems, it is more
and more common for users to expect two UI themes for apps and websites: a light
one and a dark one. In this article we’ll see how it is possible to offer two
themes in your React application, using the one the user prefers by default. And
get ready, we’ll talk about **hooks** and **contexts** 🚀.

_TL;DR: the final source code is
[in this CodeSandbox](https://codesandbox.io/embed/holy-sunset-kxxfs). If you
want to use this implementation in your project, have a look at this library I
created: [use-theme](https://github.com/scastiel/use-theme)._

If you already know hooks and contexts, you can consider this as a challenge. We
want to create a way to get and set a theme from a React component (using a
hook, althought other ways are possible).

- When the page is loaded, the theme must be the one sent by the browser
  (usually from the OS);
- The theme must be updated when the browser’s theme changes;
- A switch should allow to toggle between themes and override the browser’s one;
- The theme selected by the user must persist so it is applied next app the app
  is loaded.

We’ll start with a simple `App` component. It will apply a CSS class on the
`body` depending of the theme it got from a `useBrowserTheme` hook. To add a
class to the body, we’ll use
[React Helmet](https://github.com/nfl/react-helmet).

```js
// theme.js
export const useBrowserTheme = () => {
  return 'dark'
}
```

```js
// app.js
const App = () => {
  const theme = useBrowserTheme()
  return (
    <>
      <Helmet>
        <body className={dark} />
      </Helmet>
      <p>Hello!</p>
    </>
  )
}
```

```css
/* style.css */
body.dark {
  background-color: black;
  color: white;
}
```

Let’s start our implementation. First we want to initialize the theme with the
one that the browser provides.

## Get the theme from the browser

Most browsers offer the way to know if the user prefers a light theme or a dark
theme. For that, we’ll use
[`window.matchMedia`](https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia)
method, with a query on `prefers-color-scheme` attribute. It will return an
object with a `matches` property.

For instance, if you type this command in your browser’s console, you should get
`true` if you use a dark theme, `false` otherwise:

```js
window.matchMedia('(prefers-color-scheme: dark)').matches
```

The returned object (a
[MediaQueryList](https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList)
we’ll name `mql`) will also be used to subscribe to theme changes (we’ll see
that later), so let’s create a function to get it:

```js
const getMql = () =>
  window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)')

const getBrowserTheme = () => {
  const mql = getMql()
  return mql && mql.matches ? 'dark' : 'light'
}
```

Now we can update our `useBrowserTheme` hook to initialize the theme with
`getBrowserTheme`:

```js
export const useBrowserTheme = () => {
  return getBrowserTheme()
}
```

This version of the hook will work most of the time, but has a huge drawback. If
you use server-side rendering (e.g. if you’re using it in a Gatsby website), it
will crash since when the file is loaded there is no `window` object. Indeed,
using `window` represents a side effect, that’s why it should be done using the
`useEffect` (or `componentDidMount` for instance).

This is also the reason I declared `getMql` as a function, instead declaring the
constant `mql` at the file root. This way we can rewrite our hook and trigger
side effects only with the `useEffect` hook:

```js
import { useState, useEffect } from 'react'

export const useBrowserTheme = () => {
  const [theme, setTheme] = useState(null)

  useEffect(() => {
    if (theme === null) {
      setTheme(getBrowserTheme())
    }
  }, [theme, setTheme])

  return theme
}
```

Now we got the theme from the browser when the page is loaded, let’s update it
when it changes. This can occur when the user updates their browser settings, or
even automatically at a given time if they configured the browser or OS that
way.

## Update the theme when browser’s theme changes

To be notified of the browser’s theme change, we can use our media query list
returned by `window.matchMedia` (so our function `getMql`) to call its
`addListener` method. Let’s define a `onBrowserThemeChanged` function, that will
call the callback given as parameter each time the theme changes.

```js
const onBrowserThemeChanged = (callback) => {
  const mql = getMql()
  const mqlListener = (e) => callback(e.matches ? 'dark' : 'light')
  mql && mql.addListener(mqlListener)
  return () => mql && mql.removeListener(mqlListener)
}
```

Notice that we return a function to remove the listener, following the same
pattern as `useEffect`. Let’s update our hook:

```js
useEffect(() => {
  if (theme === null) {
    setTheme(getBrowserTheme())
  }
  return onBrowserThemeChanged(setTheme)
}, [theme, setTheme])
```

Pretty straightforward, isn’t it?

## Add a switch to change theme

Now that we initialize the app’s theme from the browser’s one, and that we
update it when the browser’s one changes, it would be nice to offer the user to
be able to change it using a switch or any other way. Said differently, now that
our hook returns the current theme, let’s make it return it a function to update
it.

As a first implementation, we’ll just return the `setTheme` function (returned
by `useState`):

```js
export const useBrowserTheme = () => {
  const [theme, setTheme] = useState(null)
  // ...
  return [theme, setTheme]
}
```

Our application can now display two buttons to update the app’s theme:

```js
const App = () => {
  const [theme, setTheme] = useBrowserTheme()
  const setDarkTheme = useCallback(() => setTheme('dark'), [setTheme])
  const setLightTheme = useCallback(() => setTheme('light'), [setTheme])
  return (
    // ...
    <button
      className={theme === 'dark' ? 'active' : ''}
      onClick={setDarkTheme}
    >
      Dark theme
    </button>{' '}
    <button
      className={theme === 'light' ? 'active' : ''}
      onClick={setLightTheme}
    >
      Light theme
    </button>
  )
}
```

To simplify our `App` component, one thing we might want to do is to create a
component `ChangeThemeButton`, giving it a theme as property (the one we want to
be set when the button is clicked). But with our current implementation, we
would have to give it the current theme and the function to update the theme as
parameter. What if we want to display the button deeply in the component
hierarchy?

We can improve our solution by using React’s contexts API, and the
provider/consumer pattern. This way we could call our hook in any component we
want, as long as it is mounted under a `ThemeProvider` component; the theme
would be shared between all components, and update it from one component would
update in in the entire app.

First we’ll define the context that will be shared all accross the app:

```js
const ThemeContext = createContext()
```

Then we’ll convert our `useBrowserTheme` to a provider component, using
`ThemeContext.Provider`:

```js
export const ThemeProvider = ({ children }) => {
  const [theme, setTheme] = useState(null)

  useEffect(/* ... */)

  return (
    theme && (
      <ThemeContext.Provider value={[theme, setTheme]}>
        {children}
      </ThemeContext.Provider>
    )
  )
}
```

Notice that the _value_ of the context is exactly what we want to return from
our `useBrowserTheme` hook: an array with the theme as first value, and a
function to set the theme as second value. So our `useBrowserTheme` hook will
just be using our context:

```js
export const useBrowserTheme = () => useContext(ThemeContext)
```

Now we’re ready to create a `ChangeThemeButton` that will use our hook:

```js
const ChangeThemeButton = ({ children, newTheme }) => {
  const [theme, setTheme] = useBrowserTheme()
  const changeTheme = useCallback(() => setTheme(newTheme), [
    newTheme,
    setTheme,
  ])
  return (
    <button className={theme === theme ? 'active' : ''} onClick={changeTheme}>
      {children}
    </button>
  )
}
```

For it to work and use the shared theme, we have to wrap our app into a
`<ThemeProvider>` component:

```js
ReactDOM.render(
  <ThemeProvider>
    <App />
  </ThemeProvider>,
  rootElement
)
```

If we created a component to display a button to change the theme, couldn’t we
extract into another component the logic of adding a class on the body depending
of the current theme? Sure we can:

```js
const ThemeClassOnBody = () => {
  const [theme] = useBrowserTheme()
  return (
    <Helmet>
      <body className={theme} />
    </Helmet>
  )
}
```

Our `App` component is much simpler, and doesn’t event use the `useBrowserTheme`
hook anymore:

```js
const App = () => (
  <>
    <ThemeClassOnBody />
    <div className="App">
      <h1>Hello!</h1>
      <p>
        <ChangeThemeButton theme="dark">Dark theme</ChangeThemeButton>
        <ChangeThemeButton theme="light">Light theme</ChangeThemeButton>
      </p>
    </div>
  </>
)
```

Our implementation is almost complete. The user can switch between light and
dark themes, but when they refresh the page, the browser’s theme is used back.
Of course that can be pretty annoying.

## Persist the selected theme

To persist the theme the user chooses, we’ll use browser’s local storage. If it
doesn’t have a theme defined, we’ll use the browser’s one. As long at is defined
in local storage, it will be always be used, as long as the browser’s theme
doesn’t change. (We could imagine different rules, but I find it relevant to
update the app theme when the browser theme changes, even if I choose the other
theme previously.)

To read from and write to the local storage, let’s start by creating helpers:

```js
const getLocalStorageTheme = () => {
  const localTheme = localStorage && localStorage.getItem('theme')
  if (localTheme && ['light', 'dark'].includes(localTheme)) {
    return localTheme
  }
}

const setLocalStorageTheme = (theme) => {
  localStorage && localStorage.setItem('theme', theme)
}
```

The next thing to do in our `ThemeProvider` is first to write a function
`updateTheme` that will be called in place of `setTheme`. This function will
call `setTheme`, but also `setLocalStorageTheme`. And the second thing is to use
`getLocalStorageTheme` when initializing the theme, in `useEffect`:

```js
export const ThemeProvider = ({ children }) => {
  const [theme, setTheme] = useState(null)

  const updateTheme = useCallback(
    (newTheme) => {
      setLocalStorageTheme(newTheme)
      setTheme(newTheme)
    },
    [setTheme]
  )

  useEffect(() => {
    if (theme === null) {
      setTheme(getLocalStorageTheme() || getBrowserTheme())
    }
    return onBrowserThemeChanged(updateTheme)
  }, [theme, setTheme])

  return (
    theme && (
      <ThemeContext.Provider value={[theme, updateTheme]}>
        {children}
      </ThemeContext.Provider>
    )
  )
}
```

Everything works perfectly. I just want to update a little our provider. Let’s
imagine we want to create a `SwitchThemeButton` component, that will set theme
to dark if it was light, or to light if it was dark.

```js
const SwitchThemeButton = ({ children }) => {
  const [, setTheme] = useBrowserTheme()
  const switchTheme = useCallback(() => {
    setTheme((theme) => (theme === 'dark' ? 'light' : 'dark'))
  }, [setTheme])
  return <button onClick={switchTheme}>{children}</button>
}
```

To get the current theme when the button is clicked, we give a function as
parameter to `setTheme`, as we would if we used `useState`. But this won’t work,
since we have made it possible to give a function as parameter of our
`updateTheme` function. This can be fixed easilly:

```js
const updateTheme = useCallback(
  (newTheme) => {
    if (typeof newTheme === 'function') {
      setTheme((currentTheme) => {
        const actualNewTheme = newTheme(currentTheme)
        setLocalStorageTheme(actualNewTheme)
        return actualNewTheme
      })
    } else {
      setLocalStorageTheme(newTheme)
      setTheme(newTheme)
    }
  },
  [setTheme]
)
```

Our implementation is complete!

---

The complete source code is available on
[this CodeSandbox](https://codesandbox.io/s/holy-sunset-kxxfs), and if you want
to add this theming feature to your app or website, you can also check
[this small `use-theme` library](https://github.com/scastiel/use-theme) I
created to use it on my blog.

_Cover photo by [Benjamin Voros](https://unsplash.com/@vorosbenisop)._
