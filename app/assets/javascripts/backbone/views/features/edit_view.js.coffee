Specifications.Views.Features ||= {}

class Specifications.Views.Features.EditView extends Backbone.View
  template: JST["backbone/templates/features/edit"]

  events :
    "submit #edit-feature" : "update"
    "click #cancel" : "cancel"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (feature) =>
        @model = feature
        window.history.back()
    )

  cancel : (e) ->
      e.preventDefault()
      e.stopPropagation()
      window.history.back()  

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    this.$("form#edit-feature").backboneLink(@model)
    return this