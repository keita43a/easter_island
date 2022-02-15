# Steady state

library(dplyr)
library(ggplot2)
library(viridis)


# Resource dynamics
# Define the function of resource dynamics (Logistic growth)

S1 = function(r,K,S,L,alpha=10^-5,beta=0.4){
  S + r*S*(1-S/K)-alpha*beta*L*S
}


# Population dynamics
# Define the function of population dynamics (Multhasian)

L1 = function(L, S, birthdeath=-0.1, phi=4, alpha=10^-5, beta = 0.4){
  L + L*(birthdeath + phi*alpha*beta*S)
}


# ----- Run simulation ------

mat = matrix(nrow=300,ncol=2)
L_int = 40 # Initial value for population

# Change the initial parameters 
r_int = 0.2    # r: intrinsic growth rate
S_int = 12000  # K: Carrying capacity 

# Simulation by loop
for(t in 1:300){ # 300 years
  if(t==1){
    mat[t,1]= L_int
    mat[t,2]= S_int
  }
  if(t>1){
    mat[t,1] = L1(L=mat[t-1,1],S=mat[t-1,2])
    mat[t,2] = S1(L=mat[t-1,1],S=mat[t-1,2], K=S_int,r = r_int)
  }
}

# Convert into a data frame
dat = data.frame(mat) %>%
  mutate(time = row_number()) %>%
  rename("Population" = 1,"Resource Stock" = 2) %>%
  tidyr::pivot_longer(cols = c("Population","Resource Stock"),names_to = "variable",
                      values_to = "values")

# Make plot 
plot_sim = ggplot(dat, aes(x=time, y=values, col = variable)) +
  geom_line() + 
  theme_bw() +
  scale_color_viridis_d() +
  annotate("text", x = 250,y=0.9*S_int, label = paste("italic(K)==",S_int), parse= TRUE) +
  annotate("text", x = 250,y=0.80*S_int, label = paste("italic(r)==",r_int), parse= TRUE) +
  theme(legend.position = "bottom")

# Show plot
plot_sim

# Save plot
ggsave(paste0("figure/plot_K_",S_int,"_r_",r_int,".png"),plot = plot_sim,height = 4.5, width = 8)




