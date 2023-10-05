function Wilson_Cowan(Kij, T, Je, Ji)
    % Define additional model parameters (adjust as needed)
    wee = 16;
    wei = 12;
    wie = 15;
    wii = 3;
    k = 2;
    be = 4;
    bi = 3.7;
    taue = 23.7;
    taui = 23.7;

    % Number of nodes
    n = size(Kij, 1);

    % Unit tests
    assert(numel(Kij) == (n * n), 'Kij must be square matrix');
    assert(mod(T, 1) == 0 && (T > 0), 'T must be a positive integer');
    assert(numel(Je) == 1 || numel(Je) == n, 'Je must be 1x1 or nx1');
    assert(numel(Ji) == 1 || numel(Ji) == n, 'Ji must be 1x1 or nx1');

    % Initialize state variables
    Ue = rand(n, 1);
    Ui = rand(n, 1);
    Ue_delay = Ue;  % Initialize Ue_delay to be the same as Ue

    % Time parameters
    tspan = [0 200];  % Simulation time span
    dt = 0.1;          % Time step

    % Open a file for saving results
    fid = fopen('simulation_results.txt', 'w');
    fprintf(fid, 'Time\tUe1\tUi1\tUe2\tUi2\n');

    % Time-stepping loop
    for t = tspan(1):dt:tspan(2)
        % Calculate derivatives
        dUe = (-Ue + F(wee * Ue - wei * Ui + Je - be + k * Kij * Ue_delay)) / taue;
        dUi = (-Ui + F(wie * Ue - wii * Ui + Ji - bi)) / taui;

        % Update state variables using Euler's method
        Ue = Ue + dt * dUe;
        Ui = Ui + dt * dUi;

        % Update Ue_delay (delayed Ue)
        Ue_delay = Ue;  % In this simple example, Ue_delay is the same as Ue

        % Print results to the file
        fprintf(fid, '%f\t', t);
        fprintf(fid, '%f\t', Ue);
        fprintf(fid, '%f\t', Ui);
        fprintf(fid, '\n');
    end

    % Close the file
    fclose(fid);
end

function y = F(x)
    y = 1 ./ (1 + exp(-x));
end