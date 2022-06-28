# `<button>` + `<turbo-stream>`

Harness the power of [Turbo Streams][] to declare `click` event handlers as a
series of HTML mutations.

Combine built-in `<button>` elements with `<turbo-stream>` elements to
declaratively drive client-side interactions with server-generated HTML.

```html
<button type="button" id="call-to-action"
        data-controller="turbo-stream-button"
        data-action="click->turbo-stream-button#evaluate">
  <span>Click me to insert the template's contents after this button!</span>

  <template data-turbo-stream-button-target="turboStreams">
    <turbo-stream action="after" target="call-to-action">
      <template><p>You clicked the button!</p></template>
    </turbo-stream>
  </template>
</button>
```

[Try it out.](https://jsfiddle.net/toybqx89/)

[Turbo Streams]: https://turbo.hotwired.dev/reference/streams

## Usage

In your JavaScript code, import and register the `turbo-stream-button`
controller with your Stimulus application:

```javascript
import "@hotwired/turbo"
import { Application } from "stimulus"
import { TurboStreamButtonController } from "@seanpdoyle/turbo_stream_button"

const application = Application.start()
application.register("turbo-stream-button", TurboStreamButtonController)
```

In your Rails templates, render the `turbo_stream_button` view partial to create
the `<button>` element. The view partial renders:

* `content:` as the `<button>` element's content
* other keyword arguments as the `<button>` element's attributes
* block content as the `<template>` element's content

When the button is clicked, the `turbo-stream-button` [Stimulus controller][]
invokes the `evaluate` [Action][] to insert the contents of the [`<template>`
element][mdn-template], activating any `<turbo-stream>` elements nested inside.

[Stimulus controller]: https://stimulus.hotwired.dev/handbook/hello-stimulus#controllers-bring-html-to-life
[Action]: https://stimulus.hotwired.dev/handbook/building-something-real#connecting-the-action
[mdn-template]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/template

### Introductory: Hello, world

```html+erb
<% content = capture do %>
  <span>Click me to say "hello"</span>
<% end %>

<%= render "turbo_stream_button", content: content, id: "the-button" do %>
  <%= turbo_stream.after "the-button", "Hello, world!" %>
<% end %>

<%# =>  <button type="button" id="the-button"
                data-controller="turbo-stream-button"
                data-action="click->turbo-stream-button#evaluate">
          <span>Click me to say "hello"</span>

          <template data-turbo-stream-target="turboStreams">
            <turbo-stream action="after" target="the-button">
              <template>Hello, world!</template>
            </turbo-stream>
          </template>
        </button> %>
```

### Intermediate: Compose with other Stimulus controller actions

```html+erb
<script type="module">
  import "@hotwired/turbo"
  import { Application, Controller } from "stimulus"
  import { TurboStreamButtonController } from "@seanpdoyle/turbo_stream_button"

  class ClipboardController extends Controller {
    copy({ target: { value } }) {
      navigator.clipboard.writeText(value)
    }
  }

  const application = Application.start()
  application.register("turbo-stream-button", TurboStreamButtonController)
  application.register("clipboard", ClipboardController)
</script>

<div id="flash" role="alert"></div>

<%= render "turbo_stream_button", content: "Copy to clipboard", value: "invitation-code-abc123",
                                  data: { controller: "clipboard", action: "click->clipboard#copy" } do %>
  <turbo-stream action="append" target="flash">
    <template>
      <p>Copied "invitation-code-abc123" to your clipboard!</p>
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
                <p>Copied "invitation-code-abc123" to your clipboard!</p>
              </template>
            </turbo-stream>
          </template>
        </button> %>
```

### Advanced: Nest buttons

```html+erb
<div id="flash" role="alert"></div>

<%= render "turbo_stream_button", content: "Append flash message" do %>
  <turbo-stream action="append" target="flash">
    <template>
      <div id="a_flash_message" role="status">
        Hello, world!

        <%= render "turbo_stream_button", content: "Dismiss" do %>
          <%= turbo_stream.remove "a_flash_message" %>
        <% end %>
      </div>
    </template>
  </turbo-stream>
<% end %>

<%# =>  <button type="button"
                data-controller="turbo-stream-button"
                data-action="click->turbo-stream-button#evaluate">
          Append flash message

          <template data-turbo-stream-target="turboStreams">
            <turbo-stream action="append" target="flash">
              <template>
                <div id="a_flash_message" role="status">
                  Hello, world!

                  <button type="button"
                          data-controller="turbo-stream-button"
                          data-action="click->turbo-stream-button#evaluate">
                    Dismiss

                    <template data-turbo-stream-target="turboStreams">
                      <turbo-stream action="remove" target="a_flash_message"></turbo-stream>
                    </template>
                  </button>
                </div>
              </template>
            </turbo-stream>
          </template>
        </button> %>
```

### Advanced: Append form controls

```html+erb
<script type="module">
  import "@hotwired/turbo"
  import { Application } from "stimulus"
  import { TurboStreamButtonController } from "@seanpdoyle/turbo_stream_button"
  import { TemplateInstance } from "https://cdn.skypack.dev/@github/template-parts"

  class CloneController extends Controller {
    static targets = [ "template" ]
    static values = { count: Number, counter: String }

    templateTargetConnected(target) {
      const templateInstance = new TemplateInstance(target, {
        [this.counterValue]: this.countValue
      })

      target.content.replaceChildren(templateInstance)

      this.countValue++
    }
  }

  const application = Application.start()
  application.register("turbo-stream-button", TurboStreamButtonController)
  application.register("clone", CloneController)
</script>

<%= form_with scope: :applicant do |form| %>
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

<%# =>  <button type="button"
                data-controller="turbo-stream-button"
                data-action="click->turbo-stream-button#evaluate">
          Add reference

          <template data-turbo-stream-button-target="turboStreams">
            <turbo-stream action="append" target="references">
              <template data-clone-target="template">
                <li>
                  <label for="applicant_reference_attributes_{{counter}}_referrer">Referrer</label>
                  <input type="text" name="applicant[reference_attributes][{{counter}}][referrer]" id="applicant_reference_attributes_{{counter}}_referrer">

                  <label for="applicant_reference_attributes_{{counter}}_relationship">Relationship</label>
                  <input type="text" name="applicant[reference_attributes][{{counter}}][relationship]" id="applicant_reference_attributes_{{counter}}_relationship">
                </li>
              </template>
            </turbo-stream>
          </template>
        </button> %>
```

## Exploring examples

To poke around with some working examples, start the [dummy application][]
locally:

```sh
cd test/dummy
bundle exec rails server --port 3000
```

Then, visit <http://localhost:3000/examples>.

[dummy application]: ./test/dummy

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
