#CloudCover
#M.P.Maurits

#Dependencies:
#magick
#ggplot2
#gridExtra
#colorRamps

#Function to create clouds using new surface area method
#Input looks like this:

#  word   freq
#1 Pizza   15
#2 Spons   30
#3 Gozer   60
#4 Krimp  120
#5 Joker  240

#max_words determines the max number of words to plot
#order=TRUE makes it so the most frequent word is on the bottom and the least frequent on the top
#font=2 makes all words bold, 1 is normal, 3 is italic, 4 is both bold and italic
#party=TRUE assigns random colours (with some exclusions) to the words
#cap determines whether words are in all-caps ("all"), no-caps ("none"), or as provided ("as.is")

plotCloudSA <- function(dat, max_words=10, order=F, font=2, party=FALSE, cap = c("all", "none", "as.is")){
  #Order words on frequency (descending) if order=TRUE
  if(order) dat <- dat[order(dat$freq, decreasing = T),]
  #Randomise words if order=FALSE
  if(!order) dat <- dat[sample(1:nrow(dat), nrow(dat)),]
  #Capitalise words according to cap argument
  cap <- match.arg(cap)
  if(cap == "all") words <- toupper(dat$word)
  if(cap == "none") words <- tolower(dat$word)
  if(cap == "as.is") words <- as.vector(dat$word)
  #Some prelimenary work
  char_counts <- nchar(words)
  freqs <- dat$freq
  #Create a temporary directory for the .png's
  dir.create("Temp", showWarnings = F)
  #Create separate .png for every word
  for(i in 1:length(words)){
    #Pick random colour if party=TRUE, otherwise pick black
    if(party){
      col <- primary.colors()[sample(1:length(primary.colors()), 1)]
    } else {
      col <- "black"
    }
    #Create tight fitting plot box containing word
    h <- strheight(words[i], cex = 10, family = "mono", units = "inches", font = font)
    w <- strwidth(words[i], cex = 10, family = "mono", units = "inches", font = font)
    png(width = w + 0.1, height = h + 0.1, units = "in", file = paste0("Temp/File_", formatC(i, digits = 2, flag = "0"), ".png"), res = 72)
    par(mar = c(0,0,0,0))
    plot.new()
    text(x = -0.05, y = 0.4, words[i], cex = 10, family = "mono", font = font, pos = 4, col = col)
    dev.off()
  }
  #Read all words as .png
  word_ims <- lapply(1:length(words), function(x){
    image_read(paste0("Temp/File_", formatC(x, digits = 2, flag = "0"), ".png"))
  })
  #Remove temporary directory
  unlink("Temp", recursive = T)
  
  #Determine which words to include (based on max_words & provided data)
  cloud_lim <- min(c(max_words, length(word_ims)))
  word_ras <- word_ims[1:cloud_lim]
  word_ras <- lapply(word_ras, as.raster)
  cloud_count <- char_counts[1:cloud_lim]
  cloud_freq <- freqs[1:cloud_lim]
  
  #Set minimum word dimensions
  cloud_width_min <- 10
  
  cloud_size_min <- ((100/length(word_ras)) - 1)*cloud_width_min
  
  cloud_freq_min <- min(cloud_freq)
  
  #Calculate size for each word
  cloud_size <- (cloud_freq/cloud_freq_min)*cloud_size_min
  
  #Calculate corresponding height
  cloud_height <- sqrt(cloud_size/cloud_count)
  
  #Calculate corresponding width
  cloud_width <- cloud_height*cloud_count
  
  #Determine locations to plot words (stacked, left alligned)
  cloud_lines_lower <- c(0, cumsum(cloud_height))[1:cloud_lim]
  
  cloud_lines_lower <- cloud_lines_lower + seq(0, cloud_lim - 1, 1)
  
  cloud_lines_upper <- c(cumsum(cloud_height))
  
  cloud_lines_upper <- cloud_lines_upper + seq(0, cloud_lim - 1, 1)
  
  cloud_allign <- sample(seq(5,100,1), cloud_lim)
  
  #Create background for cloud
  cloud_bg <- ggplot(df <- data.frame()) + 
    geom_point() + 
    xlim(0, max(c(cloud_allign + cloud_width, cloud_lines_upper)) + 5) + 
    ylim(0, max(c(cloud_allign + cloud_width, cloud_lines_upper)) + 5) +
    theme_bw() +
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          panel.border = element_blank(),
          axis.ticks = element_blank(),
          axis.text = element_blank())
  
  #Add each word to the plot at the designated position
  cloud_plot <- paste0("cloud_bg + ", paste0("annotation_raster(word_ras[[", 1:cloud_lim, "]], ", cloud_allign, ", ", cloud_allign + cloud_width, ",", cloud_lines_lower,",", cloud_lines_upper,")", collapse = "+"))
  
  #Plot the cloud
  eval(parse(text = cloud_plot))
}

#Function to create clouds using old scaling method
#Arguments are the same as for the plotCloudSA() function
#Except for scale, which sets the range to scale words between
#Most frequent word is set to the first value in scale, second value is the asymptotic lower bound
#Function also works very similarly to the plotCloudSA() function, thus no internal annotation is provided

plotCloudST <- function(dat, max_words=10, order=F, font=2, party=FALSE, cap = c("all", "none", "as.is"), scale = c(4,0.5)){
  if(order) dat <- dat[order(dat$freq, decreasing = T),]
  if(!order) dat <- dat[sample(1:nrow(dat), nrow(dat)),]
  cap <- match.arg(cap)
  if(cap == "all") words <- toupper(dat$word)
  if(cap == "none") words <- tolower(dat$word)
  if(cap == "as.is") words <- as.vector(dat$word)
  char_counts <- nchar(words)
  freqs <- dat$freq
  dir.create("Temp", showWarnings = F)
  for(i in 1:length(words)){
    if(party){
      col <- primary.colors()[sample(1:length(primary.colors()), 1)]
    } else {
      col <- "black"
    }
    h <- strheight(words[i], cex = 10, family = "mono", units = "inches", font = font)
    w <- strwidth(words[i], cex = 10, family = "mono", units = "inches", font = font)
    png(width = w + 0.1, height = h + 0.1, units = "in", file = paste0("Temp/File_", formatC(i, digits = 2, flag = "0"), ".png"), res = 72)
    par(mar = c(0,0,0,0))
    plot.new()
    text(x = -0.05, y = 0.4, words[i], cex = 10, family = "mono", font = font, pos = 4, col = col)
    dev.off()
  }
  word_ims <- lapply(1:length(words), function(x){
    image_read(paste0("Temp/File_", formatC(x, digits = 2, flag = "0"), ".png"))
  })
  unlink("Temp", recursive = T)
  
  cloud_lim <- min(c(max_words, length(word_ims)))
  word_ras <- word_ims[1:cloud_lim]
  word_ras <- lapply(word_ras, as.raster)
  cloud_count <- char_counts[1:cloud_lim]
  cloud_freq <- freqs[1:cloud_lim]
  
  cloud_freq_min <- min(cloud_freq)
  
  cloud_freq_norm <- cloud_freq/cloud_freq_min
  
  #cloud_scale <- (scale[1] - scale[2]) * cloud_freq_norm + scale[2]
  
  letter_dim <- 10
  
  cloud_height <- cloud_freq_norm*letter_dim
  
  cloud_width <- (cloud_freq_norm*letter_dim)*cloud_count
  
  cloud_lines_lower <- c(0, cumsum(cloud_height))[1:cloud_lim]
  
  cloud_lines_lower <- cloud_lines_lower + seq(0, cloud_lim - 1, 1)
  
  cloud_lines_upper <- c(cumsum(cloud_height))
  
  cloud_lines_upper <- cloud_lines_upper + seq(0, cloud_lim - 1, 1)
  
  cloud_allign <- sample(seq(5,100,1), cloud_lim)
  
  cloud_bg <- ggplot(df <- data.frame()) + 
    geom_point() + 
    xlim(0, max(c(cloud_allign + cloud_width, cloud_lines_upper)) + 5) + 
    ylim(0, max(c(cloud_allign + cloud_width, cloud_lines_upper)) + 5) +
    theme_bw() +
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          panel.border = element_blank(),
          axis.ticks = element_blank(),
          axis.text = element_blank())
  
  cloud_plot <- paste0("cloud_bg + ", paste0("annotation_raster(word_ras[[", 1:cloud_lim, "]], ", cloud_allign, ", ", cloud_allign + cloud_width, ",", cloud_lines_lower,",", cloud_lines_upper,")", collapse = "+"))
  
  eval(parse(text = cloud_plot))
}

