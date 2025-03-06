# Source code for: Experimental study on cement paste using the ultrasonic pulse transmission method

## Abstract

This file describes how to reproduce the analysis results presented in section *Technical Validation* of the accompanying manuscript titled: **Experimental study on cement paste using the ultrasonic pulse transmission method**.


## Table of contents

- [License](#license)
- [Prerequisites](#prerequisites)
- [Directory and file structure](#directory-and-file-structure)
- [Installation instructions](#installation-instructions)
- [Usage instructions](#usage-instructions)
- [Help and Documentation](#help-and-documentation)
- [Related data sources](#related-data-sources)
- [Related software](#related-software)
- [Revision and release history](#revision-and-release-history)


## License

Copyright 2025 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)

This file is part of the PhD thesis of Jakob Harden.

All GNU Octave function files (\*.m) and the file */tex/oct2texdefs.tex* are licensed under the *MIT* license. See also licence information file "LICENSE".

All other files (\*.md, \*.html, \*.tex, \*.oct, \*.ofig, \*.png) are licensed under the *Creative Commons Attribution 4.0 International* license. See also: [CC BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.en)


## Prerequisites

As a prerequisite, *GNU Octave 6.2.0* (or a more recent version) need to be installed. *GNU Octave* is available via the package management system on many Linux distributions. For *Microsoft Windows* or *MacOS* users it is suggested to download the Windows or MacOS version of GNU Octave and to install the software manually. See also: [GNU Octave download](https://octave.org/download)


## Directory and file structure

All GNU Octave script files (\*.m) are written in the scientific programming language of *GNU Octave 6.2.0*. All LaTeX files (\*.tex) are written with compliance to *TeXlive* version 2020.20210202-3. Text files (\*.m, \*.tex) are generally encoded in UTF-8.

### Overview of the directory structure

```
anadd-1.0.0    
├── results    
│   ├── bin    
│   └── tex    
├── struct    
│   ├── README.html    
│   ├── README.md    
│   ├── struct_objattrib.m    
│   ├── struct_objdata.m    
│   └── struct_objref.m    
├── tex    
│   ├── oct2texdefs.tex    
│   ├── README.html    
│   ├── README.md    
│   ├── tex_def_csvarray.m    
│   ├── tex_def_dotarray.m    
│   ├── tex_def_scalar.m    
│   ├── tex_def_tabarray.m    
│   ├── tex_def_tabmatrix.m    
│   ├── tex_serialize.m    
│   ├── tex_settings.m    
│   ├── tex_struct_export.m    
│   ├── tex_struct.m    
│   ├── tex_struct_objattrib.m    
│   ├── tex_struct_objdata.m    
│   └── tex_struct_objref.m    
├── anadd_analyse.m    
├── anadd_dsdefs.m    
├── anadd_init.m    
├── anadd_param.m    
├── LICENSE    
├── README.html    
└── README.md    
```

### Brief description of files and folders

- **anadd-1.0.0** ... main program directory
  - *anadd\_analyse.m* ... function file, analysis procedure (MIT license)
  - *anadd\_dsdefs.m* ... function file, data set information and organization (MIT license)
  - *anadd\_init.m* ... function file, program initialization (MIT license)
  - *anadd\_param.m* ... function file, analysis parameter definitions (MIT license)
  - *LICENSE* ... license information file for "the MIT license"
  - *README.html* ... file, HTML version of *./README.md*
  - *README.md* ... this file, information about the program
- **anadd-1.0.0/results** ... directory, analysis results (CC BY-4.0 license)
- **anadd-1.0.0/results/bin** ... directory, binary output files, data and figures (\*.oct, \*.ofig, \*.png)
- **anadd-1.0.0/results/tex** ... directory, LaTeX code files, data (\*.tex)
- **anadd-1.0.0/struct** ... directory, data structure building tools (MIT license)
  - *README.html* ... file, HTML version of *./struct/README.md*
  - *README.txt* ... file, additional information about the directory content
  - *struct\_objattrib.m* ... function file, create attribute object (atomic attribute element, AAE)
  - *struct\_objdata.m* ... function file, create data object (atomic data element, ADE)
  - *struct\_objref.m* ... function file, create reference object (atomic reference element, ARE)
- **anadd-1.0.0/tex** ... directory, data structure TeX file export tools (MIT license)
  - *oct2texdefs.tex* ... file, LaTeX commands to use the data exported from GNU Octave data structures
  - *README.html* ... file, HTML version of *./tex/README.md*
  - *README.md* ... file, additional information about the directory content
  - *tex\_def\_csvarray.m* ... function file, serialize array variable to TeX code (comma-separated list, e.g. version numbers)
  - *tex\_def\_dotarray.m* ... function file, serialize short array variable to TeX code (dot-separated list, e.g. structure path)
  - *tex\_def\_scalar.m* ... function file, serialize scalar value to TeX-code
  - *tex\_def\_tabarray.m* ... function file, serialize array value to TeX-code (tabulated)
  - *tex\_def\_tabmatrix.m* ... function file, serialize matrix value to TeX code (tabulated)
  - *tex\_serialize.m* ... function file, serialize single value of various data types
  - *tex\_settings.m* ... function file, create data structure containing the TeX-code serialization settings
  - *tex\_struct\_export.m* ... function file, export data structure(s) to TeX-code files
  - *tex\_struct.m* ... function file, serialize data structure(s) to TeX-code
  - *tex\_struct\_objattrib.m* ... function file, serialize atomic attribute element to TeX-code
  - *tex\_struct\_objdata.m* ... function file, serialize atomic data element to TeX-code
  - *tex\_struct\_objref.m* ... function file, serialize atomic reference element to TeX-code


## Installation instructions

### Data set installation

1. Download the dataset records (see section **Related data sources**) from the repository and move them to a directory of your choice. e.g. **/home/acme/science/data/*\_dataset.tar.xz**
2. Extract datasets from the TAR archives using *GNU tar*. For *Microsoft Windows* users it is suggested to use *7-zip* instead.

```
bash: $ tar -xzf ts1_datasets.tar.xz
```

The expected outcome is to have all datasets (\*.oct files) in the directories of the respective test series.

```
home    
└── acme    
    └── science    
        └── data    
            ├── ts5_dataset    
            │   └── *.oct    
            ├── ts6_dataset    
            │   └── *.oct    
            └── ts7_dataset    
                └── *.oct    
```

  > [!NOTE]
  > *7-zip* is available online. [7-zip download](https://www.7-zip.org/download.html)


### Analysis script installation

1. Download the record containing the analysis code from the repository and move it to a directory of your choice. e.g. **/home/acme/science**   
2. Decompress analysis code from the ZIP archive **anadd-1.0.0.zip**. e.g. **/home/acme/science/anadd-1.0.0**   
3. Run GNU Octave.   
4. Make the program directory **/home/acme/science/anadd-1.0.0** the working directory.   
5. Adjust the variables 'r\_ds.paths.dssrc', 'r\_ds.paths.ts5oct', 'r\_ds.paths.ts6oct' and 'r\_ds.paths.ts7oct' in function file **/home/acme/science/anadd-1.0.0\_param.m**. They have to point to the actual location of the folders containing the previously extracted datasets (\*.oct) of the respective test series.    

```
    anadd_param.m:  ...    
    anadd_param.m:  r_ds.paths.dssrc = '/home/acme/data'; # data source path    
    anadd_param.m:  r_ds.paths.ts5oct = 'ts5_dataset'; # test series 5 dataset directory    
    anadd_param.m:  r_ds.paths.ts6oct = 'ts6_dataset'; # test series 6 dataset directory    
    anadd_param.m:  r_ds.paths.ts7oct = 'ts7_dataset'; # test series 7 dataset directory    
    anadd_param.m:  ...    
```

## Usage instructions

1. Open GNU Octave.   
2. Initialize program.   
3. Run analysis.   


### Initialize program (command line interface)

The *anadd\_init* function initializes the program. The initialization must be run once before executing all the other functions. The command is adding the subdirectories included in the main program directory to the 'path' environment variable. This function also creates the analysis result output directory *./results* and the subdirectories *bin* and *tex*.

```
    octave: >> anadd_init();   
```


### Run analysis (command line interface)

The *anadd\_analyse* function compiles the analysis results and writes them to the aforementioned result directory. This function also plots the analysis results and displays them on the screen.

```
    octave: >> anadd_analyse();    
```


## Help and Documentation

All function files contain an adequate function description and instructions on how to use the functions. The documentation can be displayed in the GNU Octave command line interface by entering the following command:

```
    octave: >> help function_file_name;    
```


## Related data sources

Datasets whos content can be analyzed and plotted with this scripts are made available at the repository of *Graz University of Technology* under the *Creative Commons Attribution 4.0 International* license. The data records enlisted below contain the raw data, the compiled datasets and a technical description of the record content.


### Data records

- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 1, Cement Paste at Early Stages". Graz University of Technology. doi: [10.3217/bhs4g-m3z76](https://doi.org/10.3217/bhs4g-m3z76)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 5, Reference Tests on Air". Graz University of Technology. doi: [10.3217/bjkrj-pg829](https://doi.org/10.3217/bjkrj-pg829)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 6, Reference Tests on Water". Graz University of Technology. doi: [10.3217/hn7we-q7z09](https://doi.org/10.3217/hn7we-q7z09)   
- Harden, J. (2025) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 7, Reference Tests on Aluminium Cylinder (1.1)". Graz University of Technology. doi: [10.3217/w3mb5-1wx17](https://doi.org/10.3217/w3mb5-1wx17)   


## Related software

### Dataset Compiler, version 1.2:

The referenced datasets are compiled from raw data using a dataset compilation tool implemented in the programming language of *GNU Octave 6.2.0*. To understand the structure of the datasets, it is a good idea to look at the source code of that tool. Therefore, it was made publicly available under the *MIT* license at the repository of *Graz University of Technology*.

- Harden, J. (2025) "Ultrasonic Pulse Transmission Tests: Data set compiler (1.2)". Graz University of Technology. doi: [10.3217/bcydt-6ta35](https://doi.org/10.3217/bcydt-6ta35)

  > [!NOTE]
  > *Dataset Compiler* is also available on **GitHub**. [Dataset Compiler](https://github.com/jakobharden/phd_dataset_compiler)


### Dataset Exporter, version 1.1:

*Dataset Exporter* is implemented in the programming language of GNU Octave 6.2.0 and allows for exporting data contained in the datasets. The main features of that script collection cover the export of substructures to variables and the serialization to the CSV format, the JSON structure format and TeX code. It is also made publicly available under the *MIT* licence at the repository of *Graz University of Technology*.

- Harden, J. (2025) "Ultrasonic Pulse Transmission Tests: Dataset Exporter (1.1)". Graz University of Technology. doi: [10.3217/d3p6m-w7d64](https://doi.org/10.3217/d3p6m-w7d64)

  > [!NOTE]
  > *Dataset Exporter* is also available on **GitHub**. [Dataset Exporter](https://github.com/jakobharden/phd_dataset_exporter)


### Dataset Viewer, version 1.0:

*Dataset Viewer* is implemented in the programming language of GNU Octave 6.2.0 and allows for plotting measurement data contained in the datasets. The main features of that script collection cover 2D plots, 3D plots and rendering MP4 video files from the measurement data contained in the datasets. It is also made publicly available under the *MIT* licence at the repository of *Graz University of Technology*.

- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Dataset Viewer (1.0)". Graz University of Technology. doi: [10.3217/c1ccn-8m982](https://doi.org/10.3217/c1ccn-8m982)

  > [!NOTE]
  > *Dataset Viewer* is also available on **GitHub**. [Dataset Viewer](https://github.com/jakobharden/phd_dataset_viewer)


## Revision and release history

### 2025-03-07, version 1.0.0

- published/released version 1.0.0, by Jakob Harden   
- repository: [TU Graz Repository](https://repository.tugraz.at/)   
- doi: [10.3217/xmrmb-5ap42](https://doi.org/10.3217/xmrmb-5ap42)   
- GitHub: [Repository](https://github.com/jakobharden/phd_paper_1_analysis)

