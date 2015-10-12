CREATE OR REPLACE 
PACKAGE BODY pkg_analytic
AS
	PROCEDURE analytic IS 

	l_empno emp.empno%TYPE;
	l_deptno emp.deptno%TYPE;
	l_hiredate emp.hiredate%TYPE;
	l_srlno NATURAL;

	l_RANK NATURAL;
	l_DENSE_RANK NATURAL;
	l_NEXT_LOWER_SAL NUMBER;
	l_PREV_HIGHER_SAL NUMBER;
	l_DAY_GAP DATE;
	l_AVG_SAL_YR1_HIRE NUMBER;
	l_FROM_P3_TO_F1 NATURAL;
	l_FROM_PU_TO_C NATURAL;
	l_FROM_P2_TO_P1 NATURAL;
	l_FROM_F1_TO_F3 NATURAL;
	l_CNT_LT_HALF NATURAL;
	l_CNT_MT_HALF NATURAL;
	BEGIN

		SELECT 
		 empno
		,deptno
		,hiredate
		,ROW_NUMBER( ) OVER (PARTITION BY deptno ORDER BY hiredate NULLS LAST) SRLNO
		,RANK() OVER (PARTITION BY deptno ORDER BY sal DESC NULLS LAST) RANK
		,DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC NULLS LAST) DENSE_RANK
		,LEAD(sal, 1, 0) OVER (PARTITION BY dept ORDER BY sal DESC NULLS LAST) NEXT_LOWER_SAL
		,LAG(sal, 1, 0) OVER (PARTITION BY dept ORDER BY sal DESC NULLS LAST) PREV_HIGHER_SAL
		,FIRST_VALUE(hiredate) OVER (PARTITION BY deptno ORDER BY hiredate) DAY_GAP
		,TRUNC( AVG(sal) KEEP (DENSE_RANK FIRST ORDER BY TO_CHAR(hiredate,'YYYY') ) OVER (PARTITION BY deptno)) AVG_SAL_YR1_HIRE
		,COUNT(*) OVER (PARTITION BY TO_CHAR(hiredate, 'YYYY') ORDER BY hiredate ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING) FROM_P3_TO_F1
		,COUNT(*) OVER (PARTITION BY TO_CHAR(hiredate, 'YYYY') ORDER BY hiredate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM_PU_TO_C
		,COUNT(*) OVER (PARTITION BY TO_CHAR(hiredate, 'YYYY') ORDER BY hiredate ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) FROM_P2_TO_P1
		,COUNT(*) OVER (PARTITION BY TO_CHAR(hiredate, 'YYYY') ORDER BY hiredate ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) FROM_F1_TO_F3
		,Count(*) OVER (PARTITION BY deptno ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND (sal/2) PRECEDING) CNT_LT_HALF
		,COUNT(*) OVER (PARTITION BY deptno ORDER BY sal RANGE BETWEEN (sal/2) FOLLOWING AND UNBOUNDED FOLLOWING) CNT_MT_HALF
		INTO
		 l_empno 
		,l_deptno 
		,l_hiredate 
		,l_srlno 
		,l_rank
		,l_dense_rank
		,l_next_lower_sal
		,l_prev_higher_sal
		,l_day_gap
		,l_avg_sal_yr1_hire
		,l_from_p3_to_f1
		,l_from_pu_to_c
		,l_from_p2_to_p1
		,l_from_f1_to_f3
		,l_cnt_lt_half
		,l_cnt_mt_half
		FROM emp
		WHERE deptno IN (10, 20)
		ORDER BY deptno, SRLNO
		;
	END;
END;
/

