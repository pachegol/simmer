ReplicationContainer<-setRefClass("ReplicationContainer", fields=list(
  simulators = "vector"))

ReplicationContainer$methods(build_container = function(sim_obj, n_replications = 1){
  simulators<<-sapply(1:n_replications, function(x) deep_copy_simulator(sim_obj))
  return(.self)
})


ReplicationContainer$methods(simmer = function(until = Inf){
  for(sim in .self$simulators){
    sim$simmer(until)
  }
  
  return(.self)
})

ReplicationContainer$methods(init_sim = function(until = Inf){
  for(sim in .self$simulators){
    sim$init_sim()
  }
  
  return(.self)
})

#' Replicate the simulation n times
#' @param sim_obj the Simulator object
#' @param n_replications the number of desired replications
#' @export
replicator<-function(sim_obj, n_replications){
  replication_container<-ReplicationContainer()
  replication_container$build_container(sim_obj, n_replications)
}


deep_copy_simulator<-function(sim_obj){
  obj_copy <- sim_obj$copy()
  obj_copy$resources_monitor<-sapply(obj_copy$resources_monitor, function(obj) obj$copy())
  obj_copy$entities_monitor<-sapply(obj_copy$entities_monitor, function(obj) obj$copy())
  obj_copy
}
