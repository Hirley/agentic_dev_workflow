# frozen_string_literal: true

require_relative 'base_generator'

module AgenticBootstrap
  module Generators
    # Gera um exemplo de Arquitetura Hexagonal (lib/domain, lib/ports,
    # lib/adapters) no diretório alvo, nomeado a partir de `entity_name`
    # (padrão: 'task'). Não sobrescreve arquivos existentes.
    class ExampleDomainGenerator < BaseGenerator
      DOMAIN_TEMPLATE = load_template('domain_task.rb.erb')
      PORT_TEMPLATE = load_template('ports_task_repository.rb.erb')
      ADAPTER_TEMPLATE = load_template('adapters_in_memory_task_repository.rb.erb')

      def initialize(target_dir:, entity_name: 'task')
        super(target_dir: target_dir)
        @entity_name = entity_name
        @class_name = camelize(entity_name)
      end

      def generate
        locals = { entity_name: @entity_name, class_name: @class_name }

        write_file(File.join('lib', 'domain', "#{@entity_name}.rb"), render(DOMAIN_TEMPLATE, locals))
        write_file(File.join('lib', 'ports', "#{@entity_name}_repository.rb"), render(PORT_TEMPLATE, locals))
        write_file(File.join('lib', 'adapters', "in_memory_#{@entity_name}_repository.rb"),
                   render(ADAPTER_TEMPLATE, locals))
      end

      private

      def camelize(name)
        name.to_s.split(/[_-]/).map { |part| part[0].upcase + part[1..] }.join
      end
    end
  end
end
