Specifications.Views.Userstories ||= {}

class Specifications.Views.Userstories.EditView extends Backbone.View
  template: JST["backbone/templates/userstories/edit"]
  tagName: "div"
  className: "edit_userstory"

  events :
    "submit .edit-userstory" : "update"
    "click .cancel" : "cancel"
    "keydown .submit_on_return" : "submitOnReturn" 

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (userstory) =>
        @model = userstory
        view = new Specifications.Views.Userstories.UserstoryView({model : @model})
        $userstory_html = @$(".edit-userstory").closest("li")
        $userstory_html.replaceWith(view.render().el)
    )

  cancel : (e) ->
    e.preventDefault()
    e.stopPropagation()
    @showHideControls(@$(".edit-userstory").closest("li"))
      
  submitOnReturn : (e) ->
    if e.keyCode == 13
      e.preventDefault()
      @$("form").find('textarea').blur()
      @$("form").submit()





  showHideControls : ($userstory_html) ->
    $userstory_html.find("p").show()
    $userstory_html.find(".action-group").show()
    $userstory_html.find(".edit_userstory").remove()

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    this.$("form").backboneLink(@model)
    return this