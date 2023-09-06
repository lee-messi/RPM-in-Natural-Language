
## Anonymous
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 15 March 2023

# Install and load packages ----------------------------------------------------

if(!require("tidyverse")){install.packages("tidyverse", dependencies = TRUE); require("tidyverse")}
if(!require("ggplot2")){install.packages("ggplot2", dependencies = TRUE); require("ggplot2")}
if(!require("ggsci")){install.packages("ggsci", dependencies = TRUE); require("ggsci")}

# Load Data --------------------------------------------------------------------

# Import SC-WEAT D scores
setwd('Results')
scweat = read.csv('scweat_results.csv')

# Separate SC-WEAT D scores pertaining to the superiority dimension
# Change variable names for easy plotting 
scweat_superior <- scweat %>% 
  filter(dimensions == "Superiority") %>%
  rename(superior_effect = effect) %>%
  rename(superior_lower = lower) %>%
  rename(superior_upper = upper)

# Separate SC-WEAT D scores pertaining to the Americanness dimension
# Change variable names for easily plotting 
scweat_american <- scweat %>% 
  filter(dimensions == "Americanness") %>%
  rename(american_effect = effect) %>%
  rename(american_lower = lower) %>%
  rename(american_upper = upper)

# Bring the two data frames into a single one again
scweat <- merge(scweat_superior, scweat_american, by = "groups")

# Plot -------------------------------------------------------------------------

setwd('../Plots')

ggplot(scweat, aes(x = american_effect, y = superior_effect, color = groups)) + 
  geom_hline(yintercept=0,  
             color = "black",
             linetype = 'dotted', 
             linewidth = 1) + 
  geom_vline(xintercept= 0, 
             color = "black",
             linetype = 'dotted', 
             linewidth = 1) + 
  geom_point(size = 3) + 
  geom_errorbar(aes(xmin = american_lower, xmax = american_upper), 
                linewidth = 0.8, width = 0.1) + 
  geom_errorbar(aes(ymin = superior_lower, ymax = superior_upper), 
                linewidth = 0.8, width = 0.1) + 
  labs(x = expression(paste("Americanness SC-WEAT ", italic(D))),
       y = expression(paste("Superiority SC-WEAT ", italic(D))),
       color = "Groups") + 
  theme_bw() +
  scale_x_continuous(breaks = seq(-1.5, 1.5, by = 0.5), 
                     limits = c(-1.5, 1.5), 
                     labels = c("-1.5", "-1.0", "-0.5", "0", "0.5", "1.0", "1.5")) +
  scale_y_continuous(breaks = seq(0, 3.0, by = 0.5), 
                     limits = c(0, 3.0), 
                     labels = c("0", "0.5", "1.0", "1.5", "2.0", "2.5", "3.0")) + 
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 5, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)), 
        legend.position = "top", 
        legend.title = element_blank(), 
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 16), 
        legend.text = element_text(size = 14)) +
  scale_color_jama(labels = c("African Americans", "Asian Americans", 
                              "Hispanic Americans", "White Americans"))

ggsave("scweat2d_plot.pdf", width = 10, height = 7.5, dpi = "retina")
ggsave("scweat2d_plot.png", width = 10, height = 7.5, dpi = "retina")

