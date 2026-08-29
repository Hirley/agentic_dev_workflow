# frozen_string_literal: true

require_relative 'base_generator'

module AgenticBootstrap
  module Generators
    # Gera um exemplo de Arquitetura Hexagonal (lib/domain, lib/ports,
    # lib/adapters) no diretório alvo. Não sobrescreve arquivos existentes.
    class ExampleDomainGenerator < BaseGenerator
      DOMAIN_TEMPLATE = load_template('domain_task.rb.erb')
      PORT_TEMPLATE = load_template('ports_task_repository.rb.erb')
      ADAPTER_TEMPLATE = load_template('adapters_in_memory_task_repository.rb.erb')

      def generate
        write_file(File.join('lib', 'domain', 'task.rb'), render(DOMAIN_TEMPLATE))
        write_file(File.join('lib', 'ports', 'task_repository.rb'), render(PORT_TEMPLATE))
        write_file(File.join('lib', 'adapters', 'in_memory_task_repository.rb'), render(ADAPTER_TEMPLATE))
      end
    end
  end
end
