module.exports = (grunt) ->	

	# Local paths
	comp = 'public/components/'
	css = 'public/css/'
	sass = 'public/sass/'
	js = 'public/js/'
	coffee = 'public/coffee/'
	dist = 'dist/'

	# Raw from github or cdn
	ladda = 'https://raw.github.com/hakimel/Ladda/master/dist/'
	pure_http = 'http://yui.yahooapis.com/pure/<%= pure.version %>/'

	# Bower js files
	misc = [
		comp + 'modernizr/modernizr.js'
		# comp + 'Chart.js/Chart.js'
		comp + 'selectize/selectize.js'
		# comp + 'magnific-popup/dist/jquery.magnific-popup.js'
	]
	
	unlicend = [
		# '<%= copy.yepnope.dest %>'
		'<%= copy.parsley.dest %>'
		'<%= copy.popupjs.dest %>'
		# '<%= copy.underscore.dest %>'
		# Zepto also here, called directly
	]
	
	# Files to download with curl
	http_files = [
		{ url: ladda + 'ladda-themeless.min.css', file: sass + '_ladda-themeless-min.scss' }
		{ url: ladda + 'ladda.min.css', file: sass + '_ladda-mis.scss' }
		{ url: ladda + 'ladda.min.js', file: js + 'ladda.min.js' }
		{ url: ladda + 'spin.min.js', file: js + 'spin.min.js' }
		{ url: pure_http + 'pure-min.css', file: sass + '_pure.scss' }
	]
		
	# Regex
	css_file = /([^\/]+)\.css$/
	
	# Helpers for shell curl
	curlSave = (url, file) ->
		"curl " + url + " > '" + file + "'"
	curlArray = (arr) ->
		(curlSave elem.url, elem.file for elem in arr).join '&&'
		


	@initConfig
		
		# Versions, names for licenses
		pkg: grunt.file.readJSON 'package.json'
		pure: grunt.file.readJSON comp + 'pure/package.json'
		parsleyjs: grunt.file.readJSON comp + 'parsleyjs/bower.json'
		underscore: grunt.file.readJSON comp + 'underscore/package.json'
		yepnope: grunt.file.readJSON comp + 'yepnope/.bower.json'
		zeptojs: grunt.file.readJSON comp + 'zeptojs/.bower.json'
		popup: grunt.file.readJSON comp + 'magnific-popup/bower.json'
		

		# TODO: Get from Bower if avaliable
		shell:
			files: 
				command: curlArray http_files
			index:
				# Remember to have a server running!
				command: curlSave 'http://localhost:5000', dist + 'index.html'
			dist:
				options:
					stdout: true
				command: 'rsync -ax --del --exclude components public/* ' + dist

		
		copy:
			# CSS
			normalize:
				src: comp + 'normalize-css/normalize.css'
				dest: sass + '_normalize.scss'
			pure:
				files: [
					{
						expand: true
						filter: 'isFile'
						src: [comp + 'pure/src/**/css/*.css']
						dest: sass + 'pure'
						rename: (dest, src) ->
							dest + '/_' + src.match(css_file)[1] + '.scss'
					}
				]
			toggleSwitch:
				src: comp + 'css-toggle-switch/src/toggle-switch.scss'
				dest: sass + '_toggle-switch.scss'
			popupcss:
				src: comp + 'magnific-popup/dist/magnific-popup.css'
				dest: sass + '_magnific-popup.scss'
			popupjs:
				src: comp + 'magnific-popup/dist/jquery.magnific-popup.js'
				dest: js + 'magnific-popup.js'
			# Unlicensed Js
			yepnope:
				src: comp + 'yepnope/yepnope.js'
				dest: js + 'yepnope.js'
			parsley:
				src: comp + 'parsleyjs/parsley.js'
				dest: js + 'parsley.js'
			underscore:
				src: comp + 'underscore/underscore.js'
				dest: js + 'underscore.js'
			zepto:
				src: comp + 'zeptojs/src/zepto.js'
				dest: js + 'zepto.js'
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
				
			underscore:
				options:
					banner: [
						'\n/*!'
						' * Underscore.js v<%= underscore.version %>'
						' * http://underscorejs.org'
						' * (c) 2009-2013 Jeremy Ashkenas, DocumentCloud Inc.'
						' * Underscore may be freely distributed under the MIT license.'
						' * */\n'
					].join '\n'
				expand: true
				src   : ['<%= copy.underscore.dest %>']
				
			yepnope:
				options:
					banner: [
						'\n/*!'
						' * yepnope.js'
						' * Version - <%= yepnope.version %>'
						' * Alex Sexton - @SlexAxton - AlexSexton[at]gmail.com'
						' * Ralph Holzmann - @ralphholzmann - ralphholzmann[at]gmail.com'
						' * http://yepnopejs.com/'
						' * https://github.com/SlexAxton/yepnope.js/'
						' * Tri-license - WTFPL | MIT | BSD'
						' */\n'
					].join '\n'
				expand: true
				src   : ['<%= copy.yepnope.dest %>']				
			
			zepto:
				options:
					banner: [
						'\n/*!'
						' * Zepto.js v<%= zeptojs.version %> | MIT License | https://github.com/madrobby/zepto/blob/master/MIT-LICENSE'
						' * Copyright (c) 2008-2013 Thomas Fuchs'
						' * http://zeptojs.com/'
						' */\n'
					].join '\n'
				expand: true
				src   : ['<%= copy.zepto.dest %>']

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
				
			pure:
				options:
					banner: [
						'\n/*!'
						' * Pure v<%= pure.version %>'
						' * Copyright 2013 Yahoo! Inc. All rights reserved.'
						' * Licensed under the BSD License.'
						' * https://github.com/yui/pure/blob/master/LICENSE.md'
						' */\n'
					].join '\n'
				expand: true
				cwd   : sass + '/pure/'
				src   : [
					'*.scss'
					'!_pure.scss'
				]

		coffeeredux: 
			options:
				bare: true
			compile:
				src: coffee + 'main.coffee'
				dest: js + 'main.js'
		compass:
			dev:
				options:
					config: 'public/config.rb'
					basePath: 'public'
			production:
				options:
					config: 'public/config.rb'
					basePath: 'public'
					environment: 'production'
		
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
			zepto:
				src: [
					# Zepto was copied and licensed first
					'<%= copy.zepto.dest %>'
					misc...
					unlicend...
					'<%= coffeeredux.compile.dest %>'
				]
				dest: js + 'zepto-pack.js'
			jquery:
				src: [
					'<%= copy.jquery.dest %>'
					misc...
					unlicend...
					'<%= coffeeredux.compile.dest %>'
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
						' * Copyright <%= grunt.template.today("yyyy") %> Tok3n, LLC. All rights reserved.'
						' * Licensed under the MIT License'
						' * https://github.com/Tok3n/tok3n-webapp/blob/master/LICENSE'
						' */\n'
					].join '\n'
			zepto:
				src: '<%= concat.zepto.dest %>'
				dest: js + 'zepto-pack-min.js'
			jquery:
				src: '<%= concat.jquery.dest %>'
				dest: js + 'jquery-pack-min.js'

		# replace:
		# 	dist:
		# 		options:
		# 			variables:
		# 				'devel': '-min'
		# 			prefix: replacePrefix
		# 		files:
		# 			src: dist + 'index.html'
		# 			dest: dist + 'index.html'
		
		# Replace js loader text
		replace:
			dist:
				src: dist + 'index.html'
				overwrite: true
				replacements: [
					{
						from: '-pack.js'
						to: '-pack-min.js'
					}
					{
						from: '<script src="http://localhost:35729/livereload.js"></script>'
						to: "<script>(function(b,o,i,l,e,r){b.GoogleAnalyticsObject=l;b[l]||(b[l]=function(){(b[l].q=b[l].q||[]).push(arguments)});b[l].l=+new Date;e=o.createElement(i);r=o.getElementsByTagName(i)[0];e.src='//www.google-analytics.com/analytics.js';r.parentNode.insertBefore(e,r)}(window,document,'script','ga'));ga('create','UA-39917560-2');ga('send','pageview');</script>"
					}
					{
						from: 'css/style.css'
						to: 'css/style-min.css'
					}
				]
			jquery:
				src: '<%= uglify.jquery.dest %>'
				dest: dist + 'js/jquery-pack-min.js'
				replacements: [
					from: ',/*!'
					to: ',\n/*!'
				]
			zepto:
				src: '<%= uglify.zepto.dest %>'
				dest: dist + 'js/zepto-pack-min.js'
				replacements: [
					from: ',/*!'
					to: ',\n/*!'
				]
		cssmin:
			dist:
				expand: true,
				cwd: 'dist/css/'
				src: ['*.css', '!*-min.css']
				dest: 'dist/css/'
				ext: '-min.css'

		watch:
			options:
				livereload: true
				files: [css, '<%= concat.zepto.dest %>', '<%= concat.jquery.dest %>']
			coffee:
				files: coffee + '*'
				tasks: ['coffeeredux', 'concat']
			sass:
				files: sass + '*'
				tasks: ['compass:dev', 'csslint']
				
		
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
	# @loadNpmTasks 'grunt-replace'
	@loadNpmTasks 'grunt-coffee-redux'
	@loadNpmTasks 'grunt-shell'
	@loadNpmTasks 'grunt-text-replace'

	@registerTask 'build', ['bower-install', 'shell:files', 'copy', 'license']
	@registerTask 'default', ['compass:dev', 'csslint', 'coffeeredux', 'concat']
	@registerTask 'server',  ['compass:production', 'csslint', 'coffeeredux', 'concat', 'uglify']
	@registerTask 'dist', ['shell:index', 'shell:dist', 'cssmin:dist', 'replace:dist', 'replace:zepto', 'replace:jquery']
