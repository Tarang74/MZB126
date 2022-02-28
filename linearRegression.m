clear all
close all

x = [0.5, ];
y = [];

% Fit a linear model:
% y = beta0 + beta1 * x
model = fitlm(x, y, 'VarNames', {'x', 'y'});

% Display the results of the linear model fit
disp(model);

% Visualise the residuals
figure
plotResiduals(model, 'fitted');

%%% Calculate 99% Confidence Interval

% Number of Samples
n = model.NumObservations;

% Degrees of Freedom
df = model.DFE;

% Standard Deviation
s = 1;

% Intercept
beta0_hat = model.Coefficients.Estimate(1);
% Production Rate
beta1_hat = model.Coefficients.Estimate(2);

% Data Mean
x_mean = mean(x);
y_mean = mean(y);

% yield_i_hat
y_i_hat = beta0_hat + beta1_hat * x;

% Confidence Interval
confidence = 0.99;
area = 1 - (1 - confidence) / 2;

upper_y_i_hat = y_i_hat + tinv(area, df) .* s .* sqrt(1 / n + (x - x_mean).^2 / sum((x - x_mean).^2));
lower_y_i_hat = y_i_hat - tinv(area, df) .* s .* sqrt(1 / n + (x - x_mean).^2 / sum((x - x_mean).^2));

% beta1 CI99
disp([beta1_hat - tinv(area, df) * model.Coefficients.SE(2), beta1_hat + tinv(area, df) * model.Coefficients.SE(2)])

% Visualise Points
figure
plot(x, y, 'x');
hold on
fplot(@(x) beta0_hat + beta1_hat * x, 'b-')

plot(x, upper_y_i_hat, 'r--')
plot(x, lower_y_i_hat, 'r--')

axis([3.8 10.4 0 2])
hold off
