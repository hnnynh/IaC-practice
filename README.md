# IaC-practice
IaC practice playground w/Terraform&amp;Ansible

## 사전 설정
- awscli + terraform + ansible 설치
- aws configure로 권한 허용된 사용자 액세스 키 전달

## Terraform
aws 서울 region VPC 구성
- EC2 t2.micro 인스턴스 2개 생성 및 설정
- EC2 인스턴스 public ip 부여
- 서브넷 생성
- Internet Gateway 생성
- Route table 생성 및 Internet Gateway, 서브넷 연결
- 보안그룹 22번 포트 허용

```bash
terraform init 
terraform plan
terraform apply
```

➡️ AWS 리소스 생성 확인

## Ansible
```bash
echo "[webservers]" > hosts.ini
terraform output -json instance_ips | jq -r '.[]' >> hosts.ini

➡️ 

# hosts.ini
[webservers]
<web-0-public-ip>
<web-1-public-ip>
```

설정 파일 작성
1. ansible.cfg - 리소스 접속
2. playbook.yml - 리소스에서 실행할 파일
3. playbook 실행
```ansible-playbook -i hosts.ini playbook.yml```
    ➡️ nginx 설치 + 실행
4. 인스턴스 접속 후 nginx 동작 확인

- [Ansible CLI cheatsheet](https://docs.ansible.com/ansible/latest/command_guide/cheatsheet.html#)
