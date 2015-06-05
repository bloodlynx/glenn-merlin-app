document.addEventListener "deviceready", ->
  angular.bootstrap document, ['cameraApp']

cameraApp = angular.module 'cameraApp', ['ngTouch']

cameraApp.controller 'IndexCtrl', ($scope)->

  # Native UI
  steroids.view.navigationBar.show "Camera"

  # Camera options

  $scope.imageSrc = null
  $scope.cordovaError = undefined

  $scope.cameraOptions =
    fromPhotoLibrary:
      quality: 100
      destinationType: navigator.camera.DestinationType.IMAGE_URI
      sourceType: navigator.camera.PictureSourceType.PHOTOLIBRARY
      correctOrientation: true # Let Cordova correct the picture orientation (WebViews don't read EXIF data properly)
      targetWidth: 600
      popoverOptions: # iPad camera roll popover position
        width: 768
        height: 190
        arrowDir: Camera.PopoverArrowDirection.ARROW_UP

    fromCamera:
      quality: 100
      destinationType: navigator.camera.DestinationType.IMAGE_URI
      correctOrientation: true
      targetWidth: 600

  # Camera failure callback
  cameraError = (message)->
    $scope.cordovaError = message
    $scope.showSpinner = false
    $scope.$apply()

  # File system failure callback
  fileError = (error)->
    $scope.cordovaError = "Cordova error code: " + error.code
    $scope.showSpinner = false
    $scope.$apply()

  # Take a photo using the device's camera with given options, callback chain starts
  $scope.getPicture = (options)->
    $scope.cordovaError = undefined
    navigator.camera.getPicture imageUriReceived, cameraError, options
    $scope.showSpinner = true
    $scope.$apply()

  # Move the selected photo from Cordova's default tmp folder to Steroids's user files folder
  imageUriReceived = (imageURI)->
    window.resolveLocalFileSystemURI imageURI, gotFileObject, fileError

  gotFileObject = (file)->
    # Define a target directory for our file in the user files folder
    # steroids.app variables require the Steroids ready event to be fired, so ensure that
    steroids.on "ready", ->
      targetDirURI = "file://" + steroids.app.absoluteUserFilesPath
      fileName = "user_pic.png"

      window.resolveLocalFileSystemURI(
        targetDirURI
        (directory)->
          file.moveTo directory, fileName, fileMoved, fileError
        fileError
      )

    # Store the moved file's URL into $scope.imageSrc
    fileMoved = (file)->
      # localhost serves files from both steroids.app.userFilesPath and steroids.app.path, add timestamp to circumvent cache issues
      $scope.imageSrc = "/#{file.name}?#{(new Date()).getTime()}"
      $scope.showSpinner = false
      $scope.$apply()
