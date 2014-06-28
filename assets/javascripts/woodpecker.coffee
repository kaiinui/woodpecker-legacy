window.addEventListener 'load', ->
  WoodPecker.initalize()

# @class WoodPecker

window.WoodPecker = {}

# @public

WoodPecker.initalize = ->
  ["a", "p", "div", "span", "img", "iframe", "li", "dt", "dd", "h1", "h2", "h3", "h4", "h5", "h6"].forEach (elName)->
    WoodPecker._registElementEvents(elName)
  WoodPecker.UI.addShowSampleJSONButton()

# @private

WoodPecker._registElementEvents = (elName)->
  # [TODO] overlap element so that it doesn't mess original element.
  $$(elName).each (el)->
    return unless el.hasAnyTextAtRoot()
    el.on 'mouseover', (e)->
      WoodPecker._registMouseover(e)
    el.on 'mouseout', (e)->
      WoodPecker._registMouseout(e)
    el.on 'click', (e)->
      WoodPecker._registOnclick(e)

WoodPecker._registOnclick = (e)->
  return unless e.target.hasAnyTextAtRoot()
  e.stopPropagation()
  e.preventDefault()
  console.log getXPath(e.target)
  WoodPecker.UI.addOverlayAt(e.target)

WoodPecker._registMouseover = (e)->
  return unless e.target.hasAnyTextAtRoot() # [FIXME] Somehow return above does not work properly.
  e.target.css "background", "yellow"

WoodPecker._registMouseout = (e)->
  e.target.css "background", "inherit"

# @class WoodPecker.UI

WoodPecker.UI = {}

# @public

WoodPecker.UI.addOverlayAt = (el)->
  $el = $(el)
  $offset = $el.offset()
  $("<div class='wp-overlay-label'/>").css(
    "left": $offset.left
    "top": $offset.top
    "width": $el.width()
    "height": $el.height()
  ).appendTo $("body")
  WoodPecker.UI._addFieldNameInputAt(el)

WoodPecker.UI.addShowSampleJSONButton = ->
  $("<a href='' class='wp-button-show-sample' />").text("Show").on('click', (e)->
    e.preventDefault()
    WoodPecker.UI._showSampleJSON()
  ).appendTo $("body")

# @private

WoodPecker.UI._showSampleJSON = ->
  json = WoodPecker.Field.sampleJSONHTML()
  $("<div id='_wp_samplejson_overlay' class='wp-overlay-all' />").append(
    $("<span />").html(json).prepend(
      $("<h3 />").text("JSON")
    )
  ).append(
    $("<a href=''/>").addClass("wp-button-close").text("x").on('click', (e)->
      e.preventDefault()
      $("#_wp_samplejson_overlay").remove()
    )
  ).appendTo $("body")

# @private

WoodPecker.UI._addFieldNameInputAt = (el)->
  $el = $(el)
  $offset = $el.offset()
  $text = $el.text()
  $("<input type='text' class='wp-input-field' placeholder='Field Name'/>").css(
    "left": $offset.left
    "top": $offset.top - 30
  ).on('keydown', (e)->
    return unless e.keyCode == 13
    name = e.target.value
    WoodPecker.Field.setItem(
      "text": $text
      "name": name
      "xpath": getXPath(el).replace(/"/g, "'")
    )
    WoodPecker.UI._addFieldNameLabelAt name, el
    $(this).remove()
  ).appendTo($("body")).focus()

WoodPecker.UI._addFieldNameLabelAt = (name, el)->
  $el = $(el)
  $offset = $el.offset()
  $("<span class='wp-field-name-label' />").css(
    "left": $offset.left - 10
    "top": $offset.top - 10
  ).text(name).appendTo $("body")

# @class WoodPecker.field

WoodPecker.Field = {}
WoodPecker.Field._storage = []

# @public

WoodPecker.Field.all = ->
  WoodPecker.Field._storage

WoodPecker.Field.setItem = (item)->
  WoodPecker.Field._storage.push item

# @private

WoodPecker.Field._toSchemaYAML = ->
  WoodPecker.Field.all().map( (field)->
    "#{field.name}: #{field.xpath}"
  ).join("\n")

WoodPecker.Field._toSchemaJSON = ->
  json = {}
  WoodPecker.Field.all().forEach (field)->
    json[field.name] = field.xpath
  JSON.stringify json, null, 4

WoodPecker.Field.sampleJSON = ->
  json = {}
  WoodPecker.Field.all().forEach (field)->
    json[field.name] = field.text
  JSON.stringify json, null, 4

WoodPecker.Field.sampleJSONHTML = ->
  WoodPecker.Field.sampleJSON().replace(/( )/gm,"&nbsp;").replace(/(\r\n|\n|\r)/gm,"<br />")

# @extension

Element.prototype.hasAnyTextAtRoot = ->
  this.textAtRoot().removeSpaces() != ""

Element.prototype.textAtRoot = ->
  this.innerHTML
    .removeLineBreaks()
    .replace(/<.*>/gm, "")

String.prototype.removeLineBreaks = ->
  this.replace(/(\r\n|\n|\r)/gm,"")

String.prototype.removeSpaces = ->
  this.replace(/( )/gm, "")