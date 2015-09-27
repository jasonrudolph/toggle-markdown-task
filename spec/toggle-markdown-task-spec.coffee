describe "toggling markdown task", ->
  [activationPromise, editor, editorView] = []

  toggleMarkdownTask = (callback) ->
    atom.commands.dispatch editorView, "toggle-markdown-task:toggle"
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open()

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorView = atom.views.getView(editor)
      activationPromise = atom.packages.activatePackage("toggle-markdown-task")

  describe "when the cursor is on a single line", ->
    it "toggles a task from incomplete to complete", ->
      editor.setText """
        - [ ] A
        - [ ] B
        - [ ] C
      """
      editor.setCursorBufferPosition([1, 0])

      toggleMarkdownTask ->
        expect(editor.getText()).toBe """
          - [ ] A
          - [x] B
          - [ ] C
        """

    it "toggles a task from complete to incomplete", ->
      editor.setText """
        - [ ] A
        - [x] B
        - [ ] C
      """
      editor.setCursorBufferPosition([1, 0])

      toggleMarkdownTask ->
        expect(editor.getText()).toBe """
          - [ ] A
          - [ ] B
          - [ ] C
        """

    it "retains the original cursor position", ->
      editor.setText """
        - [ ] A
        - [ ] B
        - [ ] C
      """
      editor.setCursorBufferPosition([1, 2])

      toggleMarkdownTask ->
        expect(editor.getCursorBufferPosition()).toEqual [1, 2]

  describe "when multiple lines are selected", ->
    it "toggles completion of the tasks on the selected lines", ->
      editor.setText """
        - [ ] A
        - [ ] B
        - [ ] C
        - [ ] D
      """
      editor.setSelectedBufferRange([[1,1], [2,1]])

      toggleMarkdownTask ->
        expect(editor.getText()).toBe """
          - [ ] A
          - [x] B
          - [x] C
          - [ ] D
        """

    it "retains the original selection range", ->
      editor.setText """
        - [ ] A
        - [ ] B
        - [ ] C
        - [ ] D
      """
      editor.setSelectedBufferRange([[1,1], [2,1]])

      toggleMarkdownTask ->
        expect(editor.getSelectedBufferRange()).toEqual [[1,1], [2,1]]

  describe "when multiple cursors are present", ->
    it "toggles completion of the tasks in every cursor's selection range", ->
      editor.setText """
        - [ ] A
        - [ ] B
        - [ ] C
        - [ ] D
      """

      # Add cursor with empty selection range on the line of task "A"
      editor.addCursorAtBufferPosition([0, 0])

      # Add cursor with selection range that includes tasks "C" and "D"
      editor.addSelectionForBufferRange([[2, 0], [3, 7]])

      toggleMarkdownTask ->
        expect(editor.getText()).toBe """
          - [x] A
          - [ ] B
          - [x] C
          - [x] D
        """
