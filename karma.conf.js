var glob = require('glob');

module.exports = function (config) {
  config.set({

    basePath: '',

    frameworks: [ 'jasmine', 'browserify' ],

    files: glob.sync('src/**/test/*-test.cjsx'),

    exclude: [],

    preprocessors: {
      'src/**/test/*-test.cjsx': ['browserify']
    },

    browserify: {
      debug: true,
      watch: true,
      transform: [
        'coffee-reactify'
      ]
    },

    reporters: ['progress'],

    port: 9876,

    colors: true,

    logLevel: config.LOG_INFO,

    autoWatch: true,

    browsers: ['Chrome'],

    captureTimeout: 60000,

    singleRun: true
  });
};
