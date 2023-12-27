
## Anonymous
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 27 Dec 2023

# Install and load packages ----------------------------------------------------

if(!require("tidyverse")){install.packages("tidyverse", dependencies = TRUE); require("tidyverse")}
if(!require("ggplot2")){install.packages("ggplot2", dependencies = TRUE); require("ggplot2")}
if(!require("ggpubr")){install.packages("ggpubr", dependencies = TRUE); require("ggpubr")}

# Import the dataset -----------------------------------------------------------

# Import WEAT results
setwd("Results")

# Change below line of code to test different threshold values to compile names
weat_table = read.csv('weat_results_70.csv')
# weat_table = read.csv('weat_results_60.csv')
# weat_table = read.csv('weat_results_7020.csv')

# Filter WEAT results in the superiority dimension
superior_table <- weat_table %>% 
  filter(dimensions == "Superiority") %>%
  mutate(groups = factor(groups, levels = c("Black v. Hispanic people",
                                            "Asian v. Hispanic people",
                                            "Asian v. Black people",
                                            "White v. Hispanic people",
                                            "White v. Asian people",
                                            "White v. Black people")))

# Filter WEAT results in the Americanness dimension
american_table <- weat_table %>% 
  filter(dimensions == "Americanness") %>%
  mutate(groups = factor(groups, levels = c("Asian v. Hispanic people",
                                            "Black v. Hispanic people",
                                            "Black v. Asian people",
                                            "White v. Hispanic people",
                                            "White v. Asian people",
                                            "White v. Black people")))

# Generate forest plots for each dimension -------------------------------------

# Change working directory to Plots
setwd("../Plots")

superior_plot <- ggplot(superior_table, aes(x = effect, y = groups, xmin = lower, xmax = upper)) +
  geom_vline(xintercept = 0, linetype = "longdash") + 
  scale_x_continuous(limits = c(-1, 2.5),
                     breaks = c(-1.0, -0.5, 0, 0.5, 1.0, 1.5, 2.0, 2.5),
                     labels = c('-1.0', '-0.5', '0', '0.5', '1.0', '1.5', '2.0', '2.5')) + 
  geom_point(size = 2) +
  geom_errorbarh(height = .2) + 
  theme_bw() + 
  theme(plot.title = element_text(size = 16, hjust = 0.5),
        axis.title.x = element_blank(),
        axis.text.x = element_text(size = 16),
        axis.title.y = element_blank(),
        axis.text.y = element_text(size = 16, margin = margin(r = 5)))

american_plot <- ggplot(american_table, aes(x = effect, y = groups, xmin = lower, xmax = upper)) +
  geom_vline(xintercept = 0, linetype = "longdash") + 
  scale_x_continuous(limits = c(-1, 2.5),
                     breaks = c(-1.0, -0.5, 0, 0.5, 1.0, 1.5, 2.0, 2.5),
                     labels = c('-1.0', '-0.5', '0', '0.5', '1.0', '1.5', '2.0', '2.5')) + 
  geom_point(size = 2) +
  geom_errorbarh(height = .2) + 
  theme_bw() + 
  theme(plot.title = element_text(size = 16, hjust = 0.5),
        axis.title.x = element_blank(),
        axis.text.x = element_text(size = 16),
        axis.title.y = element_blank(),
        axis.text.y = element_text(size = 16, margin = margin(r = 5)))

# Place them on a single grid and label them -----------------------------------

ggarrange(superior_plot, american_plot, nrow = 2, labels = c("A", "B"))

# Change below line of code to plot results using group word stimuli 
# compiled using different threshold values
ggsave(file = "weat_70.pdf", width = 10, height = 6, dpi = "retina")
# ggsave(file = "weat_60.pdf", width = 10, height = 6, dpi = "retina")
# ggsave(file = "weat_7020.pdf", width = 10, height = 6, dpi = "retina")

