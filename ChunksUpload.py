from flask import Flask, request, jsonify
import boto3
from io import BytesIO

app = Flask(__name__)

# Initialize S3 client
s3 = boto3.client('s3',region_name='eu-central-1')
# Initialize  SQS client
sqs = boto3.client('sqs',region_name='eu-central-1')
bucket_name = 'dev-bucket-upload-video-test'


@app.route('/uploadChunks', methods=['POST']) #First method. Devides file to chunks and loads it
def upload_video():
    # Retrieve the video file from the request
    video_file = request.files['file']
    
    # Define chunk size
    chunk_size = 1024 * 1024
    key_prefix = 'chunks/directory/'
    
    chunk_num = 1
    while True:
        chunk_data = video_file.read(chunk_size)
        if not chunk_data:
            break 
        
        # Upload chunks to S3
        key = f'{key_prefix}chunk_{chunk_num}'
        s3.upload_fileobj(BytesIO(chunk_data), bucket_name, key)
        
        chunk_num += 1
    
    return jsonify({'message': f'Video uploaded in {chunk_num-1} chunks'}), 200


@app.route('/sendMessage', methods=['POST']) #Secind method. Send chunks to sqs
def upload_message_sqs():
    queue_url = sqs.get_queue_url(QueueName='start_upload')['QueueUrl']
    # Send the message to the queue
    response = sqs.send_message(QueueUrl=queue_url,MessageBody="Start stiching!")

    return jsonify({'message': f'Message sent!'}), 200 

if __name__ == '__main__':
    app.run(port=8181, debug=True)