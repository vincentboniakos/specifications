class Specifications.Models.Feature extends Backbone.Model
  paramRoot: 'feature'

  defaults:
    name: null
    description: null
    project_id: null

  initialize: ->
    @userstories = new Specifications.Collections.UserstoriesCollection()
    @userstories.url = "/projects/#{@attributes.project_id}/features/#{@id}/userstories"  
    @userstories.parent=@

class Specifications.Collections.FeaturesCollection extends Backbone.Collection
  model: Specifications.Models.Feature
  url: '/features'
