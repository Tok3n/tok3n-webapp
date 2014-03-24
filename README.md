Tok3n Web App
===============

Requirements
-
* [Git][1]
* [Node.js][2]
* [Bundler][3]
* [nvm][4] with Node version >= 0.10.24
* [rvm][5] with Ruby version >= 2.1


Installation
-
```bash
git clone http://github.com/Tok3n/tok3n-webapp && cd tok3n-webapp
echo "RACK_ENV=development" >> .env
nvm use 0.10
rvm use 2.1
rvm gemset create tok3n-webapp
rvm gemset use tok3n-webapp
npm install -g bower grunt-cli foreman nodemon
npm install
bundle install
bower install
```

Using locally
-
This will run the app on localhost:5000 and `grunt watch` the project.
```bash
foreman start -f Procfile.dev
```

Building dependencies and minified assets
-
```bash
# Download http assets with curl, bower install and license missing scripts:
grunt build

# After building, Compile css and coffee, concat js for development.
grunt

# Compile css and coffee, concat js, uglify and gzip for production. In order to work,
# you NEED to run `foreman start -f Procfile.dev` or `nodemon server.js` simultaneously in
# another terminal window.
grunt dist
```


To-do
-
* Use @extend instead of bootstrap classes in html
* Test in not-so-old browsers (>= IE8)
* Figure out gzip compression

Current milestones
-
* Remove a from dropdown button
* Make span.label's cascade gracefully on mobile
* Use only the neccesary icons with fontastic.me
* Middle column active color change
* Merge all dashboard screens into one
* Finish dashboard
* Style background login-v2

[1]: http://git-scm.com/downloads
[2]: http://nodejs.org/download/
[3]: http://gembundler.com/
[4]: https://github.com/creationix/nvm
[5]: https://rvm.io/
