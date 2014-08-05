# relative-url

This is an experimental plugin for Sass 3.3+. It will replace relative paths in CSS url() calls with a function result.

Related issue in Sass: https://github.com/sass/sass/issues/1361

## What?

Example:

```scss
@function asset-path($path) {
  @return "/assets/#{$path}";
}

$relative-url-fn: asset-path;
@import "relative-urls";

.logo {
  // Relative paths are processed with $relative-url-fn:
  background-image: url("logo.png");
  //=> background-image: url(/assets/logo.png);

  // Absolute paths are not:
  background-image: url("http://google.com/image.jpg")
  //=> background-image: url(http://google.com/image.jpg);

  // Unquoted quoteds in url() are not affected either, though I wish we could change this:
  background-image: url(logo.png);
  //=> background-image: url(logo.png);
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
