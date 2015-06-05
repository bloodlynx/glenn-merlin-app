# The contents of individual model .js files will be concatenated into dist/models.js

do ->

	# Protects views where AngularJS is not loaded from errors
	if ( typeof angular == 'undefined' )
		return

	module = angular.module('ExampleModel', ['restangular'])

	module.factory 'ExampleRestangular', (Restangular)->

	  return Restangular.withConfig (RestangularConfigurer)->

	    RestangularConfigurer.setBaseUrl 'http://localhost/data'
	    RestangularConfigurer.setRequestSuffix '.json'
