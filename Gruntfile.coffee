path = require('path')

module.exports = (grunt) ->	

	# Local paths
	comp = 'web/components/'
	css = 'web/css/'
	sass = 'web/sass/'
	js = 'web/js/'
	img = 'web/img/'
	font = 'web/font/'
	coffee = 'web/coffee/'
	dart = 'web/dart/'
	dist = 'dist/'
	build = 'build/'
	localhost = 'http://localhost:5000/'
	currentFolder = path.resolve().toString()

	# grunt.log.write path.join(currentFolder, js + 'polyfills')


	# Remote paths
	cdnUrl = '//s3.amazonaws.com/static.tok3n.com/<%= pkg.name %>/<%= pkg.version %>/'
		
	# Regex
	css_file = /([^\/]+)\.css$/

	@initConfig
		
		# Versions, names for licenses
		pkg: grunt.file.readJSON 'package.json'
		aws: grunt.file.readJSON '/Users/aficio/Dropbox/Development/Amazon/tok3n-aficio.json'


		shell:
			sleep:
				command: 'sleep 3s'


		curl:
			masonry:
				dest: js + 'masonry.pkgd.min.js'
				src: 'http://masonry.desandro.com/masonry.pkgd.min.js'
			buoy:
				dest: js + 'buoy.js'
				src: 'https://raw.githubusercontent.com/cferdinandi/buoy/master/buoy.js'
			
			# We need to find a way to do this programatically
			dashboard:
				src: localhost + 'dashboard'
				dest: dist + 'dashboard.html'

			'backup-codes':
				src: localhost + 'backup-codes'
				dest: dist + 'backup-codes.html'

			'devices/device-view':
				src: localhost + 'devices/device-view'
				dest:  dist + 'partials/' + 'devices/device-view' + '.html'

			'devices/device-new-1':
				src: localhost + 'devices/device-new-1'
				dest:  dist + 'partials/' + 'devices/device-new-1' + '.html'

			'devices/device-new-2':
				src: localhost + 'devices/device-new-2'
				dest:  dist + 'partials/' + 'devices/device-new-2' + '.html'

			'devices/device-new-3':
				src: localhost + 'devices/device-new-3'
				dest:  dist + 'partials/' + 'devices/device-new-3' + '.html'

			'phonelines/phoneline-view-cellphone':
				src: localhost + 'phonelines/phoneline-view-cellphone'
				dest:  dist + 'partials/' + 'phonelines/phoneline-view-cellphone' + '.html'

			'phonelines/phoneline-view-landline':
				src: localhost + 'phonelines/phoneline-view-landline'
				dest:  dist + 'partials/' + 'phonelines/phoneline-view-landline' + '.html'

			'phonelines/phoneline-new-1':
				src: localhost + 'phonelines/phoneline-new-1'
				dest:  dist + 'partials/' + 'phonelines/phoneline-new-1' + '.html'

			'phonelines/phoneline-new-2':
				src: localhost + 'phonelines/phoneline-new-2'
				dest:  dist + 'partials/' + 'phonelines/phoneline-new-2' + '.html'

			'phonelines/phoneline-new-3':
				src: localhost + 'phonelines/phoneline-new-3'
				dest:  dist + 'partials/' + 'phonelines/phoneline-new-3' + '.html'

			'integrations/integration-view':
				src: localhost + 'integrations/integration-view'
				dest:  dist + 'partials/' + 'integrations/integration-view' + '.html'

			'integrations/integration-new':
				src: localhost + 'integrations/integration-new'
				dest:  dist + 'partials/' + 'integrations/integration-new' + '.html'

			'integrations/integration-edit':
				src: localhost + 'integrations/integration-edit'
				dest:  dist + 'partials/' + 'integrations/integration-edit' + '.html'



		copy:
			jquery:
				src: comp + 'jquery/jquery.js'
				dest: js + 'jquery.js'


		compass:
			options:
				outputStyle: 'expanded'
				raw: """
				preferred_syntax = :sass
				::Sass::Script::Number.precision = [10, ::Sass::Script::Number.precision].max
				sass_options = {:quiet => true}

				"""
				require: ['breakpoint-slicer', 'animate']
				cssDir: css
				sassDir: sass
				imagesDir: img
				fontsDir: font
				javascriptsDir: js
			dev:
				options:
					relativeAssets: true
					force: true
			watch:
				options:
					relativeAssets: true
			production:
				options:
					force: true
					relativeAssets: false
					httpPath: cdnUrl
					httpJavascriptsPath: cdnUrl + 'js'
					httpStylesheetsPath: cdnUrl + 'css'
					httpImagesPath: cdnUrl + 'img'
					httpFontsPath: cdnUrl + 'font'


		csslint:
			options:
				csslintrc: '.csslintrc'
			files:
				src: [
					css + 'base.css'
					css + 'main.css'
				]


		cssmin:
			dist:
				options:
					report: 'gzip'
					banner: grunt.file.read('banner.txt')
				files: [
					{
						expand: true
						replace: true
						cwd: css
						src: ['*.css', '!*-min.css']
						dest: css
						ext: '-min.css'
					}
				]


		coffee: 
			options:
				bare: true
			glob:
				expand: true
				flatten: true
				cwd: 'web/coffee'
				src: ['*.coffee']
				dest: js
				ext: '.js'


		coffeelint:
			app:
				files:
					src: [coffee + '*.coffee']
				options:
					configFile: 'coffeelint.json'


		concat:
			options:
				separator: '\n'
			utils:
				src: [
					js + 'masonry.pkgd.min.js'
					js + 'modernizr.js'
					comp + 'jquery/dist/jquery.js'
					comp + 'parsleyjs/dist/parsley.js'
					comp + 'eventEmitter/EventEmitter.js'
					js + 'utils-pre.js'
				]				
				dest: js + 'utils.js'
			dashboard:
				src: [
					js + 'slider.js'
					js + 'main.js'
				]
				dest: js + 'dashboard.js'
			dashboardProd:
				src: [
					'<%= concat.utils.dest %>'
					js + 'async.js'
					js + 'screens.js'
					'<%= concat.dashboard.dest %>'
				]
				dest: js + 'dashboard-prod.js'


		uglify:
			options:
				mangle: true
				compress: true
				report: 'min'
				preserveComments: 'some'
			dashboard:
				options:
					banner: [
						'/*!'
						' * <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %>'
						' * <%= pkg.description %>'
						' * Automatically generated by Grunt.js'
						' */\n'
					].join '\n'
				src: '<%= concat.dashboardProd.dest %>'
				dest: js + 'dashboard-min.js'
			polyfills:
				expand: true
				cwd: js + 'polyfills'
				src: '*.js'
				dest: js + 'polyfills/min/'


		replace:
			dist:
				src: dist + '*.html'
				overwrite: true
				replacements: [
					{
						from: /(['"])css\/([^\/\n"']*)\.css(['"])/g
						to: "$1#{cdnUrl}css/$2-min.css$3"
					}
					{
						from: "url('../img/"
						to: "url('#{cdnUrl}img/"
					}
					{
						from: "url('../fonts/"
						to: "url('#{cdnUrl}fonts/"
					}
					{
						from: "url('fonts/"
						to: "url('#{cdnUrl}fonts/"
					}

					{
						from: 'src="../img/'
						to: 'src="' + cdnUrl + 'img/'
					}
				]
			# Sometimes compass does not compile correctly with the change to absolute refs, this is a hackish and temporal solution
			css:
				src: dist + 'css/style.css'
				overwrite: true
				replacements: [
					{
						from: '../img/'
						to: cdnUrl + 'img/'
					}
				]
			dashboard:
				src: '<%= uglify.dashboard.dest %>'
				dest: dist + 'js/dashboard-min.js'
				replacements: [
					from: ',/*!'
					to: ',\n/*!'
				]
			distHtmlHack:
				src: dist + 'dashboard.html'
				dest: dist + 'dashboard.html'
				replacements: [
					{
						from: '\n    <!--build:template-->'
						to: ''
					}
					{
						from: '\n    <!--/build-->'
						to: ''
					}
				]


		processhtml:
			options:
				data:
					cdnUrl: cdnUrl
				process: true
			dashboard:
				src: dist + 'dashboard.html'
				dest: dist + 'dashboard.html'
			'backup-codes':
				src: dist + 'backup-codes.html'
				dest: dist + 'backup-codes.html'


		prettify:
			html:
				options:
					unformatted: ['a', 'sub', 'sup', 'b', 'i', 'u', 'script']
				expand: true
				cwd: dist
				ext: '.html'
				src: ['*.html', '*/*.html', '*/*/*.html']
				dest: dist


		sync:
			dist:
				files:[
					{
						cwd: 'web'
						src: ['css/*-min.css', 'css/fonts/**', 'js/*-min.js', 'svg/**', 'img/**', 'sass/**', 'js/utils.js', 'js/async.js', 'js/screens.js', 'js/dashboard.js']
						dest: dist
					}
				]
			# dart:
			# 	files: [
			# 		{
			# 			cwd: 'build/web'
			# 			src: ['dart/**']
			# 			dest: dist
			# 		}
			# 	]


		imagemin:
			dist:
				options:
					optimizationLevel: 3
				files: [
					{
						expand: true
						cwd: img
						src: '{,*/}*.{png,jpg,jpeg}'
						dest: dist + 'img'
					}
				]


		watch:
			options:
				livereload: true
			coffee:
				files: coffee + '*'
				tasks: ['watch-coffee-tasks']
			sass:
				files: sass + '*'
				tasks: ['compass:watch']


		s3:
			options:
				key: '<%= aws.key %>'
				secret: '<%= aws.secret %>'
				bucket: 'static.tok3n.com'
				access: 'public-read'
				gzip: true
				gzipExclude: ['.jpg', '.jpeg', '.png', '.gif', 'tiff']
				headers:
					"Cache-Control": "max-age=630720000, public",
					"Expires": new Date(Date.now() + 63072000000).toUTCString()
			dist:
				options:
					verify: true
				sync: [
					{						
						src: dist + '**'
						dest: '/<%= pkg.name %>/<%= pkg.version %>/'
						rel: path.join(currentFolder, dist)
					}
				]
			polyfills:
				options:
					verify: true
				sync: [
					{
						src: js + 'polyfills/**'
						dest: '/<%= pkg.name %>/polyfills/'
						rel: path.join(currentFolder, js + 'polyfills')
					}
					{
						src: js + 'compatibility.js'
						dest: '/<%= pkg.name %>/polyfills/compatibility.js'
					}
				]


	@registerTask 'bower-install', 'Installs Bower dependencies.', ->
		bower = require 'bower'
		done = this.async()
		bower.commands.install()
			.on 'data', (data) ->
				grunt.log.write data
				return
			.on 'end', done
		return


	@loadNpmTasks 'grunt-contrib-concat'
	@loadNpmTasks 'grunt-contrib-compass'
	@loadNpmTasks 'grunt-contrib-csslint'
	@loadNpmTasks 'grunt-contrib-copy'
	@loadNpmTasks 'grunt-contrib-uglify'
	@loadNpmTasks 'grunt-contrib-watch'
	@loadNpmTasks 'grunt-contrib-cssmin'
	@loadNpmTasks 'grunt-contrib-imagemin'
	@loadNpmTasks 'grunt-coffee-redux'
	@loadNpmTasks 'grunt-contrib-coffee'
	@loadNpmTasks 'grunt-shell'
	@loadNpmTasks 'grunt-text-replace'
	@loadNpmTasks 'grunt-sync'
	@loadNpmTasks 'grunt-prettify'
	@loadNpmTasks 'grunt-uncss'
	@loadNpmTasks 'grunt-processhtml'
	@loadNpmTasks 'grunt-curl'
	@loadNpmTasks 'grunt-coffeelint'
	@loadNpmTasks 'grunt-s3'

	@registerTask 'build', [
		'bower-install'
		'shell:sleep'
		'shell:files'
		'copy'
	]

	@registerTask 'curlAll', [
		'curl:dashboard'
		'curl:backup-codes'

		'curl:devices/device-view'
		'curl:devices/device-new-1'
		'curl:devices/device-new-2'
		'curl:devices/device-new-3'

		'curl:phonelines/phoneline-view-cellphone'
		'curl:phonelines/phoneline-view-landline'
		'curl:phonelines/phoneline-new-1'
		'curl:phonelines/phoneline-new-2'
		'curl:phonelines/phoneline-new-3'

		'curl:integrations/integration-view'
		'curl:integrations/integration-new'
		'curl:integrations/integration-edit'

	]

	@registerTask 'distBuildHtml', [
		'sync'
		'shell:sleep'
		'curlAll'
		'replace:dist'
		'prettify'
		'processhtml'
		'replace:distHtmlHack'
	]

	@registerTask 'watch-coffee-tasks', [
		'coffeelint'
		'coffee'
		'concat:utils'
		'concat:dashboard'
	]

	@registerTask 'default', [
		'compass:dev'
		'csslint'
		'coffeelint'
		'coffee'
		'concat'
	]

	@registerTask 'dist-test', [
		'compass:production'
		'csslint'
		'coffeelint'
		'coffee'
		'concat:dashboardProd'
		'uglify'
		'cssmin:dist'
		'distBuildHtml'
		'imagemin:dist'
	]

	@registerTask 'dist', [
		'dist-test'
		's3'
	]