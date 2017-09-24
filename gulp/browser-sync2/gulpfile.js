var gulp        = require('gulp');
var browserSync = require('browser-sync').create();
var reload      = browserSync.reload;
// The package file contains the list of packages required. Meant for working with xamp.
// tested to glob wildcard watch subdirectories for theme files. 
// npm install 
// Save a reference to the `reload` method

// Watch scss AND html files, doing different things with each.
gulp.task('serve', function () {

    // Serve files from the root of this project. Direct browser to http://localhost:3000 for sync
    browserSync.init({
        proxy: {
            target: "http://localhost"
        }
    });

    gulp.watch("papermachine/**/*.html").on("change", reload);
	gulp.watch("papermachine/**/*.css").on("change", reload);
	gulp.watch("papermachine/**/*.js").on("change", reload);
	gulp.watch("papermachine/**/*.php").on("change", reload);
});