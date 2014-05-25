/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    // Task configuration.
    coffee: {
      build: {
        options: {
          bare: false
        },
        expand: true,
        cwd: 'src',
        src: ['**/*.coffee'],
        dest: 'build',
        ext: '.js'
      }
    },
    jade: {
      options: {
        pretty: true
      },
      build: {
        expand: true,
        cwd: 'src',
        src: ['**/*.jade'],
        dest: 'build',
        ext: '.html'
      }
    },
    clean: {
      build: {
        src: ['build']
      }
    },
    watch: {
      coffee: {
        files: '<%= coffee.build.src %>',
        tasks: ['coffee']
      },
      jade: {
        files: '<%= jade.build.src %>',
        tasks: ['jade']
      }
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-jade');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-watch');

  // Default task.
  grunt.registerTask('default', ['clean', 'coffee', 'jade', 'watch']);

};
