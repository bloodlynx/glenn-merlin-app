modalApp = angular.module 'modalApp', ['ngTouch']

modalApp.controller 'IndexCtrl', ($scope) ->

  steroids.view.navigationBar.show "Modal"

  $scope.hideModal = () ->
    steroids.modal.hide()
