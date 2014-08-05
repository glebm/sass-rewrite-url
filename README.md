# relative-url

This is an experimental plugin for Sass 3.3+. It processes relative paths in `url()` values.

Related issue in Sass: https://github.com/sass/sass/issues/1361

## What?

Example:

```scss
// Specify how relative URLs should be processed:
$relative-url-fn: asset-path;
@function asset-path($path) { @return "/assets/#{$path}"; }

// Import the library
@import "relative-url";


// Now you can use regular url("") and it will be processed if it is relative:
.logo {
  // Relative paths are processed with $relative-url-fn:
  background-image: url("logo.png");
  //=> background-image: url(/assets/logo.png);

  // Absolute paths are not processed:
  background-image: url("http://google.com/image.jpg")
  //=> background-image: url(http://google.com/image.jpg);

  // Sadly, unquoted strings do not work:
  background-image: url(logo.png);
  //=> background-image: url(logo.png);
}
```

Experimental integration for Compass:

```scss
@import "relative-url/integrations/compass";
@import "relative-url";

// From now just use url instead of image/font-url
a {
 background-image: url("logo.png");
}
```

Experimental integration for Sprockets:

```scss
@import "relative-url/integrations/sprockets";
@import "relative-url";

// From now just use url  instead of asset-url!
a {
 background-image: url("logo.png");
}
```

## Why?

Many Sass environment, such as Compass or Sprockets, define helpers to be used instead of `url`:

```scss
.logo {
  background-image: image-url("logo.png")
}
```

This makes it difficult to write Sass code compatible with all the environments (e.g. a library).

## How?

This plugin makes `url` a function that delegates relative paths to the specified asset helper (using `call` by name function introduced in Sass 3.3).
With this, instead of using environment-specific asset helpers, you can use regular `url()`.
