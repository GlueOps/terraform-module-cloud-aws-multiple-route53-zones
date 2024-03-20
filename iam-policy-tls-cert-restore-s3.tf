resource "aws_iam_policy" "tls_cert_restore_s3" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "tls-cert-restore-s3-${aws_route53_zone.clusters[each.key].name}"
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject*",
        "s3:List*",
        "s3:ListBucket*"
      ],
      "Resource": [
        "${module.common_s3.primary_s3_bucket_arn}/${aws_route53_zone.clusters[each.key].name}/tls-cert-backups/*",
        "${module.common_s3.replica_s3_bucket_arn}/${aws_route53_zone.clusters[each.key].name}/tls-cert-backups/*"
      ]
    }
  ]
}
EOF
}
