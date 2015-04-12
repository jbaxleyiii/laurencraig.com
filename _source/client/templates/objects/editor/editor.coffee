Meteor.startup ->
  class @BlogEditor extends MediumEditor

    # FACTORY
    @make: (tpl) ->

      # Set up the medium editor with image upload
      editor = new BlogEditor '.editable',
        placeholder: ''
        firstHeader: 'h1'
        secondHeader: 'h2'
        buttonLabels: 'fontawesome'
        buttons:
          ['bold', 'italic', 'underline', 'anchor', 'header1', 'header2', 'orderedlist', 'unorderedlist', 'quote']
        cleanPastedHTML: true

      tpl.editor = editor


      tpl.$('.editable').mediumInsert
        editor: editor
        enabled: true
        addons:
          images:
            uploadFile: ($placeholder, file, that) ->
              # Use CollectionFS + Amazon S3
              FS.Utility.eachFile event, (file) ->
                S3Files.insert file, (err, fileObj) ->
                  Tracker.autorun (c) ->
                    theFile = S3Files.find({_id: fileObj._id}).fetch()[0]
                    if theFile.isUploaded() and theFile.url?()
                      that.uploadCompleted { responseText: theFile.url() }, $placeholder
                      c.stop()
                      return
                    else
                      $progress = $('.progress:first', this.$el)
                      complete = theFile.uploadProgress() ? 0
                      $progress.attr 'value', complete
                      $progress.html complete

          embeds:
            label: '<span class="fa fa-youtube-play"></span>'
            placeholder: 'Paste a YouTube, Vimeo, Facebook, Twitter or Instagram link and press Enter'
            captionPlaceholder: 'Type caption (optional)'
            oembedProxy: 'http://medium.iframe.ly/api/oembed?iframe=1'
            actions: remove:
              label: '<span class="fa fa-times"></span>'
              clicked: ($el) ->
                # (function) Callback function called when an action is selected
                $event = $.Event('keydown')
                $event.which = 8
                $(document).trigger $event
                return

      editor

    # INSTANCE METHODS

    constructor: ->
      @init.apply @, arguments

      # Don't let the medium insert plugin submit the form
      $('form').on 'click', (event) ->
        if $(event.target).is '.mediumInsert' then event.preventDefault();

    # Return medium editor's contents
    contents: ->
      @.serialize()['element-0'].value

    # Return medium editor's contents thru HTML beautifier
    pretty: ->
      html_beautify @.contents(),
        preserve_newlines: false
        indent_size: 2
        wrap_line_length: 0

    # Highlight code blocks
    highlightSyntax: ->
      hljs.configure userBR: true

      br2nl = (i, html) ->
        html
          # medium-editor leaves <br>'s in <pre> tags, which screws up
          # highlight.js. Replace them with actual newlines.
          .replace(/<br>/g, "\n")
          # Strip out highlight.js tags so we don't create them multiple times
          .replace(/<[^>]+>/g, '')

      # Remove 'hljs' class so we don't create it multiple times
      $(@elements[0]).find('pre').removeClass('hljs').html(br2nl).each (i, block) ->
        hljs.highlightBlock block

    # inPreformatted: =>
    #   @.findMatchingSelectionParent (el) ->
    #     el.tagName.toLowerCase() is 'pre'

    # Disable medium toolbar if we are in a code block
    checkSelection: ->
      # if @.inPreformatted()
      #   return false
      #
      super()

    # Disable "hard" returns if we are in a code block
    bindParagraphCreation: (index) ->
      @.elements[index].addEventListener 'keyup', (e) =>
        if e.which is 13 and @inPreformatted()
          e.preventDefault()
          @options.disableReturn = true
        else
          @options.disableReturn = false

      super index

    # Insert "soft" returns always if we are in a code block
    bindReturn: (index) ->
      @.elements[index].addEventListener 'keypress', (e) =>
        if e.which is 13 and @inPreformatted()
          e.preventDefault()
          document.execCommand 'insertHTML', false, "\n"

      super index
