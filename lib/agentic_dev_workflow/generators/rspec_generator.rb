# frozen_string_literal: true

require_relative 'base_generator'

module AgenticDevWorkflow
  module Generators
    # Gera .rspec e spec/spec_helper.rb no diretório alvo. Não sobrescreve
    # arquivos já existentes.
    class RspecGenerator < BaseGenerator
      DOT_RSPEC_TEMPLATE = load_template('dot_rspec.erb')
      SPEC_HELPER_TEMPLATE = load_template('spec_helper.rb.erb')

      def generate
        write_file('.rspec', render(DOT_RSPEC_TEMPLATE))
        write_file(File.join('spec', 'spec_helper.rb'), render(SPEC_HELPER_TEMPLATE))
      end
    end
  end
end
