library(igraph)
library(ggraph)

# CONFIG
congress = 116

nodes <- read.csv(paste(congress, "node_list.csv", sep = ""), header = TRUE, as.is = TRUE)
nodes <- nodes[!duplicated(nodes$id), ]
links <- read.csv(paste(congress, "edge_list.csv", sep = ""), header = TRUE, as.is = TRUE)

desc_edge = function(edge){
  if (nodes$party[nodes$id == edge[1]] == "I" |
      nodes$party[nodes$id == edge[1]] == "ID" |
      nodes$party[nodes$id == edge[2]] == "I" |
      nodes$party[nodes$id == edge[2]] == "ID"){
    return("I")
  }
  return(paste(nodes$party[nodes$id == edge[1]], nodes$party[nodes$id == edge[2]], sep = ""))
}

links$relation <- apply(links, 1, desc_edge)
net <- graph_from_data_frame(d = links, vertices = nodes, directed = TRUE)
senate_net <- delete.vertices(net, nodes$id[nodes$short_title != "Sen." | !nodes$in_office])
house_net <- delete.vertices(net, nodes$id[nodes$short_title == "Sen." | !nodes$in_office])

png(paste(congress, "senate_plot.png", sep = ""), height = 6.07, width = 7.14, units = "in", res = 300)
ggraph(senate_net, layout = "fr") +
  geom_edge_link(aes(color = E(senate_net)$relation), alpha = 0.1) +
  scale_edge_color_manual(name = "Direction", values = c("DD" = "dodgerblue1", "RR" = "firebrick1", "RD" = "dodgerblue4", "DR" = "firebrick4", "I" = "darkseagreen")) +
  geom_node_point(aes(color = V(senate_net)$party)) +
  scale_color_manual(name = "Party", values = c("D" = "dodgerblue1", "R" = "firebrick1", "I" = "darkseagreen", "ID" = "darkseagreen")) +
  labs(x = "", y = "") +
  coord_fixed() +
  theme_bw()
dev.off()


png(paste(congress, "house_plot.png", sep = ""), height = 6.07, width = 7.14, units = "in", res = 300)
ggraph(house_net, layout = "fr") +
  geom_edge_link(aes(color = E(house_net)$relation), alpha = 0.1) +
  scale_edge_color_manual(name = "Direction", values = c("DD" = "dodgerblue1", "RR" = "firebrick1", "RD" = "dodgerblue4", "DR" = "firebrick4", "I" = "darkseagreen")) +
  geom_node_point(aes(color = V(house_net)$party)) +
  scale_color_manual(name = "Party", values = c("D" = "dodgerblue1", "R" = "firebrick1", "I" = "darkseagreen", "ID" = "darkseagreen")) +
  labs(x = "", y = "") +
  coord_fixed() +
  theme_bw()
dev.off()
