# This code solves the dynamic programming code for Econ 260A

rm(list=ls(all=TRUE)) 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
width=2;
library(ggplot2)
library(dplyr)
library(stringr)
library(cowplot)

DynamicObjective260A=function(H,X,a,b,delta,r,K,q,Xgrid,V)
{
  #To be used in optimization...this thing is minimized by choosing H
  Pi = a*H - b*(H^2)/2
  Xprime = (X-H) + r*(X-H)*(1-(X-H)/K)
  Vnext = spline(Xgrid,V,xout=Xprime,method="natural")
  negout = -(Pi + delta*Vnext$y)
  return(negout)
}

a=10
b=.2
delta=1/1.1
r=.8
K=100
q=.5
X0=K/5

T=30
XL=100

Xgrid = seq(.1,K,length.out=XL) #Grid over state space
Vmat = matrix(0,nrow=length(Xgrid),ncol=T+1)
Hstar=matrix(NA,nrow=length(Xgrid),ncol=T) #Initialize the control vector 
Vnew=matrix(NA,nrow=length(Xgrid),ncol=1) #Initialize the "new" value function 

for (t in seq(T,1,-1))
{
  print(t)
  for (i in seq(1,length(Xgrid),1))
  {
    guess=0       
    X = Xgrid[i]    
    #This finds optimal policy function 
    Thing = optim(par=guess,fn=DynamicObjective260A,gr=NULL,lower=0,upper=X,X=X,a=a,b=b,delta=delta,r=r,K=K,q=q,Xgrid=Xgrid,V=Vmat[,t+1],method="L-BFGS-B")
    Htmp = Thing$par
    Valtmp = Thing$value
    Hstar[i,t] = Htmp #the optimal Harvest for each stock 
    Vnew[i,1] = -Valtmp
   }
  Vmat[,t]=Vnew
}

xg=data.frame(Xgrid)
hdf=data.frame(Hstar)
vdf=data.frame(Vmat[,1:T])
II=data.frame(index=1:XL)
hdf2 = bind_cols(II,xg,hdf)
vdf2 = bind_cols(II,xg,vdf)
hdf_new = gather(data=hdf2,key="Xtime",value="harvest_opt",num_range('X',1:T)) %>% 
  mutate(T_end=T+1-as.numeric(str_replace(Xtime, 'X', ''))) %>%
  select(-Xtime)
vdf_new = gather(data=vdf2,key="Xtime",value="value_function",num_range('X',1:T)) %>% 
  mutate(T_end=T+1-as.numeric(str_replace(Xtime, 'X', ''))) %>%
  select(-Xtime)
DF = left_join(hdf_new,vdf_new,by=c("index", "Xgrid", "T_end"))
DF_converge = DF %>%
  filter(T_end==T)

P1 = ggplot(data=DF) +
  geom_line(aes(x=Xgrid,y=harvest_opt,color=T_end,group=T_end),size=1) +
  xlab("Stock, X") +
  ylab("Opt. Harvest") +
  scale_color_continuous(name="Time to End")

P2 = ggplot(data=DF) +
  geom_line(aes(x=Xgrid,y=value_function,color=T_end,group=T_end),size=1) +
  xlab("Stock, X") +
  ylab("Value Fn.") +
  scale_color_continuous(name="Time to End")

P3 = plot_grid(P1,P2,nrow=2)

ggsave(filename="../Converge.pdf",plot=P3)




# Now do Forward Sweep
XX=vector() #Initialize vectors
HH=vector()
Pi=vector()
Pipv=vector()
XX[1] = X0 #Starting stock for forward sweep

#Forward Simulation
simtime = seq(1,T,length.out=T)
for (tt in 1:T)
{
HHtmp= spline(Xgrid,Hstar[,tt],xout=XX[tt],method="natural") #Interpolate to find harvest
HH[tt] = HHtmp$y #Use interpolated harvest in period tt
XX[tt+1] = (XX[tt]-HH[tt]) + r*(XX[tt]-HH[tt])*(1-(XX[tt]-HH[tt])/K)
Pi[tt] = a*HH[tt] - b*(HH[tt]^2)/2
Pipv[tt] = (delta^tt)*Pi[tt]
}

DFsim = data.frame(time=simtime,X=XX[1:T],H=HH[1:T],Profit=Pi[1:T],PVProfit=Pipv[1:T])

S1 = ggplot(data=DFsim) +
  geom_line(aes(x=time,y=H),color="blue",size=2) +
  xlab("Harvest")

S2 = ggplot(data=DFsim) +
  geom_line(aes(x=time,y=X),color="blue",size=2) +
  xlab("Stock")


S3 = ggplot(data=DFsim) +
  geom_line(aes(x=time,y=Profit),color="blue",size=2)


S4 = ggplot(data=DFsim) +
  geom_line(aes(x=time,y=PVProfit),color="blue",size=2)

P4 = plot_grid(S1,S2,S3,S4,ncol=2,nrow=2)
P4

ggsave(filename="../Simulation.pdf",plot=P4)



