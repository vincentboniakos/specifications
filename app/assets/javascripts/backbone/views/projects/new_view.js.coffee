Specifications.Views.Projects ||= {}

class Specifications.Views.Projects.NewView extends Backbone.View
  template: JST["backbone/templates/projects/new"]

  events:
    "submit #new-project": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (project, jqXHR) =>
        @model = project
        window.location.hash = "/#{@model.id}"
        @model.features.url = "/projects/#{@model.id}/features"

      error: (project, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
