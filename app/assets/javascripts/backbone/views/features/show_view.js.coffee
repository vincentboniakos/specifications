Specifications.Views.Features ||= {}

class Specifications.Views.Features.ShowView extends Specifications.Views.Features.FeatureView
  template: JST["backbone/templates/features/show"]

  events:
    "click .destroy" : "destroy"

  destroy: () ->
    project_id = @model.attributes.project_id
    @model.destroy()
    this.remove()
    window.location.hash = "/#{project_id}"
    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    @addUserstories()
    return this