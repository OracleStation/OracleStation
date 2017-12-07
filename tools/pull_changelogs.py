import requests, dateutil.parser

issue_url = "https://api.github.com/repos/OracleStation/OracleStation/pulls?state=closed&page="

#for page in range(1, 1):
page = 1
response = requests.get(issue_url + str(page))

data_structure = []

def parse_issue(pull_request):

	body_split = pull_request["body"].split(":cl:")
	if(len(body_split) != 3):
		return

	date = dateutil.parser.parse(pull_request["merged_at"])
	print("{0}-{1}-{2}:".format(date.year, date.month, date.day))

	body_full = body_split[1][:-1]

	changes = body_full.split("\n")
	author = changes.pop(0).strip()
	print("  {0}:".format(author))

	for change in changes:
		change_split = change.split(":")
		if (len(change_split) < 2):
			continue

		change_tag = change_split[0].strip()
		change_label = ":".join(change_split).strip()

		print("  - {0}: {1}".format(change_tag, change_label))

for pull_request in response.json():
	if(pull_request["merged_at"] != None):
		parse_issue(pull_request)
