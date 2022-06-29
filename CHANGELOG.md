# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.1.0

- Initial release

## [Unreleased]

### Changed

- Replace checks for `nice_partials` with built-in support for capturing the
  `turbo_streams` block

- Introduce the `turbo_stream_button_tag` helper, and replace documented calls
  to `render("turbo_stream_button")` with calls to `turbo_stream_button_tag`
