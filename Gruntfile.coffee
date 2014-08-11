


JADE_FILE_PATH = {"build/index.html" : "index.jade"}

CSS_DIR = 'build/css/'

JS_DIR = 'build/js/'



module.exports = (grunt) ->

    conf =

        pkg: grunt.file.readJSON('package.json')

        jade:
            compile:
                options:
                    pretty: true
                files: JADE_FILE_PATH

        coffee:
            compile:
                options:
                    bare: true
                files: [
                    expand: true
                    cwd: 'coffee'
                    src: ['**/*.coffee']
                    dest: JS_DIR
                    ext: '.js'
                ]

        compass:
            dist:
                options:
                    sassDir: "sass"
                    cssDir: CSS_DIR

        connect:
            server:
                options:
                    port: 3000
                    hostname: "*"
                    livereload: 35729

        esteWatch:
            options:
                dirs: [
                    "."
                    "coffee/"
                    "sass/"
                    "build/"
                ]
                livereload:
                    enabled: true
                    extensions: ['js', 'html', 'css']
                    port: 35729
            jade: (path) -> ['jade']
            coffee: (path) -> ['newer:coffee']
            sass: (path) -> ['compass']

    grunt.initConfig conf



    grunt.loadNpmTasks 'grunt-este-watch'
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-newer'
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-compass'

    grunt.registerTask 'make', ['newer:coffee', 'newer:jade', 'newer:compass']
    grunt.registerTask 'default', ['make', 'connect', 'esteWatch']

    return
