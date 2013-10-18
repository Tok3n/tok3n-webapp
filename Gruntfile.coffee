module.exports = (grunt) ->	

	# Local paths
	comp = 'public/components/'
	css = 'public/css/'
	sass = 'public/sass/'
	js = 'public/js/'
	img = 'public/img/'
	font = 'public/font/'
	coffee = 'public/coffee/'
	dist = 'dist/'

	# Raw from github or cdn
	ladda = 'https://raw.github.com/hakimel/Ladda/master/dist/'
	pureHttp = 'http://yui.yahooapis.com/pure/<%= pure.version %>/'
	masonry = 'http://masonry.desandro.com/'
	cdnUrl = '//static.tok3n.com/<%= pkg.version %>/'

	# Bower js files
	misc = [
		js + 'masonry.pkgd.min.js'
		comp + 'enquire/dist/enquire.js'
		comp + 'modernizr/modernizr.js'
		# comp + 'underscore/underscore.js'
		# comp + 'backbone/backbone.js'
		# comp + 'Tourist.js/tourist.js'
		comp + 'eventEmitter/EventEmitter.js'
		# comp + 'Chart.js/Chart.js'
		# comp + 'selectize/selectize.js'
		comp + 'bootstrap-sass/js/transition.js'
		comp + 'bootstrap-sass/js/collapse.js'
		comp + 'bootstrap-sass/js/dropdown.js'
		comp + 'resizeend/lib/resizeend.js'
		comp + 'jquery-mousewheel/jquery.mousewheel.js'
	]
	
	# All unlicensed not added directly (main.js & zepto)
	unlicend = [
		# '<%= copy.yepnope.dest %>'
		# '<%= copy.parsley.dest %>'
		'<%= copy.popupjs.dest %>'
	]
	
	# Files to download with curl
	http_files = [
		{ url: ladda + 'ladda-themeless.min.css', file: sass + '_ladda-themeless-min.scss' }
		{ url: ladda + 'ladda.min.css', file: sass + '_ladda-mis.scss' }
		{ url: ladda + 'ladda.min.js', file: js + 'ladda.min.js' }
		{ url: ladda + 'spin.min.js', file: js + 'spin.min.js' }
		{ url: pureHttp + 'pure-min.css', file: sass + '_pure.scss' }
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
		pure: grunt.file.readJSON comp + 'pure/package.json'
		parsleyjs: grunt.file.readJSON comp + 'parsleyjs/bower.json'
		# underscore: grunt.file.readJSON comp + 'underscore/package.json'
		# yepnope: grunt.file.readJSON comp + 'yepnope/.bower.json'
		# zeptojs: grunt.file.readJSON comp + 'zeptojs/.bower.json'
		popup: grunt.file.readJSON comp + 'magnific-popup/bower.json'
		aws: grunt.file.readJSON '/Users/aficio/Dropbox/Development/Amazon/tok3n-aficio.json'
		

		# There must be fancier ways, which I'll be glad to learn :D
		# Please fork
		shell:
			files: 
				command: curlArray http_files
			apps:
				command: curlArray([
					{url: 'http://localhost:5000', file: dist + 'index.html'}
					{url: 'http://localhost:5000/apps', file: dist + 'apps.html'}
					{url: 'http://localhost:5000/login', file: dist + 'login.html'}
				])
		
		copy:
			# CSS
			# normalize:
			# 	src: comp + 'normalize-css/normalize.css'
			# 	dest: sass + '_normalize.scss'
			# pure:
			# 	files: [
			# 		{
			# 			expand: true
			# 			filter: 'isFile'
			# 			cwd: comp
			# 			src: 'pure/src/**/css/*.css'
			# 			dest: sass + 'pure'
			# 			rename: (dest, src) ->
			# 				dest + '/_' + src.match(css_file)[1] + '.scss'
			# 		}
			# 	]
			# toggleSwitch:
			# 	src: comp + 'css-toggle-switch/src/toggle-switch.scss'
			# 	dest: sass + '_toggle-switch.scss'
			popupcss:
				src: comp + 'magnific-popup/dist/magnific-popup.css'
				dest: sass + '_magnific-popup.scss'
			# chardincss:
			# 	src: comp + 'chardin.js/chardinjs.scss'
			# 	dest: sass + '_chardinjs.scss'
			# introjscss:
			# 	src: comp + 'intro.js/introjs.css'
			# 	dest: sass + '_introjs.scss'
			# touristcss:
			# 	src: comp + 'Tourist.js/tourist.css'
			# 	dest: sass + '_tourist.scss'
			popupjs:
				src: comp + 'magnific-popup/dist/jquery.magnific-popup.js'
				dest: js + 'magnific-popup.js'
			# Unlicensed Js
			# yepnope:
			# 	src: comp + 'yepnope/yepnope.js'
			# 	dest: js + 'yepnope.js'
			parsley:
				src: comp + 'parsleyjs/parsley.js'
				dest: js + 'parsley.js'
			# underscore:
			# 	src: comp + 'underscore/underscore.js'
			# 	dest: js + 'underscore.js'
			# zepto:
			# 	src: comp + 'zeptojs/src/zepto.js'
			# 	dest: js + 'zepto.js'
			jquery:
				src: comp + 'jquery/jquery.js'
				dest: js + 'jquery.js'
		
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
				
			# underscore:
			# 	options:
			# 		banner: [
			# 			'\n/*!'
			# 			' * Underscore.js v<%= underscore.version %>'
			# 			' * http://underscorejs.org'
			# 			' * (c) 2009-2013 Jeremy Ashkenas, DocumentCloud Inc.'
			# 			' * Underscore may be freely distributed under the MIT license.'
			# 			' * */\n'
			# 		].join '\n'
			# 	expand: true
			# 	src   : ['<%= copy.underscore.dest %>']
				
			# yepnope:
			# 	options:
			# 		banner: [
			# 			'\n/*!'
			# 			' * yepnope.js'
			# 			' * Version - <%= yepnope.version %>'
			# 			' * Alex Sexton - @SlexAxton - AlexSexton[at]gmail.com'
			# 			' * Ralph Holzmann - @ralphholzmann - ralphholzmann[at]gmail.com'
			# 			' * http://yepnopejs.com/'
			# 			' * https://github.com/SlexAxton/yepnope.js/'
			# 			' * Tri-license - WTFPL | MIT | BSD'
			# 			' */\n'
			# 		].join '\n'
			# 	expand: true
			# 	src   : ['<%= copy.yepnope.dest %>']				
			
			# zepto:
			# 	options:
			# 		banner: [
			# 			'\n/*!'
			# 			' * Zepto.js v<%= zeptojs.version %> | MIT License | https://github.com/madrobby/zepto/blob/master/MIT-LICENSE'
			# 			' * Copyright (c) 2008-2013 Thomas Fuchs'
			# 			' * http://zeptojs.com/'
			# 			' */\n'
			# 		].join '\n'
			# 	expand: true
			# 	src   : ['<%= copy.zepto.dest %>']

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
				
			# pure:
			# 	options:
			# 		banner: [
			# 			'\n/*!'
			# 			' * Pure v<%= pure.version %>'
			# 			' * Copyright 2013 Yahoo! Inc. All rights reserved.'
			# 			' * Licensed under the BSD License.'
			# 			' * https://github.com/yui/pure/blob/master/LICENSE.md'
			# 			' */\n'
			# 		].join '\n'
			# 	expand: true
			# 	cwd   : sass + '/pure/'
			# 	src   : [
			# 		'*.scss'
			# 		'!_pure.scss'
			# 	]

		coffeeredux: 
			options:
				bare: true
			main:
				src: coffee + 'main.coffee'
				dest: js + 'main.js'
			test:
				src: coffee + 'test.coffee'
				dest: js + 'test.js'
		
		compass:
			options:
				outputStyle: 'expanded'
				raw: 'preferred_syntax = :sass\nSass::Script::Number.precision = 2\n'
				require: ['breakpoint-slicer']
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
			# zepto:
			# 	src: [
			# 		# Zepto was copied and licensed first
			# 		'<%= copy.zepto.dest %>'
			# 		misc...
			# 		unlicend...
			# 		'<%= coffeeredux.main.dest %>'
			# 	]
			# 	dest: js + 'zepto-pack.js'
			jquery:
				src: [
					'<%= copy.jquery.dest %>'
					misc...
					unlicend...
					'<%= coffeeredux.main.dest %>'
				]
				dest: js + 'jquery-pack.js'

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
			# zepto:
			# 	src: '<%= concat.zepto.dest %>'
			# 	dest: js + 'zepto-pack-min.js'
			jquery:
				src: '<%= concat.jquery.dest %>'
				dest: js + 'jquery-pack-min.js'
		
		# Replace js loader text
		replace:
			dist:
				src: dist + '*.html'
				overwrite: true
				replacements: [
					{
						from: 'js/jquery-pack.js'
						to: cdnUrl + 'js/jquery-pack-min.js'
					}
					{
						from: '<script src="http://localhost:35729/livereload.js"></script>'
						to: '<script type="application/dart" src="/code/Dashboard.dart"></script>\n    '+'<script src="/packages/browser/dart.js"></script>\n    '+"<script>(function(b,o,i,l,e,r){b.GoogleAnalyticsObject=l;b[l]||(b[l]=function(){(b[l].q=b[l].q||[]).push(arguments)});b[l].l=+new Date;e=o.createElement(i);r=o.getElementsByTagName(i)[0];e.src='//www.google-analytics.com/analytics.js';r.parentNode.insertBefore(e,r)}(window,document,'script','ga'));ga('create','UA-39917560-2');ga('send','pageview');</script>"
					}
					{
						from: 'css/style.css'
						to: cdnUrl + 'css/style-min.css'
					}
					{
						from: '\n    <script src="js/test.js"></script>'
						to: ''
					}
					{
						from: '\n    try\n    {\n      Typekit.load()\n    }\n    catch (e)\n    {}\n    '
						to: 'try{Typekit.load();}catch(e){}'
					}
					{
						from: "background-image: url('../img/"
						to: "background-image: url('" + cdnUrl + "img/"
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
			# zepto:
			# 	src: '<%= uglify.zepto.dest %>'
			# 	dest: dist + 'js/zepto-pack-min.js'
			# 	replacements: [
			# 		from: ',/*!'
			# 		to: ',\n/*!'
			# 	]

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
						cwd: dist + 'css'
						src: ['*.css', '!*-min.css']
						dest: dist + 'css'
						ext: '-min.css'
					}
				]

		sync:
			dist:
				files:[
					{
						cwd: 'public'
						src: ['css/style.css', 'sass/**', 'js/*-pack-min.js', 'svg/**']
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
					# '<%= concat.zepto.dest %>'
					'<%= concat.jquery.dest %>'
				]
			coffee:
				files: coffee + '*'
				tasks: ['coffeeredux', 'concat']
			sass:
				files: sass + '*'
				tasks: ['compass:watch', 'csslint']

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
						src: [dist + 'sass/**', dist + '*.html']
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

	@registerTask 'build', ['bower-install', 'shell:files', 'copy', 'license']
	@registerTask 'default', ['compass:dev', 'csslint', 'coffeeredux', 'concat']
	@registerTask 'dist', ['compass:production', 'csslint', 'coffeeredux', 'concat:jquery', 'uglify:jquery', 'sync:dist', 'shell:apps', 'prettify', 'replace', 'cssmin:dist', 'imagemin:dist', 's3-sync']
