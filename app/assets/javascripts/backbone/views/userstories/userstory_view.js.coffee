Specifications.Views.Userstories ||= {}

class Specifications.Views.Userstories.UserstoryView extends Backbone.View
  template: JST["backbone/templates/userstories/userstory"]
  tagName: "li"

  events :
    "dblclick p" : "addEditForm"

  addEditForm: () =>
   	view = new Specifications.Views.Userstories.EditView({model : @model})
   	$action_group = @$(".action-group")
    $action_group.after(view.render().el)
    $action_group.parent().find("div.edit_userstory").find("textarea").focus();
    @$("p").hide()
    $action_group.hide()


  render: ->
    @el.id = "userstory_#{@model.id}"
    $(@el).html(@template(@model.toJSON() ))
    sortableUserstories(".userstories")
    return this