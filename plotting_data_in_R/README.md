# Description

This tutorial will show you how to plot repeated measures data in R (using ggplot), with a particular focus on visualizing uncertainty in data. The current tutorial builds upon the basics of ggplot, showing you how to construct more complex plots for improved understanding of data uncertainty. This style of plotting is “on- trend” academically. <br>

The tutorial uses data from a behavioral decision task – the Framed Gambling Task (FGT). The dependent variable is proportion of gambles, the within-subjects independent variables are trial block (1-4) and decision framing (gain, loss), and the between-subjects independent variable is feedback condition (full, minimal, partial). The code provided can be relatively easily adapted to any research with a continuous DV and a repeated measures IV.
If you are interested in learning more about the properties of the FGT, see
https://doi.org/10.1371/journal.pone.0204694
The raw data from the FGT has already been filtered and formatted for plotting. If you need help transforming your own dataset, you can view my Data Transformation Tutorial. Note that this was created to help my undergraduate research assistant who is working with the same data.

# Prerequisites

If you have never used ggplot before, I would recommend looking through my tutorial from the 2019 cog summer workshop on exploratory plotting. It focuses on plotting simple histograms, bar charts, and scatter plots.

https://github.com/TU-Coding-Outreach-Group/cog_summer_workshops_2019/blob/master/plotting_data_in_R/Exploratory%20Plotting%20in%20R%20Tutorial.ipynb


# Additional Resources
* [Installing libraries from GitHub](https://kbroman.org/pkg_primer/pages/github.html)
* [Describes implantation of gghalves for half boxplots, violins, and points](
https://erocoar.github.io/gghalves/)
* [Repeated measures plotting tutorial that inspired the current tutorial](https://github.com/jorvlan/open-visualizations/blob/master/R/repmes_tutorial_R.pdf)
* [Describes look of different plotting themes and how to create and re-use your own custom theme](https://chrischizinski.github.io/SNR_R_Group/2016-10-05-Themes_Facets)
* [Shape codes](http://www.cookbook-r.com/Graphs/Shapes_and_line_types/)
