(function(){
  var each;
  each = require('prelude-ls').each;
  module.exports = function(grunt){
    each(function(it){
      return grunt.loadNpmTasks(it);
    }, ['grunt-livescript', 'grunt-contrib-clean', 'grunt-contrib-watch', 'grunt-contrib-copy', 'grunt-karma', 'grunt-express', 'grunt-open', 'grunt-contrib-concat', 'grunt-contrib-uglify']);
    grunt.initConfig({
      pkg: grunt.file.readJSON('package.json'),
      clean: {
        'default': ['./dist/lib/**', './dist/vendor/**', './dist/tests/**', './dist/concat.js'],
        reports: ['test_reports/**']
      },
      livescript: {
        src: {
          expand: true,
          cwd: 'src/',
          src: ['**/*.ls', '!tests/**'],
          dest: 'dist/',
          ext: '.js'
        },
        grunt: {
          expand: true,
          src: ['gruntfile.ls'],
          dest: './',
          ext: '.js'
        },
        bare: {
          options: {
            bare: true
          },
          expand: true,
          cwd: 'src/',
          src: ['**/*.ls', '!tests/**'],
          dest: 'dist/',
          ext: '.js'
        }
      },
      copy: {
        'default': {
          expand: true,
          cwd: 'src/',
          src: ['**', '!**/*.ls'],
          dest: 'dist/',
          filter: 'isFile'
        }
      },
      concat: {
        'default': {
          src: ['src/lib/**/*.ls', 'src/tests/**/*.ls'],
          dest: 'src/test/test.ls'
        }
      },
      watch: {
        target: {
          files: ['src/**/*.ls', 'gruntfile.ls'],
          tasks: ['default']
        }
      },
      karma: {
        options: {
          files: ['dist/vendor/*.js', 'dist/lib/*.js', 'dist/test/test.js']
        },
        continuous: {
          preprocessors: {
            'dist/lib/**/*.js': 'coverage'
          },
          frameworks: ['jasmine'],
          autoWatch: false,
          background: true,
          singleRun: true,
          browsers: ['Chrome'],
          reporters: ['progress', 'coverage', 'html'],
          coverageReporter: {
            type: 'html',
            dir: 'dist/test_reports/coverage/'
          },
          htmlReporter: {
            outputDir: 'dist/test_reports/unit/',
            templatePath: 'node_modules/karma-html-reporter/jasmine_template.html'
          }
        }
      }
    });
    grunt.registerTask('default', ['clean', 'concat', 'copy', 'test', 'watch']);
    return grunt.registerTask('test', ['livescript:bare', 'karma:continuous', 'clean:default', 'copy', 'livescript:src', 'livescript:grunt']);
  };
}).call(this);
