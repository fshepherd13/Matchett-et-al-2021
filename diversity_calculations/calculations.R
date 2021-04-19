#Sars cov 2 per site variation"
#Frances Shepherd
#4/16/2021
###Code looks at the proportion of sequences in this downsampled dataset that vary at each position from the consensus sequence. 
###Input is a masked amino acid alignment in csv form, where the first column is the strain name and second column is the sequence. "." represents a match to the consensus sequence. Code first splits each character into its own column in a dataframe so that each position in protein alignment is its own column. 
###The code then counts the number of columns that do not contain "." or "X" (X is ignored because this represents an ambiguous amino acid identity).

library(dplyr)
library(ggplot2)

setwd("") # <- set by user
n <- read.csv("n_masked_align.csv", header=F, row.names = 1, stringsAsFactors = FALSE) 
df_n <- data.frame(do.call(rbind, strsplit(as.character(n$V2), "")), stringsAsFactors = FALSE)
row.names(df_n) <- row.names(n)
names(df_n) <- as.character(seq(1, 420, 1))

n_variation <- apply(df_n, 2, function(x) sum(x != "." & x != "X")/length(x)) %>%
  as.data.frame() %>%
  setNames("proportion_variable_seqs")

#create variable to site position:
n_variation$position <- seq(1,420, 1)
n_plot <- ggplot(n_variation, aes(x = position, y = proportion_variable_seqs)) +
  geom_bar(stat = "identity", fill = "red", color = "red") +
  scale_x_continuous(breaks = seq(0,420, 20)) +
  scale_y_continuous(limits = c(0, 0.5)) +
  ggtitle("Nucleocapsid") +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"))
n_plot
#ggsave(plot = n_plot, filename = "nucleocapsid_per_site_variation.pdf", device = "pdf")


s <- read.csv("spike_masked_align.csv", header = FALSE, row.names = 1, stringsAsFactors = FALSE)
df_s <- data.frame(do.call(rbind, strsplit(as.character(s$V2), "")), stringsAsFactors = FALSE)
row.names(df_s) <- row.names(s)
names(df_s) <- as.character(seq(1, 1274, 1))

s_variation <- apply(df_s, 2, function(x) sum(x != "." & x != "X")/length(x)) %>%
  as.data.frame() %>%
  setNames("proportion_variable_seqs")

#create variable to site position:
s_variation$position <- seq(1,1274, 1)

ggplot(s_variation, aes(x = position, y = proportion_variable_seqs)) +
  geom_bar(stat = "identity", fill = "blue", color = "blue") +
  scale_x_continuous(breaks = seq(0,1280, 60)) +
  scale_y_continuous(limits = c(0, 0.5)) +
  ggtitle("Spike")+
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"))

###Next, calculate mutations per strain
#For nucleocapsid
df_n$muts_per_strain <- rowSums(df_n != "." & df_n != "X")

#For spike
df_s$muts_per_strain <- rowSums(df_s != "." & df_s != "X")

mean_mutations_df <- data.frame(Gene=c("spike", "nucleocapsid"),
                                av_mutations_per_gene=c(mean(df_s$muts_per_strain), 
                                                        mean(df_n$muts_per_strain)))
mean_mutations_df$gene_length <- c(1275, 420)
mean_mutations_df <- transform(mean_mutations_df, av_mutations_per_res = av_mutations_per_gene/gene_length)

mean_mutations_df