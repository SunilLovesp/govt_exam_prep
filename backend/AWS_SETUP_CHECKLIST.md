# AWS + MongoDB Atlas Setup Checklist

This machine now has:

- AWS CLI installed
- Elastic Beanstalk CLI installed at `~/Library/Python/3.13/bin/eb`
- `~/.zshrc` updated so new terminals can run `eb`

## 1. Refresh Your AWS Credentials

Your current AWS CLI credentials exist, but AWS rejected them as invalid. Configure fresh credentials using one of these options.

### Option A: IAM Access Key

Run:

```bash
aws configure
```

Enter:

```text
AWS Access Key ID: <from AWS IAM>
AWS Secret Access Key: <from AWS IAM>
Default region name: ap-south-1
Default output format: json
```

Then verify:

```bash
aws sts get-caller-identity
```

### Option B: AWS SSO

Run:

```bash
aws configure sso
aws sso login
```

Then verify:

```bash
aws sts get-caller-identity
```

## 2. Create MongoDB Atlas

1. Open MongoDB Atlas.
2. Create a free/shared cluster.
3. Create a database user.
4. Network Access:
   - For testing: allow `0.0.0.0/0`
   - For production: restrict access later
5. Copy the Node.js connection string.

It should look like:

```text
mongodb+srv://USERNAME:PASSWORD@cluster0.xxxxx.mongodb.net/examprep?retryWrites=true&w=majority
```

## 3. Create S3 Bucket

Create an S3 bucket in `ap-south-1`, for example:

```text
examprep-pyq-files
```

Your Elastic Beanstalk EC2 instance profile needs:

```text
s3:PutObject
s3:GetObject
s3:DeleteObject
```

on:

```text
arn:aws:s3:::YOUR_BUCKET_NAME/*
```

## 4. Initialize Elastic Beanstalk

From the backend folder:

```bash
cd /Users/sp/govt_exam_prep/backend
source ~/.zshrc
eb init examprep-backend --platform node.js --region ap-south-1
```

Create the environment:

```bash
eb create examprep-backend
```

## 5. Set Backend Environment Variables

Replace placeholders:

```bash
eb setenv \
  NODE_ENV=production \
  MONGODB_URI="mongodb+srv://USERNAME:PASSWORD@cluster0.xxxxx.mongodb.net/examprep?retryWrites=true&w=majority" \
  JWT_SECRET="MAKE_A_LONG_RANDOM_SECRET" \
  ADMIN_EMAIL="admin@examprep.com" \
  ADMIN_PASSWORD="MAKE_A_STRONG_PASSWORD" \
  CORS_ORIGIN="*" \
  AWS_REGION="ap-south-1" \
  AWS_S3_BUCKET="YOUR_BUCKET_NAME"
```

## 6. Deploy

```bash
eb deploy
eb open
```

Check:

```bash
curl https://YOUR_BACKEND_URL/api/health
```

## 7. Point Flutter To AWS

Run Flutter with:

```bash
flutter run --dart-define=API_BASE_URL=https://YOUR_BACKEND_URL/api
```

For release builds:

```bash
flutter build apk --dart-define=API_BASE_URL=https://YOUR_BACKEND_URL/api
```
