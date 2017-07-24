// a sane browsersync gulp file for mortals.

var gulp = require('gulp');
var bs = require('browser-sync').create();

gulp.task('browser-sync', function() {
    bs.init({
		proxy: "localhost:80/bradgillap.com/" //change this depending on your local hosted page through xampp.
    });
	gulp.watch("*.html").on('change', bs.reload); //when to refresh the browser.
	gulp.watch("*.css").on('change', bs.reload);
	gulp.watch("*.js").on('change', bs.reload);
});

gulp.task('default', ["browser-sync"]); //initiate the task above.
