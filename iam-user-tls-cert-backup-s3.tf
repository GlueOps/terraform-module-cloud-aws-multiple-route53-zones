resource "aws_iam_user" "tls_cert_backup_s3" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "tls-cert-backup-s3-${aws_route53_zone.clusters[each.key].name}"
}

resource "aws_iam_user_policy_attachment" "tls_cert_backup_s3" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.tls_cert_backup_s3
  user       = each.value.name
  policy_arn = aws_iam_policy.tls_cert_backup_s3[each.key].arn
  depends_on = [aws_iam_user.tls_cert_backup_s3]
}

resource "aws_iam_access_key" "tls_cert_backup_s3" {
  for_each   = aws_iam_user.tls_cert_backup_s3
  provider   = aws.clientaccount
  user       = each.value.name
  depends_on = [aws_iam_user.tls_cert_backup_s3]
}