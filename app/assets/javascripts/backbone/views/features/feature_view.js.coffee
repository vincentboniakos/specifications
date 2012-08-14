Specifications.Views.Features ||= {}

class Specifications.Views.Features.FeatureView extends Backbone.View
  template: JST["backbone/templates/features/feature"]
  tagName: "article"

  addUserstories: () =>
    request = @model.userstories.fetch()
    request.complete (xhr, status) =>
      @model.userstories.each(@addOneUserstory)

  addOneUserstory: (userstory) =>
   	view = new Specifications.Views.Userstories.UserstoryView({model : userstory})
    @$(".userstories").append(view.render().el)

  render: ->
    @el.id = "a_feature_#{@model.id}"
    $(@el).html(@template(@model.toJSON() ))
    @addUserstories()
    sortableFeatures(".features");
    return this