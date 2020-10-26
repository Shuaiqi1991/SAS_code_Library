

%MACRO TWEEDIE(INDATA=, P=, DEP_VAR=, CLASS_VAR=, MDL_VAR=, WEIGHT=, OUTDATA=, PRED_VAL=, PARAM_EST=);
	PROC GENMOD DATA = &INDATA.;
		P=&P.;
		A=_MEAN_;
		Y=_RESP_;
		VARIANCE VAR=A**P;
		DEVIANCE DEV=2*(Y**(2-P)-(2-P)*Y*A**(1-P)+(1-P)*A**(2-P))/((1-P)*(2-P));

		CLASS &CLASS_VAR./MISSING;
		MODEL &DEP_VAR. = &MDL_VAR. /LINK = LOG MAXIT = 300 CONVERGE = 0.02;
		WEIGHT &WEIGHT.;
		OUTPUT OUT = &OUTDATA. P = &PRED_VAL.;
		ODS OUTPUT PARAMETERESTIMATES = &PARAM_EST.;
	RUN; 
%MEND;
