b=[84    86    88    89    90    92    93];

dsk1=data1(:,2);
ini_dsk1=data1(:,3);
avg_v1=data1(:,4);
f_v1=data1(:,5);
avg_theta1=data1(:,7);
f_theta1=data1(:,8);

dsk2=data2(:,2);
ini_dsk2=data2(:,3);
avg_v2=data2(:,4);
f_v2=data1(:,5);
avg_theta2=data2(:,7);
f_theta2=data2(:,8);

figure;
plot(b,dsk1,'-g*')
hold on
plot(b,dsk2,'-ro')
hold on
xlabel('Field (mT)')
ylabel('Average d_s_k (nm)')
legend('Filter by size','Filter by size + Deflection')
title('Average Sk Size vs External Field')
%**************Average Deflection********************************
figure;
plot(dsk1,avg_theta1,'g*')
hold on
plot(dsk2,avg_theta2,'ro')
hold on
%plot(dsk2,tt,'b+')
legend('Filter by size','Filter by size + Deflection','Filter by size + Deflection, normalized by speed')
xlabel('Average d_s_k (nm)')
ylabel('Average Sk Deflection (^o)')
title('Average Sk deflection vs Average Sk Size')

%**************Final Deflection********************************
figure;
plot(dsk1,f_theta1,'g*')
hold on
plot(dsk2,f_theta2,'ro')
legend('Filter by size','Filter by size + Deflection')
xlabel('Average d_s_k (nm)')
ylabel('Final Sk Deflection (^o)')
title('Final Sk deflection vs Average Sk Size')

figure;
plot(ini_dsk1,f_theta1,'g*')
hold on
plot(ini_dsk2,f_theta2,'ro')
legend('Filter by size','Filter by size + Deflection')
xlabel('Initial d_s_k (nm)')
ylabel('Final Sk Deflection (^o)')
title('Final Sk deflection vs Initial Sk Size')


%**************avg Velocity********************************
figure;
plot(dsk1,avg_v1,'g*')
hold on
plot(dsk2,avg_v2,'ro')
legend('Filter by size','Filter by size + Deflection')
xlabel('Average d_s_k (nm)')
ylabel('Average Sk Velocity (px/frame)')
title('Average Sk Velocity vs Average Sk Size')
%**************Final Velocity********************************
figure;
plot(dsk1,f_v1,'g*')
hold on
plot(dsk2,f_v2,'ro')
legend('Filter by size','Filter by size + Deflection')
xlabel('Average d_s_k (nm)')
ylabel('Final Sk Velocity (px/frame)')
title('Final Sk Velocity vs Average Sk Size')

figure;
plot(ini_dsk1,f_v1,'g*')
hold on
plot(ini_dsk2,f_v2,'ro')
legend('Filter by size','Filter by size + Deflection')
xlabel('Initial d_s_k (nm)')
ylabel('Final Sk Velocity (px/frame)')
title('Final Sk Velocity vs Initial Sk Size')


