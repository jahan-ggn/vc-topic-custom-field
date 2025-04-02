import { withPluginApi } from "discourse/lib/plugin-api";

const DealStatusHeaderCell = <template>
  <th>Deal Status</th>
</template>;
const DealStatusItemCell = <template>
  <td>{{#if @topic.deal_status}}
      <a href="{{@topic.lastUnreadUrl}}" data-topic-id="{{@topic.id}}">
        <span>
          {{@topic.deal_status}}
        </span>
      </a>

    {{else}}
      <span> - </span>
    {{/if}}
  </td>
</template>;

export default {
  name: "vc-topic-custom-field-intializer",
  initialize(container) {
    const siteSettings = container.lookup("service:site-settings");
    const rawFieldName = siteSettings.VC_topic_custom_field_name;

    withPluginApi("1.37.3", (api) => {
      api.serializeOnCreate(rawFieldName);
      api.serializeToDraft(rawFieldName);
      api.serializeToTopic(rawFieldName, `topic.${rawFieldName}`);

      api.registerValueTransformer(
        "topic-list-columns",
        ({ value: columns }) => {
          columns.add("deal-status", {
            header: DealStatusHeaderCell,
            item: DealStatusItemCell,
          });
        }
      );
    });
  },
};
