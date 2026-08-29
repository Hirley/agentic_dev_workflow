# frozen_string_literal: true

require_relative 'base_generator'

module AgenticDevWorkflow
  module Generators
    # Gera o arquivo CLAUDE.md no diretório alvo, a partir do template
    # em templates/CLAUDE.md.erb. Não sobrescreve um CLAUDE.md existente.
    class ClaudeMdGenerator < BaseGenerator
      TEMPLATE = load_template('CLAUDE.md.erb')

      def generate
        write_file('CLAUDE.md', render(TEMPLATE))
      end
    end
  end
end
