# relative-url

This is an experimental plugin for Sass 3.3+. It will replace relative paths in CSS url() calls with a function result.

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
@import "relative-url/integrations/compass"
@import "relative-url"

// From now just use `url("")`!
a {
 background-image: url("logo.png");
}
```

Experimental integration for Sprockets:

```scss
@import "relative-url/integrations/sprockets"
@import "relative-url"

// From now just use `url("")`!
a {
 background-image: url("logo.png");
}
```

## Why?

This is an attempt at resolving the mess that asset helper methods are.
Every environment, such as Compass or Sprockets, defines its own `asset-path` / `image-url` helper methods that are meant to be used like so:

```scss
.logo {
  background-image: image-url("logo.png")
}
```

Unfortunately, this means there is no way for libraries to reference assets in a compatible way.
This also means the user has to go through hoops if the Sass library they are using uses different asset URL helpers, or no helpers at all.

## How?

This plugin makes `url` a function that delegates relative paths to the specified asset helper (using `call` by name function introduced in Sass 3.3).
With this, instead of using environment-specific asset helpers, you can use regular `url()`.
