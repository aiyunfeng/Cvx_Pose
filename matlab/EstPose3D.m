function [R,T,residual] = EstPose3D(obs, model, weights)
% Matanya Horowitz, Nikolai Matni
% 10/21/2013
%
% 3D Estimation software. Takes a collection of 3D points obs and finds the
% pose in SE(3) that best aligns the model points to the obs. The obs and
% model points are assumed to be of the same length.
%
%Inputs:
% obs - An 3xn list of observed points
% model - An 3xn list of corresponding points on the model
% lambda - An L1 penalty. This feature is disabled if lambda=0
%
%Outputs:
% trans - The estimated translation
% rot - The estimated rotation
% residual - The residual

n = length(obs);
m = length(model);

if n ~= m
    display('Point lists must be of equal length');
    return;
end

%% Compute centroid
centroid_obs = mean(obs')';
centroid_model = mean(model')';

trans = centroid_obs - centroid_model;
obs = obs - repmat(centroid_obs,1,n);
model = model - repmat(centroid_model,1,n);

%% Setup SDP
cvx_begin sdp
cvx_solver sdpt3

variable R(3,3);

cons_matrix = [1+R(1,1)+R(2,2)+R(3,3),      R(3,2)-R(2,3),             R(1,3)-R(3,1),             R(2,1)-R(1,2);
                        R(3,2)-R(2,3),      1+R(1,1)-R(2,2)-R(3,3),    R(2,1)+R(1,2),             R(1,3)+R(3,1);
                        R(1,3)-R(3,1),      R(2,1)+R(1,2),             1-R(1,1)+R(2,2)-R(3,3),    R(3,2)+R(2,3);
                        R(2,1)-R(1,2),      R(1,3)+R(3,1),             R(3,2)+R(2,3),             1-R(1,1)-R(2,2)+R(3,3)];

%% Setup features and objective

X = model(:);
Y = obs(:);

S = kron(eye(n),R);

objective = -(Y)'*(S*X);

minimize(objective);
subject to
cons_matrix > 0;
cvx_end

residual = 2*double(objective)  + Y'*Y + X'*X;

R = double(R);
T = trans;
