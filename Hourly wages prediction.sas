DATA a1;
infile 'E:\Users\hxb210007\Desktop\Excel file-wages.csv' firstobs = 2 delimiter = ','; 
INPUT id year edu hr wage famearn selfempl salaried  married numkid age locunemp;
RUN;
proc print data = a1 (obs = 6); run;


/*Question 1*/
data a2;
set a1;
wage1 = log(wage);
proc print data = a2 (obs = 6); run;
PROC REG data = a2; MODEL wage1 = edu hr selfempl salaried  married numkid age locunemp/selection = adjrsq sse aic; run;
/* The best model here is edu hr famearn selfempl salaried  married numkid age with 8 variables and removed locunemp since p>0.05*/
PROC REG data = a2; MODEL wage1 = edu hr selfempl salaried  married numkid age locunemp; run;

PROC REG data = a2; MODEL wage1 = edu hr selfempl salaried age; run; /* best model*/

/* Multicollinearity test */
PROC REG data = a2; MODEL wage1 = edu hr selfempl salaried age /vif; run;
PROC REG data = a2; MODEL wage1 = edu hr selfempl salaried age /collin; run;

/* Same explanation as that Q.7 from HW 2*/


/*Question 2*/
data a3;
set a2;
edu1 = edu**2;
hr1 = hr**2;
age1 = age**2;
run;

proc print data = a3 (obs = 6); run;


PROC REG data = a3; MODEL wage1 =  edu hr selfempl salaried age hr1 edu1 age1;run;


 
/*Question 3*/
PROC MODEL data=a3;
parms b0 b1 b2 b3 b4 b5 b6 b7 b8;
wage1=b0+b1*edu+ b2*hr + b3*selfempl + b4*salaried + b5*age +b6*edu1 +b7*hr1 +b8*age1;
fit wage1 / white out=resid outresid; run;

/* p <0.05, we reject null and conclude that there is heteroscedasticity in the model */


/* Question 4*/
PROC REG data = a3; MODEL wage1 = edu hr selfempl salaried age hr1 edu1 age1; run;


/* Question 5*/
proc panel data=a3;       
id id year;       
model wage1 =  edu hr selfempl salaried age hr1 edu1 age1/ fixone fixtwo ranone rantwo ;    
run;



