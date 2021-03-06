#' plots the 96 dimensional mutational spectrum
#' @param  df_snvs a data frame with 96-dimensional spectra on its columns
#' @param file_name the name of the plot to be generated with the proper extension
#' e.g. "test.pdf", "test.png", etc
#' @param labely string for the label of the y axis
#' @param  legend boolean determining whether legend should be printed
#' @param text_size size of the text of the x and y axis text and titles
#' @param signame a text to be printed on the figure

plot_tribase_dist <- function(df_snvs, file_name = "test.png", labely = "N SNVs", legend = T, 
                              text_size = 10, signame = ''){


  typeref <- c(rep('C',48), rep('T',48))
  typealt <- c(rep('A',16), rep('G',16), rep('T',16), 
               rep('A',16), rep('C',16),rep('G',16))


  subtype <- c(rep(c('ACA','ACC','ACG','ACT',
                     'CCA','CCC','CCG','CCT',
                     'GCA','GCC','GCG','GCT',
                     'TCA','TCC','TCG','TCT'), 3),
               rep(c('ATA','ATC','ATG','ATT',
                     'CTA','CTC','CTG','CTT',
                     'GTA','GTC','GTG','GTT',
                     'TTA','TTC','TTG','TTT'), 3))


  snvs <- rep('', 96) 
  context_snvs <- rep('', 96)
  for(i in 1:96){
    snvs[[i]] <- paste0(typeref[[i]], ">", typealt[[i]])
    context_snvs[[i]] <- paste0(snvs[[i]], ":", subtype[[i]])
  }

  df_snvs$context <- context_snvs
  df_snvs$snvs <- snvs
  df_snvs$subtype <- subtype
  
  molten_table <- reshape2::melt(df_snvs, 
                       id = c('context', 'snvs', 'subtype'))

  medians <- by(molten_table, molten_table$context, 
                function(x){median(x[,'value'])})

  df_med <- data.frame(context = names(medians),
                       median = c(unlist(medians)))
  
  molten_table$median <- df_med$median[match(molten_table$context, df_med$context)]

  molten_table_error <- Rmisc::summarySE(molten_table, 
                                         measurevar = "value", 
                                         groupvars = c("context", "snvs", "median"), 
                                         na.rm = TRUE)

 
#  c_snv_palette <- c("#800080", "#FF9912", "#436EEE", "#ffdf12", "#27408B", "#E066FF")
#  c_snv_pal_label <- c(rep("#800080",16), 
#                       rep("#FF9912",16),
#                       rep("#436EEE",16), 
#                       rep("#ffdf12",16), 
#                       rep("#27408B",16), 
#                       rep("#E066FF",16))

  c_snv_palette <- c("#824b82", "#f9bb68", "#89a0e5", "#fcea79", "#616b89", "#cf8ae2")
  c_snv_pal_label <- c(rep("#824b82", 16), 
                       rep("#f9bb68", 16),
                       rep("#89a0e5", 16),
                       rep("#fcea79", 16),
                       rep("#616b89", 16),
                       rep("#cf8ae2", 16))
 
  plot <- ggplot2::ggplot(molten_table_error, 
                         ggplot2::aes(x = context, y = value, fill = snvs), 
                         color = 'black')

  plot <- plot + ggplot2::geom_bar(position = ggplot2::position_dodge(), 
                                  stat = 'identity', color = 'white', size = 0.1)
  plot <- plot + ggplot2::geom_errorbar(ggplot2::aes(ymin = value - se, ymax = value + se),
                                        color = "blue")
  plot <- plot + ggplot2::scale_fill_manual(name = "sig_group", values = c_snv_palette)

  plot <- plot + ggplot2::theme_bw() 
  plot <- plot + ggplot2::theme(axis.text.x = ggplot2::element_text(angle=90, hjust=1, size = text_size - 5, 
                                                                    colour = c_snv_pal_label), 
                                axis.text.y = ggplot2::element_text(size = text_size),
                                axis.title.y = ggplot2::element_text(size = text_size), 
                                text = ggplot2::element_text(size = 20),
                                legend.title = ggplot2::element_blank(),
                                legend.justification = c(1,1),
                                legend.text = ggplot2::element_text(size = text_size, face = "bold"),
                                legend.position="top", 
                                panel.grid.major = ggplot2::element_blank(),
                                panel.grid.minor = ggplot2::element_blank())
  if(!legend) plot <- plot + ggplot2::theme(legend.position = "none")

  plot <- plot + ggplot2::ylab(labely) + ggplot2::xlab("") 
  plot <- plot + ggplot2::ylim(0, max(molten_table_error$value)*1.2)
  plot <- plot + ggplot2::scale_x_discrete(labels = subtype)
  plot <- plot + ggplot2::annotate('text', x = -Inf, y = Inf, hjust = 0, vjust = 1, label = signame, size = 4)
#  plot <- plot + ggplot2::geom_text(ggplot2::aes(x = 2, y = Inf, hjust = 0, vjust = 1, label = signame), 
#                                    size = as.integer(text_size/3))
  plot <- plot + ggplot2::guides(fill = ggplot2::guide_legend(nrow = 1))

  return(plot)
}
