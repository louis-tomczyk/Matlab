function S = Jones2Stockes(J,varargin)
%%
% ---------------------------------------------
% ----- INFORMATIONS -----
%   Author          : louis tomczyk
%   Institution     : Telecom Paris
%   Email           : louis.tomczyk@telecom-paris.fr
%   Arxivs          :
%   Date            : 2023-03-04
%   Version         : 1.0.0
%   Licence         : cc-by-nc-sa
%                     Attribution - Non-Commercial - Share Alike 4.0 International
%
% ----- Main idea -----
%   Convert the polarisation expression from the Jones formalism
%   to the Stocked one.
%
% ----- INPUTS -----
%   J           (array)     Jones vectors of shape (2,Nstates).
%                           Jones vectors should be unitary.
%   VARARGIN    (string)    Whatever, it will plot the Poincare Sphere
%                           with the states provided
%
% ----- BIBLIOGRAPHY -----
%   Articles/Books
%   Authors             : Jay N. DAMASK
%   Title               : Polarization Optics in Telecommunications
%   Jounal/Editor       : SPRINGER
%   Volume - N°         : 
%   Date                : 2004
%   DOI/ISBN            : 0-387-22493-9
%   Pages               : 54 - 56
% ---------------------------------------------
%%
    if size(J,1) ~= 2
        J = reshape(J,2,[]);
    end

    pauli_0 = eye(2);
    pauli_1 = [1,0; 0,-1];
    pauli_2 = [0,1; 1,0];
    pauli_3 = [0,-1; 1,0]*1i;

    Nstates = size(J,2);
    S       = zeros(4,Nstates);

    for k = 1:Nstates
        S1(k)      = J(:,k)'*pauli_1*J(:,k);
        S2(k)      = J(:,k)'*pauli_2*J(:,k);
        S3(k)      = J(:,k)'*pauli_3*J(:,k);
    
        S0(k)      = sqrt(S1(k).^2+S2(k).^2+S3(k).^2);
        S(:,k)     = [S0(k),S1(k),S2(k),S3(k)].';
    end

    if nargin == 2
        plot_Poincare_state(S,Nstates)
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NESTED FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------
% ----- CONTENTS -----
%   plot_Poincare_state     (S,Nstates)
% ---------------------------------------------

function plot_Poincare_state(S,Nstates)
   
    [x, y, z]   = sphere();
    h           = surf(x, y, z,FaceColor="none",EdgeColor=[1,1,1]*0.8); 

    set(h, 'FaceAlpha', 0.15)
    hold on

    S1_Xaxis    = [0,1.1];
    S1_Yaxis    = [0,0];
    S1_Zaxis    = [0,0];

    S2_Xaxis    = [0,0];
    S2_Yaxis    = [0,1.1];
    S2_Zaxis    = [0,0];

    S3_Xaxis    = [0,0];
    S3_Yaxis    = [0,0];
    S3_Zaxis    = [0,1.1];

    plot3(S1_Xaxis,S1_Yaxis,S1_Zaxis,LineWidth=2,Color='k')
    plot3(S2_Xaxis,S2_Yaxis,S2_Zaxis,LineWidth=2,Color='k')
    plot3(S3_Xaxis,S3_Yaxis,S3_Zaxis,LineWidth=2,Color='k')

    text(1.2,0,0,"S_1","fontsize",15,"fontweight","bold","fontname","Times")
    text(0,1.2,0,"S_2","fontsize",15,"fontweight","bold","fontname","Times")
    text(0,0,1.2,"S_3","fontsize",15,"fontweight","bold","fontname","Times")

    % chatGPT
    hsv_colors  = [(0:Nstates-1)'/Nstates, ones(Nstates,2)];
    colors      = hsv2rgb(hsv_colors);


    for k = 1:Nstates
        scatter3(S(2,k),S(3,k),S(4,k),'filled', ...
            MarkerFaceColor=colors(k,:),MarkerEdgeColor=colors(k,:))
    end

    axis equal
    view(155,21)
    title("Poincare Sphere")
    grid off
    set(gca,"fontsize",15,"fontweight","bold","fontname","Times")
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'ZTickLabel',[]);
