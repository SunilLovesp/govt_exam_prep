# AWS Backend Deployment

This backend is ready for AWS Elastic Beanstalk with MongoDB Atlas and S3.

## 1. Create MongoDB Atlas

Create a MongoDB Atlas cluster, database user, and connection string:

```text
mongodb+srv://USERNAME:PASSWORD@cluster.mongodb.net/examprep?retryWrites=true&w=majority
```

For first testing, allow network access from `0.0.0.0/0`. Lock this down later.

## 2. Create S3 Bucket

Create an S3 bucket for previous-year-paper PDFs, for example:

```text
examprep-pyq-files
```

Give the Elastic Beanstalk EC2 instance profile permission for:

```text
s3:PutObject
s3:GetObject
s3:DeleteObject
```

on:

```text
arn:aws:s3:::YOUR_BUCKET_NAME/*
```

## 3. Deploy With Elastic Beanstalk CLI

Install EB CLI:

```bash
pip install awsebcli
```

From this folder:

```bash
cd /Users/sp/govt_exam_prep/backend
eb init
```

Choose:

```text
Region: ap-south-1
Platform: Node.js
```

Create the environment:

```bash
eb create examprep-backend
```

Set production environment variables:

```bash
eb setenv \
  NODE_ENV=production \
  MONGODB_URI="mongodb+srv://USERNAME:PASSWORD@cluster.mongodb.net/examprep?retryWrites=true&w=majority" \
  JWT_SECRET="REPLACE_WITH_A_LONG_RANDOM_SECRET" \
  ADMIN_EMAIL="admin@examprep.com" \
  ADMIN_PASSWORD="REPLACE_WITH_A_STRONG_PASSWORD" \
  CORS_ORIGIN="*" \
  AWS_REGION="ap-south-1" \
  AWS_S3_BUCKET="YOUR_BUCKET_NAME"
```

Deploy:

```bash
eb deploy
```

Open:

```bash
eb open
```

Check:

```bash
curl https://YOUR_BACKEND_URL/api/health
```

## 4. Update Flutter App

Set the API base URL in:

```text
/Users/sp/govt_exam_prep/lib/core/constants/app_config.dart
```

Example:

```dart
static const String baseUrl = 'https://YOUR_BACKEND_URL/api';
```

## Notes

- Do not upload `.env` to AWS. Elastic Beanstalk environment variables replace it.
- Prefer IAM roles over `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` on AWS.
- Change `CORS_ORIGIN=*` to your real admin/mobile web origin before production.
