import boto3
import os

def delete_txt_files(bucket_name):
    s3 = boto3.client('s3')
    
    # List all objects in the bucket
    response = s3.list_objects_v2(Bucket=bucket_name)

    # Loop through the objects and delete .txt files
    if 'Contents' in response:
        for item in response['Contents']:
            key = item['Key']
            if key.endswith('.txt'):
                print(f"Deleting file: {key}")
                s3.delete_object(Bucket=bucket_name, Key=key)
                print(f"Deleted {key}")

    print("Deletion process complete.")

def lambda_handler(event, context):
    # Read bucket name from environment variable
    bucket_name = os.getenv('S3_BUCKET_NAME')

    if bucket_name:
        delete_txt_files(bucket_name)
    else:
        print("S3_BUCKET_NAME environment variable is not set.")
