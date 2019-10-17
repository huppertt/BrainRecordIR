function system = restore_default_settings(type)
% Save the system file into the root directory to change the default load
% behavior
% save('System.config','system','-MAT')


if(nargin==1)
    system.Type=type;
else
    system.Type = "BTNIRS";
end

datafolder='BTNIRS_Data';
if(ismac | isunix)
    system.Folders.DefaultData = ['/Users/' getenv('USER') '/Desktop/' datafolder];
else
    system.Folders.DefaultData = [getenv('UserProfile') '\Desktop\' datafolder];
end

system.Folders.DefaultFileType = {'.nirs'};  % the file type that dat will be saved as (can be more then one)

switch(upper(system.Type))
    case('SIMULATOR')
        
        % the list laser to optode and wavelength info
        % this gives the freedom to use any combination of wavelengths (or numbers
        % of wavelengths) at any optode position
        system.Lasers.Laser2OptodeMapping(1)=struct('Optode',1,'Laser',1,'Wavelength',690);
        system.Lasers.Laser2OptodeMapping(2)=struct('Optode',1,'Laser',2,'Wavelength',830);
        system.Lasers.Laser2OptodeMapping(3)=struct('Optode',2,'Laser',3,'Wavelength',690);
        system.Lasers.Laser2OptodeMapping(4)=struct('Optode',2,'Laser',4,'Wavelength',830);
        system.Lasers.Laser2OptodeMapping(5)=struct('Optode',3,'Laser',5,'Wavelength',690);
        system.Lasers.Laser2OptodeMapping(6)=struct('Optode',3,'Laser',6,'Wavelength',830);
        system.Lasers.Laser2OptodeMapping(7)=struct('Optode',4,'Laser',7,'Wavelength',690);
        system.Lasers.Laser2OptodeMapping(8)=struct('Optode',4,'Laser',8,'Wavelength',830);
        system.Lasers.Laser2OptodeMapping(9)=struct('Optode',5,'Laser',9,'Wavelength',690);
        system.Lasers.Laser2OptodeMapping(10)=struct('Optode',5,'Laser',10,'Wavelength',830);
        system.Lasers.Laser2OptodeMapping(11)=struct('Optode',6,'Laser',11,'Wavelength',690);
        system.Lasers.Laser2OptodeMapping(12)=struct('Optode',6,'Laser',12,'Wavelength',830);
        system.Lasers.Laser2OptodeMapping(13)=struct('Optode',7,'Laser',13,'Wavelength',690);
        system.Lasers.Laser2OptodeMapping(14)=struct('Optode',7,'Laser',14,'Wavelength',830);
        system.Lasers.Laser2OptodeMapping(15)=struct('Optode',8,'Laser',15,'Wavelength',690);
        system.Lasers.Laser2OptodeMapping(16)=struct('Optode',8,'Laser',16,'Wavelength',830);
        
        % Flag to allow adjustable laser settings
        system.Lasers.Adjustable = true;
        system.Lasers.GainRange = [0 9];
        
        system.Detectors.Detector2OptodeMapping(1)=struct('Optode',1,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(2)=struct('Optode',2,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(3)=struct('Optode',3,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(4)=struct('Optode',4,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(5)=struct('Optode',5,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(6)=struct('Optode',6,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(7)=struct('Optode',7,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(8)=struct('Optode',8,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(9)=struct('Optode',9,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(10)=struct('Optode',10,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(11)=struct('Optode',11,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(12)=struct('Optode',12,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(13)=struct('Optode',13,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(14)=struct('Optode',14,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(15)=struct('Optode',15,'short_seperation',false,'Range',[0 255]);
        system.Detectors.Detector2OptodeMapping(16)=struct('Optode',16,'short_seperation',false,'Range',[0 255]);

        system.SampleRatesAllowed = [5 10 20 50];
        system.SampleRatesDefault = 5;
        
        system.ClassLibrary = 'Instrument.Simulator';
    case('BTNIRS')
        
        % the list laser to optode and wavelength info
        % this gives the freedom to use any combination of wavelengths (or numbers
        % of wavelengths) at any optode position
        system.Lasers.Laser2OptodeMapping(1)=struct('Optode',1,'Laser',1,'Wavelength',725);
        system.Lasers.Laser2OptodeMapping(2)=struct('Optode',1,'Laser',2,'Wavelength',850);
        system.Lasers.Laser2OptodeMapping(3)=struct('Optode',2,'Laser',3,'Wavelength',725);
        system.Lasers.Laser2OptodeMapping(4)=struct('Optode',2,'Laser',4,'Wavelength',850);
        system.Lasers.Laser2OptodeMapping(5)=struct('Optode',3,'Laser',5,'Wavelength',725);
        system.Lasers.Laser2OptodeMapping(6)=struct('Optode',3,'Laser',6,'Wavelength',850);
        system.Lasers.Laser2OptodeMapping(7)=struct('Optode',4,'Laser',7,'Wavelength',725);
        system.Lasers.Laser2OptodeMapping(8)=struct('Optode',4,'Laser',8,'Wavelength',850);
        
        % Flag to allow adjustable laser settings
        system.Lasers.Adjustable = true;
        system.Lasers.GainRange = [0 100];
        
        system.Detectors.Detector2OptodeMapping(1)=struct('Optode',[1:4],'short_seperation',false,'Range',[0 127]);
        system.Detectors.Detector2OptodeMapping(2)=struct('Optode',[5:8],'short_seperation',false,'Range',[0 127]);
%         system.Detectors.Detector2OptodeMapping(3)=struct('Optode',3,'short_seperation',false,'Range',[0 127]);
%         system.Detectors.Detector2OptodeMapping(4)=struct('Optode',4,'short_seperation',false,'Range',[0 127]);
%         system.Detectors.Detector2OptodeMapping(5)=struct('Optode',5,'short_seperation',false,'Range',[0 127]);
%         system.Detectors.Detector2OptodeMapping(6)=struct('Optode',6,'short_seperation',true,'Range',[0 127]);
%         system.Detectors.Detector2OptodeMapping(7)=struct('Optode',7,'short_seperation',false,'Range',[0 127]);
%         system.Detectors.Detector2OptodeMapping(8)=struct('Optode',8,'short_seperation',false,'Range',[0 127]);
        
        system.SampleRatesAllowed = [10:10:80];
        system.SampleRatesDefault = 10;
        
        system.ClassLibrary = 'Instrument.BTNIRS'; 
end


return