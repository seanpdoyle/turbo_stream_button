import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "turboStreams" ]

  turboStreamsTargets!: HTMLTemplateElement[]

  evaluate({ target }: Event) {
    if (target instanceof Element) {
      for (const { content } of this.turboStreamsTargets) {
        target.append(content.cloneNode(true))
      }
    }
  }
}
