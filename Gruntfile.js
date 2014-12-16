module.exports = function(grunt) {
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-browserify');
    grunt.loadNpmTasks('grunt-karma');

    // Do grunt-related things in here
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        karma: {
            unit: {
                configFile: 'karma.conf.js'
            }
        },
        browserify: {
            playground: {
                src: ['src/main.cjsx'],
                dest: 'build/main.js',
                options: {
                    transform: [
                        'coffee-reactify'
                    ],
                },
            }
        },
        watch: {
            options: {
              livereload: true
            },
            //test: {
            //    files: ['src/*.coffee', 'src/*.cjsx', 'src/**/*.coffee', 'src/**/*.cjsx'],
            //    tasks: ['test']
            //},
            build: {
                files: ['src/*.coffee', 'src/*.cjsx', 'src/**/*.coffee', 'src/**/*.cjsx'],
                tasks: ['build']
            }
        }
    });

    grunt.registerTask('build', ['browserify']);
    grunt.registerTask('test', ['karma']);
};
