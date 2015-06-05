exampleApp = angular.module 'exampleApp', ['ExampleModel', 'navigationBar', 'ngTouch']

exampleApp.controller 'IndexCtrl', ($scope, ExampleRestangular) ->

  $scope.exampleViews = []

  $scope.open = (url, isModal) ->
    if isModal
      steroids.modal.show
        view: $scope.exampleViews[url]
        navigationBar: true
    else
      steroids.layers.push
        view: $scope.exampleViews[url]
        navigationBar: true

  $scope.showMenu = () ->
    steroids.drawers.show {
      edge: steroids.screen.edges.LEFT
    }

  [
    {
      vari: 'mpaExamples'
      file: 'mpa_example'
    },
    {
      vari: 'deviceExamples',
      file: 'device_example'
    },
    {
      vari: 'dataExamples',
      file: 'data_example'
    }
  ].forEach (exampleSet)->

    ExampleRestangular.all(exampleSet.file).getList().then (examples) ->
      $scope[exampleSet.vari] = examples;
      angular.forEach examples, (val, idx) ->
        @[val.url] = new steroids.views.WebView val.url
        @[val.url].preload()
      , $scope.exampleViews

  #Native navigation
  steroids.view.navigationBar.show()
  steroids.view.setBackgroundColor "#FFFFFF"
