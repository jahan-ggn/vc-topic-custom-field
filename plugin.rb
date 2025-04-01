# frozen_string_literal: true

# name: vc-topic-custom-field
# about: A plugin to add and display custom field inside topic composer for VC community with ease.
# version: 0.0.1
# authors: Jahan Gagan
# url: https://github.com/jahan-ggn/vc-topic-custom-field

enabled_site_setting :VC_topic_custom_field_enabled
register_asset "stylesheets/common.scss"

after_initialize do
  module ::VCTopicCustomField
    FIELD_NAME = SiteSetting.VC_topic_custom_field_name
    FIELD_TYPE = SiteSetting.VC_topic_custom_field_type
  end

  register_topic_custom_field_type(
    VCTopicCustomField::FIELD_NAME,
    VCTopicCustomField::FIELD_TYPE.to_sym,
  )

  add_to_class(:topic, VCTopicCustomField::FIELD_NAME.to_sym) do
    if !custom_fields[VCTopicCustomField::FIELD_NAME].nil?
      custom_fields[VCTopicCustomField::FIELD_NAME]
    else
      nil
    end
  end

  add_to_class(:topic, "#{VCTopicCustomField::FIELD_NAME}=") do |value|
    custom_fields[VCTopicCustomField::FIELD_NAME] = value
  end

  on(:topic_created) do |topic, opts, user|
    topic.send(
      "#{VCTopicCustomField::FIELD_NAME}=".to_sym,
      opts[VCTopicCustomField::FIELD_NAME.to_sym],
    )
    topic.save!
  end

  PostRevisor.track_topic_field(VCTopicCustomField::FIELD_NAME.to_sym) do |tc, value|
    tc.record_change(
      VCTopicCustomField::FIELD_NAME,
      tc.topic.send(VCTopicCustomField::FIELD_NAME),
      value,
    )
    tc.topic.send("#{VCTopicCustomField::FIELD_NAME}=".to_sym, value.present? ? value : nil)
  end

  add_to_serializer(:topic_view, VCTopicCustomField::FIELD_NAME.to_sym) do
    object.topic.send(VCTopicCustomField::FIELD_NAME)
  end

  add_preloaded_topic_list_custom_field(VCTopicCustomField::FIELD_NAME)

  add_to_serializer(:topic_list_item, VCTopicCustomField::FIELD_NAME.to_sym) do
    object.send(VCTopicCustomField::FIELD_NAME)
  end
end
