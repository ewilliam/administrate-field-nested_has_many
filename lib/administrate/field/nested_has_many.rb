require "rails"
require "administrate"
require "administrate/field/has_many"
require "cocoon"

# TODO: DRY up special_association_name and namespace
# with :class_name and :field

module Administrate
  module Field
    class NestedHasMany < Administrate::Field::HasMany
      VERSION = "0.1.0"

      class Engine < ::Rails::Engine
        Administrate::Engine.add_javascript "administrate-field-nested_has_many/application"
      end

      DEFAULT_ATTRIBUTES = [:id, :_destroy].freeze

      def nested_fields
        associated_form.attributes.reject do |nested_field|
          skipped_fields.include?(nested_field.attribute)
        end
      end

      def nested_fields_for_obj(obj)
        associated_form(obj).attributes.reject do |nested_field|
          skipped_fields.include?(nested_field.attribute)
        end
      end

      def to_s
        data
      end

      def self.dashboard_for_resource(resource, namespace = nil)
        name = namespace.camelize.constantize if namespace

        if name
          "#{name}::#{resource.to_s.classify}Dashboard".constantize
        else
          "#{resource.to_s.classify}Dashboard".constantize
        end
      end

      def self.associated_attributes(associated_resource, namespace)
        DEFAULT_ATTRIBUTES +
          dashboard_for_resource(associated_resource, namespace).new.permitted_attributes
      end

      def self.permitted_attribute(associated_resource, options)
        {
          "#{associated_resource}_attributes".to_sym =>
          associated_attributes(associated_resource, options[:namespace]),
        }
      end

      def associated_class_name
        options.fetch(:class_name, attribute.to_s.singularize.camelcase)
      end

      def association_name
        return special_association_name unless special_association_name.empty?
        associated_class_name.underscore.pluralize
      end

      def associated_form(resource=association_name)
        Administrate::Page::Form.new(associated_dashboard, resource)
      end

      def namespace_name
        options[:namespace].to_s
      end

      private

      def skipped_fields
        Array(options[:skip])
      end

      def special_association_name
        options[:association_name].to_s
      end
    end
  end
end
