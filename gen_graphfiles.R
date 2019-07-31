library(httr)
library(jsonlite)

# CONFIG
congress = 116
data_dir <- paste(getwd(), "/congress/data/", sep = "")
bill_dir <- paste(data_dir, congress, "/bills/", sep = "")
key <- add_headers("X-API-Key" = readLines("api_key.txt"))

write_nodelist = function(){
  senate_members <- GET(paste("https://api.propublica.org/congress/v1/", congress, "/senate/members.json", sep=""), key)
  senate_members <- rawToChar(senate_members$content)
  senate_members <- unlist(fromJSON(senate_members)$results, recursive = FALSE)$members
  house_members <- GET(paste("https://api.propublica.org/congress/v1/", congress, "/house/members.json", sep=""), key)
  house_members <- rawToChar(house_members$content)
  house_members <- unlist(fromJSON(house_members)$results, recursive = FALSE)$members
  members <- merge(senate_members, house_members, by = intersect(colnames(senate_members), colnames(house_members)), all = TRUE)
  
  write.csv(members, file = paste(congress, "node_list.csv", sep = ""), row.names = FALSE)
  
  return(members)
}

get_mat = function(dir, write = TRUE){
  members_id = write_nodelist()$id
  n_members <- length(members_id)
  conn_mat <- matrix(0, nrow = n_members, ncol = n_members)
  colnames(conn_mat) <- members_id
  rownames(conn_mat) <- members_id

  for(bill_type in list.files(bill_dir)){
    bills = list.files(paste(bill_dir, bill_type, "/", sep = ""))
    for (bill in bills){
      bill_path <- paste(bill_dir, bill_type, "/", bill, "/data.JSON", sep="")
      if (file.exists(bill_path)){
        bill_json <- fromJSON(bill_path)
        for (cosponsor_id in bill_json$cosponsors$bioguide_id){
          conn_mat[bill_json$sponsor$bioguide_id, cosponsor_id] = conn_mat[bill_json$sponsor$bioguide_id, cosponsor_id] + 1
        }
      }
    }
  }
  
  if (write){
    write.csv(conn_mat, file = paste(congress, "cosponsorship_mat.csv", sep = ""), row.names = FALSE)
  }
  
  return(conn_mat)
}

write_edgelist = function(conn_mat){
  non_zero =  which(conn_mat != 0, arr.ind = TRUE)
  cosp = colnames(conn_mat)[non_zero[, 2]]
  spon = rownames(conn_mat)[non_zero[, 1]]
  edge_list = data.frame(cosponsor_id = cosp, sponsor_id = spon, num = conn_mat[which(conn_mat != 0)])
  
  write.csv(edge_list, file = paste(congress, "edge_list.csv", sep = ""), row.names = FALSE)
  
  return(edge_list)
}

invisible(write_nodelist())
write_edgelist(get_mat(bill_dir, write = FALSE))