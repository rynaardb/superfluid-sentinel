resource "aws_efs_file_system" "efs_volume" {
  performance_mode = "generalPurpose"

  creation_token = "sentinel-efs-volume"
  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }
}

resource "aws_efs_mount_target" "ecs_temp_space_az0" {
  file_system_id  = aws_efs_file_system.efs_volume.id
  subnet_id       = aws_subnet.subnet.id
  security_groups = ["${aws_security_group.security-group.id}"]
}
