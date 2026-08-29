# frozen_string_literal: true

require_relative 'base_generator'

module AgenticBootstrap
  module Generators
    # Gera docker-compose.observability.yml e observability/prometheus.yml no
    # diretório alvo. Não sobrescreve arquivos existentes.
    class ObservabilityGenerator < BaseGenerator
      COMPOSE_TEMPLATE = load_template('docker-compose.observability.yml.erb')
      PROMETHEUS_TEMPLATE = load_template('prometheus.yml.erb')

      def generate
        write_file('docker-compose.observability.yml', render(COMPOSE_TEMPLATE))
        write_file(File.join('observability', 'prometheus.yml'), render(PROMETHEUS_TEMPLATE))
      end
    end
  end
end
