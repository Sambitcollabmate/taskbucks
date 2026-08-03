# Why this isn't just `axios.post(...)` in the component

In React you'd probably write this straight inside the component:

```js
const res = await axios.post('/api/login', { identifier, password });
setToken(res.data.token);
```

That's fine for a small app. Flutter apps split this into layers mainly
because there's no browser doing things for you for free — no shared
`localStorage`, no automatic cookie jar, no single global `axios` instance
already configured. Each of these files replaces something the browser/React
ecosystem gives you implicitly.

## The layers, and their React equivalent

| File | What it does | Closest React/JS equivalent |
|---|---|---|
| `api_client.dart` | One shared `dio` instance: base URL + auto-attaches the auth header to every request | An `axios.create({ baseURL, headers })` instance + an axios request interceptor |
| `token_store.dart` | Holds the current token in memory | A module-level variable your axios interceptor reads (`let token = null`) |
| `api_exception.dart` | Turns Laravel's `{ message, errors }` 422 response into one predictable error type | Your axios `catch` block that does `err.response?.data?.errors` |
| `auth_service.dart` | One function per endpoint (`login()`, `register()`, ...) | Your `api/auth.js` with `export function login(...)` |
| `auth_provider.dart` | Holds "is logged in" + current user, persists/restores the token, notifies the UI when it changes | React Context + `useState`/`useReducer` for auth, e.g. an `AuthContext.Provider` |
| the screens (`login_screen.dart` etc.) | Calls the service, updates loading/error state, navigates on success | Your component's `onSubmit` handler |

## Why bother splitting it up

- **No component calls the network directly.** Screens only call
  `AuthService`. If the backend URL, auth header format, or error shape
  changes, one file changes — not every screen.
- **The token has to be attached manually.** Unlike a browser with cookies,
  every request needs `Authorization: Bearer <token>` added by hand — the
  interceptor in `api_client.dart` does this once so no call site has to
  remember to.
- **`AuthProvider` is the single source of truth for "am I logged in,"**
  the same job a `AuthContext` + `useContext(AuthContext)` would do in
  React — the router (`app_router.dart`) watches it to decide whether to
  show the login screen or the app.

So functionally, `AuthService.login()` **is** your `axios.post('/api/login')`
call. Everything else around it is just the boilerplate a browser/React app
gets for free, made explicit.
