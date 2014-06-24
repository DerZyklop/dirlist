module.exports = (grunt) ->

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)


  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    paths:
      assets: 'demo/inc'
      sass: '<%= paths.assets %>/sass'
      sassfilename: 'styles'
      css: '<%= paths.assets %>/css'
    banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' + '<%= grunt.template.today("yyyy-mm-dd") %> */'


    sass:
      all:
        options:
          style: 'compressed'
          banner: '<%= banner %>'
        files: '<%= paths.css %>/<%= paths.sassfilename %>.min.css': '<%= paths.sass %>/<%= paths.sassfilename %>.sass'

    # autoprefixer
    autoprefixer:
      all:
        files: [
          expand: true
          cwd: '<%= paths.css %>'
          src: ['*.css']
          dest: '<%= paths.css %>'
          ext: '.css'
        ]


    watch:
      options:
        livereload: true

      livereload:
        files: [
          '<%= paths.css %>/**/*'
        ]
        tasks: ['reload']

      sass:
        files: ['<%= paths.sass %>/*.sass']
        tasks: ['sass', 'autoprefixer']
      css:
        files: ['<%= paths.sass %>/*.css']
        tasks: ['cssmin']


    php:
      all:
        options:
          port: 7007
          hostname: 'localhost'
          base: 'demo'
          keepalive: true

    open:
      all:
        path: 'http://<%= php.all.options.hostname %>:<%= php.all.options.port%>'


  grunt.registerTask "reload", "reload Chrome on OS X", ->
    require("child_process").exec("osascript " +
        "-e 'tell application \"Google Chrome\" " +
          "to tell the active tab of its first window' " +
        "-e 'reload' " +
        "-e 'end tell'")


  grunt.registerTask('server', ['open','php'])
  grunt.registerTask('default', ['reload','watch'])
