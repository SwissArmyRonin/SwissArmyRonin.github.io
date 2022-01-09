# Parseltounge is a stupid programming language

- whitespace indentation
- no privacy
  - underscore vars, methods, and files are just pretend private
  - double underscore names cause mangling to avoid shadowing
- you have to list self as a parameter
- no block comments
- clumsy entry points: `if __name__ == '__main__':`
- `pass`, because we can't do empty scopes 🙄
- custom ternaries: ` client_data['client_id'] if dynamically_registered else _config.get("client_id", "")`

## Minor quibbles

- No null coalescing operators

## Sort of cool

- Mixins
