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

  describe "when the cursor is on the line of an incomplete task", ->
    it "marks the task as completed", ->
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

  describe "when the cursor is on the line of a completed task", ->
    it "marks the task as incomplete", ->
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
