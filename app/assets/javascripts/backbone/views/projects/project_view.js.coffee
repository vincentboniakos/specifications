Specifications.Views.Projects ||= {}

class Specifications.Views.Projects.ProjectView extends Backbone.View
  template: JST["backbone/templates/projects/project"]


  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
