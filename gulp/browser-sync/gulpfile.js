// a sane browsersync gulp file for mortals.
// npm install commands.
// npm install gulp --save-dev
// npm install browser-sync -g
// npm install gulp-clean-css --save-dev

// to shrink css on cmd run: gulp minify-css


var gulp = require('gulp');
var bs = require('browser-sync').create();
let cleanCSS = require('gulp-clean-css');

gulp.task('browser-sync', function() {
    bs.init({
		proxy: "localhost:80/bradgillap.com/" //change this depending on your local hosted page through xampp.
    });
	gulp.watch("*.html").on('change', bs.reload); //when to refresh the browser.
	gulp.watch("*.css").on('change', bs.reload);
	gulp.watch("*.js").on('change', bs.reload);
});

gulp.task('default', ["browser-sync"]); //initiate the task above.

gulp.task('minify-css', () => {
  return gulp.src('css/*.css')
    .pipe(cleanCSS({compatibility: '*'}))  //* designates browser version. see https://www.npmjs.com/package/clean-css#compatibility-modes
    .pipe(gulp.dest('dist/css'));
});