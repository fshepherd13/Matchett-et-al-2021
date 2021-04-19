#Load libraries
library(ggplot2)
library(ggpubr)
library(dplyr)
#Set working directory
setwd("/Users/sheph085/Documents/postdoc_projects/ncov/diversity_panel_data")

####AA entropy####
#Load spike aa entropy data
spike_aa_ent <- read.csv("spike_aa_entropy.tsv", sep = "\t", header = TRUE)

#Load nucleocapsid aa entropy data, drop the ORF9b-related data
n_aa_ent <- read.csv("n_aa_entropy.tsv", sep = "\t", header = TRUE) %>%
  subset(., gene != "ORF9b") %>%
  droplevels()

s_ent_plot <- ggplot(spike_aa_ent, aes(x = position, y = entropy)) +
  geom_bar(stat = "identity", fill = "blue", color = "blue") +
  scale_y_continuous(limits = c(0,0.7), name = "spike entropy")+
  scale_x_continuous(limits = c(0,1274), breaks = seq(0, 1300, 100)) +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"))

n_ent_plot <- ggplot(n_aa_ent, aes(x = position, y = entropy)) +
  geom_bar(stat = "identity", fill = "red", color = "red", size = 0.05) +
  scale_y_continuous(limits = c(0,0.7), name = "nucleocapsid entropy") +
  scale_x_continuous(limits = c(0,420), breaks = seq(0, 450, 100)) +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"))

ggarrange(s_ent_plot, n_ent_plot, #Arrange 2 plots
          labels = c("A", "B"),
          ncol = 1, nrow = 2) %>%
  annotate_figure(., top = text_grob("Amino acid entropy")) %>% #Add title
  ggexport(filename = "sarscov2_aa_entropy.pdf") #export to pdf

####Nucleotide entropy####
#Load spike nt entropy data
spike_nt_ent <- read.csv("spike_nt_entropy.tsv", sep = "\t", header = TRUE)
#Load nucleocapsid aa entropy data, drop the ORF9b-related data
n_nt_ent <- read.csv("n_nt_entropy.tsv", sep = "\t", header = TRUE)

s_ent_plot <- ggplot(spike_nt_ent, aes(x = base, y = entropy)) +
  geom_bar(stat = "identity", fill = "blue", color = "blue") +
  scale_y_continuous(limits = c(0,0.8), name = "spike entropy")+
  scale_x_continuous(limits = c(21500,25500), breaks = seq(21500,25500, 500)) +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"))

n_ent_plot <- ggplot(n_nt_ent, aes(x = base, y = entropy)) +
  geom_bar(stat = "identity", fill = "red", color = "red") +
  scale_y_continuous(limits = c(0,0.8), name = "nucleocapsid entropy") +
  scale_x_continuous(limits = c(28200, 29600), breaks = seq(28200, 29500, 100)) +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"))


ggarrange(s_ent_plot, n_ent_plot, #Arrange 2 plots
                    labels = c("A", "B"),
                    ncol = 1, nrow = 2) %>%
  annotate_figure(., top = text_grob("Nucleotide entropy")) %>%
  ggexport(filename = "sarscov2_nt_entropy.pdf") #export to pdf


####AA events####
#Load spike aa event data
spike_aa_evnt <- read.csv("spike_aa_events.tsv", sep = "\t", header = TRUE)
#Load nucleocapsid aa entropy data, drop the ORF9b-related data
n_aa_evnt <- read.csv("n_aa_events.tsv", sep = "\t", header = TRUE) %>%
  subset(., gene != "ORF9b") %>%
  droplevels()

s_evnt_plot <- ggplot(spike_aa_evnt, aes(x = position, y = events)) +
  geom_bar(stat = "identity", fill = "blue", color = "blue") +
  scale_y_continuous(limits = c(0,20), name = "# spike aa mutations")+
  scale_x_continuous(limits = c(0,1274), breaks = seq(0, 1300, 100)) +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"))

n_evnt_plot <- ggplot(n_aa_evnt, aes(x = position, y = events)) +
  geom_bar(stat = "identity", fill = "red", color = "red") +
  scale_y_continuous(limits = c(0,20), name = "# nucleocapsid aa mutations") +
  scale_x_continuous(limits = c(0,420), breaks = seq(0, 450, 100)) +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"))


ggarrange(s_evnt_plot, n_evnt_plot, #Arrange 2 plots
                    labels = c("A", "B"),
                    ncol = 1, nrow = 2) %>%
  annotate_figure(., top = text_grob("AA mutational events")) %>%
  ggexport(filename = "sarscov2_aa_events.pdf") #export to pdf


####NT events####
#Load spike nt event data
spike_nt_evnt <- read.csv("spike_nt_events.tsv", sep = "\t", header = TRUE)
#Load nucleocapsid aa entropy data, drop the ORF9b-related data
n_nt_evnt <- read.csv("n_nt_events.tsv", sep = "\t", header = TRUE)

s_evnt_plot <- ggplot(spike_nt_evnt, aes(x = base, y = events)) +
  geom_bar(stat = "identity", fill = "blue", color = "blue") +
  scale_y_continuous(limits = c(0,15), name = "spike nt mutational events")+
  scale_x_continuous(limits = c(21500,25500), breaks = seq(21500,25500, 500)) +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"))

n_evnt_plot <- ggplot(n_nt_evnt, aes(x = base, y = events)) +
  geom_bar(stat = "identity", fill = "red", color = "red") +
  scale_y_continuous(limits = c(0,15), name = "nucleocapsid nt mutational events") +
  scale_x_continuous(limits = c(28200, 29600), breaks = seq(28200, 29500, 100)) +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"))
n_evnt_plot


ggarrange(s_evnt_plot, n_evnt_plot, #Arrange 2 plots
                    labels = c("A", "B"),
                    ncol = 1, nrow = 2) %>%
  annotate_figure(., top = text_grob("Nucleotide mutational events")) %>%
  ggexport(filename = "sarscov2_nt_events.pdf") #export to pdf
