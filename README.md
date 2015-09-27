# Toggle Markdown Task: An Atom Package

Provides a command to toggle completion of [tasks in GitHub-flavored Markdown][gfm-task-lists] files.

![demo](https://cloud.githubusercontent.com/assets/2988/9983485/94a87090-5fcb-11e5-9ce6-41d7e9382ade.gif)

## Installation

Using `apm`:

```
apm install toggle-markdown-task
```

Or search for `toggle-markdown-task` in the Atom Settings UI.

## Bring your own keymap

To get the most out of this package, you'll want to use a keyboard shortcut for toggling Markdown tasks. This package does not provide a keyboard shortcut by default, but you can easily [define your own][atom-keymaps]. For example, if you wanted to use `Control-D` (as shown in the demo above), you'd add the following mapping to your `~/.atom/keymap.cson` file:

```cson
'atom-workspace atom-text-editor:not(.mini)':
  'ctrl-d': 'toggle-markdown-task:toggle'
```

## TODO

- [ ] Set up CI
- [ ] Support multiple cursors: Toggle tasks at every cursor

[atom-keymaps]: https://atom.io/docs/v1.0.15/using-atom-basic-customization#customizing-key-bindings
[gfm-task-lists]: https://help.github.com/articles/writing-on-github/#task-lists
