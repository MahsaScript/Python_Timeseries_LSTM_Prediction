

function [dataset] = extract_jean_sale_average(year)
	dataset = table();
	month = ['01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'; '11'; '12'];
	for i=1 : length(month)
		path = sprintf('%s\\%s%s\\*.csv', year, year, month(i,:));
		datafiles = dir(path);
		numoffiles = length(datafiles);
		for j=1 : numoffiles
			datafilename = [datafiles(j).folder '\' datafiles(j).name];
			T = readtable(datafilename);
			if(isempty(T))
				continue
			else
				try
					T = T(:,{'collect_day','pum_name','sales_price'});
				catch
					fprintf('Error : %s - %d',month(i,2),j);
					continue
				end
				T.collect_day = datetime(T.collect_day);
				today = T.collect_day(1);
				T.pum_name = categorical(T.pum_name);
				n_T = table();
				c_index = T.pum_name == 'û����';
				A = T(c_index,:);
				cell_T = {today, 'û����', mean(A.sales_price)};
				n_T = [n_T;cell_T];
				n_T.Properties.VariableNames = T.Properties.VariableNames;
				if(isempty(dataset))
					dataset = n_T;
				else
					dataset = [dataset;n_T];
				end
			end
			fprintf('%d',j);
			clearvars -except dataset datafiles numoffiles year month i j
		end
		fprintf('%d\n',i);
	end
end

year = ['2015';'2016';'2017';'2018';'2019'];
jean_sales = table();
for i=1 : length(year)
	tt = extract_jean_sale_average(year(i,:));
	jean_sales = [jean_sales; tt];