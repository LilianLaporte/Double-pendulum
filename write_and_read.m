filename = 'data\waveform_input_4.csv';
writematrix(input_data.data, filename);
inputdata = csvread(filename);

th = [th1_data.data th2_data.data];
filename = 'data\waveform_resp_4.csv';
writematrix(th, filename);
theta = csvread(filename);





















