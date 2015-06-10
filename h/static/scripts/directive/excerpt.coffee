###*
# @ngdoc directive
# @name excerpt
# @restrict C
# @description Checks to see if text is overflowing its container.
# If so, it prepends/appends expanders/collapsers. Note, to work
# the element needs a max height.
###
module.exports = [ '$timeout', ($timeout) ->
  link: (scope, elem, attr, ctrl) ->
    # Check for excerpts if an annotation has been created / edited.
    scope.$watch (-> scope.vm.editing), (editing) ->
      if editing
        elem.find('.more').remove()
        elem.find('.less').remove()
      scope.excerpt()

    # Check for excerpts on threadCollapseToggle event.
    scope.$on 'threadToggleCollapse', (value) ->
      scope.excerpt()

    do scope.excerpt = ->
      $timeout ->
        if elem.find('.more').length == 0
          if elem[0].scrollHeight > elem[0].clientHeight
            elem.prepend angular.element '<span class="more"> More...</span>'
            elem.append angular.element '<span class="less"> Less ^</span>'
            elem.find('.more').on 'click', ->
              $(this).hide()
              elem.addClass('show-full-excerpt')
            elem.find('.less').on 'click', ->
              elem.find('.more').show()
              elem.removeClass('show-full-excerpt')
  restrict: 'C'
]
