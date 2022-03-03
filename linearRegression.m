clear all
close all

x = [1 2 3 4 5 6 7 8 9 10];
y = [1.1 2.3 4.5 5.1 6.7 7.4 8.9 10.0 11.1 11.9];

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
plot(x, y, 'bx');
hold on
fplot(@(x) beta0_hat + beta1_hat * x, [min(x) max(x)], 'r-')

plot(x, upper_y_i_hat, 'r:')
plot(x, lower_y_i_hat, 'r:')

xlabel('x1')
ylabel('y')
title('y vs. x1')

legend('Data', 'Fit', 'Confidence bounds', 'Location', 'southeast')

xPad = (max(x) - min(x)) * 0.1;
yPad = (max(y) - min(y)) * 0.4;

axis([min(x)-xPad, max(x)+xPad, min(y)-yPad, max(y)+yPad]);

hold off