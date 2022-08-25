# FishRAM Shiny App
This guide outlines how to download the necessary materials to run the Fisheries Resource Allocation Model (FishRAM) through a Shiny application. 

## Initial Setup
#### 1. Install R

Download and install R following the instructions at [https://cran.rstudio.com/](https://cran.rstudio.com/).

#### 2. Install RStudio

Download and install RStudio Desktop following the instructions at [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/).


#### 3. Install relevant packages
Open R studio, and the bottom left section of the screen will show a console. Paste the following code into the console and hit Enter. This will install the R packages that are required to run the app.

``` r
install.packages(c("devtools", "shinydashboard"))
devtools::install_github("CefasRepRes/FishRAM")
```

![Installing packages screenshots](README_screenshots/InstallPackages.png)


## Running the app
Download the files in this repo by clicking the green "Code" button in the top right corner of the main pane. Then select "Download ZIP" from the options.

![GitHub Screenshots](README_screenshots/GitHub.png)


When the ZIP file has finished downloading, extract the files, ensuring that all the `.R` files are in the same folder.


![File Structure Screenshot](README_screenshots/FileStructure.png)

In RStudio, open the ui.R file by navigating to File -> Open File from the RStudio menu. In the top right corner of the text editor there will appear a "Run App" button. 


![Run app screenshot](README_screenshots/RunApp.png)

Click this button to run the FishRAM app.

![Running app screenshot](README_screenshots/OpenedApp.png)

