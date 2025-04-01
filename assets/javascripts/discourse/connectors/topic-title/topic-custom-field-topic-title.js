import Component from "@glimmer/component";
import { inject as controller } from "@ember/controller";
import { alias } from "@ember/object/computed";
import { service } from "@ember/service";

export default class TopicCustomFieldTopicTitle extends Component {
  @service siteSettings;
  @controller topic;

  @alias("siteSettings.VC_topic_custom_field_name") rawFieldName;

  get fieldName() {
    return this.rawFieldName
      ?.split("_")
      .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
      .join(" ");
  }

  get fieldValue() {
    return this.args.outletArgs.model.get(this.rawFieldName) || "On-Going";
  }
}
