Tok3n Web App
===============

Requirements
-
* [Git][1]
* [Node.js][2]
* [Ruby][3] and [rubygems][4]
* [Bundler][5]
* [Grunt][6]
* [Bower][7]



Installation
-
```bash
git clone http://github.com/Tok3n/tok3n-webapp && cd tok3n-webapp
echo "RACK_ENV=development" >> .env
bundle install
npm install -g grunt-cli
npm install -g bower
npm install
```

Using locally
-
This will run the app on localhost:5000 and grunt watch the project.
```
foreman start -f Procfile.dev
```

Building dependencies and minified assets
-
If you are not sure about this, SKIP.
```bash
# Download http assets with curl, bower install and license missing scripts:
grunt build

# Build without bower install
grunt light-build

# After building, compile once for development, cat files but don't minify
grunt

# The same as above, but uglify and minify too for production.
grunt server
```

Deploying
-
Remember to configure the following (only if heroku app is new!):
```bash
heroku config:set BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-nodejs
heroku ps:scale web=1
heroku config:set NODE_ENV=production
```

To-do
-
* Make a/b tests
* Inteligent loader with modernizr and yepnope
* Compass grunt watch
* Livereload


Current milestones
-


[1]: http://git-scm.com/downloads
[2]: http://nodejs.org/download/
[3]: http://www.ruby-lang.org/en/downloads/
[4]: http://rubygems.org/pages/download
[5]: http://gembundler.com/
[6]: http://gruntjs.com
[7]: http://bower.io/