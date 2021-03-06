require 'spec_helper_acceptance'

describe "#{TEST_CLASS} class" do
  # Using puppet_apply as a helper
  it 'should work idempotently with no errors' do
    pp = <<-EOS
      include #{TEST_CLASS}
    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  it_behaves_like "#{TEST_CLASS}"
end
