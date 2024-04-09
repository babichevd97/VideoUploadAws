import boto3
import os

s3 = boto3.client('s3')

def stitch_video(event, context):
    
    bucket_name = 'dev-bucket-upload-video-test'
    key_prefix = 'chunks/directory/'
    chunks = []

    #Count the number of objects that match the chunk naming convention
    num_chunks = len(s3.list_objects_v2(Bucket=bucket_name, Prefix=key_prefix+'chunk_').get('Contents', []))

    for i in range(1, num_chunks + 1):

        key = f'{key_prefix}chunk_{i}'
        response = s3.get_object(Bucket=bucket_name, Key=key)
        chunk_data = response['Body'].read()
        chunks.append(chunk_data)
    
    video_data = b''.join(chunks)

    s3.put_object(Bucket=bucket_name, Key='files/stitched/'+'stitched_photo.JPG', Body=video_data)
 
    return {
        'statusCode': 200,
        'body': 'Video Stitched'
    }