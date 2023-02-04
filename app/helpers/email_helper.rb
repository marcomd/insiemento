module EmailHelper
  def email_image_tag(image_name, path: 'app/assets/images', image: nil, binary: nil, size: '100%', style: nil, preview: nil)
    if preview
      if binary
        encoded_content = Base64.encode64(binary)
        image_tag("data:image/png;base64,#{encoded_content}", size:, style:)
      else
        image_tag((image || image_name), size:, style:)
      end
    else
      binary ||=
        if image
          # open(url_for(image)) { |f| f.read }
          image.download
        else
          File.binread(Rails.root.join(path, image_name))
        end
      encoded_content = Base64.encode64(binary)
      # Per rails 4+ potrebbe essere necessario usare il tag data al posto di content
      attachments.inline[image_name] = {
        mime_type: 'image/png',
        encoding: 'base64',
        content: encoded_content,
      }

      image_tag(attachments[image_name].url, size:, style:)
    end
  end
end
