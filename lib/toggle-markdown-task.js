const {CompositeDisposable} = require('atom')

module.exports = ({
  subscriptions: null,

  activate (state) {
    this.subscriptions = new CompositeDisposable()
    this.subscriptions.add(atom.commands.add('atom-text-editor',
      {'toggle-markdown-task:toggle': () => this.toggle()})
    )
  },

  deactivate () {
    this.subscriptions.dispose()
  },

  toggle () {
    const editor = atom.workspace.getActiveTextEditor()
    if (editor) {
      editor.transact(() => {
        editor.getSelections().forEach((selection) => toggleSelection(selection))
      })
    }
  }
})

function toggleSelection (selection) {
  const originalRange = selection.getBufferRange()

  const [startingRow, endingRow] = selection.getBufferRowRange()
  for (let row = startingRow; row <= endingRow; row++) {
    selection.cursor.setBufferPosition([row, 0])
    selection.selectToEndOfLine()

    const toggledTask = toggleTask(selection.getText())
    selection.insertText(toggledTask)
  }

  selection.setBufferRange(originalRange)
}

function toggleTask (taskText) {
  const regex = new RegExp(/([-*] )(\[[ x]\])/)

  return taskText.replace(regex, (_, taskPrefix, taskStatus) => {
    return (taskStatus === '[ ]') ? `${taskPrefix}[x]` : `${taskPrefix}[ ]`
  })
}
