require 'rest-client'
require 'json'
require_relative 'process-block-types'

NOTION_API_ENDPOINT = 'https://api.notion.com/v1/pages'
# NOTION_DATABASE_ID = '8b7bd720c2d043698ecaea9a8d5adb16'
NOTION_DATABASE_ID = '86d77f32e0284be694bcff207a70ad97'
# NOTION_API_TOKEN = 'secret_2fTj1Crwbhou0S0obTBvdvYHrZRf2U7VhlP8oK2FKfx'
NOTION_API_TOKEN = 'secret_ENTu20TKm4Afmkh7WzY2wqZMtZCfSXfSy0qfBgJiAL8'

# Create Notion API headers with integration token
headers = {
    'Content-Type' => 'application/json',
    'Authorization' => "Bearer #{NOTION_API_TOKEN}",
	'Notion-Version' => '2022-06-28'
}

## Read JSON data from a file
#file_path = '.github/scripts/sample_release.json'

## Open and read the file
#github_response = File.read(file_path)

github_response = ARGV[0]
data = JSON.parse(github_response)

# Extract individual fields from the JSON response
release_name = 'Release Notes | ' << data['name']
release_title = ''
release_tag = data['tag_name']
release_description = data['body']
release_created_at = data['created_at']

table_data = [{
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


new_data = {}

# Extracting headings and titles with their content
release_description.scan(/^(#+)\s+(.*?)\s*\n(.*?)(?=(?:^###\s+|^#\s+|\z))/m) do |level, title, content|
  if level == '###'
    new_data[title.strip] = content.strip
elsif level == '##'
	release_title = title.strip
    # Handle # titles if needed
  end
end

# Datatable
## Check what kind of changes have been done in the release
changes = []
unless new_data['New features 🆕'].nil?
	changes.append({ name: 'New features' })
end
unless new_data['Enhancements 🚀'].nil?
	changes.append({ name: 'Enhancements' })
end
unless new_data['Bugs fixed 🐞'].nil?
	changes.append({ name: 'Bugs fixed' })
end

## Check if it's a production or staging release
if release_tag.include?('v')
	url_env = {
		"content": "Hawaii PROD",
		"link": {
			url: 'https://hawaii.buk.cl'
		}
	}	
elsif release_tag.include?('rc')
	url_env = {
		"content": "Hawaii STAGE",
		"link": {
			url: 'https://stag.hawaii.buk.cl/'
		}
	}
end

# Page content
page_content = [
	{
		object: 'block',
		heading_1: {
		  rich_text: [
			{
			  text: {
				content: release_title
			  }
			}
		  ]
		}
	}
]
new_data.each do |heading, content|
	page_content.append({
		object: 'block',
		heading_2: {
		  rich_text: [
			{
			  text: {
				content: heading
			  }
			}
		  ]
		}
	  })
	content_list = content.scan(/(\#\# [^\r\n]+|\[.*?\]\([^\)]+\)|[^\r\n]+)/).flatten

	if content_list.include?('Contributors | Questions and/or comments | Who asks?')
		categorize_item = process_content(content_list[2..-1], table_data)
		unless categorize_item.nil?
			page_content.append(categorize_item)
		end
	else
		content_list.each_with_index do |item, index|
			if item.include?("**Full Changelog**")
				page_content.append(process_divider)
			end
			categorize_item = process_content(item)
			unless categorize_item.nil?
				page_content.append(categorize_item)
			end
		end
	end
end

# Create Notion page
request_body = {
	icon: {
		type: 'emoji',
		emoji: '🗒️'
	},
	parent: {
		type: 'database_id',
		database_id: NOTION_DATABASE_ID
	},
	properties: {
		'Name': {
		id: '',
		title: [
			{
				text: {
					content: release_name
				}
			}
		],
		},
		'Version': {
			type: 'multi_select',
			multi_select: [
				{
				name: release_tag
				},
			]
		},
		'Release date': {
			type: 'date',
			date: {
				"start": release_created_at,
				"end": nil,
				"time_zone": nil
			},
		},
		'Changes': {
			type: 'multi_select',
			multi_select: changes
		},
		'URL': {
			"rich_text": [
				{
				  "type": "text",
				  "text": url_env,
				  "annotations": {
					"bold": true,
					"italic": false,
					"strikethrough": false,
					"underline": false,
					"code": false,
					"color": "default"
				  },
				}
			  ]
		}
	},
	children: page_content
}

begin
response = RestClient.post(NOTION_API_ENDPOINT, request_body.to_json, headers)
# Process the response if successful
rescue RestClient::Unauthorized => e
puts "Authentication failed: #{e.response.body}"
# Handle unauthorized access, e.g., prompt for credentials or refresh tokens
rescue RestClient::BadRequest => e
puts "Bad request error: #{e.response.body}"
rescue RestClient::NotFound => e
puts "Not found error: #{e.response.body}"
end

