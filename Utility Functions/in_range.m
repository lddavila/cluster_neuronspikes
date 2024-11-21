function [condition] = in_range(x,lower_bound,upper_bound)
condition = x >= lower_bound && x <= upper_bound;
end