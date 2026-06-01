/*
-- 建数据差异量表
CREATE TABLE TAB_DATA_COMPARE_COUNT(
	OWNER						VARCHAR2(100)			-- 层级
	,TABLE_NAME					VARCHAR2(1000)			-- 表名
	,COUNT_TABLE_USER1			NUMBER					-- USER1的表数据量
	,COUNT_TABLE_USER2			NUMBER					-- USER2的表数据量
	,COUNT_USER1_MINUS_USER2	NUMBER					-- USER1的表数据量减去USER2的表数据量
	,ERROR_MSG             		VARCHAR2(4000)          -- 报错信息
	,ETL_TIMESTAMP         		TIMESTAMP(6)          	-- 时间戳
);
*/

CREATE OR REPLACE PROCEDURE P_TAB_DATA_COMPARE_COUNT(
	I_DT		VARCHAR2,		-- 数据日期
	I_OWNER		VARCHAR2		-- 层级

)
/*********************************************************************
  *过程名称： P_TAB_DATA_COMPARE_COUNT
  *中文名称： 单表数据比对
  *输入参数： I_DT     数据日期('YYYYMMDD')
			  I_OWNER  层级('IOL','IML','ICL')
  *功能描述： 统计USER1和USER2的同一张表的表数据量
  *开发人员： 曾桦翔
  *创建日期： 20240513
  *更新记录： 20240515   曾桦翔   将清空数据差异量表修改为删除重跑的层级原数据；在结果表里增加报错信息，时间戳，表数据相减字段。
  
  *********************************************************************/
AS
	V_OWNER						VARCHAR2(100);		-- 层级
	V_TAB						VARCHAR2(1000);		-- 表名
	V_TAB2					VARCHAR2(1000);		-- 表名
	V_DT						VARCHAR2(100);		-- 数据日期
	V_COUNT_TAB_USER1			NUMBER;				-- USER1 的表数据量
	V_COUNT_TAB_USER2			NUMBER;				-- USER2 的表数据量
	V_EXISTS_BAK				VARCHAR2(1);		-- 备份表存在标志
	V_EXISTS_EV					VARCHAR2(1);		-- ETL_DT存在标志
	V_SQL1						VARCHAR2(4000);		-- 统计USER1的表数据量的动态SQL语句
	V_SQL2						VARCHAR2(4000);		-- 统计USER2的表数据量的动态SQL语句
	V_SQL3						VARCHAR2(4000);		-- 将统计结果插入结果表中的动态SQL语句
	V_ERROR_MSG					CLOB;				-- 报错信息
	
BEGIN
	-- 不限制输出结果
	DBMS_OUTPUT.ENABLE(BUFFER_SIZE => NULL);	
	
	-- 开启并发
	EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL QUERY PARALLEL 8';
	EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL DML PARALLEL 8';
	
	-- 初始化变量
	V_DT 	 := I_DT;
	V_OWNER	 := UPPER(I_OWNER);
	
	-- 删除重跑的层级原数据
	EXECUTE IMMEDIATE 'DELETE FROM TAB_DATA_COMPARE_COUNT_'||V_OWNER||' WHERE SCHEMA = '''||V_OWNER||'''';
	COMMIT;
	
	-- 循环取表名
	FOR TABS IN (
		SELECT TABLE_NAME 
		FROM ALL_TABLES@TMP_HDW_UTF8
		WHERE OWNER = V_OWNER
		AND OWNER IN ('IOL','IML','ICL')
--		AND TABLE_NAME IN ('CMM_DEP_ACCT_INFO','PTY_CORP','NCBS_RB_ACCT')
	) LOOP
		-- 初始化变量
		V_TAB := TABS.TABLE_NAME;
		V_TAB2 := TABS.TABLE_NAME||'@TMP_HDW_UTF8';
		BEGIN
			-- 判断备份表是否存在
			SELECT COUNT(1) INTO V_EXISTS_BAK 
			FROM ALL_TABLES
			WHERE OWNER = V_OWNER AND TABLE_NAME = V_TAB;
			--DBMS_OUTPUT.PUT_LINE(V_EXISTS_BAK);
			
			-- 只统计备份表存在的
			IF V_EXISTS_BAK = 1 THEN
				-- 判断表结构
				SELECT COUNT(1) INTO V_EXISTS_EV
				FROM ALL_TAB_COLS
				WHERE OWNER = V_OWNER AND TABLE_NAME = V_TAB AND COLUMN_NAME = 'ETL_DT';
				--DBMS_OUTPUT.PUT_LINE(V_EXISTS_EV);
				
				-- 流水表
				IF V_EXISTS_EV = 1 THEN
					-- 统计USER1的表数据量
					V_SQL1 := '
					SELECT COUNT(1)  
					FROM '||V_OWNER||'.'||V_TAB||' 
					WHERE ETL_DT = TO_DATE('''||V_DT||''',''YYYYMMDD'') 
					';
					EXECUTE IMMEDIATE V_SQL1 INTO V_COUNT_TAB_USER1;
					--DBMS_OUTPUT.PUT_LINE(V_COUNT_TAB_USER1);
					
					-- 统计USER2的表数据量
					V_SQL2 := '
					SELECT COUNT(1)  
					FROM '||V_OWNER||'.'||V_TAB2||' 
					WHERE ETL_DT = TO_DATE('''||V_DT||''',''YYYYMMDD'') 
					';
					EXECUTE IMMEDIATE V_SQL2 INTO V_COUNT_TAB_USER2 ;
					--DBMS_OUTPUT.PUT_LINE(V_COUNT_TAB_USER2);					
					
					-- 将统计结果插入结果表中
					V_SQL3 := '
					INSERT INTO TAB_DATA_COMPARE_COUNT_'||V_OWNER||'
					VALUES(
					'''||V_OWNER||''',
					'''||V_TAB||''',
					'||V_COUNT_TAB_USER1||',
					'||V_COUNT_TAB_USER2||',
					'''',
					'''',
					sysdate
					)';
					--DBMS_OUTPUT.PUT_LINE(V_SQL3);
					EXECUTE IMMEDIATE V_SQL3;
					COMMIT;
				
				-- 拉链表
				ELSE
					-- 统计USER1的表数据量
					V_SQL1 := '
					SELECT COUNT(1)  
					FROM '||V_OWNER||'.'||V_TAB||' 
					WHERE START_DT <= TO_DATE('''||V_DT||''',''YYYYMMDD'') AND END_DT > TO_DATE('''||V_DT||''',''YYYYMMDD'')
					';
					EXECUTE IMMEDIATE V_SQL1 INTO V_COUNT_TAB_USER1;
					--DBMS_OUTPUT.PUT_LINE(V_COUNT_TAB_USER1);
					
					-- 统计USER2的表数据量
					V_SQL2 := '
					SELECT COUNT(1) 
					FROM '||V_OWNER||'.'||V_TAB2||' 
					WHERE START_DT <= TO_DATE('''||V_DT||''',''YYYYMMDD'') AND END_DT > TO_DATE('''||V_DT||''',''YYYYMMDD'')
					';
					EXECUTE IMMEDIATE V_SQL2 INTO V_COUNT_TAB_USER2 ;
					--DBMS_OUTPUT.PUT_LINE(V_COUNT_TAB_USER2);					
					
					-- 将统计结果插入结果表中
					V_SQL3 := '
					INSERT INTO TAB_DATA_COMPARE_COUNT_'||V_OWNER||'
					VALUES(
					'''||V_OWNER||''',
					'''||V_TAB||''',
					'||V_COUNT_TAB_USER1||',
					'||V_COUNT_TAB_USER2||',
					'''',
					'''',
					sysdate
					)';
					--DBMS_OUTPUT.PUT_LINE(V_SQL3);
					EXECUTE IMMEDIATE V_SQL3;
					COMMIT;
					
				END IF;
			
			EXECUTE IMMEDIATE 'UPDATE TAB_DATA_COMPARE_COUNT_'||V_OWNER||' SET COUNT_USER1_MINUS_USER2 = COUNT_TABLE_USER1 - COUNT_TABLE_USER2';
			COMMIT;
				
			END IF;
		
		EXCEPTION
			WHEN OTHERS THEN
				V_COUNT_TAB_USER1 := 9.9;
				V_COUNT_TAB_USER2 := 9.9;
				V_ERROR_MSG	:= '统计'||V_OWNER||'的'||V_TAB||'时 ERROR OCCURRED:'||SQLERRM;				
				DBMS_OUTPUT.PUT_LINE(V_ERROR_MSG);
				-- 将统计结果插入结果表中
				V_SQL3 := '
				INSERT INTO TAB_DATA_COMPARE_COUNT_'||V_OWNER||' 
				VALUES(
				'''||V_OWNER||''',
				'''||V_TAB||''',
				'||V_COUNT_TAB_USER1||',
				'||V_COUNT_TAB_USER2||',
				'''',
				'''||V_ERROR_MSG||''',
				sysdate
				)';
				EXECUTE IMMEDIATE V_SQL3;
				COMMIT;				
			CONTINUE;
		
		END;
	
	END LOOP;
	
	
EXCEPTION
	WHEN OTHERS THEN
		--ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('ERROR OCCURRED:'||SQLERRM);

END;
/
/*
-- 调用
DECLARE

BEGIN
	P_TAB_DATA_COMPARE_COUNT('20240423','IOL');
	--P_TAB_DATA_COMPARE_COUNT('20240423','ICL');
	--P_TAB_DATA_COMPARE_COUNT('20240423','IML');
END;
*/
