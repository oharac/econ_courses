
source('https://raw.githubusercontent.com/oharac/src/master/R/common.R')
library(cowplot)

calc_cost <- function(h = 1, x, B, interval = .001) {
  ### h = 1 will return the marginal cost at stock x
  
  if(x < 0 | h < 0 | h > x) {
    stop('Error: calc_cost params invalid: x =', x, '; h =', h)
  }
  
  # tot_cost <- B * (log(x) - log(x - h))
  ### This would result in an error if optimal policy (e.g.
  ### in time TT) is to harvest all.  Adding a tiny fraction to x
  ### should avoid this.
  tot_cost <- B * (log(x + interval) - log(x - h + interval))
  
  return(tot_cost)
}

calc_payoff <- function(h, x, args) {
  p <- args['p'];  B <- args['B'];  r <- args['r'];  K <- args['K']
  ### payoff for a given harvest
  if(h < 0) {
    warning('Harvest must not be negative. Setting h = 0.')
    h <- 0
  }
  if(h > x) {
    warning('Harvest must not exceed stock. Setting h = x.')
    h <- x
  }
  rent <- p * h
  cost <- calc_cost(h, x, B)
  profit <- rent - cost
  
  return(profit)
}

calc_motion <- function(y, r, K) {
  f_y <- y + r * y * (1 - y / K)
  x_tplus1 <- f_y
  return(x_tplus1)
}
  
calc_dpe <- function(harvest, stock,
                     payoff_args, coll_act_cost,
                     delta, r, K,
                     x_vec, V) {
  ### To be used in optimization...this function is minimized by choosing h
  
  ### Calc payment and x_{t+1} terms
  pay_t <- calc_payoff(harvest, stock, payoff_args)
  
  ### calc stock status for no shock, then low and high shocks from that
  x <- calc_motion(y = stock - harvest, r = r, K = K)

  v_tplus1 <- spline(x_vec, V, xout = x, method = 'natural') %>%
    .$y

  ### return negative value; optim will minimize this, maximizing the payout
  negout <- -(pay_t - coll_act_cost + delta * v_tplus1)
  
  if(is.infinite(negout)) negout <- 0
  
  return(negout)
}

## Optimization functions
# `optimize_dpe()` iterates over $t$ and $x$ to determine optimal harvests and 
# values. It returns a list with the $h^*$ matrix and $V$ matrix.

optimize_dpe <- function(x_vec, TT, payoff_args, delta, r, K, coll_act_cost = 0) {
  ### Iterates for each time period and each stock value to determine optimal
  ### policy and optimal value functions.
  # cat('in optimize_dpe: z = ', z, '...\n')
  
  v_mat  <- matrix(0,  nrow = length(x_vec), ncol = TT + 1)
    ### initialize value matrix
  h_star <- matrix(NA_real_, nrow = length(x_vec), ncol = TT)
    ### Initialize the control vector 
  v_new  <- rep(NA_real_, length = length(x_vec)) 
    ### Initialize the 'new' value function 

  for (t in TT:1) { ### count down from end time to beginning time
    ### t <- TT
    message('Period t = ', t)
    for (i in seq_along(x_vec)) {
      ### i <- 1
      guess <- 0       
      x <- x_vec[i]    
      
      ### This finds optimal policy function 
      thing <- optim(par = guess, 
                     fn  = calc_dpe, 
                     gr  = NULL, 
                     lower = 0, upper = x, ### bounds on h
                     stock = x,
                     payoff_args = payoff_args, 
                     coll_act_cost = coll_act_cost,
                     delta = delta,
                     r = r, K = K,
                     x_vec = x_vec, V = v_mat[ , t+1],
                     method = 'L-BFGS-B')
  
      h_star[i, t] <- thing$par 
        ### the optimal parameter
      v_new[i] <- -thing$value
        ### the value of the dpe at the optimal parameter

    } ### end of loop for this value of x in time t
    
    v_mat[ , t] = v_new
  } ### end of t loop
  
  return(list(h_star, v_mat))
}

# `assemble_df()` takes the outputs from `optimize_dpe()` and arranges them 
# into a more convenient format: a dataframe with variables `index`, `x_vec`, 
# `harvest_opt`, `t_end`, and `value_fn`.

assemble_df <- function(opt_fxns, x_vec, TT, K) {
  ### convert matrices to data.frames, clip v_mat to T = 30
  h_df <- opt_fxns[[1]] %>% data.frame()
  v_df <- opt_fxns[[2]][ , 1:TT] %>% data.frame()
  
  harvest_df <- data.frame(index = 1:K,
                           x_vec,
                           h_df)
  value_df   <- data.frame(index = 1:K,
                           x_vec,
                           v_df)
  
  h_df_long <- harvest_df %>%
    gather(key = xtime, value = harvest_opt, paste0('X', 1:TT)) %>% 
    mutate(xtime = as.numeric(str_extract(xtime, '[0-9]+'))) %>%
    mutate(t_end = TT + 1 - xtime) %>%
    select(-xtime)
  
  v_df_long <- value_df %>%
    gather(key = xtime, value = value_fn, paste0('X', 1:TT)) %>% 
    mutate(xtime = as.numeric(str_extract(xtime, '[0-9]+'))) %>%
    mutate(t_end = TT + 1 - xtime) %>%
    select(-xtime)
  
  df <- left_join(h_df_long, v_df_long, 
                  by = c('index', 'x_vec', 't_end'))
  
  return(df)
}


plot_results <- function(sims_df, cost_df) {
  
  present_value <- sims_df %>%
    group_by(sim) %>%
    mutate(discount = delta ^ (year - 1)) %>%
    summarize(`excluding c_p`   = sum(profit * discount) / n_fishers,
              `including c_p` = sum((profit - cost_enf) * discount) / n_fishers) %>%
    gather(type, PV, -sim) %>%
    ungroup()
  
  crashes <- sims_df %>%
    filter(year == max(year)) %>%
    summarize(crashes = sum(shirk == 1),
              sims = n(),
              pct_crashes = crashes / sims)
  
  means_df <- sims_df %>%
    group_by(year) %>%
    summarize(harvest   = mean(harvest),
              poach     = mean(poach),
              stock     = mean(stock),
              res_stock = mean(res_stock))
  
  harv_plot <- ggplot(sims_df, aes(x = year, y = harvest, color = sim)) +
    ggtheme_plot(base_size = 6) +
    geom_line(data = means_df, size = 1.5, color = 'grey30') +
    geom_line(aes(group = sim), alpha = .1, show.legend = FALSE) +
    scale_color_viridis_c() +
    ylim(c(0, NA)) + 
    labs(title = sprintf('Harvest (crashes: %s of %s, %s%%)', 
                         crashes$crashes, crashes$sims, 
                         round(crashes$pct_crashes * 100, 1)),
         x = 'Simulation year')
  
  cost_dist_plot <- ggplot(cost_df %>% mutate(sim = as.character(sim)), 
                           aes(x = init_cost)) +
    ggtheme_plot(base_size = 6) +
    theme(axis.title.y = element_blank(),
          axis.text.y = element_blank()) +
    geom_histogram(fill = '#440154', color = 'grey60', alpha = .5,
                   breaks = seq(b_init / n_fishers, b_init, length.out = 30),
                   size = .25, show.legend = FALSE) +
    geom_vline(xintercept = c(b_init / n_fishers, b_init), 
               linetype = 'dashed') +
    labs(title = 'Participation cost',
         x = 'Initial c_p')
  
  pv_plot <- ggplot(present_value, 
                    aes(x = PV, fill = type)) +
    ggtheme_plot(base_size = 6) +
    theme(legend.position = c(.6, .8),
          legend.key.size = unit(.5, "line")) +
    theme(axis.title.y = element_blank(),
          axis.text.y = element_blank()) +
    geom_histogram(alpha = .5, color = 'grey60', position = 'identity',
                   breaks = seq(0, round(pv_base_df[1, 2] + 50, -2), length.out = 30),
                   size = .25) +
    geom_vline(data = pv_base_df, aes(xintercept = pcpv_mean, color = type),
               linetype = 'dashed',
               show.legend = FALSE) +
    scale_color_brewer(palette = 'Dark2') +
    scale_fill_brewer(palette = 'Dark2') +
    labs(title = 'Per-capita Present Value',
         x = 'per-capita PV over 15 years', fill = '')

  plot_row <- plot_grid(cost_dist_plot, harv_plot, pv_plot,
                        ncol = 3, align = 'h', rel_widths = c(1, 2, 2))
  return(plot_row)

}

calc_yrs_to_crash <- function(sims_df) {
  years_to_crash <- sims_df %>%
    filter(last(shirk) == 1) %>%
    mutate(cum_harvest = cumsum(harvest)) %>%
    filter(cum_harvest != last(cum_harvest)) %>%
    summarize(crash_year = max(year) + 1)

  return(years_to_crash)
}

mc_run_sims <- function(cost_df, sims, replace_dist, cores = 24) {
  ### At the risk of crappy programming practices, I will leave
  ### most of the parameters in the global environment to be
  ### pulled in as needed...
  
  sims_list <- parallel::mclapply(X = 1:sims, mc.cores = cores,
    FUN = function(j) {
      ### j <- 2
      
      ### Set up vecs and initial values for this simulation
      x <- h <- b <- rep(0, length = sim_yrs)
      x[1] <- x_star  ### start at optimally managed x, ready to harvest
      b[1] <- b_init ### benefit from optimally managed x, no poaching
      
      cost_vec <- cost_df %>%
        filter(sim == j) %>%
        .$init_cost
      
      ### Poaching based on benefits from prior period - so
      ### start with shirk[1] = 0, and calculate poaching rate
      ### in next period based on benefits and costs in this period
      ### This will be the proportion of non-cooperative fishers.
      shirk_rate <- poach_harv <- rep(0, length = sim_yrs)

      ### set up period cost vectors: one for total cost of all fishers,
      ### and one for total cost of those who participate in enforcement
      cost_all_fishers <- cost_enforce <- rep(0, length = sim_yrs)
      
      for (t in 1:sim_yrs) { ### t <- 3
        
        # cat('t = ', t, '\n')
        h[t] <-  spline(converged_df$x_vec, converged_df$harvest_opt,
                        xout = x[t], method = 'natural') %>% 
          .$y %>% round(3)
        if(h[t] < 0) {
          warning('Harvest ', h[t], '< 0... setting to zero\n')
          h[t] <- 0
        }
        
        ### Calc benefit of participation in fishery based on no poaching
        ### Note this is the *individual* payoff
        b[t] <- calc_payoff(h[t], x[t], payoff_args)

        ### calc proportion of fishers who drop out for next period
        # delta / (1 - delta) * (b[t] - c_i) > c_i - b[t] / n_fishers
        if(t > 1) {
          p_df <- data.frame(cost = cost_vec,
                             benefit = b[t-1]) %>%
            mutate(benefit_to_shirk  = cost - benefit / n_fishers,
                   cost_of_expulsion = delta / (1 - delta) * (benefit - cost),
                   shirk  = benefit_to_shirk > obs_rate * cost_of_expulsion,
                   obs    = runif(n()) < obs_rate,
                   caught = ifelse(shirk & obs, TRUE, FALSE))
          
          shirkers <- p_df$shirk
          caught   <- p_df$caught
          shirk_rate[t] <- sum(shirkers) / n_fishers
        } else {
          ### for period 1, no defections
          shirkers <- caught <- rep(FALSE, n_fishers)
          shirk_rate[t] <- 0
        }
        
        ### calc plot-level mean poaching
        poach_harv[t] <- shirk_rate[t] * ((x[t] - h[t]) - x_oa)
        
        ### calc fishery-level fisher costs for this period
        cost_all_fishers[t] <- sum(cost_vec)
        cost_enforce[t]     <- sum(cost_vec[!shirkers])
        ### update fisher cost list for those expelled from fishery
        cost_vec[caught] <- gen_cost_vec(n = sum(caught), 
                                           replace_dist)
        
        # cat('t =', t, ': x[t] =', x[t], '... z =', z, '... h[t] =', h[t], '...\n')
        
        x[t+1] <- calc_motion(y = x[t] - h[t] - poach_harv[t], r = r, K = K)
      }
      
      ### This dataframe includes summed values across all plots
      sim_df <- data.frame(year    = 1:sim_yrs, 
                           stock   = (x * n_fishers)[1:sim_yrs],
                           harvest = h * n_fishers,
                           profit  = b * n_fishers,
                           shirk   = shirk_rate[1:sim_yrs],
                           poach   = poach_harv[1:sim_yrs] * n_fishers,
                           cost_all = cost_all_fishers,
                           cost_enf = cost_enforce) %>%
        mutate(sim = j)
    })
  
  sims_df <- bind_rows(sims_list) %>%
    mutate(res_stock = stock - harvest - poach)
  
  return(sims_df)
}


gen_cost_vec <- function(n, cost_dist) {
  if(cost_dist$dist == 'runif') {
    cost_vec <- runif(n, cost_dist$min, cost_dist$max)
  } else if(cost_dist == 'rtruncnorm') {
    cost_vec <- truncnorm::rtruncnorm(n, a = cost_dist$min, b = cost_dist$max, 
                                      mean = cost_dist$mean, sd = cost_dist$sd)
  } else {
    stop('Accepts either "runif" or "rtruncnorm" as distributions')
  }
  return(cost_vec)
}
