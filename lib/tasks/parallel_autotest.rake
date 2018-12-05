# namespace :parallel do
  desc "Autotest in parallel"
  task autotest: :environment do
    # require 'parallel_autotest'
    ParallelAutotest::Autotest.run
  end
# end
