function [x, V_TO] = takeoff_dist(file,Cl_def,Cd_def,payload,S,c_fric)
dry_mass = 3; %kg
mass = dry_mass + payload; %kg
g = 9.81;
density = 1.225; %[kg/m^3]
V_stall = sqrt((2.*mass.*g)./(density.*S.*Cl_def));
V_TO = 1.1.*V_stall; %[m/s]
W = mass*g;

%DATA IMPORT%
fid=fopen(file, 'r'); %apertura file
tline=fgetl(fid); %salta la prima riga di intestazione
a=fscanf(fid,'%f  %f  %f', [3 54]); %3 colonne di float
fclose(fid);
V_data=a(1,:)'; %colonna velocità
T_data=a(3,:)'; %colonna spinta (thrust)
T0 = T_data(1); %spinta statica

%NOTA: la colonna (2) ha la potenza, presente perchè può essere utile per
%altri script (es. potenza disponibile di ale)

%INTERPOLZIONE%
c = polyfit(V_data, T_data, 2);
y = polyval(c, linspace(0,max(V_data),numel(V_data)));
%interpola i dati di motocal per ottenere la parabola di spinta

%A e B sono due coefficienti necessari per il calcolo (vedi
%takeoff&landing.pdf)
A = g*(T0./W - c_fric); 
B = g/W * (0.5*density*S.*(Cd_def - c_fric.*Cl_def) + c(1));

%dist = 1./(2*B) .* log(A./(A - B.*(V_TO).^2));
%Dà problemi col logaritmo (numeri complessi a caso)

for i=1:6
    Vx = @(v) v./(A-B(i).*v.^2); %funzione da integrare
if i ==1
    x = integral(Vx, 0, V_TO(i)); %integrazione numerica
else
    x = [x integral(Vx, 0 ,V_TO(i))]; %come sopra ma per i valori successivi al primo
end

%Grafici%
figure(1)
%Parabola di spinta
hold on
grid on
title('Thrust vs Airspeed');
xlabel("Airspeed (m/s)");
ylabel("Thrust (N)");
plot(linspace(0,max(V_data),numel(V_data)), y, 'b', 'LineWidth', 2)
scatter(V_data, T_data,'r','.', 'LineWidth',0.5)

%Info
% disp(['Coefficiente spinta: ', num2str(c(1))])
% disp(['Spinta statica: ', num2str(T0), ' N'])
% disp(['Velocità di decollo: ', num2str(V_TO), ' m/s'])

end

