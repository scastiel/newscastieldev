---
title: Understand how React hooks work
date: '2021-01-03'
excerpt: >-
  The reason hooks cause developers to struggle is that they look simple, just
  basic functions, but they are a lot more complex than that. The complex logic
  is very well hidden in the React core, but understanding a little how they
  work will help you to use them at their full potential, and overcome the
  issues you face more easily.
cover: /assets/posts/hooks-mental-model-and-rules/cover.webp
lang: en
---

<aside>

React hooks are awesome, but they are not as easy to use as they sound. In my
personal experience, with other developers, and in technical interviews, I
realized that React developers often stuggle on the same problems. This is why I
wrote a short but dense eBook dedicated to hooks, that I then converted to an
online interactive course:
[useEffect.dev](https://useeffect.dev).

Its goal is to help you understand how they work, how to debug them, and how to
solve common problems they can cause. This post is an extract of the course.

</aside>

The reason hooks cause developers to struggle is that they look simple, just
basic functions, but they are a lot more complex than that. The complex logic is
very well hidden in the React core, but understanding a little how they work
will help you to use them at their full potential, and overcome the issues you
face more easily.

## How React renders a component without hooks

Let’s consider this component example, which doesn’t involve hooks:

```jsx
const WithoutHooks = ({ name }) => {
  return <p>Hello {name}!</p>
}
```

Since this component is a function, React renders the component (or more
precisely knows what to render) by invoking this function with the props. When
the props (i.e. `name`) are changed, the function is called again to get the new
rendering result.

If we suppose the name was initially “John” and was changed to “Jane”, we can
describe the renderings like this:

```jsx
// Rendering 1
return <p>Hello John!</p>

// Prop `name` changed
//  ↓
// Rendering 2
return <p>Hello Jane!</p>
```

Now let’s see what happens when we introduce a local state with the `useState`
hook.

## How React renders a component with a local state

In this variant, the `name` is no longer a prop, but a local state, updated with
an `input`:

```jsx
const WithLocalState = () => {
  const [name, setName] = useState('John')
  return (
    <>
      <input value={name} onChange={(event) => setName(event.target.value)} />
      <p>Hello {name}!</p>
    </>
  )
}
```

When React encounters the call to `useState`, it initializes a local state
somewhere in the memory, knowing that it is linked to the _first_ hook call in
this component. In the subsequent renderings, it will assume that the first call
to `useState` always refers to this first memory index.

Note that there is no magic in this; React does not parse the function code to
identify the hooks call: everything is handled in the hooks code itself (and in
React’s core).

```jsx
// Rendering 1
const [name, setName] = useState('John')
// → HOOKS[0] := [state: 'John']
return <> ...Hello John... </>

// setName('Jane')
// → HOOKS[0] := [state: 'Jane']
//  ↓
// Rendering 2
const [name, setName] = useState('John')
// → HOOKS[0] already exists, returns 'Jane'
return <> ...Hello Jane... </>
```

Note that the behavior would be the same with several states, just with several
state elements in our imaginary array `HOOKS`.

Now let’s see what happens when we introduce a call to `useEffect`.

## How React renders a component with effects

Now, instead of rendering a greeting message with the entered name, we want to
call a web service each time the name is updated, which will return us an ID
associated with the user name, stored in some database.

```jsx
const WithLocalStateAndEffect = () => {
  const [name, setName] = useState('John')
  const [id, setId] = useState(0)
  useEffect(() => {
    getUserId(name).then((id) => setId(id))
  }, [name])
  return (
    <>
      <input value={name} onChange={(event) => setName(event.target.value)} />
      <p>ID: {id}</p>
    </>
  )
}
```

Same as `useState`, `useEffect` will reserve some space in the memory (our
`HOOKS` array), but not to store a state. What `useEffect` needs to store is the
dependencies array, so that it knows next time if the function must be executed
again or not.

```jsx
// Rendering 1
const [name, setName] = useState('John')
// → HOOKS[0] := [state: 'John']
const [id, setId] = useState(0)
// → HOOKS[1] := [state: 0]
useEffect(..., [name])
// → Executes the function
// → HOOKS[2] := [effect: ['John']]
return <> ...ID: 0... </>
```

On the first rendering, two spaces in the memory are initialized for the two
local states, and a third for the `useEffect`, containing the dependencies,
`['John']`.

The second rendering is triggered when the promise inside `useEffect` is
resolved, invoking `setId`, updating the state of the component.

```jsx
// setId(123) (when the promise in useEffect is resolved)
// → HOOKS[1] := [state: 123]
//  ↓
// Rendering 2
const [name, setName] = useState('John')
// → HOOKS[0] already exists, returns 'John'
const [id, setId] = useState(0)
// → HOOKS[1] already exists, returns 123
useEffect(..., [name])
// → Dependencies ['John'] is already equal to HOOKS[2], do nothing
return <> ...ID: 123... </>
```

Although the state is modified, the dependencies array of `useEffect` is still
evaluated to `['John']` (because `name` wasn’t modified), so the function is not
executed again. Now, if we update the name in the input:

```jsx
// setName('Jane') (when the input value is modified)
// → HOOKS[0] := [state: 'Jane']
//  ↓
// Rendering 3
const [name, setName] = useState('John')
// → HOOKS[0] already exists, returns 'Jane'
const [id, setId] = useState(0)
// → HOOKS[1] already exists, returns 123
useEffect(..., [name])
// → Dependencies ['Jane'] is different from ['John']
// → Executes the function
// → HOOKS[2] := [effect: ['Jane']]
return <> ...ID: 123... </>
```

This time, `name` changed, so the function is `useEffect` is executed again,
creating a new promise, which when resolved will trigger a new call to `setId`,
therefore a new rendering:

```jsx
// setId(456) (when the promise in useEffect is resolved)
// → HOOKS[1] := [state: 456]
//  ↓
// Rendering 4
const [name, setName] = useState('John')
// → HOOKS[0] already exists, returns 'Jane'
const [id, setId] = useState(0)
// → HOOKS[1] already exists, returns 456
useEffect(..., [name])
// → Dependencies ['Jane'] is already equal to HOOKS[2], do nothing
return <> ...ID: 456... </>
```

The model described here is simpler than the real one, but is good enough to
understand how hooks work under the hood. Plus, since all the hooks could be
written using `useState` and `useEffect`, it allows you to imagine what happens
with all the other hooks.

## Rules this model implies when using hooks

You noticed that when rendering a component several times, each call to a hook
was referred by an index. The first hook, then the second, etc. It might seem
weird, but React has its reasons for this behavior. And what is more important
is the consequence it has.

Since each hook call is referred to by its index, it means that this index must
remain consistent from a rendering to the next one. So if at the first
rendering, the first hook is a `useState` storing the name, it cannot be another
state storing the user ID at the second one, nor can it be a `useEffect`.

What it implies is that you cannot use hooks in conditions, loops, or any
function body.

```jsx
if (id === 0) {
  // Using a hook inside a condition is forbidden!
  useEffect(() => alert('Wrong ID'), [id])
}

const getUserName = (id) => {
  // Using a hook inside a function is forbidden!
  useEffect(() => {
    fetch(...)
  }, [id])
}
```

It is also not possible to return something prematurly before a hook call:

```jsx
const Division = ({ numerator, denominator }) => {
  if (denominator === 0) return <p>Invalid denominator</p>

  // Using a hook after a `return` is forbidden.
  const [result, setResult] = useState(undefined)
  useEffect(() => {
    setResult(numerator / denominator)
  }, [numerator, denominator])

  return <p>Result = {result}</p>
}
```

The rules on hooks can be simplified this way: all calls to hooks must be done
at the root of the component function body, and before any `return`.

You may think of it as a contraint, but in most cases it is not that hard to
find another way. For instance, instead of having a `useEffect` inside a `if`,
you can put the `if` inside the `useEffect`:

```jsx
useEffect(() => {
  if (id === 0) {
    alert('Wrong ID')
  }
}, [id])
```

To avoid calling hooks after a `return`, you may have to use some tricks.

```jsx
const Division = ({ numerator, denominator }) => {
  const [result, setResult] = useState(undefined)
  const [invalid, setInvalid] = useState(false)

  useEffect(() => {
    if (denominator === 0) {
      setInvalid(true)
      setResult(undefined)
    } else {
      setInvalid(false)
      setResult(numerator / denominator)
    }
  }, [numerator, denominator])

  if (invalid) {
    return <p>Invalid denominator</p>
  } else {
    return <p>Result = {result}</p>
  }
}
```

---

I hope this article helped you to understand how hooks work. If you liked it,
know that you can learn a lot more about hooks in my course
[useEffect.dev](https://useeffect.dev).
