# Changelog

## [1.4.0](https://github.com/azyphon/terraform-azure-vnet/compare/v1.3.0...v1.4.0) (2025-03-10)


### Features

* adjusted files to reflect org change ([#24](https://github.com/azyphon/terraform-azure-vnet/issues/24)) ([0caf463](https://github.com/azyphon/terraform-azure-vnet/commit/0caf4631a079376d121422f4d738bac59ac0c605))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#21](https://github.com/azyphon/terraform-azure-vnet/issues/21)) ([c280f8c](https://github.com/azyphon/terraform-azure-vnet/commit/c280f8c6b248afcd660f587d770bde51855a3c39))
* **testing:** add extended destroy functionality in makefile and tests ([#22](https://github.com/azyphon/terraform-azure-vnet/issues/22)) ([8e9d5a5](https://github.com/azyphon/terraform-azure-vnet/commit/8e9d5a512f639439272a6dd0e67ab6842b192a41))
* trigger workflow2 ([#27](https://github.com/azyphon/terraform-azure-vnet/issues/27)) ([dc423c8](https://github.com/azyphon/terraform-azure-vnet/commit/dc423c80ecb8c0165fb7fc00ef7fe853f25804a7))

## [1.3.0](https://github.com/aztfmods/terraform-azure-vnet/compare/v1.2.0...v1.3.0) (2024-12-19)


### Features

* **tests:** encapsulated config and use constants and updates module sources to use registry in usages ([#20](https://github.com/aztfmods/terraform-azure-vnet/issues/20)) ([dc3e632](https://github.com/aztfmods/terraform-azure-vnet/commit/dc3e6327db9a3523cbdbdc7c4050ae058c8f9418))
* **validation:** add more validation that ensures subnet address prefixes are within the vnet address space and nsg rules have unique priorities ([#18](https://github.com/aztfmods/terraform-azure-vnet/issues/18)) ([745e27c](https://github.com/aztfmods/terraform-azure-vnet/commit/745e27c32f9f86a3953aabea185938a07d542ec9))

## [1.2.0](https://github.com/aztfmods/terraform-azure-vnet/compare/v1.1.0...v1.2.0) (2024-12-18)


### Features

* **docs:** move goals and non-goals to a separate file ([#16](https://github.com/aztfmods/terraform-azure-vnet/issues/16)) ([e2fcd56](https://github.com/aztfmods/terraform-azure-vnet/commit/e2fcd5620bae69e62fef02f1e63f6b49f2e6a726))

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
