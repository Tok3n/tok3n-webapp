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
			index:
				dest: dist + 'index.html'
				src: 'http://localhost:5000'
			apps:
				dest: dist + 'apps.html'
				src: 'http://localhost:5000/apps'
			loginV2:
				dest: dist + 'login-v2.html'
				src: 'http://localhost:5000/login-v2'
			masonry:
				dest: js + 'masonry.pkgd.min.js'
				src: 'http://masonry.desandro.com/masonry.pkgd.min.js'
			buoy:
				dest: js + 'buoy.js'
				src: 'https://raw.githubusercontent.com/cferdinandi/buoy/master/buoy.js'
		
		copy:
			jquery:
				src: comp + 'jquery/jquery.js'
				dest: js + 'jquery.js'

		coffee: 
			options:
				bare: true
			main:
				src: coffee + 'main.coffee'
				dest: js + 'main.js'
			slider:
				src: coffee + 'slider.coffee'
				dest: js + 'slider.js'
			async:
				src: coffee + 'async.coffee'
				dest: js + 'async.js'
			compatibility:
				src: coffee + 'compatibility.coffee'
				dest: js + 'compatibility.js'
			test:
				src: coffee + 'test.coffee'
				dest: js + 'test.js'
			jQueryDashboard:
				src: coffee + 'jquery-dashboard.coffee'
				dest: js + 'jquery-dashboard.js'
		
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
				
		concat:
			options:
				separator: '\n'
			utils:
				src: [
					js + 'masonry.pkgd.min.js'
					js + 'modernizr.js'
					comp + 'jquery/dist/jquery.js'
					comp + 'parsleyjs/dist/parsley.js'
				]				
				dest: js + 'utils.js'
			dashboard:
				src: [
					'<%= coffee.main.dest %>'
					'<%= coffee.jQueryDashboard.dest %>'
				]
				dest: js + 'dashboard.js'

		uglify:
			options:
				mangle: true
				compress: true
				report: 'gzip'
				preserveComments: 'some'
				banner: [
					'/*!'
					' * <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %>'
					' * <%= pkg.description %>'
					' * Automatically generated by Grunt.js'
					' */\n'
				].join '\n'
			# dashboard:
			# 	src: '<%= concat.dashboard.dest %>'
			# 	dest: js + 'dashboard-min.js'
			utils:
				src: '<%= concat.utils.dest %>'
				dest: js + 'utils-min.js'
		
		replace:
			dist:
				src: dist + '*.html'
				overwrite: true
				replacements: [
					{
						from: /(['"])css\/([^\/\n"']*)\.css(['"])/g
						to: '$1' + cdnUrl + 'css/$2-min.css$3'
					}
					{
						from: "url('../img/"
						to: "url('" + cdnUrl + "img/"
					}
					{
						from: "url('../fonts/"
						to: "url('" + cdnUrl + "fonts/"
					}
					{
						from: "url('fonts/"
						to: "url('" + cdnUrl + "fonts/"
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

		processhtml:
			options:
				data:
					cdnUrl: cdnUrl
				process: true
			index:
				src: dist + 'index.html'
				dest: dist + 'index.html'
			apps:
				src: dist + 'apps.html'
				dest: dist + 'apps.html'
			loginV2:
				src: dist + 'login-v2.html'
				dest: dist + 'login-v2.html'

		prettify:
			html:
				options:
					unformatted: ['a', 'sub', 'sup', 'b', 'i', 'u', 'script']
				expand: true
				cwd: dist
				ext: '.html'
				src: ['*.html']
				dest: dist

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

		sync:
			dist:
				files:[
					{
						cwd: 'web'
						src: ['css/*-min.css', 'css/fonts/**', 'sass/**', 'js/*-min.js', 'svg/**', 'img/*.svg']
						dest: dist
					}
				]
			dart:
				files: [
					{
						cwd: 'build/web'
						src: ['dart/**']
						dest: dist
					}
				]

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
				files: [
					css
					'<%= concat.dashboard.dest %>'
				]
			coffee:
				files: coffee + '*'
				tasks: ['coffee', 'concat']
			sass:
				files: sass + '*'
				tasks: ['compass:watch']
				# tasks: ['compass:watch', 'csslint']

		's3-sync':
			options:
				key: '<%= aws.key %>'
				secret: '<%= aws.secret %>'
				bucket: 'static.tok3n.com'
				db: ->
					levelup = require 'levelup'
					levelup './s3cachedb'
			dist:
				files: [
					{
						root: dist
						src: [dist + 'css/**', dist + 'js/**', dist + 'img/**', dist + 'svg/**', dist + '*.html', dist + 'sass/**', dist + 'dart/**']
						dest: '/<%= pkg.name %>/<%= pkg.version %>/'
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
	@loadNpmTasks 'grunt-s3-sync'
	@loadNpmTasks 'grunt-sync'
	@loadNpmTasks 'grunt-prettify'
	@loadNpmTasks 'grunt-uncss'
	@loadNpmTasks 'grunt-processhtml'
	@loadNpmTasks 'grunt-curl'

	@registerTask 'build', ['bower-install', 'shell:sleep', 'shell:files', 'copy']
	@registerTask 'curlAll', ['curl:index', 'curl:apps', 'curl:loginV2']
	@registerTask 'distBuildHtml', ['sync', 'shell:sleep', 'curlAll', 'replace:dist', 'prettify', 'processhtml']

	@registerTask 'default', ['compass:dev', 'csslint', 'coffee', 'concat']
	@registerTask 'dist', ['compass:production', 'csslint', 'coffee', 'concat', 'uglify', 'cssmin:dist', 'distBuildHtml', 'imagemin:dist', 's3-sync']
