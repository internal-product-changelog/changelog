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

# Read JSON data from a file
file_path = '.github/scripts/sample_release.json'

# Open and read the file
github_response = File.read(file_path)

# github_response = ARGV[0]
data = JSON.parse(github_response)

# Extract individual fields from the JSON response
release_name = data['name']
release_tag = data['tag_name']
release_description = data['body']
release_created_at = data['created_at']

new_data = {}

# Extracting headings and their content
release_description.scan(/^#\s+(.*?)\s*\n(.*?)(?=(?:^#\s+|\z))/m) do |heading, content|
	puts heading, content
  	new_data[heading.strip.downcase] = content.strip
end

puts new_data

# Extract information from the release data
# new_features = sections[0] || ''
# new_features_details = sections[1] || ''
# enhancements = sections[2] || ''
# enhancements_details = sections[3] || ''
# fixed_bugs = sections[4] || ''
# fixed_bugs_details = sections[5] || ''
# notes = sections[6] || ''
# notes_details = sections[7] || ''
# contributors = sections[8] || ''
# contributors_details = sections[9] || ''

# Datatable
changes = []
if 'New feature' in release_description
	changes.append({ name: 'New features' })
elsif 'Enhancement' in release_description
	changes.append({ name: 'Enhancements' })
elsif 'Bug fixed' in release_description
	changes.append({ name: 'Bugs fixed' })
end

# Page content
page_content = []
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
	page_content.append({
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
	})
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
		}
	},
	children: page_content
}

puts request_body

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

