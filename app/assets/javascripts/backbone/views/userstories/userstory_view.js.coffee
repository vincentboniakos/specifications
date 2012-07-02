Specifications.Views.Userstories ||= {}

class Specifications.Views.Userstories.UserstoryView extends Backbone.View
  template: JST["backbone/templates/userstories/userstory"]
  tagName: "li"

  render: ->
    @el.id = "userstory_#{@model.id}"
    $(@el).html(@template(@model.toJSON() ))
    return this