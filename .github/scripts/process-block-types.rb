TABLE_DATA = [{
    'type': 'table_row',
    'table_row': {
        'cells': [
            [
                {
                    'type': 'text', 
                    'text': {'content': 'Contributor'},
                },
            ],
            [
                {
                    'type': 'text', 
                    'text': {'content': 'Questions and/or comments'},
                }, 
            ],
            [
                {
                    'type': 'text', 
                    'text': {'content': 'Who asks?'},
                }, 
            ]
        ]
    }
}]

# Function to check if content is a table
def is_table?(content)
  content.include?('|') && content.start_with?('@')
end

# Function to check if content is a heading_2
def is_heading_2?(content)
  content.start_with?('##')
end

# Function to check if content is a file
def is_file?(content)
  content.match(/\!\[.*\]\(.*\)/)
end

# Function to check if content is a link
def is_link?(content)
  content.match(/\[.*\]\(.*\)/)
end

# Process paragraph content
def is_paragraph?(content)
    # Customize the conditions for identifying a paragraph
    !content.start_with?('@') && !content.match(/\[.*\]\(.*\)/) && !content.start_with?('##') && !content.include?("|")
  end

# Process content based on type
def process_content(content)
  case
    when is_table?(content)
        process_table(content, TABLE_DATA)
    when is_heading_2?(content)
        process_heading_2(content)
    when is_file?(content)
        process_file(content)
    when is_link?(content)
        process_link(content)
    when is_paragraph?(content)
        process_paragraph(content)
  end
end

# Process table content
def process_table(content, table_data)
    unless content.include?('Contributors | Questions and/or comments | Who asks?')
        contributors_regex = content.scan(/@([^|\s]+)\s+👩🏻‍💻\s*\|\s*(.*?)\s*\|\s*(.*?)\s*$/)
        contributors_regex.each do |match|
            username, comments, who_asks = match
            table_data.append({
                'type': 'table_row',
                'table_row': {
                    'cells': [
                        [
                            {
                                'type': 'text', 
                                'text': {'content': username},
                            },
                        ],
                        [
                            {
                                'type': 'text', 
                                'text': {'content': comments.strip},
                            }, 
                        ],
                        [
                            {
                                'type': 'text', 
                                'text': {'content': who_asks.strip},
                            }, 
                        ]
                    ]
                }
            })
        end
    end

    return {
        object: 'block',
        type: 'table',
        table: {
        table_width: 3,
        has_column_header: true,
        children: table_data
        }
    }
end

# Process heading_2 content
def process_heading_2(content)
  return {
    object: 'block',
    heading_2: {
      rich_text: [
        {
          text: {
            content: content[2..-1].strip
          }
        }
      ]
    }
  }
end

# Process file content
def process_file(content)
    file_match = content.match(/\!\[(.*)\]\((.*)\)/)
    return {
        object: 'block',
        "type": "file",
        "file": {
            "caption": [{
                "type": "text",
                "text": {
                  "content": file_match[1].strip
                },
              }],
            "type": "external",
            "external": {
                "url": file_match[2].strip
            }
        }
    }
end

# Process link content
def process_link(content)
  link_match = content.match(/\[(.*)\]\((.*)\)/)
  return {
    object: 'block',
    paragraph: {
      rich_text: [
        {
          text: {
            content: link_match[1].strip,
            link: {
              url: link_match[2].strip
            }
          }
        }
      ],
      color: 'default'
    }
  }
end

# Process regular paragraph content
def process_paragraph(content)
  return {
    object: 'block',
    paragraph: {
      rich_text: [
        {
          text: {
            content: content,
          }
        }
      ],
      color: 'default'
    }
  }
end

