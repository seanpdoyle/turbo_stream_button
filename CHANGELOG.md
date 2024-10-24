# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Drop [end-of-life Ruby] versions 2.7 and 3.0
- Drop [end-of-life Rails] versions 6.2 and 7.0

[end-of-life Ruby]: https://www.ruby-lang.org/en/downloads/branches/
[end-of-lie Rails]: https://rubyonrails.org/maintenance

## 0.2.3 (Oct 24, 2024)

- Expand matrix of supported versions to include `ruby@3.3` and `rails@7.2`.
- Rely on view context's `#token_list` to merge token lists

## 0.2.2 (Jan 12, 2023)

- Qualify call to `render "turbo_stream_button_tag"` with `application/`
  namespace

## 0.2.1 (Jan 12, 2023)

- Introduce `turbo_stream_button` and `turbo_stream_button.template` helpers
  that know how to render themselves as attributes or elements

      form_with model: Post.new do |form|
        form.button **turbo_stream_button, type: :submit do
          turbo_stream_button.template.tag do
            turbo_stream.append(...)
          end
        end
      end

### Fixed

- Support multiple tokens in token list mergers
- Resolve `TurboStreamButton::Helpers` loading issue

## 0.2.0 (Jun 30, 2022 )

### Changed

- Replace checks for `nice_partials` with built-in support for capturing the
  `turbo_streams` block

### Added

- Introduce the `turbo_stream_button_tag` helper, and replace documented calls
  to `render("turbo_stream_button")` with calls to `turbo_stream_button_tag`

## 0.1.0

- Initial release
