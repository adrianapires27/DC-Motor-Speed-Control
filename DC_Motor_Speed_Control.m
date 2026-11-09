% Adriana Pires, 113223
% Ines Ferreira, 114164
% 
%% 1.1 - Determinar tensões para 600 rpm e 1200 rpm
% -Determinar experimentalmente as tensões que colocam o motor
% em regime estacionário a 600 rpm e 1200 rpm 
% -Registar os sinais medidos

clear; clc; close all;

% Parâmetros básicos:
Ts = 0.05;               % tempo entre medições (s)
Tss = 9;                 % tempo de estabilização (s)
RT050_SetLoadState(0);   % gerador sem carga
pause(1);

tolerancia_velocidade = 5;    % margem de erro (rpm)
v_limite = 3;                 % limite de segurança da tensão

% Variáveis de registo:
tempo = [];
rpm = [];
tensao = [];
t = 0;

% Encontrar tensão para 600 rpm
fprintf('\n A procurar 600 rpm \n');
v_inicial = 1;         % valor inicial de tensão
v_alvo = 600;          % velocidade alvo

while true

    % Aplica tensão e espera até estabilizar:
    RT050_SetMotorVoltage(v_inicial);
    pause(Tss); 

    % Mede a velocidade real do motor várias vezes (10 amostras)
    % Calcula a média dessas leituras
    soma = 0;
    for k = 1:10
        soma = soma + RT050_GetMotorSpeed();
        pause(Ts);
    end

    rpm_med = soma / 10;        %velocidade média real do motor
    fprintf('%.2f V -> %.1f rpm\n', v_inicial, rpm_med);

    % Regista dados:
    tempo(end+1) = t;           %instante atual
    rpm(end+1) = rpm_med;       %velocidade medida
    tensao(end+1) = v_inicial;  %tensão aplicada
    t = t + Tss;                %atualiza o tempo

    % Calcula erro:
    erro_velocidade = abs(rpm_med - v_alvo);

    % Passo de tensão adaptativo:
    if rpm_med < 500
        v_passo = 0.05;        %passo grande até ~500 rpm
    elseif erro_velocidade > 50
        v_passo = 0.02;        %passo médio
    elseif erro_velocidade > 20
        v_passo = 0.01;        %passo pequeno
    else
        v_passo = 0.005;       %passo muito pequeno
    end

    % Condição de paragem:
    if erro_velocidade <= tolerancia_velocidade
        fprintf('Estabilizado em %.1f rpm (%.3f V)\n', rpm_med, v_inicial);
        v_600 = v_inicial;
        break;
    end

    % Ajusta tensão:
    if rpm_med < v_alvo
        v_inicial = v_inicial + v_passo;
    else
        v_inicial = v_inicial - v_passo;
    end

    v_inicial = max(min(v_inicial, v_limite), 0); %garante que não ultrapassa limite
end

% Regista estabilidade a 600 rpm:
fprintf('Ponto de estabilização a 600 rpm \n');
for k = 1:30
    r = RT050_GetMotorSpeed();
    tempo(end+1) = t;
    rpm(end+1) = r;
    tensao(end+1) = v_600;
    t = t + Ts;
    pause(Ts);
end

RT050_SetMotorVoltage(0);
pause(5);

% Encontrar tensão para 1200 rpm:
fprintf('\n A procurar 1200 rpm \n');
v_inicial = v_600 + 0.1;  % começa logo acima da anterior
v_alvo = 1200;

while true

    % Aplica tensão e espera até estabilizar:
    RT050_SetMotorVoltage(v_inicial);
    pause(Tss);

    soma = 0;

    % Mede a velocidade real do motor várias vezes (10 amostras)
    % Calcula a média dessas leituras
    for k = 1:10
        soma = soma + RT050_GetMotorSpeed();
        pause(Ts);
    end
    
    rpm_med = soma / 10;        %velocidade média real do motor
    fprintf('%.2f V -> %.1f rpm\n', v_inicial, rpm_med);

    % Regista dados:
    tempo(end+1) = t;               %instante atual
    rpm(end+1) = rpm_med;           %velocidade medida
    tensao(end+1) = v_inicial;      %tensão aplicada
    t = t + Tss;                    %atualiza o tempo

    % Calcula erro:
    erro_velocidade = abs(rpm_med - v_alvo); 

    % Passo de tensão adaptativo:
    if rpm_med < 1000
        v_passo = 0.05;                 %passo grande até ~500 rpm
    elseif erro_velocidade > 50
        v_passo = 0.02;                 %passo médio
    elseif erro_velocidade > 20
        v_passo = 0.01;                 %passo pequeno
    else
        v_passo = 0.005;                %passo muito pequeno
    end

    % Condição de paragem:
    if erro_velocidade <= tolerancia_velocidade
        fprintf('Estabilizado em %.1f rpm (%.3f V)\n', rpm_med, v_inicial);
        v_1200 = v_inicial;
        break;
    end

    if rpm_med < v_alvo
        v_inicial = v_inicial + v_passo;
    else
        v_inicial = v_inicial - v_passo;
    end

    v_inicial = max(min(v_inicial, v_limite), 0); %garante que não ultrapassa limite
end

% Regista estabilidade a 1200 rpm:
fprintf('Ponto de estabilização a 1200 rpm \n');
for k = 1:30
    r = RT050_GetMotorSpeed();
    tempo(end+1) = t;
    rpm(end+1) = r;
    tensao(end+1) = v_1200;
    t = t + Ts;
    pause(Ts);
end

RT050_SetMotorVoltage(0);
fprintf('\nMotor desligado. Ensaio concluído.\n');

% Gráficos de resultados:
figure;
subplot(2,1,1);
plot(tempo, rpm, 'r', 'LineWidth', 1.3);
xlabel('Tempo (s)');
ylabel('Velocidade (rpm)');
title('Evolução da velocidade do motor');
yline(600,'--k','600 rpm'); 
yline(1200,'--k','1200 rpm');
grid on;

subplot(2,1,2);
plot(tempo, tensao, 'b', 'LineWidth', 1.3);
xlabel('Tempo (s)');
ylabel('Tensão (V)');
title('Evolução da tensão aplicada');
grid on;

v_600_encontrada = v_600;
v_1200_encontrada = v_1200;

%% 1.2 — Estabilizar a 900 rpm, ensaios dinâmicos ΔV(t) / Δω(t), parâmetros da função de transferência de 3ª ordem
%v(t)-> sinusoide

v_600 = v_600_encontrada;
v_1200 = v_1200_encontrada;

v_inicial = (v_600 + v_1200)/2;   % ~900 rpm
v_alvo = 900;

tempo = [];
rpm = [];
tensao = [];
t = 0;

fprintf('1.2 - Ajustar até ~900 rpm\n');

while true
    RT050_SetMotorVoltage(v_inicial);
    pause(Tss);

    soma = 0;
    for k = 1:10 %media de 10 amostras
        soma = soma + RT050_GetMotorSpeed();
        pause(Ts);
    end
    rpm_med = soma/10;

    % Regista dados:
    tempo(end+1) = t;
    rpm(end+1) = rpm_med;
    tensao(end+1) = v_inicial;
    t = t + Tss;

    erro_velocidade = abs(rpm_med - v_alvo);

    if rpm_med < 700
        v_passo = 0.05;
    elseif erro_velocidade > 50
        v_passo = 0.02;
    elseif erro_velocidade > 20
        v_passo = 0.01;
    else
        v_passo = 0.005;
    end

    if erro_velocidade <= tolerancia_velocidade
        v_900 = v_inicial;
        omega_ref = rpm_med;
        break;
    end

    if rpm_med < v_alvo
        v_inicial = v_inicial + v_passo;
    else
        v_inicial = v_inicial - v_passo;
    end
end

% Estabilização:
for k = 1:100
    r = RT050_GetMotorSpeed();
    tempo(end+1) = t;
    rpm(end+1) = r;
    tensao(end+1) = v_900;
    t = t + Ts;
    pause(Ts);
end

% Gráficos estacionário:
figure;
subplot(2,1,1);
plot(tempo, rpm,'r','LineWidth',1.3);
xlabel('Tempo (s)');
ylabel('rpm');
grid on;

subplot(2,1,2);
plot(tempo, tensao,'b','LineWidth',1.3);
xlabel('Tempo (s)');
ylabel('V');
grid on;

fprintf('\nMotor estabilizado em %.1f rpm\n', omega_ref);

% Ensaio dinâmico sinusoidal:
A = 0.32;
f = 0.05;
T_total = 40;
N_amostras = round(T_total / Ts);

tempo2 = zeros(1, N_amostras);
v_aplicada = zeros(1, N_amostras);
rpm2 = zeros(1, N_amostras);
DeltaV_t = zeros(1, N_amostras);
DeltaOmega_t = zeros(1, N_amostras);

for k = 1:N_amostras
    t2 = (k-1)*Ts;

    deltaV = A * sin(2*pi*f*t2);
    Vt = v_900 + deltaV;
    Vt = max(min(Vt,3),0);

    RT050_SetMotorVoltage(Vt);
    omega_t = RT050_GetMotorSpeed();

    tempo2(k) = t2;
    v_aplicada(k) = Vt;
    rpm2(k) = omega_t;
    DeltaV_t(k) = deltaV;
    DeltaOmega_t(k) = omega_t - omega_ref;

    pause(Ts);
end

RT050_SetMotorVoltage(0);

% Gráficos:
figure;
subplot(2,1,1);
plot(tempo2,DeltaV_t,'b','LineWidth',1.3);
title('ΔV aplicada');

subplot(2,1,2);
plot(tempo2,rpm2,'r','LineWidth',1.3);
title('Velocidade real');
yline(900,'--k','900 rpm'); 

% FUNÇÃO DE TRANSFERÊNCIA:
t = tempo2;
dV = DeltaV_t;
dOmega = DeltaOmega_t;

idx = find(t >= 5);
t = t(idx);
dV = dV(idx);
dOmega = dOmega(idx);

dV_s = movmean(dV,15);
dOmega_s = movmean(dOmega,15);

% Frequência usada:
f_id = 0.05;    
w0 = 2*pi*f_id;

amp_V = (max(dV_s)-min(dV_s))/2;
amp_Omega = (max(dOmega_s)-min(dOmega_s))/2;

G_exp = amp_Omega/amp_V;

[~,kV] = max(dV_s);
[~,kO] = max(dOmega_s);
delta_t = t(kO)-t(kV);
phi_exp = -w0*delta_t;

best_err = inf;

for tau_e = 0.01:0.005:0.30
    for tau_m = 0.05:0.01:1.0

        Gth = 1 / ( (1+(w0*tau_e)^2)^2 * sqrt(1+(w0*tau_m)^2) );
        phi_th = -( 2*atan(w0*tau_e) + atan(w0*tau_m) );

        err = (Gth-G_exp)^2 + 10*(phi_th-phi_exp)^2;

        if err < best_err
            best_err = err;
            best_tau_e = tau_e;
            best_tau_m = tau_m;
        end
    end
end

K = G_exp * ((1+(w0*best_tau_e)^2)^2) * sqrt(1+(w0*best_tau_m)^2);

fprintf('\nModelo identificado:\n');
fprintf('tau_e = %.4f s\n', best_tau_e);
fprintf('tau_m = %.4f s\n', best_tau_m);
fprintf('K     = %.4f\n', K);

% Função de transferência a usar:
num = K;
den = conv([best_tau_e^2 2*best_tau_e 1],[best_tau_m 1]);
G_identificada = tf(num,den);

fprintf('\nFunção de transferência criada com sucesso.\n');

% Resposta real vs Modelo:
DeltaOmega_model = lsim(G_identificada, DeltaV_t, tempo2);

plot(tempo2,DeltaOmega_t,'r','LineWidth',1.3); hold on;
plot(tempo2,DeltaOmega_model,'k--','LineWidth',1.6);
title('Comparação Resposta Real vs Modelo (1.2)');
legend('Real','Modelo');
grid on;

%% 1.3 — Rsposta ao step (Motor vs Modelo)
%v(t)-> step

fprintf('\n 1.3: Aplicar Step \n');

T_estab = 5;
duracao = 20;
N = round(duracao/Ts);

RT050_SetLoadState(0);
pause(1);

RT050_SetMotorVoltage(v_900);
pause(T_estab);

soma = 0;
for k = 1:10
    soma = soma + RT050_GetMotorSpeed();
    pause(Ts);
end
omega0 = soma/10;

fprintf('Velocidade inicial = %.1f rpm\n', omega0);

deltaV_step = 0.25;

tempo3 = zeros(1,N);
rpm3 = zeros(1,N);
DeltaOmega3 = zeros(1,N);

for k = 1:N
    tempo3(k) = (k-1)*Ts;

    if k < N/4
        Vt = v_900;
    else
        Vt = v_900 + deltaV_step;
    end

    RT050_SetMotorVoltage(Vt);
    omega = RT050_GetMotorSpeed();

    rpm3(k) = omega;
    DeltaOmega3(k) = omega - omega0;

    pause(Ts);
end

RT050_SetMotorVoltage(0);

DeltaV_step_model = zeros(1,N);
DeltaV_step_model(round(N/4):end) = deltaV_step;

DeltaOmega_step_model = lsim(G_identificada, DeltaV_step_model, tempo3);

% Gráficos:
figure;
subplot(2,1,1);
plot(tempo3,DeltaV_step_model,'b');
title('Degrau aplicado');

subplot(2,1,2);
plot(tempo3,DeltaOmega3,'r'); hold on;
plot(tempo3,DeltaOmega_step_model,'k--');
title('Resposta ao Step: Real vs Modelo');
legend('Real','Modelo');
grid on;

fprintf('\n1.3 concluída.\n');
