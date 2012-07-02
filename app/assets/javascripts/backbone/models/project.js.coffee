class Specifications.Models.Project extends Backbone.Model
  paramRoot: 'project'

  defaults:
    name: null
    description: null

  initialize: ->
    @features = new Specifications.Collections.FeaturesCollection()
    @features.url = "/projects/#{@id}/features"  
    @features.parent=@

class Specifications.Collections.ProjectsCollection extends Backbone.Collection
  model: Specifications.Models.Project
  url: '/projects'
