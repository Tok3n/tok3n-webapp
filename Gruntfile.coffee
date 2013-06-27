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
		comp + 'yepnope/yepnope.js'
		comp + 'Chart.js/Chart.js'
		comp + 'magnific-popup/dist/jquery.magnific-popup.js'
		comp + 'selectize/selectize.js'
		comp + 'parsleyjs/parsley.js'
		comp + 'underscore/underscore.js']
		
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
		normalize: grunt.file.readJSON comp + 'normalize/bower.json'
		pure: grunt.file.readJSON comp + 'pure/package.json'

		# TODO: Get from Bower if avaliable
		shell:
			pure:
				command:
					curlSave pure_http + 'pure-min.css', sass + 'pure/_pure.scss'
			ladda: 
				command: curlArray [
						{ url: ladda + 'ladda-themeless.min.css', file: sass + '_ladda-themeless-min.scss' }
						{ url: ladda + 'ladda.min.css', file: sass + '_ladda-mis.scss' }
						{ url: ladda + 'ladda.min.js', file: js + 'ladda.min.js' }
						{ url: ladda + 'spin.min.js', file: js + 'spin.min.js' }
					]
		
		copy:
			normalize:
				src: comp + 'normalize-css/normalize.css'
				dest: sass + '_normalize.scss'
			pure:
				files: [
					{
						expand: true
						filter: 'isFile'
						src: [pure + '**/css/*.css']
						dest: sass + 'pure'
						rename: (dest, src) ->
							dest + '/_' + src.match(css_file)[1] + '.scss'
					}
				]
			popup:
				src: comp + 'pure/src/magnific-popup/dist/magnific-popup.css'
				dest: sass + '_magnific-popup.scss'

		coffeeredux: 
			options:
				bare: true
			src:
				coffee + 'main.coffee'
			dest:
				js + 'main.js'

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
					comp + 'zeptojs/src/zepto.js'
					misc...
					'<%= coffeeredux.dest %>'
				]
				dest:
					js + 'zepto-pack.js'
			jquery:
				src: [
					comp + 'jquery/jquery.js'
					misc...
					'<%= coffeeredux.dest %>']
				dest:
					js + 'jquery-pack.js'
		
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
		
		license:
			normalize:
				options:
					banner: [
						'/*!'
						'normalize.css v<%= normalize.version %> | MIT License | git.io/normalize'
						'Copyright (c) Nicolas Gallagher and Jonathan Neal'
						'*/\n'
					].join '\n'
				expand: true,
				cwd   : '',
				src   : ['base*.css', 'forms*.css', 'tables*.css', '<%= pkg.name %>*.css']
				
			pure:
				options:
					banner: [
						'/*!',
						'Pure v<%= pure.version %>',
						'Copyright 2013 Yahoo! Inc. All rights reserved.',
						'Licensed under the BSD License.',
						'https://github.com/yui/pure/blob/master/LICENSE.md',
						'*/\n'
					].join '\n'
				expand: true,
				cwd   : '',
				src   : ['base*.css', 'forms*.css', 'tables*.css', '<%= pkg.name %>*.css']
				
		
		grunt.registerMultiTask "license", "Stamps license banners on files.", ->
			options = @options(banner: "")
			banner = grunt.template.process(options.banner)
			tally = 0
			
			@files.forEach (filePair) ->
				filePair.src.forEach (file) ->
					grunt.file.write file, banner + grunt.file.read(file)
					tally += 1
					
			grunt.log.writeln "Stamped license on " + String(tally).cyan + " files."
		
		grunt.registerTask 'bower-install', 'Installs Bower dependencies.', ->
			bower = require 'bower'
			done = this.async()
			
			bower.commands.install()
				.on 'data', (data) -> grunt.log.write data
				.on 'end', done


	@loadNpmTasks 'grunt-contrib-concat'
	@loadNpmTasks 'grunt-contrib-compass'
	@loadNpmTasks 'grunt-contrib-csslint'
	@loadNpmTasks 'grunt-contrib-copy'
	@loadNpmTasks 'grunt-contrib-uglify'
	
	@loadNpmTasks 'grunt-coffee-redux'
	@loadNpmTasks 'grunt-shell'

	@registerTask 'default', ['compass:dev', 'csslint', 'coffeeredux', 'concat']
	@registerTask 'server',  ['compass:production', 'csslint', 'coffeeredux', 'concat', 'uglify']
	@registerTask 'build',	 ['shell', 'copy']