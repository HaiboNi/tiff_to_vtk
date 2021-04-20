classdef tiff_2_vtk < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        InputtiffimagesinformationUIFigure  matlab.ui.Figure
        RunButton                      matlab.ui.control.Button
        CancelButton                   matlab.ui.control.Button
        SelecttifffilenameEditFieldLabel  matlab.ui.control.Label
        SelecttifffilenameEditField    matlab.ui.control.EditField
        SelectButton                   matlab.ui.control.Button
        NumberofZstacksEditFieldLabel  matlab.ui.control.Label
        NumberofZstacksEditField       matlab.ui.control.NumericEditField
    end

    
    properties (Access = public)
        
%         Property tif_file=' ';% Description
% %         
%         Property2 zstack_num=10;% Description
        tif_file = '';
        zstack_num=10;% Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: SelecttifffilenameEditField
        function SelecttifffilenameEditFieldValueChanged(app, event)
            value = app.SelecttifffilenameEditField.Value;
            %app.SelecttifffilenameEditField.Value = event.Value;
        end

        % Button pushed function: SelectButton
        function SelectButtonPushed(app, event)
           [file,path] = uigetfile('*.tif');

           if(file==0)
               return;
           end
           app.SelecttifffilenameEditField.Value = [path,file];
        end

        % Button pushed function: CancelButton
        function CancelButtonPushed(app, event)
        answer = questdlg('You have not speicified tiff file parameters. Are you sure that you want to exit?', ...
	'Cancel', ...
	'Yes','No', 'Yes');
            switch answer
                case 'No'
                    return;
        
                case 'Yes'
                    delete(app);
            end
            %delete(app);
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
%             assignin('base','tif_file',app.SelecttifffilenameEditField.Value);
%             assignin('base','zstack_num',app.NumberofZstacksEditField.Value);
            tif_file=app.SelecttifffilenameEditField.Value;
            zstack_num=app.NumberofZstacksEditField.Value;
            
            dapi=zeros(512,512,zstack_num);
            pla=zeros(512,512,zstack_num);
            f = waitbar(0,'Processing ...');
            pause(.5)
            
            for i = 1:zstack_num
               	b = imread(tif_file,2*i-1);
               	dapi(:,:,i)=b;
               	b = imread(tif_file,2*i);
               	pla(:,:,i)=b;
            end
            waitbar(.33,f,'writing dapi.vtk');
            write_vtk(dapi,'dapi.vtk')
            waitbar(.67,f,'writing pla.vtk');
            write_vtk(pla,'pla.vtk')
            waitbar(1,f,'Finishing');
            pause(1)
            close(f)
            delete(app);
        end

        % Close request function: InputtiffimagesinformationUIFigure
        function InputtiffimagesinformationUIFigureCloseRequest(app, event)
            delete(app)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create InputtiffimagesinformationUIFigure and hide until all components are created
            app.InputtiffimagesinformationUIFigure = uifigure('Visible', 'off');
            app.InputtiffimagesinformationUIFigure.Color = [0.9412 0.9412 0.9412];
            app.InputtiffimagesinformationUIFigure.Position = [700 500 604 221];
            app.InputtiffimagesinformationUIFigure.Name = 'Input tiff images information';
            app.InputtiffimagesinformationUIFigure.CloseRequestFcn = createCallbackFcn(app, @InputtiffimagesinformationUIFigureCloseRequest, true);

            % Create RunButton
            app.RunButton = uibutton(app.InputtiffimagesinformationUIFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.Position = [315 9 100 22];
            app.RunButton.Text = 'Run';

            % Create CancelButton
            app.CancelButton = uibutton(app.InputtiffimagesinformationUIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [446 9 100 22];
            app.CancelButton.Text = 'Cancel';

            % Create SelecttifffilenameEditFieldLabel
            app.SelecttifffilenameEditFieldLabel = uilabel(app.InputtiffimagesinformationUIFigure);
            app.SelecttifffilenameEditFieldLabel.HorizontalAlignment = 'center';
            app.SelecttifffilenameEditFieldLabel.FontSize = 14;
            app.SelecttifffilenameEditFieldLabel.Position = [14 129 125 22];
            app.SelecttifffilenameEditFieldLabel.Text = 'Select tiff filename';

            % Create SelecttifffilenameEditField
            app.SelecttifffilenameEditField = uieditfield(app.InputtiffimagesinformationUIFigure, 'text');
            app.SelecttifffilenameEditField.ValueChangedFcn = createCallbackFcn(app, @SelecttifffilenameEditFieldValueChanged, true);
            app.SelecttifffilenameEditField.HorizontalAlignment = 'right';
            app.SelecttifffilenameEditField.FontSize = 14;
            app.SelecttifffilenameEditField.Position = [158 129 308 22];
            app.SelecttifffilenameEditField.Value = '*.tif';

            % Create SelectButton
            app.SelectButton = uibutton(app.InputtiffimagesinformationUIFigure, 'push');
            app.SelectButton.ButtonPushedFcn = createCallbackFcn(app, @SelectButtonPushed, true);
            app.SelectButton.Position = [494 129 92 22];
            app.SelectButton.Text = 'Select';

            % Create NumberofZstacksEditFieldLabel
            app.NumberofZstacksEditFieldLabel = uilabel(app.InputtiffimagesinformationUIFigure);
            app.NumberofZstacksEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofZstacksEditFieldLabel.FontSize = 14;
            app.NumberofZstacksEditFieldLabel.Position = [14 82 132 22];
            app.NumberofZstacksEditFieldLabel.Text = 'Number of Z stacks';

            % Create NumberofZstacksEditField
            app.NumberofZstacksEditField = uieditfield(app.InputtiffimagesinformationUIFigure, 'numeric');
            app.NumberofZstacksEditField.Limits = [1 10000];
            app.NumberofZstacksEditField.HorizontalAlignment = 'left';
            app.NumberofZstacksEditField.FontSize = 14;
            app.NumberofZstacksEditField.Position = [157 82 100 22];
            app.NumberofZstacksEditField.Value = 10;

            % Show the figure after all components are created
            app.InputtiffimagesinformationUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = tiff_2_vtk

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.InputtiffimagesinformationUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.InputtiffimagesinformationUIFigure)
        end
    end
end