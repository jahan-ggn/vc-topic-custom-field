# frozen_string_literal: true

VcTopicCustomField::Engine.routes.draw do
  get "/examples" => "examples#index"
  # define routes here
end

Discourse::Application.routes.draw { mount ::VcTopicCustomField::Engine, at: "vc-topic-custom-field" }
