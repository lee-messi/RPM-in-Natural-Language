
## Anonymous
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 21 Sept 2023

# Install and load packages ----------------------------------------------------

if(!require("tidyverse")){install.packages("tidyverse", dependencies = TRUE); require("tidyverse")}

# Load Dataset -----------------------------------------------------------------

setwd("Results")

# Load WEAT Ds calculated using ALC embeddings 
acad = read.csv('acad_weat_results.csv')
blog = read.csv('blog_weat_results.csv')
fic = read.csv('fic_weat_results.csv')
mag = read.csv('mag_weat_results.csv')
news = read.csv('news_weat_results.csv')
spok = read.csv('spok_weat_results.csv')
tvm = read.csv('tvm_weat_results.csv')
web = read.csv('web_weat_results.csv')

# Load meta-analytic estimates calculated using "meta_analysis.R"
superior_meta = read.csv('superior_meta_estimate.csv')
american_meta = read.csv('american_meta_estimate.csv')

# Bind all test results together as a single dataframe
all_tests <- rbind(acad, blog, fic, mag, news, spok, tvm, web)

# Store type of texts as a character vector for later use
category.column <- rep(c('Academic Articles', 'Blogs', 'Fiction', 
                         'Magazines', 'Newspapers', 'Spoken Language', 
                         'TV/Movie Subtitles', 'The Internet'), each = 12)

# Filter test results pertaining to the superiority dimension 
superior <- all_tests %>% 
  mutate(tot = as.factor(category.column)) %>% 
  filter(dimension == "Superiority") %>%
  rename(yi = effect) %>%
  mutate(sei = (yi - lower)/1.96) %>%
  arrange(match(groups, c("White v. Black people", 
                          "White v. Asian people",
                          "White v. Hispanic people",
                          "Asian v. Black people",
                          "Asian v. Hispanic people",
                          "Black v. Hispanic people")))


# Filter test results pertaining to the Americanness dimension 
american <- all_tests %>% 
  mutate(tot = category.column) %>% 
  filter(dimension == "Americanness") %>%
  rename(yi = effect) %>%
  mutate(sei = (yi - lower)/1.96) %>%
  arrange(match(groups, c("White v. Black people", 
                          "White v. Asian people",
                          "White v. Hispanic people",
                          "Black v. Asian people",
                          "Black v. Hispanic people",
                          "Asian v. Hispanic people")))


# Forest Plot of Superiority WEAT Ds -------------------------------------------

setwd("../Plots")

pdf(file = "superiority_meta.pdf", width = 18, height = 10)

op <- par(mar = c(7,7,2,2))
plot(1, type="n", xlab="", ylab="", 
     xlim=c(0.5, 7.7), ylim=c(-1.5, 4.0), axes = FALSE)
box()
mtext(expression(paste("WEAT ", italic(D))), side = 2, line = 5, cex = 1.6)
axis(1, at = c(1.2, 2.4, 3.6, 4.8, 6.0, 7.2), 
     labels = c("White v. Black\npeople", 
                "White v. Asian\npeople",
                "White v. Hispanic\npeople",
                "Asian v. Black\npeople",
                "Asian v. Hispanic\npeople",
                "Black v. Hispanic\npeople"),
     cex.axis = 1.6, padj = 1)

axis(2, at = seq(-1.5, 4.0, by = 0.5), 
     labels = seq(-1.5, 4.0, by = 0.5), 
     las = 2, 
     cex.axis = 1.6)
abline(h = 0, lty = 2)
abline(v = c(1.8, 3.0, 4.2, 5.4, 6.6), lty = 2, lwd = 2.5)

points(seq(1.2, 7.2, by = 1.2),
       superior_meta$effect, 
       pch = 17, cex = 2, col = "black")
segments(x0 = seq(1.2, 7.2, by = 1.2), x1 = seq(1.2, 7.2, by = 1.2),
         y0 = superior_meta$lower,
         y1 = superior_meta$upper, 
         lty = 1, lwd = 3, col = "black")

points(seq(0.8, 6.8, by = 1.2),
       superior$yi[superior$tot =="Academic Articles"], 
       pch = 16, cex = 1.5, col = "darkgrey")
segments(x0 = seq(0.8, 6.8, by = 1.2), x1 = seq(0.8, 6.8, by = 1.2),
         y0 = superior$lower[superior$tot =="Academic Articles"],
         y1 = superior$upper[superior$tot =="Academic Articles"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(0.9, 6.9, by = 1.2),
       superior$yi[superior$tot =="Blogs"], 
       pch = 4, cex = 1.5, col = "darkgrey")
segments(x0 = seq(0.9, 6.9, by = 1.2), x1 = seq(0.9, 6.9, by = 1.2),
         y0 = superior$lower[superior$tot =="Blogs"],
         y1 = superior$upper[superior$tot =="Blogs"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.0, 7.0, by = 1.2),
       superior$yi[superior$tot =="Fiction"], 
       pch = 8, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.0, 7.0, by = 1.2), x1 = seq(1.0, 7.0, by = 1.2),
         y0 = superior$lower[superior$tot =="Fiction"],
         y1 = superior$upper[superior$tot =="Fiction"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.1, 7.1, by = 1.2),
       superior$yi[superior$tot =="Magazines"], 
       pch = 15, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.1, 7.1, by = 1.2), x1 = seq(1.1, 7.1, by = 1.2),
         y0 = superior$lower[superior$tot =="Magazines"],
         y1 = superior$upper[superior$tot =="Magazines"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.3, 7.3, by = 1.2),
       superior$yi[superior$tot =="Newspapers"], 
       pch = 1, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.3, 7.3, by = 1.2), x1 = seq(1.3, 7.3, by = 1.2),
         y0 = superior$lower[superior$tot =="Newspapers"],
         y1 = superior$upper[superior$tot =="Newspapers"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.4, 7.4, by = 1.2),
       superior$yi[superior$tot =="Spoken Language"], 
       pch = 5, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.4, 7.4, by = 1.2), x1 = seq(1.4, 7.4, by = 1.2),
         y0 = superior$lower[superior$tot =="Spoken Language"],
         y1 = superior$upper[superior$tot =="Spoken Language"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.5, 7.5, by = 1.2),
       superior$yi[superior$tot =="TV/Movie Subtitles"], 
       pch = 0, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.5, 7.5, by = 1.2), x1 = seq(1.5, 7.5, by = 1.2),
         y0 = superior$lower[superior$tot =="TV/Movie Subtitles"],
         y1 = superior$upper[superior$tot =="TV/Movie Subtitles"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.6, 7.6, by = 1.2),
       superior$yi[superior$tot =="The Internet"], 
       pch = 3, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.6, 7.6, by = 1.2), x1 = seq(1.6, 7.6, by = 1.2),
         y0 = superior$lower[superior$tot =="The Internet"],
         y1 = superior$upper[superior$tot =="The Internet"],
         lwd = 2, col = "darkgrey", lty = 2)

legend("bottom", c('Academic Articles', 'Blogs', 'Fiction', 
                   'Magazines', 'Meta Estimate', 'Newspapers', 'Spoken Language', 
                   'TV/Movie Subtitles', 'The Internet'),
       col = c(rep("darkgrey", 4), "black", rep("darkgrey", 4)),
       pch = c(16, 4, 8, 15, 17, 1, 5, 0, 3), lwd = 2, 
       cex = 1.5, pt.cex = c(rep(2, 9)), bg = "white", ncol = 2)

par(op)
dev.off()

# Americanness Forest Plot -----------------------------------------------------

pdf(file = "americanness_meta.pdf", width = 18, height = 10)

op <- par(mar = c(7,7,2,2))
plot(1, type="n", xlab="", ylab="", 
     xlim=c(0.5, 7.7), ylim=c(-1.5, 4.0), axes = FALSE)
box()
mtext(expression(paste("WEAT ", italic(D))), side = 2, line = 5, cex = 1.6)
axis(1, at = c(1.2, 2.4, 3.6, 4.8, 6.0, 7.2), 
     labels = c("White v. Black\npeople", 
                "White v. Asian\npeople",
                "White v. Hispanic\npeople",
                "Black v. Asian\npeople",
                "Black v. Hispanic\npeople",
                "Asian v. Hispanic\npeople"),
     cex.axis = 1.6, padj = 1)

axis(2, at = seq(-1.5, 4.0, by = 0.5), 
     labels = seq(-1.5, 4.0, by = 0.5), 
     las = 2, 
     cex.axis = 1.6)
abline(h = 0, lty = 2)
abline(v = c(1.8, 3.0, 4.2, 5.4, 6.6), lty = 2, lwd = 2.5)

points(seq(1.2, 7.2, by = 1.2),
       american_meta$effect, 
       pch = 17, cex = 2, col = "black")
segments(x0 = seq(1.2, 7.2, by = 1.2), x1 = seq(1.2, 7.2, by = 1.2),
         y0 = american_meta$lower,
         y1 = american_meta$upper, 
         lty = 1, lwd = 3, col = "black")

points(seq(0.8, 6.8, by = 1.2),
       american$yi[american$tot =="Academic Articles"], 
       pch = 16, cex = 1.5, col = "darkgrey")
segments(x0 = seq(0.8, 6.8, by = 1.2), x1 = seq(0.8, 6.8, by = 1.2),
         y0 = american$lower[american$tot =="Academic Articles"],
         y1 = american$upper[american$tot =="Academic Articles"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(0.9, 6.9, by = 1.2),
       american$yi[american$tot =="Blogs"], 
       pch = 4, cex = 1.5, col = "darkgrey")
segments(x0 = seq(0.9, 6.9, by = 1.2), x1 = seq(0.9, 6.9, by = 1.2),
         y0 = american$lower[american$tot =="Blogs"],
         y1 = american$upper[american$tot =="Blogs"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.0, 7.0, by = 1.2),
       american$yi[american$tot =="Fiction"], 
       pch = 8, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.0, 7.0, by = 1.2), x1 = seq(1.0, 7.0, by = 1.2),
         y0 = american$lower[american$tot =="Fiction"],
         y1 = american$upper[american$tot =="Fiction"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.1, 7.1, by = 1.2),
       american$yi[american$tot =="Magazines"], 
       pch = 15, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.1, 7.1, by = 1.2), x1 = seq(1.1, 7.1, by = 1.2),
         y0 = american$lower[american$tot =="Magazines"],
         y1 = american$upper[american$tot =="Magazines"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.3, 7.3, by = 1.2),
       american$yi[american$tot =="Newspapers"], 
       pch = 1, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.3, 7.3, by = 1.2), x1 = seq(1.3, 7.3, by = 1.2),
         y0 = american$lower[american$tot =="Newspapers"],
         y1 = american$upper[american$tot =="Newspapers"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.4, 7.4, by = 1.2),
       american$yi[american$tot =="Spoken Language"], 
       pch = 5, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.4, 7.4, by = 1.2), x1 = seq(1.4, 7.4, by = 1.2),
         y0 = american$lower[american$tot =="Spoken Language"],
         y1 = american$upper[american$tot =="Spoken Language"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.5, 7.5, by = 1.2),
       american$yi[american$tot =="TV/Movie Subtitles"], 
       pch = 0, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.5, 7.5, by = 1.2), x1 = seq(1.5, 7.5, by = 1.2),
         y0 = american$lower[american$tot =="TV/Movie Subtitles"],
         y1 = american$upper[american$tot =="TV/Movie Subtitles"],
         lwd = 2, col = "darkgrey", lty = 2)

points(seq(1.6, 7.6, by = 1.2),
       american$yi[american$tot =="The Internet"], 
       pch = 3, cex = 1.5, col = "darkgrey")
segments(x0 = seq(1.6, 7.6, by = 1.2), x1 = seq(1.6, 7.6, by = 1.2),
         y0 = american$lower[american$tot =="The Internet"],
         y1 = american$upper[american$tot =="The Internet"],
         lwd = 2, col = "darkgrey", lty = 2)

legend("bottom", c('Academic Articles', 'Blogs', 'Fiction', 
                   'Magazines', 'Meta Estimate', 'Newspapers', 'Spoken Language', 
                   'TV/Movie Subtitles', 'The Internet'), 
       col = c(rep("darkgrey", 4), "black", rep("darkgrey", 4)),
       pch = c(16, 4, 8, 15, 17, 1, 5, 0, 3), lwd = 2, 
       cex = 1.5, pt.cex = c(rep(2, 9)), bg = "white", ncol = 2)

par(op)
dev.off()
