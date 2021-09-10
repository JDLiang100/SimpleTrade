clear;clc;close all
stock = readmatrix("NOK.csv"); % Create the matrix of the data
openPrice = stock(:,2); %import opening price of the stock
meanPrice = mean(openPrice) % Calculate the mean of open price from the past 250 days
stdPrice = std(openPrice) % Calculate the standard deviation of open price from the past 250 days
year = 1;
for j = 1:10 %10 realizations
    prediction = stdPrice.*randn(days,1)+meanPrice; %Prediction prices for next year
    balance = 10000; %starting balance 
    stockNumber = 0;%number of stocks
    openPrice = prediction;
    
    for i= 1:250
       if(openPrice(i) <= meanPrice - meanPrice *.04 && balance > openPrice(i)* 100) %% If open price is lower than the mean price by 4%, then buy shares
           stockNumber = stockNumber + 100;
           balance = balance - openPrice(i) * 100;
           if(40 > (openPrice(i)*100)*0.03) %Check wich comission fee is higher
               balance = balance - 40;  %substract comission fee
           else
               balance = balance -  (openPrice(i)*100)*0.03;  %substract comission fee
        end
       end
       if(openPrice(i) > meanPrice + meanPrice *.2)
           balance = balance + stockNumber * openPrice(i);
           stockNumber = 0;
           if(40 > (openPrice(i)*100)*0.03) %Check wich comission fee is higher
               balance = balance - 40;  %substract comission fee
           else
               balance = balance -  (openPrice(i)*100)*0.03;  %substract comission fee
           end
       end 
       if(i == 250)
           balance = balance + stockNumber * openPrice(i);%Total balance including stocks that were not sold
       end
       dailyBalance(i) = balance + stockNumber * openPrice(i);%daily balance
    end
    
    yearlyBalance(year) = balance;%balance for each realization
    year = year + 1;
end
averageProfit = mean(yearlyBalance);
stdAverageProfit = std(yearlyBalance);
minProfit = min(yearlyBalance);
maxProfit = max(yearlyBalance);

fprintf ('%s  Is the average profit of the 10 realizations\n', averageProfit);
fprintf ('%s  Is the average standard deviation of the 10 realizations\n', stdAverageProfit);
fprintf ('%s  Is the min profit of the 10 realizations\n', minProfit);
fprintf ('%s  Is the max profit of the 10 realizations\n', maxProfit);


