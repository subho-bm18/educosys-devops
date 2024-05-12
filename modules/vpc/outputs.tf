output "vpc_id" {
  value = aws_vpc.subhodeep_vpc.id
}

output "internal_subnet_ids" {
  value = aws_subnet.internal_subnet.*.id
}

output "external_subnet_ids" {
  value = aws_subnet.external_subnet.*.id
}
