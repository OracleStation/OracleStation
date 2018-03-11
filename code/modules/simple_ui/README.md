# `/datum/simple_ui`

In summary, `/datum/simple_ui` does this:
- Wraps the `use << browse` functionality
- Keeps track of all the people viewing the UI
- Handles multicasting updates to viewers
- Handles multicasting js invocations to viewers
- Handles closing UI windows when players are no longer able to view them
- Handles sending assets to viewers

It does not:
- Use node.js
- Handle `Topic()` calls
