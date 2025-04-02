import Component from "@glimmer/component";
import { service } from "@ember/service";
import { withPluginApi } from "discourse/lib/plugin-api";

class TopicDealStatusIndicator extends Component {
  @service siteSettings;

  get displayFieldName() {
    const rawFieldName = this.siteSettings.VC_topic_custom_field_name;
    return rawFieldName
      ?.split("_")
      .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
      .join(" ");
  }

  <template>
    {{#if this.args.outletArgs.topic.deal_status}}
      <span style="color: green;">
        |
        <a
          href="{{this.args.outletArgs.topic.lastUnreadUrl}}"
          data-topic-id="{{this.args.outletArgs.topic.id}}"
        >
          <span>{{this.displayFieldName}}:
            {{this.args.outletArgs.topic.deal_status}}
          </span>
        </a>
      </span>
    {{/if}}
  </template>
}

export default {
  name: "vc-topic-custom-field-intializer",
  initialize(container) {
    const siteSettings = container.lookup("service:site-settings");
    const rawFieldName = siteSettings.VC_topic_custom_field_name;

    withPluginApi("1.37.3", (api) => {
      api.serializeOnCreate(rawFieldName);
      api.serializeToDraft(rawFieldName);
      api.serializeToTopic(rawFieldName, `topic.${rawFieldName}`);

      api.renderInOutlet("topic-list-after-title", TopicDealStatusIndicator);
    });
  },
};
