# OmicsData
Matlab library of methods for analyzing high-throughput data

## Installation
- Clone or download repository
- Add the repository file path to your Matlab search path (e.g. by addpath.m)


## Examples

An OmicsData object is created by `O = OmicsData(file);` where .txt, .xls, .xlsx, .csv and .mat files as well as a numeric input are accepted, e.g. the MaxQuant output tables can serve as file inputs here. Example data can be found in OmicsData/TestData.
```
OmicsInit
O = OmicsData('proteinGroups.txt');
O = log2(O);
image(O)
```

```
OmicsInit
O = OmicsData('proteinGroups.txt');
O = OmicsFilter(O,0.8,'log2');
O = DIMA(O);
```

```
OmicsInit
O = OmicsData('YEAST-Data-NonNormalized.csv',[],[],'yeast');     % PXD002099
O = DIMA(O,'fast');
```

## Methods

Some methods published from our group can be applied via:
- `O = DIMA(O);` Egert J, Warscheid B, and Kreutz C. DIMA: Data-driven selection of a suitable imputation algorithm. bioRxiv, 2020. doi: 10.1101/2020.10.13.323618. [DIMA Wiki](https://github.com/kreutz-lab/OmicsData/wiki/Data-driven-selection-of-an-imputation-algorithm)
- `O = OmicsMbqnMatlab(O);` Brombacher E, Schad A, Kreutz C. Tail-Robust Quantile Normalization. Proteomics. 2020;20(24). doi: 10.1002/pmic.202000068.
- `O = gsri(isnan(O));` Gehring J, Kreutz C, Bartholomé K and Timmer J. Introduction to the GSRI package : Estimating Regulatory Effects utilizing the Gene Set Regulation Index. 2013.

The OmicsData library includes an R function interface Rcall which executes R commands via command line. If R functunationalities like `O = limma(O);` are used in the OmicsData tools, a proper R version has to be installed. (https://github.com/kreutz-lab/Rcall/wiki)
