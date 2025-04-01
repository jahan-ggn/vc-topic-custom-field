import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { Input, Textarea } from "@ember/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { readOnly } from "@ember/object/computed";
import { service } from "@ember/service";
import { eq } from "truth-helpers";
import DSelect from "discourse/components/d-select";
import { i18n } from "discourse-i18n";

export default class TopicCustomFieldInput extends Component {
  @service siteSettings;

  @tracked selectedItem = this.args.fieldValue || "On-Going";

  @readOnly("siteSettings.VC_topic_custom_field_name") fieldName;
  @readOnly("siteSettings.VC_topic_custom_field_type") fieldType;

  // Options for the DSelect dropdown
  get options() {
    return [
      { id: "ongoing", label: "On-Going" },
      { id: "withdrawn", label: "Withdrawn" },
      { id: "funded", label: "Funded" },
    ];
  }

  @action
  handleSelectChange(value) {
    this.selectedItem = value;
    if (this.args?.onChangeField) {
      this.args.onChangeField(value);
    }
  }

  <template>
    {{#if (eq this.fieldType "boolean")}}
      <Input
        @type="checkbox"
        @checked={{@fieldValue}}
        {{on "change" (action @onChangeField value="target.checked")}}
      />
      <span>{{this.fieldName}}</span>
    {{/if}}

    {{#if (eq this.fieldType "integer")}}
      <Input
        @type="number"
        @value={{@fieldValue}}
        placeholder={{i18n
          "topic_custom_field.placeholder"
          field=this.fieldName
        }}
        class="topic-custom-field-input small"
        {{on "change" (action @onChangeField value="target.value")}}
      />
    {{/if}}

    {{#if (eq this.fieldType "string")}}
      <Input
        @type="text"
        @value={{@fieldValue}}
        placeholder={{i18n
          "topic_custom_field.placeholder"
          field=this.fieldName
        }}
        class="topic-custom-field-input large"
        {{on "change" (action @onChangeField value="target.value")}}
      />
    {{/if}}

    {{#if (eq this.fieldType "json")}}
      <Textarea
        @value={{@fieldValue}}
        {{on "change" (action @onChangeField value="target.value")}}
        placeholder={{i18n
          "topic_custom_field.placeholder"
          field=this.fieldName
        }}
        class="topic-custom-field-textarea"
      />
    {{/if}}

    {{#if (eq this.fieldType "select")}}
      <DSelect
        @options={{this.options}}
        @value={{this.selectedItem}}
        @onChange={{this.handleSelectChange}}
        class="topic-custom-field-select"
        @placeholder="Select an option"
        @includeNone=""
        as |select|
      >
        {{#each this.options as |option|}}
          <select.Option @value={{option.label}}>
            {{option.label}}
          </select.Option>
        {{/each}}
      </DSelect>
    {{/if}}
  </template>
}
