#!/usr/bin/env fish

function convert_mpeg_to_mp4
    set src_dir $argv[1]
    set dest_dir $argv[2]

    if not test -d "$src_dir"
        echo "Source directory does not exist."
        return 1
    end

    if not test -d "$dest_dir"
        mkdir -p "$dest_dir"
    end

    # Find .mpeg and .mpg files
    for file in (find $src_dir -type f \( -iname '*.mpeg' -o -iname '*.mpg' \))
	echo "Found $file"
        # Compute relative path
        set rel_path (string replace -- "$src_dir/" "" "$file")

        # Remove original extension and add .mp4
        set rel_dir (dirname "$rel_path")
        set base_name (basename "$file" | sed 's/\.[^.]*$//')
        set output_dir "$dest_dir/$rel_dir"
        set output_file "$output_dir/$base_name.mp4"

        # Create destination directory if needed
        mkdir -p "$output_dir"

        # Convert the file
        echo "Converting: $file -> $output_file"
        ffmpeg -i "$file" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 128k "$output_file"
    end
end

convert_mpeg_to_mp4 $argv

# Example usage:
# convert_mpeg_to_mp4 /path/to/source /path/to/destination

