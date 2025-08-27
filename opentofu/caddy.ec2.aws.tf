# data "aws_ami" "debian" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["debian-13-amd64-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["136693071363"] # Debian
# }

# resource "aws_instance" "caddy" {
#   ami           = data.aws_ami.debian.id
#   instance_type = "t3.nano"
#   key_name      = aws_key_pair.caddy.key_name

#   tags = {
#     Name = "caddy"
#   }

#   depends_on = [aws_key_pair.caddy]
# }

# resource "aws_key_pair" "caddy" {
#   key_name   = "caddy-zuedev"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0kwVbA9ZdXOAuiyPeXsJ7HSujPtCIYtFPl2GdajHDT0SwsZDUMNr/p6Y9DyQjOI1zqD73ndGSOIe6EY7adB3L6ZSODvDwFlGMtP5sXE0UESOcJJdU7m4wHWieM3xal5nz1Y2BJyp2x04Ol5+kpak9A4MqUcHz29Z4ubgPG/UUWENoKZIfHXSCZfvJBO82InrvieAu/dpKzmtkXNJ9bP+fSkiNnCOVo+ZvCbIuZm8tOoQIhshzdeVhfNmdUj9LNErkoGoJ+CA13eXYlqT9B8o45E+M8lLxQr/RpzCk/3likszBzVqITB6Vkrvey8BcHhcbrs+5LYbxvb6s+1bsRHNAwO+w7SgrD3eX8AQqFKvb6xzrFji+996NWSC2hVLcKZyDvSM2p6ws4IDLFLD64IS+73SEZv2fN847j0vmqJqXYPpB/jQKuUG+rWeonkDXBfPjFrHtp75nk5bSBBDi+LQBGW52nz6/gtOWP46USV46BW2zF+YFSyw/2Ta7DMhrvXlLWuDV/CpK0FytpHjQWjHoiDfrZfiDAOu8sPIiH7hjZevHqzNJ+xOZDNqNbYqxxB1gLeK4u6xX9c4Jkk259r09tMutFACbzxxPQr3LYBKW8IrPcX1rfuE4+aZ1UysfjG/2FmKOPeWca9tVSQUK7RSThvzWDGdm0gXxI0HrPwmfZQ=="
# }

# resource "aws_security_group" "caddy-ssh" {
#   name        = "allow_ssh"
#   description = "Allow SSH inbound traffic"

#   ingress {
#     description      = "SSH"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_network_interface_sg_attachment" "caddy" {
#   security_group_id    = aws_security_group.caddy-ssh.id
#   network_interface_id = aws_instance.caddy.primary_network_interface_id

#   depends_on = [
#     aws_instance.caddy,
#     aws_security_group.caddy-ssh
#   ]
# }
