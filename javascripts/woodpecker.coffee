window.addEventListener 'load', ->
  WoodPecker.initalize()

# @class WoodPecker

window.WoodPecker = {}

# @public

WoodPecker.initalize = ->
  ["a", "p", "div", "span", "img", "iframe", "li", "dt", "dd", "h1", "h2", "h3", "h4", "h5", "h6"].forEach (elName)->
    WoodPecker._registElementEvents(elName)

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

#**JQUERY
WoodPecker.UI.addOverlayAt = (el)->
  $el = $(el)
  $offset = $el.offset()
  $("<div />").css(
    "background": "yellow" # [TODO]: CSS stylize
    "opacity": 0.5
    "boxShadow": "0 1px 2px rgba(0,0,0,.25)"
    "zIndex": 23929393
    "position": "absolute"
    "left": $offset.left
    "top": $offset.top
    "width": $el.width()
    "height": $el.height()
  ).appendTo $("body")
  WoodPecker.UI._addFieldNameInputAt(el)

# @private

WoodPecker.UI._addFieldNameInputAt = (el)->
  $el = $(el)
  $offset = $el.offset()
  $("<input type='text' placeholder='Field Name'/>").css(
    "position": "absolute"
    "zIndex": 33929392
    "height": 20
    "left": $offset.left
    "top": $offset.top - 30
  ).on('keydown', (e)->
    return unless e.keyCode == 13
    name = e.target.value
    WoodPecker.Field.setItem(
      name: name
      xpath: getXPath(el)
    )
    WoodPecker.UI._addFieldNameLabelAt name, el
    $(this).remove()
  ).appendTo $("body")

WoodPecker.UI._addFieldNameLabelAt = (name, el)->
  $el = $(el)
  $offset = $el.offset()
  $("<span />").css(
    "background": "orange"
    "boxShadow": "0 1px 2px rgba(0,0,0,.25)"
    "color": "white"
    "position": "absolute"
    "zIndex": 425343434
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

WoodPecker.Field._toYAML = ->
  WoodPecker.Field.all.map (field)->
    "#{field.name}: #{field.xpath}"


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