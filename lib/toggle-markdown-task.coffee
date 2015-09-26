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
      rows  = selection.getBufferRowRange()

      for row in [rows[0]..rows[1]]
        selection.cursor.setBufferPosition([row, 0])
        selection.selectToEndOfLine()

        if line = selection.getText()
          toggledTask = toggleTask(line)

          if toggledTask
            selection.insertText(toggledTask)

toggleTask = (taskText) ->
  if taskText.search(/\- \[ \]/) != -1
    taskText.replace /\- \[ \]/, "- [x]"
  else if taskText.search(/\- \[x\]/) != -1
    taskText.replace /\- \[x\]/, "- [ ]"
