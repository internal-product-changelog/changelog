require 'rest-client'
require 'json'

NOTION_API_ENDPOINT = 'https://api.notion.com/v1/pages'
NOTION_DATABASE_ID = '8b7bd720c2d043698ecaea9a8d5adb16'
NOTION_API_TOKEN = 'secret_2fTj1Crwbhou0S0obTBvdvYHrZRf2U7VhlP8oK2FKfx'

# Create Notion API headers with integration token
headers = {
    'Content-Type' => 'application/json',
    'Authorization' => "Bearer #{NOTION_API_TOKEN}",
	'Notion-Version' => '2022-06-28'
}

github_response = ARGV[0]
data = JSON.parse(github_response)
puts data
print data

# Extract individual fields from the JSON response
release_name = data['name']
release_tag = data['tag_name']
release_description = data['body']
release_created_at = data['created_at']

# Splitting the string into an array of sections based on '#'
sections = release_description.split(/\n#/)

# Displaying each section
sections.each do |section|
  puts section.strip  # Using strip to remove leading/trailing whitespaces
end

# Extract information from the release data
title = sections[1] || ''
# new_features = data['new_features'] || ''
# enhancements = data['enhancements'] || ''
# fixed_bugs = data['fixed_bugs'] || ''
# notes = data['notes'] || ''
# contributors = data['contributors'] || ''
puts title


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
			multi_select: [
				{
				name: 'New feature'
				},
				{
				name: 'Enhancement'
				},
				{
				name: 'Bug fixed'
				}
			]
		}
	},
	children: [
		{
		object: 'block',
		heading_2: {
			rich_text: [
			{
				text: {
				content: ""
				}
			}
			]
		}
		},
		{
		object: 'block',
		paragraph: {
			rich_text: [
			{
				text: {
				content: "",
				}
			}
			],
			color: 'default'
		}
		},
		{
			object: 'block',
			heading_2: {
			rich_text: [
				{
				text: {
					content: ""
				}
				}
			]
			}
		},
		{
			object: 'block',
			paragraph: {
			rich_text: [
				{
				text: {
					content: "",
				}
				}
			],
			color: 'default'
			}
		},
		{
			object: 'block',
			heading_2: {
			rich_text: [
				{
				text: {
					content: ""
				}
				}
			]
			}
		},
		{
			object: 'block',
			paragraph: {
			rich_text: [
				{
				text: {
					# content: "\n\n#{release_data['notes']}\n\n#{release_data['contributors']}",
					content: release_description
				}
				}
			],
			color: 'default'
			}
		}
	]
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

