###*
# @ngdoc directive
# @name excerpt
# @restrict AE
# @description Checks to see if text is overflowing its container.
# If so, it prepends/appends expanders/collapsers. Note, to work
# the element needs a max height.
###
module.exports = ->
  link: (scope, elem, attr, ctrl) ->
    if scope.enabled == undefined
      scope.enabled = true

    if scope.showControls == undefined
      scope.showControls = true

    scope.collapsed = true

    scope.isOverflowing = ->
      excerpt = elem[0].querySelector('.excerpt')
      if excerpt == null
        return false
      return elem[0].scrollHeight > elem[0].clientHeight

    scope.toggle = ->
      scope.collapsed = !scope.collapsed

  scope:
    excerptHeight: '=excerptHeight'
    enabled: '=?excerptIf'
    bottomGradient: '=?excerptBottomGradient'
    showControls: '=?excerptShowControls'
  restrict: 'AE'
  transclude: true
  templateUrl: 'excerpt.html'
