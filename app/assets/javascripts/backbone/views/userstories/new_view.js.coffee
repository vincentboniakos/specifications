Specifications.Views.Userstories ||= {}

class Specifications.Views.Userstories.NewView extends Backbone.View
  template: JST["backbone/templates/userstories/new"]
  tagName: "div"
  className: "well new_userstory"

  events :
    "submit .new-userstory" : "update"
    "click .cancel" : "cancel"
    "keydown .submit_on_return" : "submitOnReturn" 

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (userstory) =>
        @model = userstory
        # @TODO : Handle save
    )

  cancel : (e) ->
    e.preventDefault()
    e.stopPropagation()
    # @TODO : Handle cancel
      
  submitOnReturn : (e) ->
    if e.keyCode == 13
      e.preventDefault()
      @$("form").find('textarea').blur()
      @$("form").submit()


  render: ->
    $(@el).html(@template(@model.toJSON() ))
    this.$("form").backboneLink(@model)
    return this