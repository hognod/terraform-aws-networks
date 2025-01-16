# networks.csv

`vpc_name` 항목과 `vpc_cidr` 항목은 세트로 지정되어야 하며 서로 다른 세트 값마다 새로운 VPC가 생성된다.

| vpc_name |   vpc_cidr   |
| :------: | :----------: |
|  Test1   | 10.0.0.0/16  |
|  Test1   | 10.0.0.0/16  |
|  Test2   | 10.10.0.0/16 |
|  Test3   | 10.20.0.0/16 |

위 예시의 경우 `vpc_name`과 `vpc_cidr`의 값이 페어로 이루어져 3종류의 vpc가 생성되게 된다.


* `enable`: 인프라의 부분 생성 및 삭제 Flag. `true`로 지정된 값만 생성한다.

* `vpc_name`: 생성하려는 VPC 마다 **독립된 값을 지정**해야한다. 지정한 값을 기준으로 Network 리소스들의 Tag Name이 지정된다.
    * `vpc`: <vpc_name>-vpc
    * `subnet`: <vpc_name>-<subnet_type>-subnet-<availability_zone>

* `vpc_cidr`: 생성하려는 VPC 마다 **독립된 값을 지정**해야한다. 지정한 값에 맞게 vpc에 cidr를 할당한다.
* `type`: `public`, `private` 중 선택
* `subnet_cidr`: 생성하려는 Subnet 마다 **독립된 값을 지정**해야한다. `vpc_cidr`에 속한 범위 내에서 지정해야 한다.
* `availability_zone`: `ap-northeast-2a`, `ap-northeast-2b`, `ap-northeast-2c`, `ap-northeast-2d` 중 선택
