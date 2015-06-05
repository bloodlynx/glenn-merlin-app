settingsApp = angular.module 'settingsApp', ['navigationBar', 'ngTouch']

settingsApp.controller 'IndexCtrl', ($scope, $filter) ->

  ###
  Navigation
  ###

  $scope.showMenu = ()->
    steroids.drawers.show {
      edge: steroids.screen.edges.LEFT
    }

  steroids.view.navigationBar.show "Theme"

  ###
  Settings specific
  ###

  $scope.rgb =
    red: 0
    green: 174
    blue: 239

  $scope.$watch "rgb", () ->
    steroids.view.navigationBar.setStyleCSS "background-color: #{$filter("rgbToHex")($scope.rgb)}"
    steroids.tabBar.setStyleCSS "background-color: #{$filter("rgbToHex")($scope.rgb)}"
  , true

settingsApp.filter 'rgbToHex', () ->

  componentToHex = (component) ->
    component = parseInt(component)
    hex = component.toString(16)
    if hex.length is 1 then "0" + hex else hex

  (rgb) ->
    "#" + componentToHex(rgb.red) + componentToHex(rgb.green) + componentToHex(rgb.blue)