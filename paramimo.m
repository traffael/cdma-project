% Wireless Receivers II - Assignment 1:
%
% AWGN Spread Spectrum Multipath Parameter File
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters

P=[];
P.NumberOfBits      = 184;


P.CodingType    = 'None';
P.Modulation    = 1;        % 1: BPSK
P.codeLength = 8; % encoding (K=1+P.codeLength = 8)
P.codeRate = 1/2; % convolutional coding rate
P.encoderPolynominal = [753 561];
P.hadamardLength = 64; 
P.ChannelType   = 'Multipath'; % 'AWGN', 'Fading'
P.ChannelLength = 4;
P.NumberOfFrames  = 1e4;
P.nMIMO = 2; %2 antennas
P.useIS95Walsh = 0; %boolean, 1 if the standard Walsh mapping is used as
%                   defined in the IS95 standard. 0 if
%                   orthogonalMIMO(De)modulation function is used.

% P.nUsers = 64; % Number of users
% for i_user = 1:P.nUsers
%     ESN = randi([0 1],1, 32);
%     P.Long_code(:,i_user) = gen_long_code(ESN,P); %PN sequence. Specific to each USER, but the SAME for both mimo
% end 

P.SNRRange = -35:2:5; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

P.RakeFingers = 3;

u=[32 8 1];
c=[ 3 4 5];
simlab={};

%% ======================== Zero Forcing  =================================
figure(10)

c_map=[0.5 0 0;0.5 0 0;0.5 0 0;0 0.5 0;0 0.5 0;0 0.5 0;0 0 0.5;0 0 0.5;0 0 0.5;];
c_map=c_map+[0.1 0.1 0.1;0.2 0.2 0.2; 0.3 0.3 0.3;0.1 0.1 0.1;0.2 0.2 0.2; 0.3 0.3 0.3;0.1 0.1 0.1;0.2 0.2 0.2; 0.3 0.3 0.3;];
colormap(c_map);
for i_nuser=1:length(u)
    i_nuser
    for i_channel=1:length(c)
        i_channel
        P.nUsers     = u(i_nuser);
        P.ChannelLength = c(i_channel);
       
        
     %  BERmimo(i_channel,:,i_nuser) = simulatorMIMOzf(P);
    
        simlab{(i_channel-1)*3+i_nuser} = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.nUsers);
    end
end

figure(10)
semilogy(P.SNRRange,BERmimo(1,:,1),'*-m')
hold on
semilogy(P.SNRRange,BERmimo(1,:,2),'*-g')
semilogy(P.SNRRange,BERmimo(1,:,3),'*-b')

semilogy(P.SNRRange,BERmimo(2,:,1),'o-m')
semilogy(P.SNRRange,BERmimo(2,:,2),'o-g')
semilogy(P.SNRRange,BERmimo(2,:,3),'o-b')

semilogy(P.SNRRange,BERmimo(3,:,1),'.-m')
semilogy(P.SNRRange,BERmimo(3,:,2),'.-g')
semilogy(P.SNRRange,BERmimo(3,:,3),'.-b')

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
ylim([1e-5, 1e0]);
title('MIMO IS95 simulation with zero-forcing')
grid minor;

legend(simlab);
hold off


BERmimo
% 
% %% ============================= SVD ================================
% for i_rakefingers=1:length(r)
%     i_rakefingers
%     simlab=[];
%     for i_nuser=1:length(u)
%         i_nuser
%         P.nUsers     = u(i_nuser);
%         P.ChannelLength = r(i_rakefingers);
%         P.RakeFingers = r(i_rakefingers);
%         
%         BERsvd(i_nuser,:,i_rakefingers) = simulatorMIMOsvd(P);
%         
%             simlab{i_nuser} = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.nUsers);
%     end
% 
% figure
% semilogy(P.SNRRange,BERsvd(:,:,i_rakefingers),'*-')
% 
% xlabel('SNR','FontSize',12,'FontWeight','bold');
% ylabel('BER','FontSize',12,'FontWeight','bold');
% xlim([min(P.SNRRange) max(P.SNRRange)]);
% ylim([1e-6, 1e0]);
% title('MIMO IS95 simulation with singular value decomposition')
% grid minor;
% legend(simlab);
% 
% end
% 
% BERsvd
% 
% =============================== MMSE   =============================
% 
% for i_rakefingers=1:length(r)
%     i_rakefingers
%     simlab=[];
%     for i_nuser=1:length(u)
%         i_nuser
%         P.nUsers     = u(i_nuser);
%         P.ChannelLength = r(i_rakefingers);
%         P.RakeFingers = r(i_rakefingers);
%         
%         BERmmsenew(i_nuser,:,i_rakefingers) = simulatorMIMOmmse(P);
%         
%             simlab{i_nuser} = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.nUsers);
%     end
% 
% figure
% semilogy(P.SNRRange,BERmmsenew(:,:,i_rakefingers),'*-')
% 
% xlabel('SNR','FontSize',12,'FontWeight','bold');
% ylabel('BER','FontSize',12,'FontWeight','bold');
% xlim([min(P.SNRRange) max(P.SNRRange)]);
% ylim([1e-6, 1e0]);
% title('MIMO IS95 simulation with MMSE')
% grid minor;
% legend(simlab);
% 
% end
% 
% BERmmsenew
% 
% save('sim10e5')


% 
% 
%         P.nUsers     = 32;
%         P.ChannelLength = 3;
%         P.RakeFingers = 3;
%         
%         BERbarker(1,:) = simulatorMIMO(P);
%         simlab{1} = sprintf('Long code, different for every user');
%      
%         BERbarker(2,:) = simulatorMIMOtest(P);
%         simlab{2} = sprintf('Long code, same for every user');
%         
%         
%         P.Long_code(:,1) = genbarker(length(P.Long_code));
%         BERbarker(3,:) = simulatorMIMOtest(P);
%         simlab{3} = sprintf('Barker code, same for every user');
%         
%     
% 
%     figure
% 
%     semilogy(P.SNRRange,BERbarker,'*-')
% 
%     xlabel('SNR','FontSize',12,'FontWeight','bold');
%     ylabel('BER','FontSize',12,'FontWeight','bold');
%     xlim([min(P.SNRRange) max(P.SNRRange)]);
%     ylim([1e-6, 1e0]);
%     title('MIMO IS95 simulation with zero-forcing. Users = 32, channel length = 3, rake fingers = 3')
%     grid minor;
%     legend(simlab);
% 
%     hold on
% 
% BERbarker
% 
% save('sim10e5')




