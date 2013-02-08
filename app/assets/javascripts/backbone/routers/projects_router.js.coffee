class Specifications.Routers.ProjectsRouter extends Backbone.Router
  initialize: (options) ->
    @projects = new Specifications.Collections.ProjectsCollection()
    @projects.reset options.projects

  routes:
    #Project
    "new"      : "newProject"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"
    #Feature
    ":project_id/features/new" : "newFeature"
    ":project_id/features/:id" : "showFeature"
    ":project_id/features/:id/edit" : "editFeature"

  #Project
  newProject: ->
    @view = new Specifications.Views.Projects.NewView(collection: @projects)
    $(".content").html(@view.render().el)

  index: ->
    @view = new Specifications.Views.Projects.IndexView(projects: @projects)
    $(".content").html(@view.render().el)

  show: (id) ->
    project = @projects.get(id)

    @view = new Specifications.Views.Projects.ShowView(model: project)
    $(".content").html(@view.render().el)
    sortableFeatures(".features")
    sortableUserstories(".userstories")

  edit: (id) ->
    project = @projects.get(id)

    @view = new Specifications.Views.Projects.EditView(model: project)
    $(".content").html(@view.render().el)

  #Feature
  newFeature: (project_id) ->
    @view = new Specifications.Views.Features.NewView(collection: @projects.get(project_id).features)
    $(".content").html(@view.render().el)

  showFeature: (project_id, id) ->
    @getFeature project_id, id, (feature) ->
      @view = new Specifications.Views.Features.ShowView(model: feature)
      $(".content").html(@view.render().el)
      sortableUserstories(".userstories")

  editFeature: (project_id, id) ->
    @getFeature project_id, id, (feature) ->
      @view = new Specifications.Views.Features.EditView(model: feature)
      $(".content").html(@view.render().el)



## PRIVATE
  getFeature: (project_id, id, callback) -> 
    project = @projects.get(project_id)
    feature = project.features.get(id)
    # If the feature is not yet added to the collection, go fetch it from the server
    if !feature?
      project.features.fetch().complete (xhr, status) => 
        feature = @projects.get(project_id).features.get(id)
        callback(feature)        
    else
      callback(feature)

