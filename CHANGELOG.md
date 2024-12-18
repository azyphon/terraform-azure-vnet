# Changelog

## [1.1.0](https://github.com/aztfmods/terraform-azure-vnet/compare/v1.0.2...v1.1.0) (2024-12-18)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#8](https://github.com/aztfmods/terraform-azure-vnet/issues/8)) ([761db21](https://github.com/aztfmods/terraform-azure-vnet/commit/761db2129be7db7e745fb0267bfb11858f67cae3))
* **docs:** improve testing documentation with clearer instructions and examples ([#15](https://github.com/aztfmods/terraform-azure-vnet/issues/15)) ([4e1c469](https://github.com/aztfmods/terraform-azure-vnet/commit/4e1c46963cf7fc7143abf4ecbeb0c88e910c32b0))
* refactor tests and makefile and updated documentation ([#9](https://github.com/aztfmods/terraform-azure-vnet/issues/9)) ([b4f7fdd](https://github.com/aztfmods/terraform-azure-vnet/commit/b4f7fdd82ff7c860e8abdc6993f3fd5482b5b0d7))


### Bug Fixes

* ignore inline security rules in network security groups ([#12](https://github.com/aztfmods/terraform-azure-vnet/issues/12)) ([06f8291](https://github.com/aztfmods/terraform-azure-vnet/commit/06f82910b632ae8e3c9ec2c02de30f0e9a967be8))
* prevent race condition in network security group assocations ([#11](https://github.com/aztfmods/terraform-azure-vnet/issues/11)) ([f19229d](https://github.com/aztfmods/terraform-azure-vnet/commit/f19229d026c78bf4e195e3d7a34e2f56776208a0))
* rename subnet cidr property to address_prefixes ([#13](https://github.com/aztfmods/terraform-azure-vnet/issues/13)) ([025062f](https://github.com/aztfmods/terraform-azure-vnet/commit/025062fbb13459ae74e331e5d497d9a55a434182))
* standardize property access using try/coalesce ([#14](https://github.com/aztfmods/terraform-azure-vnet/issues/14)) ([e137d5c](https://github.com/aztfmods/terraform-azure-vnet/commit/e137d5c3ecb7e65145e151b1e22484e3224b424c))

## [1.0.2](https://github.com/aztfmods/terraform-azure-vnet/compare/v1.0.1...v1.0.2) (2024-10-19)


### Bug Fixes

* fix module reference default usage ([#6](https://github.com/aztfmods/terraform-azure-vnet/issues/6)) ([2bdb803](https://github.com/aztfmods/terraform-azure-vnet/commit/2bdb80330997d23ec5d70d44cce98f502d357e4f))

## [1.0.1](https://github.com/aztfmods/terraform-azure-vnet/compare/v1.0.0...v1.0.1) (2024-10-17)


### Bug Fixes

* naming issues ([#4](https://github.com/aztfmods/terraform-azure-vnet/issues/4)) ([41015a5](https://github.com/aztfmods/terraform-azure-vnet/commit/41015a5b20a60f03464c626388bd267e91b43952))

## 1.0.0 (2024-10-16)


### Features

* add initial resources ([d6cd550](https://github.com/aztfmods/terraform-azure-vnet/commit/d6cd550ae5a72f1d1ca93026c5d9590390ba2b69))
* small refactor ([#2](https://github.com/aztfmods/terraform-azure-vnet/issues/2)) ([5044c88](https://github.com/aztfmods/terraform-azure-vnet/commit/5044c88c09600034b125dc9760cb88b8a486cd2f))
