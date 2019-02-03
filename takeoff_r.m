nome_file = "giusto.txt";
c_friction = 0.04; %0.04 per asfalto asciutto
Cl_0 = 0.000; %a calettamento ala 0° %0.5219
Cd_0 = 0.000;
delta_Cl = [0.0000 0.0000 0.0000 0.0000 0.0000 0.0000]; %5°,10°,15°,20°,25°, 30°
delta_Cd = [0.0000 0.0000 0.0000 0.0000 0.0000 0.0000]; %valori da divisione Sistemi
Cl = delta_Cl + Cl_0;
Cd = delta_Cd + Cd_0;
dry_mass = 3; %kg body+elettronica
payload = [0 2 4 6 8 10 12]; %kg
def = [5 10 15 20 25 30]; %deflessione flap
S = 1.15; %[m^2]
mass = dry_mass + payload; %kg

%Generazione grafico
for i = 1:length(payload)
    [dist, v_to] = takeoff_dist(nome_file, Cl, Cd, payload(i), S, c_friction);
    %restituisce i valori di distanza alle varie deflessioni di flap
    %e anche la velocità di decollo se serve
    figure(2)
    hold on
    grid on
    text(7, dist(1), [num2str(payload(i)) 'kg'])
    xlabel('Flap deflection [°]');
    ylabel('Takeoff distance [m]');
    title('Flap deflection angle vs TO distance for multiple payloads');
    %plot(def, dist, 'LineWidth',1)
    yy = spline(def, dist, 5:.5:30); %faccio la spline perchè le cose angolose non ci piacciono
    plot(5:.5:30, yy, 'LineWidth', 1)
    
end

plot(5:5:30,60*ones(1,6), 'r', 'LineWidth', 2) %limite visivo dei 60 m di decollo massimo

