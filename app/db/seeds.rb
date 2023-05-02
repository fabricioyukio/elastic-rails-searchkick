# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'csv'
# require Prompt
begin
  puts "Reading prompts.csv..."
  csv_path = "#{Rails.root}/storage/parquet/prompts.csv"
  csv_text = File.read(csv_path)  # Read the file
  csv_parsed = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")  # Parse the file
  data = []

  begin
    csv_parsed.each_with_index do |row, i|
      puts "Processing row #{i}" if i  < 3
      this_row = row.to_hash

      if i==0
        puts "Verifying if already inserted..."
        verify = Prompt.where(original_index: this_row['index'])
                        .where(content: this_row['content'])
                        .first
        unless verify.nil?
          puts "This file has already been imported."
          break
        end
      end

      data << { original_index: this_row['index'], content: this_row['content']}
    end


    raise StandardError.new "No new records to insert" if data.empty? # If we've already got this file, we're done
    puts "Importing #{data.length} prompts..."
    Prompt.insert_all(data)
    Prompt.reindex
    puts "Successfully inserted #{data.length} prompts"
  rescue Exception => e
    puts "Failed to insert prompts: #{e}"
  end
rescue Errno::ENOENT => e
  # failed to open file
  puts "Failed to process file: #{e}"
rescue CSV::MalformedCSVError => e
  puts "Failed to parse CSV: #{e}"
rescue CSV::MissingHeadersError => e
  puts "Failed to parse CSV: #{e}"
rescue CSV::IllegalFormatError => e
  puts "Failed to parse CSV: #{e}"
rescue CSV::Row::MissingRowHeaderError => e
  puts "Failed to parse CSV: #{e}"
rescue Exception => e
  puts "Failed to process file: #{e}"
else
  puts "Successfully processed"
ensure
  if File.exist?(csv_path)
    File.delete(csv_path)
    # FileUtils.rm_rf('dir/t o/remove') deletes the directory
    puts "Also, deleted #{csv_path}"
  end
end