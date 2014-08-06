# rewrite-url

This is an experimental plugin for Sass 3.3+, allows rewriting paths in `url()` values.

Related issue in Sass: https://github.com/sass/sass/issues/1361

## What?

Example:

```scss
@import "rewrite-url";

// set $rewrite-url-relative to process relative paths:
$rewrite-url-relative: asset-path;
@function asset-path($path) {
  @return "/assets/#{$path}";
}

// Now you can use regular url("") and it will be processed if it is relative:
.logo {
  background-image: url("logo.png"); //=> url(/assets/logo.png);
}

// Disable processing
$rewrite-url-relative: rewrite-url-none;
.logo {
  background-image: url("logo.png"); //=> url(logo.png);
}

// Unquoted strings do not work (yet?):
.logo {
  background-image: url(logo.png); //=> url(logo.png);
}
```

Sprockets integration:

```scss
@import "rewrite-url";
@import "rewrite-url/integrations/sprockets";

// From now just use url  instead of asset-url!
a {
 background-image: url("logo.png");
}
```

Experimental integration for Compass, it works by delegating to `image-url` or `font-url` depending on the extension:

```scss
@import "rewrite-url/integrations/compass";
@import "rewrite-url";

// From now just use url instead of image/font-url
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
