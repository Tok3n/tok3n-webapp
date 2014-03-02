module.exports = (grunt) ->	

	# Local paths
	comp = 'public/components/'
	css = 'public/css/'
	sass = 'public/sass/'
	js = 'public/js/'
	img = 'public/img/'
	font = 'public/font/'
	coffee = 'public/coffee/'
	dart = 'public/dart/'
	dist = 'dist/'

	# Raw from github or cdn
	masonry = 'http://masonry.desandro.com/'
	cdnUrl = '//s3.amazonaws.com/static.tok3n.com/<%= pkg.version %>/'

	# Bower js files
	misc = [
		js + 'masonry.pkgd.min.js'
		comp + 'enquire/dist/enquire.js'
		comp + 'modernizr/modernizr.js'
		comp + 'eventEmitter/EventEmitter.js'
		comp + 'bootstrap-sass/js/transition.js'
		comp + 'bootstrap-sass/js/collapse.js'
		comp + 'bootstrap-sass/js/dropdown.js'
		comp + 'resizeend/lib/resizeend.js'
		comp + 'jquery-mousewheel/jquery.mousewheel.js'
	]
	
	# All unlicensed not added directly (main.js)
	unlicend = [
		# '<%= copy.popupjs.dest %>'
	]

	connect = [
		comp + 'ladda/js/spin.js'
		comp + 'ladda/js/ladda.js'
	]
	
	# Files to download with curl
	http_files = [
		{ url: masonry + 'masonry.pkgd.min.js', file: js + 'masonry.pkgd.min.js' }
	]
		
	# Regex
	css_file = /([^\/]+)\.css$/
	
	# Helpers for shell curl
	curlSave = (url, file) ->
		"curl " + url + " > '" + file + "'"
	curlArray = (arr) ->
		(curlSave elem.url, elem.file for elem in arr).join '&&'
	curlLocal = (dir) ->
		curlSave('http://localhost:5000', dist + dir + '.html')

	@initConfig
		
		# Versions, names for licenses
		pkg: grunt.file.readJSON 'package.json'
		parsleyjs: grunt.file.readJSON comp + 'parsleyjs/bower.json'
		popup: grunt.file.readJSON comp + 'magnific-popup/bower.json'
		aws: grunt.file.readJSON '/Users/aficio/Dropbox/Development/Amazon/tok3n-aficio.json'
		

		# There must be fancier ways, which I'll be glad to learn :D
		# Please fork
		shell:
			sleep:
				command: 'sleep 2s'
			files: 
				command: curlArray http_files
			apps:
				command: curlArray([
					{url: 'http://localhost:5000', file: dist + 'index.html'}
					{url: 'http://localhost:5000/apps', file: dist + 'apps.html'}
					{url: 'http://localhost:5000/login', file: dist + 'login.html'}
					{url: 'http://localhost:5000/connect-login', file: dist + 'connect-login.html'}
					{url: 'http://localhost:5000/connect-create', file: dist + 'connect-create.html'}
					{url: 'http://localhost:5000/login-v2', file: dist + 'login-v2.html'}

				])
		
		copy:
			popupcss:
				src: comp + 'magnific-popup/dist/magnific-popup.css'
				dest: sass + '_magnific-popup.scss'
			popupjs:
				src: comp + 'magnific-popup/dist/jquery.magnific-popup.js'
				dest: js + 'magnific-popup.js'
			parsley:
				src: comp + 'parsleyjs/parsley.js'
				dest: js + 'parsley.js'
			jquery:
				src: comp + 'jquery/jquery.js'
				dest: js + 'jquery.js'
			dart:
				src: 'packages/browser/dart.js'
				dest: dist + 'dart/dart.js'
		
		license:
			parsley:
				options:
					banner: [
						'\n/*!'
						' * Parsley.js v<%= parsleyjs.version %> | MIT License | https://github.com/guillaumepotier/Parsley.js/blob/master/LICENCE.md'
						' * Copyright (c) 2013 Guillaume Potier - @guillaumepotier'
						' */\n'
					].join '\n'
				expand: true
				src   : ['<%= copy.parsley.dest %>']			

			popup:
				options:
					banner: [
						'\n/*!'
						' * Magnific Popup - v<%= popup.version %>'
						' * http://dimsemenov.com/plugins/magnific-popup/'
						' * Copyright (c) 2013 Dmitry Semenov'
						' */\n'
					].join '\n'
				expand: true
				src   : ['<%= copy.popupjs.dest %>']

		coffeeredux: 
			options:
				bare: true
			main:
				src: coffee + 'main.coffee'
				dest: js + 'main.js'
			test:
				src: coffee + 'test.coffee'
				dest: js + 'test.js'
			connect:
				src: coffee + 'connect.coffee'
				dest: js + 'connect.js'
		
		compass:
			options:
				outputStyle: 'expanded'
				raw: 'preferred_syntax = :sass\n::Sass::Script::Number.precision = [10, ::Sass::Script::Number.precision].max\n
					sass_options = {:quiet => true}\n'
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
			jquery:
				src: [
					'<%= copy.jquery.dest %>'
					misc...
					unlicend...
					'<%= coffeeredux.main.dest %>'
				]
				dest: js + 'jquery-pack.js'
			connect:
				src: [
					connect...
					'<%= coffeeredux.connect.dest %>'
				]
				dest: js + 'connect.js'


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
			jquery:
				src: '<%= concat.jquery.dest %>'
				dest: js + 'jquery-pack-min.js'
			connect:
				src: '<%= concat.connect.dest %>'
				dest: js + 'connect-min.js'
		
		# Replace js loader text, extremely hackish
		replace:
			dist:
				src: dist + '*.html'
				overwrite: true
				replacements: [
					{
						from: '\n    <script src="js/test.js"></script>'
						to: ''
					}
					{
						from: '\n    <script src="js/loader.js"></script>'
						to: ''
					}
					{
						from: 'js/jquery-pack.js'
						to: cdnUrl + 'js/jquery-pack-min.js'
					}
					{
						from: 'js/connect.js'
						to: cdnUrl + 'js/connect-min.js'
					}
					{
						from: '<script src="dart/connect.dart.js"></script>'
						to: '<script type="application/dart" src="' + cdnUrl + 'dart/connect.dart"></script>\n    <script src="' + cdnUrl + 'dart/dart.js"></script>'
					}
					{
						from: /(['"])css\/([^\/\n"']*)\.css(['"])/g
						to: '$1' + cdnUrl + 'css/$2-min.css$3'
					}
					{
						from: '\n    try\n    {\n      Typekit.load()\n    }\n    catch (e)\n    {}\n    '
						to: 'try{Typekit.load();}catch(e){}'
					}
					{
						from: "background-image: url('../img/"
						to: "background-image: url('" + cdnUrl + "img/"
					}
					{
						from: '<script src="http://localhost:35729/livereload.js"></script>'
						to: "<script>(function(b,o,i,l,e,r){b.GoogleAnalyticsObject=l;b[l]||(b[l]=function(){(b[l].q=b[l].q||[]).push(arguments)});b[l].l=+new Date;e=o.createElement(i);r=o.getElementsByTagName(i)[0];e.src='//www.google-analytics.com/analytics.js';r.parentNode.insertBefore(e,r)}(window,document,'script','ga'));ga('create','UA-39917560-2');ga('send','pageview');</script>"
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
			jquery:
				src: '<%= uglify.jquery.dest %>'
				dest: dist + 'js/jquery-pack-min.js'
				replacements: [
					from: ',/*!'
					to: ',\n/*!'
				]

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
					banner: [
						'/*!'
						' *  TTTTTTTTTTTTTTTTTTTTTTT              kkkkkkkk           333333333333333'
						' *  T:::::::::::::::::::::T              k::::::k          3:::::::::::::::33'
						' *  T:::::::::::::::::::::T              k::::::k          3::::::33333::::::3'
						' *  T:::::TT:::::::TT:::::T              k::::::k          3333333     3:::::3'
						' *  TTTTTT  T:::::T  TTTTTTooooooooooo    k:::::k    kkkkkkk           3:::::3nnnn  nnnnnnnn'
						' *          T:::::T      oo:::::::::::oo  k:::::k   k:::::k            3:::::3n:::nn::::::::nn'
						' *          T:::::T     o:::::::::::::::o k:::::k  k:::::k     33333333:::::3 n::::::::::::::nn'
						' *          T:::::T     o:::::ooooo:::::o k:::::k k:::::k      3:::::::::::3  nn:::::::::::::::n'
						' *          T:::::T     o::::o     o::::o k::::::k:::::k       33333333:::::3   n:::::nnnn:::::n'
						' *          T:::::T     o::::o     o::::o k:::::::::::k                3:::::3  n::::n    n::::n'
						' *          T:::::T     o::::o     o::::o k:::::::::::k                3:::::3  n::::n    n::::n'
						' *          T:::::T     o::::o     o::::o k::::::k:::::k               3:::::3  n::::n    n::::n'
						' *        TT:::::::TT   o:::::ooooo:::::ok::::::k k:::::k  3333333     3:::::3  n::::n    n::::n'
						' *        T:::::::::T   o:::::::::::::::ok::::::k  k:::::k 3::::::33333::::::3  n::::n    n::::n'
						' *        T:::::::::T    oo:::::::::::oo k::::::k   k:::::k3:::::::::::::::33   n::::n    n::::n'
						' *        TTTTTTTTTTT      ooooooooooo   kkkkkkkk    kkkkkkk333333333333333     nnnnnn    nnnnnn'
						' *'
						' * <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %>'
						' * <%= pkg.description %>'
						' * Copyright <%= grunt.template.today("yyyy") %> Tok3n, LLC. All rights reserved.'
						' * Licensed under the MIT License'
						' * https://github.com/Tok3n/tok3n-webapp/blob/master/LICENSE'
						' *'
						' * Thanks for stopping by!'
						' * please refer to the full SASS in (../sass/<filename>.sass) for complete code.'
						' *'
						' */'
					].join '\n'
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
						cwd: 'public'
						src: ['css/*-min.css', 'sass/**', 'js/*-min.js', 'svg/**', 'dart/**', 'img/*.svg']
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
					'<%= concat.jquery.dest %>'
				]
			coffee:
				files: coffee + '*'
				tasks: ['coffeeredux', 'concat']
			sass:
				files: sass + '*'
				tasks: ['compass:watch']
				# tasks: ['compass:watch', 'csslint']

		's3-sync':
			options:
				key: '<%= aws.key %>'
				secret: '<%= aws.secret %>'
				bucket: 'static.tok3n.com'
			gzipHeader:
				headers:
					'Content-Encoding': 'gzip'
				files: [
					{
						root: dist
						src: [dist + 'js/**', dist + 'css/**']
						dest: '/<%= pkg.version %>/'
					}
				]
			nogzip:
				files: [
					{
						root: dist
						src: [dist + 'img/**', dist + 'svg/**']
						dest: '/<%= pkg.version %>/'
					}
				]
			gzip:
				gzip: true
				files: [
					{
						root: dist
						src: [dist + 'sass/**', dist + '*.html', dist + 'dart/*.dart', dist + 'dart/*.js']
						dest: '/<%= pkg.version %>/'
					}
				]
		
	@registerMultiTask "license", "Stamps license banners on files.", ->
		options = @options(banner: "")
		banner = grunt.template.process(options.banner)
		tally = 0
		@files.forEach (filePair) ->
			filePair.src.forEach (file) ->
				grunt.file.write file, banner + grunt.file.read(file)
				tally += 1
				return
			return
		grunt.log.writeln "Stamped license on " + String(tally).cyan + " files."
		return
	
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
	@loadNpmTasks 'grunt-shell'
	@loadNpmTasks 'grunt-text-replace'
	@loadNpmTasks 'grunt-s3-sync'
	@loadNpmTasks 'grunt-sync'
	@loadNpmTasks 'grunt-prettify'

	@registerTask 'build', ['bower-install', 'shell:sleep', 'shell:files', 'copy', 'license']
	@registerTask 'default', ['compass:dev', 'csslint', 'coffeeredux', 'concat']
	@registerTask 'dist', ['compass:production', 'csslint', 'coffeeredux', 'concat', 'uglify', 'cssmin:dist', 'sync:dist', 'copy:dart', 'shell:sleep', 'shell:apps', 'prettify', 'replace:dist', 'imagemin:dist', 's3-sync']
