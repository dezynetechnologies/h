###*
# @ngdoc directive
# @name excerpt
# @restrict A
# @description Checks to see if text is overflowing its container.
# If so, it prepends/appends expanders/collapsers. Note, to work
# the element needs a max height.
###
module.exports = ->
  link: (scope, elem, attr, ctrl) ->
    scope.collapsed = true

    scope.isOverflowing = ->
      excerpt = elem[0].querySelector('.excerpt')
      if excerpt == null
        return false
      return excerpt.scrollHeight > excerpt.clientHeight

    scope.toggle = ->
      scope.collapsed = !scope.collapsed

  scope:
    bottomGradient: '=?excerptBottomGradient'
    showControls: '=excerptShowControls'
    excerptClass: '@excerptClass'
  restrict: 'A'
  transclude: true
  templateUrl: 'excerpt.html'
