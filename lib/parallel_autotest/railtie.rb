module ParallelAutotest
  class Railtie < Rails::Railtie
     rake_tasks do
       spec = Gem::Specification.find_by_name 'parallel_autotest'
       load "#{spec.gem_dir}/lib/tasks/parallel_autotest.rake"
      end
   end
end
