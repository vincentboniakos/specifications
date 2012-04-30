class Specifications.Models.Project extends Backbone.Model
  paramRoot: 'project'

  defaults:
    name: null
    description: null

class Specifications.Collections.ProjectsCollection extends Backbone.Collection
  model: Specifications.Models.Project
  url: '/projects'
