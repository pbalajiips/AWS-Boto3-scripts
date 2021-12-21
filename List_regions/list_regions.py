import boto3
client = boto3.client("ec2")

# To get list of opt-in regions
response = client.describe_regions( 
    Filters=[{
        'Name': 'opt-in-status',
        'Values': ['opt-in-not-required', 'opted-in']
    },
    ],
    AllRegions=True )
for region in response["Regions"]:
    print(region["RegionName"])

