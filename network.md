## 의도
max1, spark1, spark2, black은 network switch에 연결되고 

roter를 
enp1s0은 isp에 연결하고 
enp2s0는 network switch에 연결하고
enp3s0는 wifi ap(openwrt)에 연결하려고 해

wifi 는 sanggyun5g, sanggyun2g, sangyun2(iot용) 3개로 하고 
sangyun2는 인터넷을 못가게 하고 싶어
sanggyun5g, sanggyun2g는 주로 노트북, 패드, 핸드폰 에서 쓸거고

max1에는 집안에서 쓰는 service들을 올릴고 jellyfin 같은
roter에는 wireguard vpn을 설치해서
노트북, 패드, 핸드폰이 외부에서 접속할 수 있게 하고 싶어

roter에 dhcp, wireguard 구성하고


### ip 대역
- WAN isp DHCP
- 서버 enp2s0 10.0.10.0/24
- sanggyun5g/2g enp3s0 10.0.20.0/24
- sanggyun2 enp3s0.30(vlan) 10.0.30.0/24
- VPN wg0 10.0.100.0/24
 
### 서버 고정ip
```json
  spark1 = {
    mac = "30:c5:99:3d:cd:df";
    v4 = "10.0.10.11";
  };
  spark2 = {
    mac = "30:c5:99:be:64:a5";
    v4 = "10.0.10.12";
  };
  max1 = {
    mac = "38:05:25:33:dc:fd";
    v4 = "10.0.10.16";
  };
  black = {
    mac = "88:c9:b3:bc:0d:9d";
    v4 = "10.0.10.20";
  };
```

