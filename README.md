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
npm install -g bower
npm install -g grunt-cli
npm install
bower install

grunt build
grunt
```

Using locally
-
This will run the app on localhost:5000 and grunt watch the project.
```
foreman start -f Procfile.dev
```

Building dependencies and minified assets
-
```bash
# Download http assets with curl, bower install and license missing scripts:
grunt build

# After building, Compile css and coffee, concat js for development.
grunt

# Compile css and coffee, concat js, uglify and gzip for production.
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

Always ```grunt server``` before ```git push heroku master```.


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
