---
title: Reimplement Redux with vanilla React in 12 lines of code
date: '2021-01-11'
excerpt: >-
  Redux is an awesome library to handle the state of big applications, React or
  not. But when you think about it, the basic features of Redux can be
  implemented in very few lines of code. Let’s see how.
cover: /assets/posts/reimplement-redux-with-vanilla-react/cover.webp
lang: en
---

Redux is an awesome library to handle the state of big applications, React or
not. But when you think about it, the basic features of Redux can be implemented
in very few lines of code. Let’s see how.

_This article is partly extracted from my course dedicated to React hooks:
[useEffect.dev](https://useeffect.dev). Its goal is to
help you understand how hooks work, how to debug them, and how to solve common
problems they can cause._

## Contexts

In React, _contexts_ offer an elegant way to implement the “provider/consumer”
pattern. As its name suggests, this pattern is composed of two main elements: a
_provider_ whose goal is to provide a certain value, and _consumers_, the
components that will consume this value. Usually, you encapsulate your main
component inside a `Provider` component, and then in the child components you
can use hooks provided the context’s library:

```jsx
// Main component:
return (
  <Provider params={someParams}>
    <App />
  </Provider>
)

// In App or a child component:
const value = useValueFromProvider()
```

To create a context, we call the `createContext` function provided by React. The
object it returns contains a `Provider` component. By encapsulating a component
hierarchy inside this component, they’ll be able to access the context’s value.

```jsx
const myContext = createContext()

const App = () => (
  <myContext.Provider value="Hello">
    <SomeComponent />
  </myContext.Provider>
)

const SomeComponent = () => {
  const value = useContext(myContext)
  return <p>Value: {value}</p>
}
```

A very useful pattern is to create a custom provider to decorate the one
provided by the context. For instance, here is how we can make our provider
handle a local state (which will actually be used globally):

```jsx
const GlobalStateProvider = ({ initialState, children }) => {
  const [state, setState] = useState(initialState)
  return (
    <globalStateContext.Provider value={%raw%}{{ state, setState }}{%endraw%}>
      {children}
    </globalStateContext.Provider>
  )
}
```

The context now contains an object with a `state` and a `setState` attribute. To
make it even easier to our context’s user, let’s create two custom hooks to
access them:

```jsx
const useGlobalState = () => useContext(globalStateContext).state
const useSetGlobalState = () => useContext(globalStateContext).setState
```

We now have a first viable implementation of a global state management. Now
let’s see how we can implement the core notion of Redux to handle the state
updates: the _reducer_.

## Reducers

Reducers offer an elegant way to perform updates on a state using actions
instead of updating each state attribute.

Let’s say we want to update a state after an HTTP request succeeded. We want to
update a `loading` flag by setting it to `false`, and put the request result in
the `result` attribute. With reducers, we can consider having this action:

```jsx
{ type: 'request_succeeded', result: {...} }
```

This action will be passed as parameter to the _reducer_ function. It is a
function that takes two parameters: the current state and an action.
Traditionally, an action is an object with a `type` attribute, and possibly some
other attributes specific to the action. Based on this action and the current
state, the reducer function must return a new version of the state.

We can imagine this reducer to handle our first action:

```jsx
const reducer = (state, action) => {
  switch (action.type) {
    case 'request_succeeded':
      return { ...state, loading: false, result: action.result }
    default:
      // If we don’t know the action type, we return
      // the current state unmodified.
      return state
  }
}
```

Good news: there is a hook in React to let us use a reducer to handle a local
state and its updates using actions: `useReducer`. You can see it as an improved
version of `useState`, but instead of returning a setter function to update the
state, it returns a `dispatch` function to dispatch actions to the reducer.

```jsx
const [state, dispatch] = useReducer(reducer, initialState)
```

In our case, the `initialState` parameter could contain this object:

```jsx
const initialState = { loading: false, error: false, result: undefined }
```

To update the state via an action, just call `dispatch` with the action as
parameter:

```jsx
dispatch({ type: 'request_succeeded', result: {...} })
```

## A global reducer in a context

Now that we know about contexts and reducers, we have all we need to create a
context to handle our global state with a reducer. Let’s first create the
context object:

```jsx
const storeContext = createContext()
```

Then let’s create a `StoreProvider` component using the context’s `Provider`. As
we saw previously, our context will contain a local state, but instead of using
`useState`, we will use `useReducer`. The two parameters of `useReducer` (the
reducer and the initial state) will be passed as props to our `StoreProvider`:

```jsx
const StoreProvider = ({ reducer, initialState, children }) => {
  const [state, dispatch] = useReducer(reducer, initialState)
  return (
    <storeContext.Provider value={%raw%}{{ state, dispatch }}{%endraw%}>
      {children}
    </storeContext.Provider>
  )
}
```

To consume the store context, we will provide two hooks: one to read the state,
and one to dispatch an action.

To read the state, instead of just creating a hook returning the whole state,
let’s do the same as what React-Redux offers: a hook taking as parameter a
selector, i.e. a function extracting from the state the value we are interested
in.

A selector is usually very simple:

```jsx
const selectPlanet = (state) => state.planet
```

The hook `useSelector` takes this selector as parameter and calls it to return
the right piece of state:

```jsx
const useSelector = (selector) => selector(useContext(storeContext).state)
```

Finally, the `useDispatch` hook simply returns the `dispatch` attribute from the
context value:

```jsx
const useDispatch = () => useContext(storeContext).dispatch
```

Our implementation is complete, and the code contains barely a dozen lines of
code! Of course, it doesn’t implement all the functions that make Redux so
powerful, such as middlewares to handle side effects (Redux-Thunk, Redux-Saga,
etc.). But it makes you wonder if you really need Redux to just keep track of a
global state with the reducer logic.

Here is the full code for our Redux implementation:

```jsx
const storeContext = createContext()

export const StoreProvider = ({ reducer, initialState, children }) => {
  const [state, dispatch] = useReducer(reducer, initialState)
  return (
    <storeContext.Provider value={%raw%}{{ state, dispatch }}{%endraw%}>
      {children}
    </storeContext.Provider>
  )
}

const useSelector = (selector) => selector(useContext(storeContext).state)

const useDispatch = () => useContext(storeContext).dispatch
```

## Using our implementation

Using our implementation of Redux looks very similar to using actual Redux.
Let’s see this in a example performing a call to an HTTP API.

First let’s create our store: the initial state, the reducer, the action
creators and the selectors:

```jsx
// Initial state
const initialState = {
  loading: false,
  error: false,
  planet: null,
}

// Reducer
const reducer = (state, action) => {
  switch (action.type) {
    case 'load':
      return { ...state, loading: true, error: false }
    case 'success':
      return { ...state, loading: false, planet: action.planet }
    case 'error':
      return { ...state, loading: false, error: true }
    default:
      return state
  }
}

// Action creators
const fetchStart = () => ({ type: 'load' })
const fetchSuccess = (planet) => ({ type: 'success', planet })
const fetchError = () => ({ type: 'error' })

// Selectors
const selectLoading = (state) => state.loading
const selectError = (state) => state.error
const selectPlanet = (state) => state.planet
```

Then, let’s create a component reading from the state and dispatching actions to
update it:

```jsx
const Planet = () => {
  const loading = useSelector(selectLoading)
  const error = useSelector(selectError)
  const planet = useSelector(selectPlanet)
  const dispatch = useDispatch()

  useEffect(() => {
    dispatch(fetchStart())
    fetch('https://swapi.dev/api/planets/1/')
      .then((res) => res.json())
      .then((planet) => {
        dispatch(fetchSuccess(planet))
      })
      .catch((error) => {
        console.error(error)
        dispatch(fetchError())
      })
  }, [])

  if (loading) {
    return <p>Loading…</p>
  } else if (error) {
    return <p>An error occurred.</p>
  } else if (planet) {
    return <p>Planet: {planet.name}</p>
  } else {
    return null
  }
}
```

And finally, let’s encapsulate our application (the `Planet` component) inside
the provider of our store:

```jsx
const App = () => {
  return (
    <StoreProvider reducer={reducer} initialState={initialState}>
      <Planet />
    </StoreProvider>
  )
}
```

That’s it! Does Redux seem less mysterious now that you know how to write your
own implementation?

I also created
[a CodeSandbox](https://codesandbox.io/s/beautiful-murdock-mbkq1?file=/src/App.js)
if you want to play with this implementation.

## Bonus: rewriting `useReducer`

We used `useReducer` because this hook is provided by React. But if it wasn’t,
did you know you it can be rewritten too, and in less that five lines of code?

```jsx
const useReducer = (reducer, initialState) => {
  const [state, setState] = useState(initialState)
  const dispatch = (action) => setState(reducer(state, action))
  return [state, dispatch]
}
```

---

If you liked this post, I talk a lot more about React and hooks in my new course
[useEffect.dev](https://useeffect.dev). Its goal is to
help you understand how they work, how to debug them, and how to solve common
problems they can cause.
