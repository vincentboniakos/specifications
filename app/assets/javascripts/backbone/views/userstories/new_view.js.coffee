Specifications.Views.Userstories ||= {}

class Specifications.Views.Userstories.NewView extends Backbone.View
  template: JST["backbone/templates/userstories/new"]
  tagName: "div"
  className: "well new_userstory"

  constructor: (options) ->
    super(options)
    @model = new @collection.model(feature_id: @collection.parent.id)

    @model.bind("change:errors", () =>
      this.render()
    )

  events :
    "submit .new-userstory" : "update"
    "click .cancel" : "cancel"
    "keydown .submit_on_return" : "submitOnReturn"
    "click .show_form_new_userstory": "showUserstoryForm"

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
    $(e.currentTarget).closest("form.new-userstory").hide();
    $(e.currentTarget).closest(".new_userstory").find("a.show_form_new_userstory").show();
      
  submitOnReturn : (e) ->
    if e.keyCode == 13
      e.preventDefault()
      @$("form").find('textarea').blur()
      @$("form").submit()

  showUserstoryForm: (e) ->
    e.preventDefault()
    $(e.currentTarget).hide();
    $(e.currentTarget).parent().find("form.new-userstory").show()
    $(e.currentTarget).parent().find("form.new-userstory").find("textarea").focus()

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    this.$("form").backboneLink(@model)
    return this