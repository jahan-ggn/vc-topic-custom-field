import { alias } from "@ember/object/computed";
import discourseComputed from "discourse/lib/decorators";
import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "vc-topic-custom-field-intializer",
  initialize(container) {
    const siteSettings = container.lookup("service:site-settings");
    const rawFieldName = siteSettings.VC_topic_custom_field_name;
    const displayFieldName = rawFieldName
      ?.split("_")
      .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
      .join(" ");

    withPluginApi("1.37.3", (api) => {
      api.serializeOnCreate(rawFieldName);
      api.serializeToDraft(rawFieldName);
      api.serializeToTopic(rawFieldName, `topic.${rawFieldName}`);

      api.modifyClass("component:topic-list-item", {
        pluginId: "vc-topic-custom-field",
        customFieldName: displayFieldName,
        customFieldValue: alias(`topic.${rawFieldName}`),

        @discourseComputed("customFieldValue")
        showCustomField: (value) => !!value,
      });
    });
  },
};
