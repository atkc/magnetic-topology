clear
J=(3*10^-3)*1.602176565e-19/(2.9*10^-10); %meV/a -> J/m
D=(0.3*10^-3)*1.602176565e-19/(2.9*10^-10)^2; %meV/a^2 -> J/m^2
thick=(20*10^-9); %nm

B=1.6;
rd=(3:11);
r=rd*J/D;

Ha=B*(D^2/(2*J)); %in SI units

ee=sqrt(2/B);%cant change
fy=(besselk(1,rd./ee));%/(J/(100*10^-9));
figure
plot(r,log10(fy/(1)));
xlabel('r [ nm ]');
ylabel('log10( Fss [ J / thickness ] )');

figure
plot(r,log10(fy*(J/thick)));
xlabel('rd [ nm ]');
ylabel('log10 (Fss [N/m])');
