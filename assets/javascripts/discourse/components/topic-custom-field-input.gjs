import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { Input, Textarea } from "@ember/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { readOnly } from "@ember/object/computed";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { service } from "@ember/service";
import { eq } from "truth-helpers";
import DSelect from "discourse/components/d-select";
import { i18n } from "discourse-i18n";

export default class TopicCustomFieldInput extends Component {
  @service siteSettings;
  @service composer;

  @tracked selectedItem = this.args.fieldValue || "On-Going";

  @readOnly("siteSettings.VC_topic_custom_field_name") fieldName;
  @readOnly("siteSettings.VC_topic_custom_field_type") fieldType;

  get allowedCategoryIds() {
    return [6];
  }

  get shouldRender() {
    const composer = this.composer;
    const categoryId =
      composer?.model?.category?.id || // for creation
      composer?.topic?.category_id; // for editing

    return this.allowedCategoryIds.includes(categoryId);
  }

  // Options for the DSelect dropdown
  get options() {
    return [
      { id: "ongoing", label: "On-Going" },
      { id: "withdrawn", label: "Withdrawn" },
      { id: "funded", label: "Funded" },
    ];
  }

  @action
  initSelect() {
    if (!this.hasInitialized && this.selectedItem) {
      this.hasInitialized = true;
      this.handleSelectChange(this.selectedItem);
    }
  }

  @action
  handleSelectChange(value) {
    this.args.onChangeField(value);
  }

  <template>
    {{#if this.shouldRender}}
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
          {{didInsert this.initSelect}}
          as |select|
        >
          {{#each this.options as |option|}}
            <select.Option @value={{option.label}}>
              {{option.label}}
            </select.Option>
          {{/each}}
        </DSelect>
      {{/if}}
    {{/if}}
  </template>
}
