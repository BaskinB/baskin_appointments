<a name="readme-top"></a>

<div align="center">
<br />

<br />
<div align="center">
  <a href="https://github.com/BaskinB/baskin_appointments">

  </a>

  <h1 align="center">Baskin Appointments</h1>

  <p align="center">
    A RedM script Developed by BaskinB!
    <br />
    <a href="#about"><strong>Explore the screenshots »</strong></a>
    <br />
    <br />
    <a href="#installation">Installation</a>
    ·
    <a href="https://github.com/BaskinB/baskin_appointment/issues">Report Bug</a>
    ·
    <a href="https://github.com/BaskinB/baskin_appointment/issues">Request Feature</a>
  </p>
</div>

<!-- [![Project license](https://img.shields.io/github/license/BaskinB/REPO_SLUG.svg?style=flat-square)](LICENSE) -->

[![GitHub contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stars][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPL-3.0 License][license-shield]][license-url]

[![code with love by BaskinB](https://img.shields.io/badge/%3C%2F%3E%20With%20%E2%99%A5%20By-BaskinB-ff1414.svg?style=flat-badge)](https://github.com/BaskinB)

### Built With
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)

</div>

---

<details open="open">
<summary>Table of Contents</summary>

- [About](#about)
- [Acknowledgements](#acknowledgements)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Roadmap](#roadmap)
- [Support](#support)
- [Author](#author)

</details>

## About
A RedM script that seamlessly facilitates the streamlined management of appointments within businesses by enabling the creation of appointments and providing a user-friendly interface thanks to Feather Menu for employees to effortlessly check and manage them.

|                               Showcase                             |
| :-------------------------------------------------------------------: |
| <video src="https://github.com/BaskinB/baskin_appointments/assets/54458253/1575f345-b8a5-450f-bf5d-38208b88f716"> |

<details>
<summary>Screenshots</summary>
<br>

|                               Regular Menu                               |
| :-------------------------------------------------------------------: |
| <img src="https://github.com/BaskinB/baskin_appointments/assets/54458253/3337eeed-7c3b-4000-bcc1-cd5328bbc53a" width="100%"> |
|                               **Employee Menu**                                 |
| <img src="https://github.com/BaskinB/baskin_appointments/assets/54458253/d7c0ab94-9253-4a5d-8861-8ad46fdc431b" width="100%"> |
|                               **Scheduling Menu**                                 |
| <img src="https://github.com/BaskinB/baskin_appointments/assets/54458253/226d2f21-3809-406e-809d-1e47d90c87bc" width="100%"> |
|                               **View Appointments Menu**                                 |
| <img src="https://github.com/BaskinB/baskin_appointments/assets/54458253/d26e6ffa-f2cb-4a16-bde2-985a98947193" width="100%"> |
|                               **View Appointments Menu**                                 |
| <img src="https://github.com/BaskinB/baskin_appointments/assets/54458253/6ec4b566-2d3d-4263-ad5b-a7b0fd8d2b9e" width="100%"> |

</details>



</details>

## Acknowledgements

- Feather Framework for Feather-Menu.
- Bryce Canyon County Scripts for BCC-Utils.
- Fistofury for the Menu Code inspiration.

## Features

1. Ability to Schedule Appointments as configured businesses.
2. Ability to Check/Delete opened Appointments if employed by the Business.
2. Configuration options for the entire script
3. Menu which supports multiple resolutions.
4. Database saving for Appointments
5. VORPCore Support


## Getting Started

### Prerequisites

- [BCC-Utils](https://github.com/BryceCanyonCounty/bcc-utils)
- [Feather Menu](https://github.com/FeatherFramework/feather-menu)
- [Vorp Core](https://github.com/VORPCORE/vorp-core-lua)
- [Vorp Character](https://github.com/VORPCORE/vorp_character-lua)

### Installation


1. Download this repo/release
2. Extract and place `baskin_appointments` into your `resources` folder
3. Add `ensure baskin_appointments` to your `server.cfg` file
4. Run the SQL code for your database.
4. Restart your server

## Usage

The table below explains each configuration option and what

**Base Settings**
 | Options | Description                                | Usage       |
|---------------|--------------------------------------------|-------------|
| defaultLang   | Choose a Language                          | en, fr, etc |
| Year          | Choose what Year is saved to the Timestamp | string      |

**Business Settings**
| Option | Description                               | Usage       |
|---------------|--------------------------------------------|-------------|
| name | Assign a name for the Business, such as the Job Name. | string |
| job | Assign the Job which the appointments belong to. | string |
| location | Assign a location for the menu. | vector3 |

## Roadmap

## Bug Reports

See the [open issues](https://github.com/BaskinB/baskin_appointments/issues) for a list of proposed features (and known issues).

- [Top Feature Requests](https://github.com/BaskinB/baskin_appointments/issues?q=label%3Aenhancement+is%3Aopen+sort%3Areactions-%2B1-desc) (Add your votes using the 👍 reaction)
- [Top Bugs](https://github.com/BaskinB/baskin_appointments/issues?q=is%3Aissue+is%3Aopen+label%3Abug+sort%3Areactions-%2B1-desc) (Add your votes using the 👍 reaction)
- [Newest Bugs](https://github.com/BaskinB/baskin_appointments/issues?q=is%3Aopen+is%3Aissue+label%3Abug)

## Support

Reach out to Baskin here:
- [GitHub issues](https://github.com/BaskinB/baskin_appointments/issues/new?assignees=&labels=question&template=04_SUPPORT_QUESTION.md&title=support%3A+)

## Author

The original setup of this repository is by [BaskinB](https://github.com/BaskinB).

## License

This project is licensed under the **GPL-3.0 license**.

See [LICENSE](LICENSE) for more information.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors-anon/BaskinB/baskin_appointments?style=for-the-badge&color=%2336bf00
[contributors-url]: https://github.com/BaskinB/baskin_appointments/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/BaskinB/baskin_appointments?style=for-the-badge
[forks-url]: https://github.com/BaskinB/baskin_appointments/forks
[forks-shield]: https://img.shields.io/github/forks/BaskinB/baskin_appointments?style=for-the-badge
[forks-url]: https://github.com/BaskinB/baskin_appointments/forks
[stars-shield]: https://img.shields.io/github/stars/BaskinB/baskin_appointments?style=for-the-badge&color=%230377fc
[stars-url]: https://github.com/BaskinB/baskin_appointments/stargazers
[issues-shield]: https://img.shields.io/github/issues/BaskinB/baskin_appointments?style=for-the-badge&color=%23fccf03
[issues-url]: https://github.com/BaskinB/baskin_appointments/issues
[license-shield]: https://img.shields.io/badge/GPL-gpl?style=for-the-badge&label=License
[license-url]: https://github.com/BaskinB/baskin_appointments/blob/main/LICENSE
