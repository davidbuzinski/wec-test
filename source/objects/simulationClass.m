%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Renewable Energy Laboratory and National 
% Technology & Engineering Solutions of Sandia, LLC (NTESS). 
% Under the terms of Contract DE-NA0003525 with NTESS, 
% the U.S. Government retains certain rights in this software.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
% http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef simulationClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The  ``simulationClass`` creates a ``simu`` object saved to the MATLAB
    % workspace. The ``simulationClass`` includes properties and methods used
    % to define WEC-Sim's simulation parameters and settings.
    %
    %.. autoattribute:: objects.simulationClass.simulationClass
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetAccess = 'public', GetAccess = 'public')%input file
        adjMassWeightFun    = 2                                            % (`integer`) Weighting function for adjusting added mass term in the translational direction. Default = ``2``
        autoRateTranBlk     = 'on'                                         % (`string`) Flag for automatically handling rate transition for data transfer, Opyions: 'on', 'off'. Default = ``'on'``
        b2b                 = 0                                            % (`integer`) Flag for body2body interactions, Options: 0 (off), 1 (on). Default = ``0``
        cicDt               = []                                           % (`float`) Sample time to calculate Convolution Integral. Default = ``dt``
        cicEndTime          = 60                                           % (`float`) Convolution integral time. Default = ``60`` s
        domainSize          = 200                                          % (`float`) Size of free surface and seabed. This variable is only used for visualization. Default = ``200`` m
        explorer            = 'on'                                         % (`string`) SimMechanics Explorer 'on' or 'off'. Default = ``'on'``
        dt                  = 0.1                                          % (`float`) Simulation time step. Default = ``0.1`` s
        dtOut               = []                                           % (`float`) Output sampling time. Default = ``dt``
        endTime             = []                                           % (`float`) Simulation end time. Default = ``'NOT DEFINED'``
        g                   = 9.81                                         % (`float`) Acceleration due to gravity. Default = ``9.81`` m/s
        mcrMatFile          = []                                           % (`string`) mat file that contain a list of the multiple conditions runs with given conditions. Default = ``'NOT DEFINED'``  
        mcrExcelFile        = [];                                          % (`string`) File name from which to load wave statistics data. Default = ``[]``        
        mode                = 'normal'                                     % (`string`) Simulation execution mode, 'normal', 'accelerator', 'rapid-accelerator'. Default = ``'normal'``
        morisonDt           = []                                           % (`float`) Sample time to calculate Morison Element forces. Default = ``dt``
        nonlinearDt         = []                                           % (`float`) Sample time to calculate nonlinear forces. Default = ``dt``
        numIntMidTimeSteps  = 5                                            % (`integer`) Number of intermediate time steps. Default = ``5`` for ode4 method
        paraview            = 0                                            % (`integer`) Flag for paraview visualization, and writing vtp files, Options: 0 (off) , 1 (on). Default = ``0``
        paraviewDt          = 0.1;                                         % (`float`) Timestep for Paraview. Default = ``0.1``         
        paraviewStartTime   = 0;                                           % (`float`) Start time for the vtk file of Paraview. Default = ``0``                                    
        paraviewEndTime     = 100;                                         % (`float`) End time for the vtk file of Paraview. Default = ``0``                                      
        paraviewDirectory   = 'vtk';                                       % (`string`) Path of the folder for Paraview vtk files. Default = ``'vtk'``     
        pressureDis         = 0                                            % (`integer`) Flag to save pressure distribution, Options: 0 (off), 1 (on). Default = ``0``
        rampTime            = 100                                          % (`float`) Ramp time for wave forcing. Default = ``100`` s        
        reloadH5Data        = 0                                            % (`integer`) Flag to re-load hydro data from h5 file between runs, Options: 0 (off), 1 (on). Default = ``0``
        rho                 = 1000                                         % (`float`) Density of water. Default = ``1000`` kg/m^3
        saveStructure       = 0                                            % (`integer`) Flag to save results as a MATLAB structure, Options: 0 (off), 1 (on). Default = ``1``
        saveText            = 0                                            % (`integer`) Flag to save results as ASCII files, Options: 0 (off), 1 (on). Default = ``0``
        saveWorkspace       = 1                                            % (`integer`) FLag to save .mat file for each run, Options: 0 (off), 1 (on). Default = ``1``
        simMechanicsFile    = 'NOT DEFINED'                                % (`string`) Simulink/SimMechanics model file. Default = ``'NOT DEFINED'``
        solver              = 'ode4'                                       % (`string`) PDE solver used by the Simulink/SimMechanics simulation. Any continuous solver in Simulink possible. Recommended to use 'ode4, 'ode45' for WEC-Sim. Default = ``'ode4'``
        stateSpace          = 0                                            % (`integer`) Flag for convolution integral or state-space calculation, Options: 0 (convolution integral), 1 (state-space). Default = ``0``
        startTime           = 0                                            % (`float`) Simulation start time. Default = ``0`` s        
        yaw                 = 0                                            % (`integer`) Flag for passive yaw calculation, Options: 0 (off), 1 (on). Default = ``0`` 
        yawThresh           = 1                                            % (`float`) Yaw position threshold (in degrees) above which excitation coefficients will be interpolated in nonlinear yaw. Default = ``1`` dg
        zeroCrossCont       = 'DisableAll'                                 % (`string`) Disable zero cross control. Default = ``'DisableAll'``
    end

    properties (SetAccess = 'public', GetAccess = 'public')%internal        
        CTTime              = []                                           % (`float vector`) Convolution integral time series. Default = dependent
        CIkt                = []                                           % (`integer`) Number of timesteps in the convolution integral length. Default = dependent
        caseDir             = []                                           % (`string`) WEC-Sim case directory. Default = dependent
        caseFile            = []                                           % (`string`) .mat file with all simulation information. Default = dependent
        gitCommit           = []                                           % (`string`) GitHub commit
        inputFile           = 'wecSimInputFile'                            % (`string`) Name of WEC-Sim input file. Default = ``'wecSimInputFile'``
        logFile             = []                                           % (`string`) File with run information summary. Default = ``'log'``        
        maxIt               = []                                           % (`integer`) Total number of simulation time steps. Approximate for variable step solvers. Default = dependent
        numCables           = []                                           % (`integer`) Number of cables in the wec model. Default = ``'NOT DEFINED'``
        numConstraints      = []                                           % (`integer`) Number of contraints in the wec model. Default = ``'NOT DEFINED'``
        numDragBodies       = []                                           % (`integer`) Number of drag bodies that comprise the WEC device (excluding hydrodynamic bodies). Default = ``'NOT DEFINED'``
        numMoorings         = []                                           % (`integer`) Number of moorings in the wec model. Default = ``'NOT DEFINED'``
        numPtos             = []                                           % (`integer`) Number of power take-off elements in the model. Default = ``'NOT DEFINED'``
        numWecBodies        = []                                           % (`integer`) Number of hydrodynamic bodies that comprise the WEC device. Default = ``'NOT DEFINED'``
        outputDir           = 'output'                                     % (`string`) Data output directory name. Default = ``'output'``
        simulationDate      = datetime                                     % (`string`) Simulation date and time
        time                = 0                                            % (`float`) Simulation time [s]. Default = ``0`` s
        wsVersion           = '4.4'                                        % (`string`) WEC-Sim version        
    end

    methods
        function obj = simulationClass()
            % This method initializes the ``simulationClass``.
            fprintf('WEC-Sim: An open-source code for simulating wave energy converters\n')
            fprintf('Version: %s\n\n',obj.wsVersion)
            fprintf('Initializing the Simulation Class...\n')
            obj.caseDir = pwd; 
            fprintf('\tCase Dir: %s \n',obj.caseDir)
            obj.outputDir = ['.' filesep obj.outputDir];
        end

        function obj = loadSimMechModel(obj,fName)
            % This method loads the simulink model and sets parameters
            % 
            % Parameters
            % ------------
            %   fname : string
            %       the name of the SimMechanics ``.slx`` file
            %
            
            load_system(fName);
            [~,modelName,~] = fileparts(fName);
            set_param(modelName,'Solver',obj.solver,...
                'StopTime',num2str(obj.endTime),...
                'SimulationMode',obj.mode,...
                'StartTime',num2str(obj.startTime),...
                'FixedStep',num2str(obj.dt),...
                'MaxStep',num2str(obj.dt),...
                'AutoInsertRateTranBlk',obj.autoRateTranBlk,...
                'ZeroCrossControl',obj.zeroCrossCont,...
                'SimCompilerOptimization','on',...            
                'ReturnWorkspaceOutputs','off',...
                'SimMechanicsOpenEditorOnUpdate',obj.explorer);
        end

        function simuSetup(obj)
            % Sets simulation properties based on values specified in input file
            obj.time = obj.startTime:obj.dt:obj.endTime;
            obj.maxIt = floor((obj.endTime - obj.startTime) / obj.dt);
            
            % Set dtOut if it was not specificed in input file
            if isempty(obj.dtOut) || obj.dtOut < obj.dt
                obj.dtOut = obj.dt;
            end
            
            % Set nonlinearDt if it was not specificed in input file
            if isempty(obj.nonlinearDt) || obj.nonlinearDt < obj.dt
                obj.nonlinearDt = obj.dt;
            end
            
            % Set cicDt if it was not specificed in input file
            if isempty(obj.cicDt) || obj.cicDt < obj.dt
                obj.cicDt = obj.dt;
            end
            
            % Set morisonDt if it was not specificed in input file
            if isempty(obj.morisonDt) || obj.morisonDt < obj.dt
                obj.morisonDt = obj.dt;
            end
            
            % Set paraviewDt if it was not specified in input file
            if isempty(obj.paraviewDt) || obj.paraviewDt < obj.dtOut
                obj.paraviewDt = obj.dtOut;
            end
            
            obj.CTTime = 0:obj.cicDt:obj.cicEndTime;            
            obj.CIkt = length(obj.CTTime);
            obj.caseFile = [obj.simMechanicsFile(length(obj.caseDir)+1:end-4) '_matlabWorkspace.mat'];
            
            % Remove existing output folder
            if exist(obj.outputDir,'dir') ~= 0
                try
                    rmdir(obj.outputDir,'s')
                catch
                    warning('The output directory could not be removed. Please close any files in the output directory and try running WEC-Sim again')
                end
            end
            mkdir(obj.outputDir)
            obj.getGitCommit;
        end

        function checkinputs(obj)
            % Checks user input to ensure that ``simu.endTime`` is specified and that the SimMechanics model exists
            if isempty(obj.endTime)
                error('simu.endTime, the simulation end time must be specified in the wecSimInputFile')
            end
            
            % Check simMechanics file exists
            obj.simMechanicsFile = [obj.caseDir filesep obj.simMechanicsFile];     
            if exist(obj.simMechanicsFile,'file') ~= 4
                error('The simMechanics file, %s, does not exist in the case directory',obj.simMechanicsFile)
            end
            
            % check that visualization is off when using accelerator modes
            if (strcmp(obj.mode,'accelerator') || strcmp(obj.mode,'rapid-accelerator')) ...
                    && strcmp(obj.explorer,'on')
                warning('Mechanics explorer not allowed in accelerator or rapid-accelerator modes. Turning mechanics explorer off.');
                obj.explorer = 'off';
            end
        end

        function rhoDensitySetup(obj,rho,g)
            % Assigns density and gravity values
            %
            % Parameters
            % ------------
            %   rho : float
            %       density of the fluid medium (kg/m^3)
            %   g : float
            %       gravitational acceleration constant (m/s^2)
            %
            obj.rho = rho;
            obj.g   = g;
        end

        function listInfo(obj,waveTypeNum)
            % Lists simulation info
            fprintf('\nWEC-Sim Simulation Settings:\n');
            %fprintf('\tTime Marching Solver                 = Fourth-Order Runge-Kutta Formula \n')
            fprintf('\tStart Time                     (sec) = %G\n',obj.startTime)
            fprintf('\tEnd Time                       (sec) = %G\n',obj.endTime)
            fprintf('\tTime Step Size                 (sec) = %G\n',obj.dt)
            fprintf('\tRamp Function Time             (sec) = %G\n',obj.rampTime)
            if waveTypeNum > 10
                fprintf('\tConvolution Integral Interval  (sec) = %G\n',obj.cicEndTime)
            end
            fprintf('\t Number of Time Steps     = %u \n',obj.maxIt)
        end

        function getGitCommit(obj)
            % Determines GitHub commit tag
            try
                ws_exe = which('wecSim');
                ws_dir = fileparts(ws_exe);
                git_ver_file = [ws_dir '/../.git/refs/heads/master'];
                obj.gitCommit = textread(git_ver_file,'%s');
            catch
                obj.gitCommit = 'No git commit tag available';
            end
        end
    end
end
