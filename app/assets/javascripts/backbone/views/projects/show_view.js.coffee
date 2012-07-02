Specifications.Views.Projects ||= {}

class Specifications.Views.Projects.ShowView extends Backbone.View
  template: JST["backbone/templates/projects/show"]

  addFeatures: () =>
    request = @model.features.fetch()
    request.complete (xhr, status) =>
      @model.features.each(@addOneFeature)


  addOneFeature: (feature) =>
    view = new Specifications.Views.Features.FeatureView({model : feature})
    @$(".features").append(view.render().el)

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    @addFeatures()
    return this
