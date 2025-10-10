[![Build status](https://github.com/dart-league/sass_builder/actions/workflows/dart.yml/badge.svg)](https://github.com/dart-league/sass_builder/actions/workflows/dart.yml)

`package:sass_builder` transpiles Sass files using the [build][1] package and
the [Dart implementation][2] of [Sass][3].

[1]: https://github.com/dart-lang/build
[2]: https://github.com/sass/dart-sass
[3]: https://sass-lang.com/dart-sass/

## Installation

This package integrates into Dart's build system, so it works after being added
as a dev-dependency:

```shell
dart pub add dev:build_runner dev:sass_builder
```

Next, create say a `web/main.scss` containing the following code:

```scss
.a {
  color: blue;
}
```

Run `dart run build_runner build` to make this package emit `web/main.css`.

## Usage

`package:sass_builder` mostly works how you'd expect Sass to behave in other
build systems:

- Each `.scss` and `.sass` file gets compiled to a `.css` file.
- For development builds, generated CSS is expanded. For `--release` builds,
  it's emitted in a compressed form.
- The builder will not run on input files starting with an underscore. These
  files can still be `@use`-imported into other Sass files though.

## Options

To configure options for the builder see the `build_config`
[README](https://github.com/dart-lang/build/blob/master/build_config/README.md).

* `outputStyle`: Supports `expanded` or `compressed`.
  Defaults to `expanded` in dev mode, and `compressed` in release mode.
* `sourceMaps`: Whether to emit source maps for compiled CSS.
  Defaults to `true` in development mode and to `false` in release mode.
* `silenceDeprecations`, `futureDeprecations` and `fatalDeprecations` control
  how Sass handles deprecation warnings.

Example:

```yaml
targets:
  $default:
    builders:
      sass_builder:
        options:
          # Emit compressed outputs in both dev and release mode.
          outputStyle: compressed
          silenceDeprecations:
            # Don't warn about @import rules
            - import

```

## Including files

This package provides the builtin `read-string` function loading assets from
the build system. It takes an asset URL as a first parameter and an optional
mime type as a second.

When no type is given, it returns the contents of the given asset as a string.
With a mime type, it returns a `data:` URL:

```scss
div::before {
  content: "";
  display: inline-block;
  width: 10px;
  height: 10px;
  background-image: url(read-string('asset:my_pkg/web/dart.svg', 'image/svg+xml'));
  background-size: contain;
  background-repeat: no-repeat;
}
```

## Sass dependencies

If you want to use any packages that provide source sass files, add them as
normal pub dependencies.
For example, if you want to use styles from `package:bootstrap_sass`:

```shell
dart pub add bootstrap_sass
```

Then, adapt `web/main.scss` to contain:

```scss
@use "sub";
@use "package:bootstrap_sass/scss/variables" as bootstrap;

.a {
  color: blue;
}

.c {
  color: bootstrap.$body-color;
}
```

Create `web/_sub.scss` containing the following code:

```scss
.b {
  color: red;
}
```

Create `web/index.html` containing the following code:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sample</title>
    <link rel="stylesheet" href="main.css">
</head>
<body>
<div class="a">Some Text</div>
<div class="b">Some Text</div>
<div class="c">Some Text</div>
</body>
</html>
```

Run `dart run build_runner serve` and then go to `localhost:8080` with a browser
and check if the file `web/main.css` was generated containing:

```css
.b {
  color: red;
}

.a {
  color: blue;
}

.c {
  color: #373a3c;
}
```
