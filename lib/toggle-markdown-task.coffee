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
      editor.transact =>
        editor.getSelections().forEach (selection) =>
          toggleSelection(selection)

toggleSelection = (selection) ->
  originalRange = selection.getBufferRange()

  rows = selection.getBufferRowRange()
  for row in [rows[0]..rows[1]]
    selection.cursor.setBufferPosition([row, 0])
    selection.selectToEndOfLine()

    toggledTask = toggleTask(selection.getText())
    selection.insertText(toggledTask)

  selection.setBufferRange(originalRange)

toggleTask = (taskText) ->
  REGEX = ///
    ([\-\*]\ ) # task prefix: '- ' or '* '
    (          # start capture group for task status
      \[       # task status begins with an open bracket: '['
      [\ x]    # task status brackets contain a single empty space or an 'x'
      \]       # task status ends with a closing bracket: ']'
    )          # end capture group for task status
  ///

  taskText.replace REGEX, (_, taskPrefix, taskStatus) ->
    if taskStatus == "[ ]"
      "#{taskPrefix}[x]"
    else
      "#{taskPrefix}[ ]"
