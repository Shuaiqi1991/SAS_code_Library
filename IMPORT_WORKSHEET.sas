%MACRO 
READXLS1(VAR);
	PROC IMPORT OUT = &VAR. 
	DATAFILE = "D:\Sean\8.0_CAPP\Data\XLS_FILE\BIPD_78_FACTORS_CAPP_2018_ADJ_PTS.xls"
	DBMS=XLS REPLACE;
	SHEET = "&&VAR";
	GETNAMES = YES;
	MIXED = YES;
RUN;
%MEND;

%MACRO 
READXLS2(VAR);
	PROC IMPORT OUT = &VAR. 
	DATAFILE = "D:\Sean\8.0_CAPP\Data\XLS_FILE\COLL_7.8A_FACTORS_CAPP_2018_Tier.xls"
	DBMS=XLS REPLACE;
	SHEET = "&&VAR";
	GETNAMES = YES;
	MIXED = YES;
RUN;
%MEND;

%MACRO 
READXLS3(VAR);
	PROC IMPORT OUT = &VAR. 
	DATAFILE = "D:\Sean\8.0_CAPP\Data\XLS_FILE\2018 TIER_COEFF_FOR_ASSIGNMENT.xls"
	DBMS=XLS REPLACE;
	SHEET = "&&VAR";
	GETNAMES = YES;
	MIXED = YES;
RUN;
%MEND;

%MACRO 
READXLS4(VAR);
	PROC IMPORT OUT = &VAR. 
	DATAFILE = "D:\Sean\8.0_CAPP\ROC\BIPD\2018_CAPP_80_BIPD_(with_USDOT_V32).xls"
	DBMS=XLS REPLACE;
	SHEET = "&&VAR";
	GETNAMES = YES;
	MIXED = YES;
RUN;
%MEND;

%MACRO 
READXLS5(VAR);
	PROC IMPORT OUT = &VAR. 
	DATAFILE = "D:\Sean\8.0_CAPP\Data\XLS_FILE\COLL_7.8A_FACTORS_CAPP_2018.xls"
	DBMS=XLS REPLACE;
	SHEET = "&&VAR";
	GETNAMES = YES;
	MIXED = YES;
RUN;
%MEND;

%MACRO 
READXLS6(VAR);
	PROC IMPORT OUT = &VAR. 
	DATAFILE = "D:\Sean\8.0_CAPP\ROC\COLL\2018_CAPP_80_COLL_(with_USDOT_V32).xls"
	DBMS=XLS REPLACE;
	SHEET = "&&VAR";
	GETNAMES = YES;
	MIXED = YES;
RUN;
%MEND;

%MACRO FMT_CREATOR(VAR); /*set up and name the macro*/
	%LET DS = %SYSFUNC(OPEN(&VAR,IS)); /*set macro variable ds to be the variable's factor sheet from excel, opened in input mode, read sequentially*/
	%DO I = 1 %TO %SYSFUNC(ATTRN(&DS,NVARS)); /*do from I = 1 to the number of variables in ds*/
		%LET DSVN&I = %SYSFUNC(VARNAME(&DS,&I)); /*set macro variable dsvn# to be the name of variable in position I from ds*/  
	%END;

	%DO i= 2 %TO %SYSFUNC(ATTRN(&DS,NVARS)); /*do from I=2 to the number of variables in ds*/
	DATA TEMP&I; /*create dataset temp#*/
		SET &VAR. END=LAST; /*set the factor sheet specified, end the loop at the last variable*/
		RETAIN FMTNAME "FMT_&&DSVN&I" TYPE 'C'; /*creates a format named fmt_dsvn# and makes it a character variable*/
		START = &DSVN1;
		LABEL = STRIP(&&DSVN&I); /*remove leading and trailing blanks from dsvn#*/
		OUTPUT;
	
		IF LAST THEN DO; 
		      HLO='O';
		      LABEL=.;
		      OUTPUT;
		END;
	RUN;
	PROC FORMAT LIBRARY=WORK CNTLIN=TEMP&I;RUN; /*save to the work library*/
	PROC DELETE DATA = WORK.TEMP&I; RUN;
	%END;
	%IF &DS > 0 %THEN 
	%LET rc = %SYSFUNC(CLOSE(&DS));
%MEND FMT_CREATOR;

