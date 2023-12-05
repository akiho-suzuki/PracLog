# PracLog

PracLog is a free, open-source app designed to track musicians' practice sessions by [Akiho Suzuki](https://akihosuzuki.com).

If you have any questions or would like to contribute, please email me at [prac.log.app@gmail.com](mailto:prac.log.app@gmail.com).

### For musicians
PracLog is a practice diary app. It allows musicians to plan and monitor their practice by setting goals, tracking how long they practise for, and rating practice sessions. The app provides weekly and monthly summaries of practice sessions through stats and graphs.

### For researchers
PracLog was originally developed for a research project looking at how conservatoire piano students practise. It is therefore designed with researchers' needs in mind.

The content of the app is loosely based on the three-phase cyclical model of self-regulated learning (SRL; [Zimmerman, 2000](https://doi.org/10.1016/B978-012109890-2/50031-7)). Users input data in three separate screens corresponding to the three phases of SRL: forethought (before the practice session), performance (during the practice session), and self-reflection (after the practice session).

The app allows the user to export data for specified dates, making it easy to access and analyse data. The data is exported as a json file. I am planning to write and publish an accompanying python script that transforms the json files into tidy dataframes that can easily be imported to softwares like RStudio and SPSS for analysis.

### For developers
PracLog was created using [Flutter](https://flutter.dev/), a cross-platform app development framework written in Dart. The app uses [Isar](https://isar.dev/) as the backend. All data is stored locally on the device.

## Future features
- [ ] Import data function: this would allow users to export data to back it up then restore it (e.g. when user gets a new phone)