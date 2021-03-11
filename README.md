# OmicsData
Matlab library of methods for analyzing high-throughput data

## Installation
- Clone or download repository
- Add the repository file path to your Matlab search path (e.g. by addpath.m)


## Example usage
```
OmicsInit
O = OmicsData('proteinGroups.txt');
O = log2(O);
image(O)
```

## Methods

The OmicsData library includes an R function interface Rcall which executes R commands via command line. If R functunationalities like `O = limma(O);` are used in the OmicsData tools, a proper R version has to be installed. (https://github.com/kreutz-lab/Rcall/wiki)

Some methods published from our group can be applied via:
- `O = DIMA(O);` [Wiki](https://github.com/kreutz-lab/OmicsData/wiki/Data-driven-selection-of-an-imputation-algorithm) Egert J, Warscheid B, and Kreutz C. DIMA: Data-driven selection of a suitable imputation algorithm. bioRxiv, 2020. doi: 10.1101/2020.10.13.323618.
- `O = OmicsMBqnMatlab(O);` Brombacher E, Schad A, Kreutz C. Tail-Robust Quantile Normalization. Proteomics. 2020;20(24). doi: 10.1002/pmic.202000068.
- `O = gsri(isnan(O));` Gehring J, Kreutz C, Bartholomé K and Timmer J. Introduction to the GSRI package : Estimating Regulatory Effects utilizing the Gene Set Regulation Index. 2013.
