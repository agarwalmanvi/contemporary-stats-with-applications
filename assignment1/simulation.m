N = 10;
p = 2;
tau_sq_vector = linspace(0.1,0.9,9);
lambda_vector = linspace(0,5,11);
results_tau = [];
results_lambda_matrix = [];


for tau_index = 1:9
    
    tau_sq = tau_sq_vector(tau_index);
    
    results_tau = [results_tau tau_sq];
    results_lambda_vector = [];
    
    for runs=1:100
        D = data(N, p, tau_sq);
        X = D(:,1:2);
        Y = D(:,end);

        minimum_mse = Inf;
        best_lambda = Inf;

        for lambda_index=1:11

            lambda = lambda_vector(lambda_index);

            total_error = 0;

            % cross validation to fit and predict
            for num=1:N
                X_fit = X;
                X_predict = X_fit(num,:);
                X_fit(num,:) = [];

                Y_fit = Y;
                Y_predict = Y_fit(num);
                Y_fit(num) = [];

                estimator = inv(X_fit' * X_fit + lambda* eye(2)) * X_fit' * Y_fit;
                Y_hat = X_predict*estimator;
                error = (Y_predict - Y_hat).^2;
                total_error = total_error + error;
            end
            % average squared error for a given lambda
            mse = total_error / N;

            % check if current mse is better than minimum mse encountered uptil now
            % if yes, store the optimal lambda
            if mse < minimum_mse
                %display("Old mse");
                %display(minimum_mse);
                %display("New best mse!");
                %display(mse);
                minimum_mse = mse;
                best_lambda = lambda;
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % give a finer grid around the chosen lambda
        best_lambda_vector = linspace(best_lambda-0.5,best_lambda+0.5,11);

        minimum_mse_finer = Inf;
        best_lambda_finer = 10;

        for lambda_index=1:11

            lambda = best_lambda_vector(lambda_index);

            total_error = 0;

            % cross validation to fit and predict
            for num=1:N
                X_fit = X;
                X_predict = X_fit(num,:);
                X_fit(num,:) = [];

                Y_fit = Y;
                Y_predict = Y_fit(num);
                Y_fit(num) = [];

                estimator = inv(X_fit' * X_fit + lambda* eye(2)) * X_fit' * Y_fit;
                Y_hat = X_predict*estimator;
                error = (Y_predict - Y_hat).^2;
                total_error = total_error + error;
            end
            % average squared error for a given lambda
            mse = total_error / N;

            % check if current mse is better than minimum mse encountered uptil now
            % if yes, store the optimal lambda
            if mse < minimum_mse_finer
                %display("Old mse");
                %display(minimum_mse_finer);
                %display("New best mse!");
                %display(mse);
                minimum_mse_finer = mse;
                best_lambda_finer = lambda;
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        results_lambda_vector = [results_lambda_vector best_lambda_finer];  
        
    end
    
    % transpose the results row vector to a column vector size
    % num_simulations by 1
    results_lambda_vector = results_lambda_vector';
    % results_lambda_matrix is of size num_simulations by num_taus
    results_lambda_matrix = [results_lambda_matrix results_lambda_vector];
    
end
histogram(results_lambda_matrix(:,9),25)
title('Optimal \lambda count for: \tau^2 = 0.9 , \mu = 1.4200')
xlabel('\lambda')
ylabel('No. of simulations')
