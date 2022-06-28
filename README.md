# `<button>` + `<turbo-stream>`

Combine `<button>` and `<turbo-stream>` to drive client-side interactions
with declarative server-generated HTML

## Usage

First, register the `turbo-stream-button` controller in your Stimulus
application:

```javascript
import "@hotwired/turbo"
import { Application } from "stimulus"
import { TurboStreamButtonController } from "@seanpdoyle/turbo_stream_button"

const application = Application.start()
application.register("turbo-stream-button", TurboStreamButtonController)
```

Next, invoke the `turbo_stream_button` view partial to render the `<button>`.
The partial assigns:

* renders the template's block content into a `<template>` element
* renders the `content:` local assignment as the button's visible content
* renders any other local assignments as the `<button>` element's HTML attributes

```erb
<% content = capture do %>
  <span>Click me!</span>
<% end %>

<%= render("turbo_stream_button", content:, id: "call-to-action") do %>
  <%= turbo_stream.after("call-to-action") { "You clicked the call to action!" } %>
<% end %>

<%# =>  <button type="button" id="call-to-action"
                data-controller="turbo-stream-button"
                data-action="click->turbo-stream-button#evaluate">
          <span>Click me!</span>

          <template data-turbo-stream-button-target="turboStreams">
            <turbo-stream action="after" target="call-to-action">
              <template>You clicked the call to action!</template>
            </turbo-stream>
          </template>
        </button> %>
```

When the button is clicked, the `turbo-stream-button#evaluate` Stimulus action
will append the contents of the `<template>` element, which can activate any
`<turbo-stream>` elements nested inside.

### Hello, world

```html+erb
<script type="module">
  import "@hotwired/turbo"
  import { Application } from "stimulus"
  import { TurboStreamButtonController } from "@seanpdoyle/turbo_stream_button"

  const application = Application.start()
  application.register("turbo-stream-button", TurboStreamButtonController)
</script>

<%= render "turbo_stream_button", content: "Click to say hello", id: "the-button" do %>
  <turbo-stream action="after" target="the-button">
    <template>Hello, from #the-button!</template>
  </turbo-stream>
<% end %>

<%# =>  <button type="button" id="the-button"
                data-controller="turbo-stream-button"
                data-action="click->turbo-stream-button#evaluate">
          Click to say hello

          <template data-turbo-stream-target="turboStreams">
            <turbo-stream action="after" target="the-button">
              <template>Hello, from #the-button!</template>
            </turbo-stream>
          </template>
        </button> %>
```

### Composing with other Stimulus controllers

```html+erb
<script type="module">
  import "@hotwired/turbo"
  import { Application, Controller } from "stimulus"
  import { TurboStreamButtonController } from "@seanpdoyle/turbo_stream_button"

  const application = Application.start()
  application.register("turbo-stream-button", TurboStreamButtonController)
  application.register("clipboard", class extends Controller {
    copy({ target: { value } }) {
      navigator.clipboard.writeText(value)
    }
  })
</script>

<div id="flash"></div>

<%= render "turbo_stream_button", content: "Copy to clipboard", value: "invitation-code-abc123",
                                  data: { controller: "clipboard", action: "click->clipboard#copy" } do %>
  <turbo-stream action="append" target="flash">
    <template>
      <div role="alert">Copied "invitation-code-abc123" to clipboard!</div>
    </template>
  </turbo-stream>
<% end %>

<%# =>  <button type="button" value="invitation-code-abc123"
                data-controller="turbo-stream-button clipboard"
                data-action="click->turbo-stream-button#evaluate click->clipboard#copy">
          Copy to clipboard

          <template data-turbo-stream-target="turboStreams">
            <turbo-stream action="append" target="flash">
              <template>
                <div role="alert">Copied "invitation-code-abc123" to clipboard!</div>
              </template>
            </turbo-stream>
          </template>
        </button> %>
```

### Nesting buttons

```html+erb
<script type="module">
  import "@hotwired/turbo"
  import { Application } from "stimulus"
  import { TurboStreamButtonController } from "@seanpdoyle/turbo_stream_button"

  const application = Application.start()
  application.register("turbo-stream-button", TurboStreamButtonController)
</script>

<div id="flash" role="alert"></div>

<%= render "turbo_stream_button", content: "Append flash message" do %>
  <turbo-stream action="append" target="flash">
    <template>
      <div id="a_flash_message" role="status">
        Hello, world!

        <%= render "turbo_stream_button", content: "Dismiss flash message" do %>
          <turbo-stream action="remove" target="a_flash_message"></turbo-stream>
        <% end %>
      </div>
    </template>
  </turbo-stream>
<% end %>
```

### Appending form controls

```html+erb
<script type="module">
  import "@hotwired/turbo"
  import { Application } from "stimulus"
  import { TurboStreamButtonController } from "@seanpdoyle/turbo_stream_button"
  import { TemplateInstance } from "https://cdn.skypack.dev/@github/template-parts"

  const application = Application.start()
  application.register("turbo-stream-button", TurboStreamButtonController)
  application.register("clone", class extends Controller {
    static targets = [ "template" ]
    static values = { count: Number, counter: String }

    templateTargetConnected(target) {
      const templateInstance = new TemplateInstance(target, {
        [this.counterValue]: this.countValue
      })

      target.content.replaceChildren(templateInstance)

      this.countValue++
    }
  })
</script>

<%= form_with model: Applicant.new do |form| %>
  <fieldset data-controller="clone" data-clone-counter-value="counter" data-clone-count-value="0">
    <legend>References</legend>

    <ol id="references"></ol>

    <%= form.fields :reference_attributes, index: "{{counter}}" do |reference_form| %>
      <%= render "turbo_stream_button", content: "Add reference" do %>
        <turbo-stream action="append" target="references">
          <template data-clone-target="template">
            <li>
              <%= reference_form.label :referrer %>
              <%= reference_form.text_field :referrer %>

              <%= reference_form.label :relationship %>
              <%= reference_form.text_field :relationship %>
            </li>
          </template>
        </turbo-stream>
      <% end %>
    <% end %>
  </fieldset>
<% end %>
```

## Integrating with [`nice_partials`][nice_partials]

If an application depends on [`nice_partials`][nice_partials], the
`turbo_stream_button` will support capturing content for the `:content` and
`:turbo_streams` named blocks:

```erb
<%= render("turbo_stream_button", id: "call-to-action") do |button| %>
  <%= button.content_for :content do %>
    <span>Click me!</span>
  <% end %>

  <%= button.content_for :turbo_streams do %>
    <%= turbo_stream.after("call-to-action") { "You clicked the call to action!" } %>
  <% end %>
<% end %>

<%# =>  <button type="button" id="call-to-action"
                data-controller="turbo-stream-button"
                data-action="click->turbo-stream-button#evaluate">
          <span>Click me!</span>

          <template data-turbo-stream-button-target="turboStreams">
            <turbo-stream action="after" target="call-to-action">
              <template>You clicked the call to action!</template>
            </turbo-stream>
          </template>
        </button> %>
```

[nice_partials]: https://github.com/bullet-train-co/nice_partials

## Installation

Add the `turbo_stream_button` dependency to your application's Gemfile:

```ruby
gem "turbo_stream_button", github: "seanpdoyle/turbo_stream_button", branch: "main"
```

And then execute:

```bash
$ bundle
```

### Installation through [importmap-rails][]

Once the gem is installed, add the client-side dependency mapping to your
project's `config/importmap.rb` declaration:

```ruby
# config/importmap.rb

pin "@seanpdoyle/turbo_stream_button", to: "turbo_stream_button.js"
```

[importmap-rails]: https://github.com/rails/importmap-rails

### Installation through `npm` or `yarn`

Once the gem is installed, add the client-side dependency to your project via
npm or Yarn:

```bash
yarn add https://github.com/seanpdoyle/turbo_stream_button.git
```

## Contributing

Please read [CONTRIBUTING.md](./CONTRIBUTING.md).

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
