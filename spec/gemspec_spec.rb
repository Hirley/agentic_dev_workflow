# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'agentic_dev_workflow.gemspec' do
  root = File.expand_path('..', __dir__)
  gemspec = Gem::Specification.load(File.join(root, 'agentic_dev_workflow.gemspec'))

  it 'empacota todos os templates ERB usados pelos geradores' do
    templates = Dir.chdir(root) { Dir['lib/agentic_dev_workflow/templates/**/*.erb'] }

    expect(templates).not_to be_empty
    expect(gemspec.files).to include(*templates)
  end
end
