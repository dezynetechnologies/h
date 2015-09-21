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
    scope.collapsed = true

    scope.isOverflowing = ->
      excerpt = elem[0].querySelector('.excerpt')
      if excerpt == null
        return false
      return elem[0].scrollHeight > elem[0].clientHeight

    scope.toggle = ->
      scope.collapsed = !scope.collapsed

  scope:
    enabled: '=excerptIf'
    maxheight: '=maxheight'
    bottomGradient: '=excerptBottomGradient'
  restrict: 'AE'
  transclude: true
  template: '''
    <ng-transclude></ng-transclude>

    <div class="excerpt-wrapper">
      <div class="excerpt" ng-style="maxheight"
         ng-class="{'excerpt-uncollapsed': !collapsed}"
         ng-transclude>
      </div>
      
      <div class="excerpt-control" ng-if="enabled" ng-class="{'excerpt-bottom-gradient': bottomGradient}">
        <a ng-if="isOverflowing() && collapsed"
           ng-click="toggle()"
           class="more"
           href="">More</a>
        <a ng-if="!collapsed"
           class="less"
           ng-click="toggle()"
           href="">Less</a>
      </div>
    </div>
  '''
