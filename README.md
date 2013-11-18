Tok3n Web App
===============

Requirements
-
* [Git][1]
* [Node.js][2]
* [Ruby][3] and [rubygems][4]
* [Bundler][5]
* [nvm][6]
+ [rvm][7] with version 1.9



Installation
-
```bash
git clone http://github.com/Tok3n/tok3n-webapp && cd tok3n-webapp
echo "RACK_ENV=development" >> .env
nvm use 0.10
rvm use 1.9
rvm gemset create tok3n-webapp
rvm gemset use tok3n-webapp
npm install -g bower grunt-cli foreman
npm install
bundle install
bower install
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

# Compile css and coffee, concat js, uglify and gzip for production. In order to work, you NEED to run `foreman start -f Procfile.dev` or `nodemon server.js` simultaneously in another terminal window.
grunt dist
```


To-do
-
* Make a/b tests
* Inteligent loader with modernizr and yepnope
* More stable progress tracker (don't depend on calc() or use a polyfill?)
* Use @extend instead of bootstrap classes in html
* Migrate icons to new font-awesome version and use @extend as well

Current milestones
-
* Finish connect


[1]: http://git-scm.com/downloads
[2]: http://nodejs.org/download/
[3]: http://www.ruby-lang.org/en/downloads/
[4]: http://rubygems.org/pages/download
[5]: http://gembundler.com/
[6]: https://github.com/creationix/nvm
[7]: https://rvm.io/
