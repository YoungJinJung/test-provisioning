# S3 Bucket for storing contents
resource "aws_s3_bucket" "self_introduce" {
 bucket = "self-introduce-youngjin"
}

resource "aws_s3_bucket_public_access_block" "self_introduce" {
 bucket = aws_s3_bucket.self_introduce.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}

resource "aws_s3_bucket_cors_configuration" "self_introduce" {
 bucket = aws_s3_bucket.self_introduce.id

 cors_rule {
   allowed_headers = ["*"]
   allowed_methods = ["GET", "HEAD"]
   allowed_origins = ["*"]
   expose_headers  = ["ETag"]
   max_age_seconds = 3000
 }
}

resource "aws_s3_bucket_versioning" "self_introduce" {
 bucket = aws_s3_bucket.self_introduce.id
 versioning_configuration {
   status = "Enabled"
 }
}

resource "aws_s3_bucket_accelerate_configuration" "self_introduce" {
 bucket = aws_s3_bucket.self_introduce.id
 status = "Enabled"
}

resource "aws_s3_bucket_policy" "self_introduce" {
 bucket = aws_s3_bucket.self_introduce.id
 policy = data.aws_iam_policy_document.self_introduce.json
}

data "aws_iam_policy_document" "self_introduce" {
 statement {
   principals {
     type        = "Service"
     identifiers = ["cloudfront.amazonaws.com"]
   }

   condition {
     test     = "StringEquals"
     variable = "AWS:SourceArn"
     values = [
       aws_cloudfront_distribution.cdn_distribution.arn,
     ]
   }

   actions   = ["s3:GetObject"]
   resources = ["${aws_s3_bucket.self_introduce.arn}/*"]
 }
}

resource "aws_s3_bucket_lifecycle_configuration" "self_introduce" {
 bucket = aws_s3_bucket.self_introduce.id

 rule {
   id     = "self_introduce_rule"
   status = "Enabled"

   filter {
     prefix = ""
   }

   transition {
     days          = 30
     storage_class = "STANDARD_IA"
   }
 }
}

resource "aws_cloudfront_origin_access_control" "cdn_contents" {
 name                              = "cdn-contents"
 origin_access_control_origin_type = "s3"
 signing_behavior                  = "always"
 signing_protocol                  = "sigv4"
}

# Cloudfront Distribution
resource "aws_cloudfront_distribution" "cdn_distribution" {
 origin {
   domain_name              = aws_s3_bucket.self_introduce.bucket_regional_domain_name
   origin_id                = "self_intro_origin"
   origin_access_control_id = aws_cloudfront_origin_access_control.cdn_contents.id
 }

 enabled         = true
 is_ipv6_enabled = true
 comment         = "Cloudfront configuration for cdn"
 http_version    = "http2and3"

 # Default Cache behavior
 default_cache_behavior {
   allowed_methods  = ["GET", "HEAD", "OPTIONS"]
   cached_methods   = ["GET", "HEAD"]
   target_origin_id = "self_intro_origin"
   compress         = true

   # Use managed cache policy instead of deprecated forwarded_values
   cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized

   viewer_protocol_policy = "redirect-to-https"
 }

 viewer_certificate {
   cloudfront_default_certificate = true
 }

 # List of Custom Cache behavior
 # This behavior will be applied before default
 ordered_cache_behavior {

   path_pattern = "*.gif"

   allowed_methods  = ["GET", "HEAD"]
   cached_methods   = ["GET", "HEAD"]
   target_origin_id = "self_intro_origin"
   compress         = false

   viewer_protocol_policy = "redirect-to-https"
   
   # Use managed cache policy for custom behavior
   cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Managed-CachingDisabled
 }

 restrictions {
   geo_restriction {
     restriction_type = "none"
   }
 }

 # You can set custom error response
 custom_error_response {
   error_caching_min_ttl = 5
   error_code            = 404
   response_code         = 404
   response_page_path    = "/404.html"
 }

 custom_error_response {
   error_caching_min_ttl = 5
   error_code            = 500
   response_code         = 500
   response_page_path    = "/500.html"
 }

 custom_error_response {
   error_caching_min_ttl = 5
   error_code            = 502
   response_code         = 502
   response_page_path    = "/500.html"
 }

 # Tags of cloudfront
 tags = {
   Name = "cdn-contents without domain"
 }
}

