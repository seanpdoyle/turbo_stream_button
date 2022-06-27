# `<button>` + `<turbo-stream>`

Combine `<button>` and `<turbo-stream>` to drive client-side interactions
with declarative server-generated HTML

## Usage

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

    <ol id="<%= form.field_id(:references) %>"></ol>

    <%= form.fields :reference_attributes, index: "{{counter}}" do |reference_form| %>
      <%= render "turbo_stream_button", content: "Add reference" do %>
        <turbo-stream action="append" target="<%= form.field_id(:references) %>">
          <template data-clone-target="template">
            <li id="<%= reference_form.field_id(:fields) %>">
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