module.exports = (grunt) ->	

	# Local paths
	comp = 'public/components/'
	css = 'public/css/'
	sass = 'public/sass/'
	js = 'public/js/'
	coffee = 'public/coffee/'

	# Raw from github or cdn
	ladda = 'https://raw.github.com/hakimel/Ladda/master/dist/'
	pure_http = 'http://yui.yahooapis.com/pure/0.2.0/'

	# Bower js files
	misc = [
		comp + 'modernizr/modernizr.js'
		comp + 'Chart.js/Chart.js'
		comp + 'magnific-popup/dist/jquery.magnific-popup.js'
		comp + 'selectize/selectize.js'
	]
	
	unlicend = [
		'<%= copy.yepnope.dest %>'
		'<%= copy.parsley.dest %>'
		'<%= copy.underscore.dest %>'
		# Zepto also here, called directly
	]
	
	http_files = [
		{ url: ladda + 'ladda-themeless.min.css', file: sass + '_ladda-themeless-min.scss' }
		{ url: ladda + 'ladda.min.css', file: sass + '_ladda-mis.scss' }
		{ url: ladda + 'ladda.min.js', file: js + 'ladda.min.js' }
		{ url: ladda + 'spin.min.js', file: js + 'spin.min.js' }
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
		

		# TODO: Get from Bower if avaliable
		shell:
			pure:
				command: curlSave pure_http + 'pure-min.css', sass + 'pure/_pure.scss'
			ladda: 
				command: curlArray http_files
		
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
			popup:
				src: comp + 'pure/src/magnific-popup/dist/magnific-popup.css'
				dest: sass + '_magnific-popup.scss'
			
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
		
		license:
			parsley:
				options:
					banner: [
						'/*!'
						'Parsley.js v<%= parsleyjs.version %> | MIT License | https://github.com/guillaumepotier/Parsley.js/blob/master/LICENCE.md'
						'Copyright (c) 2013 Guillaume Potier - @guillaumepotier'
						'*/\n'
					].join '\n'
				expand: true
				src   : ['<%= copy.parsley.dest %>']
				
			underscore:
				options:
					banner: [
						'/*!'
						'Underscore.js v<%= underscore.version %>'
						'http://underscorejs.org'
						'(c) 2009-2013 Jeremy Ashkenas, DocumentCloud Inc.'
						'Underscore may be freely distributed under the MIT license.'
						'*/\n'
					].join '\n'
				expand: true
				src   : ['<%= copy.underscore.dest %>']
				
			yepnope:
				options:
					banner: [
						'/*!'
						'yepnope.js'
						'Version - <%= yepnope.version %>'
						'Alex Sexton - @SlexAxton - AlexSexton[at]gmail.com'
						'Ralph Holzmann - @ralphholzmann - ralphholzmann[at]gmail.com'
						'http://yepnopejs.com/'
						'https://github.com/SlexAxton/yepnope.js/'
						'Tri-license - WTFPL | MIT | BSD'
						'*/\n'
					].join '\n'
				expand: true
				src   : ['<%= copy.yepnope.dest %>']				
			
			zepto:
				options:
					banner: [
						'/*!'
						'Zepto.js v<%= zeptojs.version %> | MIT License | https://github.com/madrobby/zepto/blob/master/MIT-LICENSE'
						'Copyright (c) 2008-2013 Thomas Fuchs'
						'http://zeptojs.com/'
						'*/\n'
					].join '\n'
				expand: true
				src   : ['<%= copy.zepto.dest %>']
				
			pure:
				options:
					banner: [
						'/*!'
						'Pure v<%= pure.version %>'
						'Copyright 2013 Yahoo! Inc. All rights reserved.'
						'Licensed under the BSD License.'
						'https://github.com/yui/pure/blob/master/LICENSE.md'
						'*/\n'
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
				src: [css + 'main.css']
				
		concat:
			options:
				separator: '\n'
			zepto:
				src: [
					# Zepto was copied and licensed first
					js + 'zepto.js'
					misc...
					unlicend...
					'<%= coffeeredux.dest %>'
				]
				dest: js + 'zepto-pack.js'
			jquery:
				src: [
					comp + 'jquery/jquery.js'
					misc...
					unlicend...
					'<%= coffeeredux.dest %>'
				]
				dest: js + 'jquery-pack.js'

		uglify:
			options:
				mangle: true
				compress: true
				report: 'gzip'
				preserveComments: 'some'
				banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
			zepto:
				src: '<%= concat.zepto.dest %>'
				dest: js + 'zepto-pack-min.js'
			jquery:
				src: '<%= concat.jquery.dest %>'
				dest: js + 'jquery-pack-min.js'

		watch:
			options:
				livereload: true
				files: [css, '<%= concat.zepto.dest %>', '<%= concat.jquery.dest %>']
			coffee:
				files: '<%= coffeeredux.src %>'
				tasks: ['coffeeredux', 'concat']
			sass:
				files: sass
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
	
	@loadNpmTasks 'grunt-coffee-redux'
	@loadNpmTasks 'grunt-shell'

	@registerTask 'default', ['compass:dev', 'csslint', 'coffeeredux', 'concat']
	@registerTask 'server',  ['compass:production', 'csslint', 'coffeeredux', 'concat', 'uglify']
	@registerTask 'build', ['bower-install', 'shell', 'copy', 'license']
	