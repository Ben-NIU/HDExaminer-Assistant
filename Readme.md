
## HDExaminer Assistant: *H/DX Easy Plotting*  
A web application aiming to "make life easier" for people who struggle to extract data (and plot kinetic curves) from the **ginormous data table** output by HDExaminer. Wondering what the HDExmainer output looks like? See below:  


![Alt text](pics/huge_mass.png?raw=true "Optional Title")

***The idea here is*** to upload such data table to the App and directly obtain useful information (e.g., identified peptides, overview of kinetic curves, etc.) with a few user-specified parameters, no one enjoys spending hours on a table crowded with numbers and strings, just for fumbling a fraction of information in order to plot some HDX kinetic curves.  

### User-specified parameters   
* HDX incubation time in sec: (e.g., 10, 30, 60, 300, 600, 1800, 7200)  
* Number of replicates: defaulted by 3, some people do 2 as far as I know  
**Note: With those two parameters, the app could automatically generate a list with all the identified peptides, click "Show Peptide Table" to display this list.**  
* Which peptides to plot: either input the peptide index (e.g., 3-15) shown in "Peptide Table", or simply input "All" to plot all peptides in Table  
**Note: Make sure the layout size (row number x column number) is large enough to accommodate all the peptides to be plotted  

### Kinetic curves-related parameters
* Point size  
* Curve transparency  
* Colors for two-state comparison  
* Labels for two-state comparison  

***Shown below is the kinetic curves you would obtain:***  

![Alt text](pics/curve.png?raw=true "Optional Title")

### Download reformatted data table  
If you strongly prefer to plot kinetic curves on your own, you have the option to download the reformatted data table, which groups each peptide in between two states and have the mean and standard deviation of deuterium uptake percentage calculated.   


## LICENSE  
### MIT
