# frozen_string_literal: true

require_relative 'base_generator'

module AgenticBootstrap
  module Generators
    # Gera o arquivo ROADMAP.md no diretório alvo. Não sobrescreve um
    # ROADMAP.md existente.
    class RoadmapGenerator < BaseGenerator
      TEMPLATE = load_template('ROADMAP.md.erb')

      def generate
        write_file('ROADMAP.md', render(TEMPLATE))
      end
    end
  end
end
