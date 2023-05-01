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
    puts "Successfully inserted #{data.length} prompts"
    # FileUtils.rm_rf('dir/to/remove') deletes the directory
    File.delete(csv_path) # Delete just the csv seed file
    puts "Successfully deleted #{csv_path}"
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
rescue StandardError => e
  puts "Failed to process file: #{e}"
else
  puts "Successfully processed file"
end