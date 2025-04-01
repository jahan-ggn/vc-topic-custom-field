# frozen_string_literal: true

# name: vc-topic-custom-field
# about: TODO
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :vc_topic_custom_field_enabled

module ::VcTopicCustomField
  PLUGIN_NAME = "vc-topic-custom-field"
end

require_relative "lib/vc_topic_custom_field/engine"

after_initialize do
  # Code which should run after Rails has finished booting
end
