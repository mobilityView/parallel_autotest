module ParallelAutotest
  class Autotest
    TEST_FILENAME_PATTERN = /_test.rb$/

    def self.run
      new.run
    end

    def run
      outstanding_failures = false
      loop do
        unless (test_files = test_names_for(wait_for_modified_files)).empty?
          outstanding_failures = !(last_passed = run_tests(test_files)) || outstanding_failures # note: ||= will skip test run
        end
        outstanding_failures = !run_tests(all_test_files) if outstanding_failures && last_passed
      end
    end

    private

    def wait_for_modified_files
      loop do
        unless (modified_files = discover_modified_files).empty?
          return modified_files
        end
        sleep(1)
      end
    end

    def test_names_for(filenames)
      filenames.map{|filename| calculate_test_filename(filename) }.select{|filename| filename =~ TEST_FILENAME_PATTERN && @last_file_dates[filename] }
    end

    def run_tests(filenames)
      system("parallel_test -n #{ENV['PARALLEL_COUNT'] || 8} #{filenames.join(" ")}") ? 0 : 1
    end

    def get_file_dates
      {}.tap {|file_dates| %w(app config lib test).each {|directory| load_directory directory, file_dates }}
    end

    def all_test_files
      {}.tap{|filenames| load_directory 'test', filenames}.keys
    end

    def load_directory(path, test_files_hash)
      Find.find(path) do |f|
        if File.file?(f)
          test_files_hash[f] = File.mtime(f)
        else
          load_directory f, test_files_hash unless f == path
        end
      end
    end

    def calculate_test_filename(filename)
      return filename if filename =~ /^test\//
      filename = filename.gsub(/^app\/views\//, 'controllers/').gsub(/\/[^\/]+$/, '_controller.rb') if /app\/views\// =~ filename
      'test/' + filename.gsub(/^app\//, '').gsub(/.rb$/, '_test.rb')
    end

    def modified(old_file_hash, new_file_hash)
      if old_file_hash
        (new_file_hash.keys - old_file_hash.keys).tap {|filenames| old_file_hash.each {|filename, date| filenames << filename if new_file_hash[filename] != date } }
      else
        []
      end
    end

    def discover_modified_files
      file_dates = get_file_dates
      modified_files = modified(@last_file_dates, file_dates)
      @last_file_dates = file_dates
      modified_files.uniq
    end
  end
end
