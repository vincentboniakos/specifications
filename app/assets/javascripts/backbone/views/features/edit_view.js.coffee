Specifications.Views.Features ||= {}

class Specifications.Views.Features.EditView extends Backbone.View
  template: JST["backbone/templates/features/edit"]

  events :
    "submit #edit-feature" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (feature) =>
        @model = feature
        window.location.hash = "/#{@model.attributes.project_id}/features/#{@model.id}"
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    this.$("form#edit-feature").backboneLink(@model)
    return this