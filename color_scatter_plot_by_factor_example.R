# Author: Toby Tobkin <mail@tobytobkin.com> 
#
# Short example R script that illustrates how to cleanly create a scatter plot
# of a feature vector that consists of two quantitative (R numeric data type)
# features and one qualitative (R factor data type) feature
require(ggplot2)

# Load our example data into a data frame
user_data <- read.csv( file = "example_data.csv")

# Technicality: R will automatically assume a numeric-only column in a CSV file
# is a number, so we need to convert it to a categorical variable
user_data$user <- factor(user_data$user) 

# A first attempt at creating a useful plot from hypothetical metrics "metric_1"
# and "metric_2". Don't you think we could glean some more information from the
# same size plot area? Say, what if we wanted to know whether or not there were
# any per-user trends?
png(
  filename = "uncolored_plot.png",
  width = 800,
  height = 600
  )
plot(
  user_data$metric_1 ,
  user_data$metric_2 ,
  main = "Software Usage Metrics Not Colored by Factor \"user\"" ,
  xlab = "Metric 1",
  ylab = "Metric 2",
  pch = 20, # solid dots increase the readability of this data plot
  log = "xy" # log-scale axes increase the readability of this data plot
)
dev.off()

# We can add a third dimension of information by coloring the datapoints by a
# third feature, "user". We should be able to make better exploratory sense of
# the data this way since we can visually see whether trends are user-specific, 
# or population-wide. Two methods are presented here: The Easy Way and The Hard
# Way

# Method 1: the easy way with ggplot2
# 
# This method is so simple it doesn't need much explanation. In fact, it's only
# 1 statement long! If you don't have the ggplot2 package installed, install it
# using the following command at the R interpreter prompt: 
# install.packages("ggplot2")
png(  # open our output device
  filename = "ggplot2_colored_plot.png",
  width = 800,
  height = 600
)
qplot(  # plot our data
  x = user_data$metric_1,
  y = user_data$metric_2,
  data = user_data,
  main = "Software Usage Metrics Colored by Factor \"user\" (ggplot2)", 
  xlab = "Metric 1",
  ylab = "Metric 2",
  log = "xy",
  color = user # color by user
)
dev.off() # close our output device

# Method 2: the hard way with standard R functionality. 
#
# Why would we ever do it the hard way? Because we don't have to require the 
# users of our script to install any additional packages, it will run on just
# about any R installation, not only installations with ggplot2. This will only
# be a problem in extraneous circumstances. Typically it isn't too much trouble
# to make a user enter the command "install.packages("ggplot2")" to gain 
# compatibility.
# 
# The basic idea we will use is this: use built-in features of R to
# programatically assign each of the 15 factor levels in column "user" their
# own color on a scale, then tell our plot to use those colors. If it seems a
# little hacky and technical it's because it is.

# Step 1: Create our color ramp function. If, for instance, you call
# color_pallete_function(5), it will return 5 colors on a scale from red to
# orange to blue
color_pallete_function <- colorRampPalette(
  colors = c("red", "orange", "blue"),
  space = "Lab" # Option used when colors do not represent a quantitative scale
  )

# Step 2: Create a list of colors with exactly one color per user
num_users <- nlevels(user_data$user)
user_colors <- color_pallete_function(num_users)

# Step 3: Make your new plot, adding the argument for coloring of data points
png(
  filename = "colored_plot.png",
  width = 800,
  height = 600
)
plot(
  x = user_data$metric_1 ,
  y = user_data$metric_2 ,
  main = "Software Usage Metrics Colored by Factor \"user\"" ,
  xlab = "Metric 1",
  ylab = "Metric 2",
  pch = 20, # solid dots increase the readability of this data plot
  log = "xy", # log-scale axes increase the readability of this data plot
  col = user_colors[user_data$user]
)

# Step 4: Add a legend so we know which user is which on the graph
legend(
  x ="topleft",
  legend = paste("User", levels(user_data$user)), # for readability of legend
  col = user_colors,
  pch = 19, # same as pch=20, just smaller
  cex = .7 # scale the legend to look attractively sized
)
dev.off()