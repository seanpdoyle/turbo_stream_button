import { Controller } from 'stimulus';

class default_1 extends Controller {
    evaluate({ target }) {
        if (target instanceof Element) {
            for (const { content } of this.turboStreamsTargets) {
                target.append(content.cloneNode(true));
            }
        }
    }
}
default_1.targets = ["turboStreams"];

export { default_1 as TurboStreamButtonController };
