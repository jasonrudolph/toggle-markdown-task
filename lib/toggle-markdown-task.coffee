{CompositeDisposable} = require 'atom'

module.exports = ToggleMarkdownTask =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-text-editor',
      'toggle-markdown-task:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()

  toggle: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getLastSelection();
      row = selection.getBufferRowRange()[0];

      selection.cursor.setBufferPosition([row, 0])
      selection.selectToEndOfLine()

      if line = selection.getText()
        toggledTask = toggleTask(line)

        if toggledTask
          selection.insertText(toggledTask)

toggleTask = (task) ->
  if task.search(/\- \[ \]/) != -1
    task.replace /\- \[ \]/, "- [x]"
  else if task.search(/\- \[x\]/) != -1
    task.replace /\- \[x\]/, "- [ ]"
