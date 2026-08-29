# frozen_string_literal: true

require_relative 'base_generator'

module AgenticDevWorkflow
  module Generators
    # Gera .rubocop.yml no diretório alvo, com um dos dois perfis:
    # 'strict' (regras rígidas, indicado para APIs) ou 'pragmatic' (regras
    # mais soltas, indicado para CLIs). Não sobrescreve um .rubocop.yml
    # existente.
    class RubocopGenerator < BaseGenerator
      TEMPLATE = load_template('rubocop.yml.erb')
      VALID_PROFILES = %w[strict pragmatic].freeze

      def initialize(target_dir:, profile: 'pragmatic')
        raise ArgumentError, "profile inválido: #{profile}" unless VALID_PROFILES.include?(profile)

        super(target_dir: target_dir)
        @profile = profile
      end

      def generate
        write_file('.rubocop.yml', render(TEMPLATE, profile: @profile))
      end
    end
  end
end
