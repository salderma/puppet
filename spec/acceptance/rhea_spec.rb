require 'spec_helper_acceptance'

if hosts.map(&:name).include?('rhea')
  describe 'Rhea role' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        include ::role::rhea
      EOS

      # Run it twice and test if idempotent
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it_behaves_like 'role::rhea'
  end
end
