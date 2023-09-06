
## Anonymous
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 26 Aug 2023

# Install and load packages ----------------------------------------------------

if(!require("tidyverse")){install.packages("tidyverse", dependencies = TRUE); require("tidyverse")}
if(!require("ggplot2")){install.packages("ggplot2", dependencies = TRUE); require("ggplot2")}

# Import the Dataset -----------------------------------------------------------

# Import WEAT results
setwd("Results")

# Change below line of code to test different threshold values to compile names
# weat_table = read.csv('weat_results_70.csv')
# weat_table = read.csv('weat_results_60.csv')
weat_table = read.csv('weat_results_7020.csv')

# Filter WEAT results in the superiority dimension
superior_table <- weat_table %>% 
  filter(dimensions == "Superiority") %>%
  mutate(groups = factor(groups, levels = c("African v. Hispanic Americans",
                                            "Asian v. Hispanic Americans", 
                                            "Asian v. African Americans", 
                                            "White v. Hispanic Americans",
                                            "White v. Asian Americans",
                                            "White v. African Americans")))

# Filter WEAT results in the Americanness dimension
american_table <- weat_table %>% 
  filter(dimensions == "Americanness") %>%
  mutate(groups = factor(groups, levels = c("Asian v. Hispanic Americans",
                                            "African v. Hispanic Americans", 
                                            "African v. Asian Americans", 
                                            "White v. Hispanic Americans",
                                            "White v. Asian Americans",
                                            "White v. African Americans")))

# Superiority Forest Plot ------------------------------------------------------

# Change working directory to Plots
setwd("../Plots")

ggplot(superior_table, aes(x = effect, y = groups, xmin = lower, xmax = upper)) +
  geom_vline(xintercept = 0, linetype = "longdash") + 
  scale_x_continuous(limits = c(-1, 2.5),
                     breaks = c(-1.0, -0.5, 0, 0.5, 1.0, 1.5, 2.0, 2.5),
                     labels = c('-1.0', '-0.5', '0', '0.5', '1.0', '1.5', '2.0', '2.5')) + 
  geom_point() +
  geom_errorbarh(height = .2) + 
  theme_bw() + 
  theme(plot.title = element_text(size = 16, hjust = 0.5),
        axis.title.x = element_blank(),
        axis.text.x = element_text(size = 16),
        axis.title.y = element_blank(),
        axis.text.y = element_text(size = 16, margin = margin(r = 5)))

# Change below line of code to plot results using group word stimuli 
# compiled using different threshold values
# ggsave(file = "superior_weat_70.pdf", width = 10, height = 3, dpi = "retina")
# ggsave(file = "superior_weat_70.png", width = 10, height = 3, dpi = "retina")
# ggsave(file = "superior_weat_60.pdf", width = 10, height = 3, dpi = "retina")
# ggsave(file = "superior_weat_60.png", width = 10, height = 3, dpi = "retina")
ggsave(file = "superior_weat_7020.pdf", width = 10, height = 3, dpi = "retina")
ggsave(file = "superior_weat_7020.png", width = 10, height = 3, dpi = "retina")

# Americanness Forest Plot -----------------------------------------------------

ggplot(american_table, aes(x = effect, y = groups, xmin = lower, xmax = upper)) +
  geom_vline(xintercept = 0, linetype = "longdash") + 
  scale_x_continuous(limits = c(-1, 2.5),
                     breaks = c(-1.0, -0.5, 0, 0.5, 1.0, 1.5, 2.0, 2.5),
                     labels = c('-1.0', '-0.5', '0', '0.5', '1.0', '1.5', '2.0', '2.5')) + 
  geom_point() +
  geom_errorbarh(height = .2) + 
  theme_bw() + 
  theme(plot.title = element_text(size = 16, hjust = 0.5),
        axis.title.x = element_blank(),
        axis.text.x = element_text(size = 16),
        axis.title.y = element_blank(),
        axis.text.y = element_text(size = 16, margin = margin(r = 5)))

# Change below line of code to plot results using group word stimuli 
# compiled using different threshold values
# ggsave(file = "american_weat_70.pdf", width = 10, height = 3, dpi = "retina")
# ggsave(file = "american_weat_70.png", width = 10, height = 3, dpi = "retina")
# ggsave(file = "american_weat_60.pdf", width = 10, height = 3, dpi = "retina")
# ggsave(file = "american_weat_60.png", width = 10, height = 3, dpi = "retina")
ggsave(file = "american_weat_7020.pdf", width = 10, height = 3, dpi = "retina")
ggsave(file = "american_weat_7020.png", width = 10, height = 3, dpi = "retina")


