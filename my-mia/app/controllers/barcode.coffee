barcodeApp = angular.module "barcodeApp", ["ngTouch"]

barcodeApp.controller "IndexCtrl", ($scope)->
  steroids.view.navigationBar.show "Barcode Scanner"
  steroids.view.setBackgroundColor "#FFFFFF"

  $scope.scanResult = "Waiting for barcode..."

  # Create navigation bar button
  navButton = new steroids.buttons.NavigationBarButton()
  navButton.title = "Scan"
  navButton.onTap = ->
    scan()

  # Assign the button to the navigation bar
  steroids.view.navigationBar.update
    buttons: {
      right: [navButton]
    }

  # Prompts the user to scan a barcode. Called when the user
  # taps the right navigation bar button.
  scan = ->
    scanner = cordova.plugins.barcodeScanner

    scanner.scan (result)->
      if result.cancelled
        $scope.scanResult = "Scan cancelled."
        $scope.$apply()
      else
        $scope.scanResult = "(#{result.format}) #{result.text}"
        $scope.$apply()
