# dnsrecords

A simple command-line tool that looks up common DNS record types for a given domain.

## Features

- Looks up multiple DNS record types in one command:
  - A records (IPv4 addresses)
  - AAAA records (IPv6 addresses)
  - MX records (Mail exchange)
  - NS records (Name servers)
  - SOA records (Start of authority)
  - TXT records (Text records)

## Getting started

### Dependencies

- [Zig](https://ziglang.org/) compiler
- `dig` command-line tool

### Installation

Clone this repository and build the binary:

```bash
git clone https://github.com/sanderbongers/dnsrecords.git
cd dnsrecords
zig build
```

To make the tool available system-wide, move the executable to a directory in your PATH:

```bash
cp ./zig-out/bin/dnsrecords /usr/local/bin/
```

## Usage

```bash
dnsrecords <domain>
```

### Example

```
$ dnsrecords example.org
example.org.            298     IN      A       96.7.128.192
example.org.            298     IN      A       23.215.0.132
example.org.            298     IN      A       23.215.0.133
example.org.            298     IN      A       96.7.128.186
example.org.            124     IN      AAAA    2600:1408:ec00:36::1736:7f2f
example.org.            124     IN      AAAA    2600:1406:bc00:17::6007:810d
example.org.            124     IN      AAAA    2600:1406:bc00:17::6007:8128
example.org.            124     IN      AAAA    2600:1408:ec00:36::1736:7f2e
example.org.            47870   IN      NS      a.iana-servers.net.
example.org.            47870   IN      NS      b.iana-servers.net.
example.org.            3600    IN      SOA     ns.icann.org. noc.dns.icann.org. 2025011583 7200 3600 1209600 3600
example.org.            70857   IN      MX      0 .
example.org.            86400   IN      TXT     "_uyh0vgv5ukyofwj3ddwspnni01vmlyy"
example.org.            86400   IN      TXT     "v=spf1 -all"
```

## Author

[Sander Bongers](https://github.com/sanderbongers)

## License

This project is licensed under the terms of the MIT license
