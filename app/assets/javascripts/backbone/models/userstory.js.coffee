class Specifications.Models.Userstory extends Backbone.Model
  paramRoot: 'userstory'

  defaults:
    content: null

class Specifications.Collections.UserstoriesCollection extends Backbone.Collection
  model: Specifications.Models.Userstory
  url: '/userstories'
