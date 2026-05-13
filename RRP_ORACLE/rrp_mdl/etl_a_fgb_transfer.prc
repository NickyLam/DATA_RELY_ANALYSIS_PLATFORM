CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_TRANSFER
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_TRANSFER
  *  功能描述：本表主要反映我行对公各项贷款发生减少的各种方式，包括直接转让债权、信贷资产证券化、
               信贷资产收益权转让、其他方式等项目，但不含贷款回收等。本表收集本金，不含利息的数据。
  *  创建日期：20221031
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_FGB_TRANSFER --对公资产转让模型
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221031   liuyu      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_TRANSFER';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'A_FGB_TRANSFER'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期


  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '分区处理';
   V_STARTTIME := SYSDATE;

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入信贷资产转让信息';
  V_STARTTIME := SYSDATE;

   INSERT INTO RRP_MDL.A_FGB_TRANSFER
  (BGRQ,      --1  报告日期
   JYWYM,     --2  交易唯一码
   ZWJGDM,    --3  账务机构代码
   ZWJGMC,    --4  账务机构名称
   KHWYM,     --5  客户唯一码
   KHMC,      --6  客户名称
   CPLX,      --7  产品类型
   CPMC,      --8  产品名称
   ZQZR,      --9  债权转让日期
   ZRFSLB,    --10 转让方式类别
   ZRFS,      --11 转让方式
   DYBJ,      --12 对应本金
   CZQWJFL,   --13 处置前五级分类
   SFZZG,     --14 是否债转股
   SSJE,      --15 损失金额（元）
   TZHHXJE,   --16 调整后核销金额（元）
   THZCHSHJE, --17 调回正常后收回金额
   TZHZRHSXJ, --18 调整后转让回收现金（元）
   ZRSHQTDJ,  --19 转让收回其他对价
   ZCJE,      --20 自持金额（元）
   ZCZRJYPT,  --21 资产转让交易平台
   ZCZRDJPT,  --22 资产转让登记平台
   ZJJYDSLB,  --23 直接交易对手类别
   JYDSMC,    --24 交易对手名称
   ZQZRYZ,    --25 债券转让原值（元）
   ZQZRXYJE,  --26 债权转让协议金额（元）
   DJPTDJJE   --27 登记平台登记金额
   )
   SELECT /*+ PARALLEL*/
          T1.DATA_DATE                            AS BGRQ              -- 数据日期
         ,T1.JYWYM                                AS JYWYM             -- 交易唯一码
         ,T1.ACCT_ORG_NUM                         AS ZWJGDM            -- 账务机构编号
         ,T1.ZWJGMC                               AS ZWJGMC            -- 账务机构名称
         ,T1.KHWYM                                AS KHWYM             -- 客户唯一码
         ,T1.KHMC                                 AS KHMC              -- 客户名称
         ,T1.CPLX                                 AS CPLX              -- 产品类型
         ,T1.CPMC                                 AS CPMC              -- 产品名称
         ,T1.ZQZRRQ                               AS ZQZRRQ            -- 债权转让日期
         ,CASE WHEN T10.CODE IS NOT NULL
		          THEN T10.CODENAME
			        ELSE T1.ZRFSLB
		      END                                     AS ZRFSLB            -- 转让方式类别
         ,T1.ZRFS                                 AS ZRFS              -- 转让方式
         ,T1.DYBJ                                 AS DYBJ              -- 对应本金
         ,CASE WHEN T13.CODE IS NOT NULL
		           THEN T13.CODENAME
		           ELSE T1.CZQWJFL
		      END                                     AS CZQWJFL           -- 处置前五级分类
         ,CASE WHEN T14.CODE IS NOT NULL
		           THEN T14.CODENAME
		           ELSE T1.SFZZG
		      END                                     AS SFZZG             -- 是否债转股
         ,T1.SSJE                                 AS SSJE              -- 损失金额（元）
         ,T1.DZHHXJE                              AS TZHHXJE           -- 调整后核销金额（元）
         ,T1.DHZCHSHJE                            AS THZCHSHJE         -- 调回正常后收回金额
         ,T1.DZHZRHSXJ                            AS TZHZRHSXJ         -- 调整后转让回收现金（元）
         ,T1.ZRSHQTDJ                             AS ZRSHQTDJ          -- 转让收回其他对价（元）
         ,T1.ZCJE                                 AS ZCJE              -- 自持金额（元）
         ,CASE WHEN T21.CODE IS NOT NULL
		           THEN T21.CODENAME
			         ELSE T1.ZCZRJYPT
		      END                                     AS ZCZRJYPT          -- 资产转让交易平台
         ,CASE WHEN T22.CODE IS NOT NULL
		           THEN T22.CODENAME
		           ELSE T1.ZCZRDJPT
		      END                                     AS ZCZRDJPT          -- 资产转让登记平台
         ,CASE WHEN T23.CODE IS NOT NULL
		           THEN T23.CODENAME
			         ELSE T1.ZJJYDSLB
	        END                                     AS ZJJYDSLB          -- 直接交易对手类别
         ,T1.JYDSMC                               AS JYDSMC            -- 交易对手名称
         ,''                                      AS ZQZRYZ            -- 债券转让原值（元）
         ,''                                      AS ZQZRXYJE          -- 债权转让协议金额（元）
         ,T1.DJPTDJJE                             AS DJPTDJJE          -- 登记平台登记金额
         /*,CASE WHEN T29.CODE IS NOT NULL
		       THEN T29.CODENAME
		       ELSE T1.SFSC
		  END                                     AS SFSC              -- 是否删除*/
     FROM (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY JYWYM ORDER BY JYWYM ) AS RN
             FROM M_ADD_DG_011_ASSETS_CONVEY T
            WHERE T.DATA_DATE = V_P_DATE ) T1 --资产转让补录表--模型层
	   LEFT JOIN M_BASIC_CODETABLE T10
	     ON T1.ZRFSLB = T10.CODE
	    AND T10.CODE_TABLE_CODE = 'A0023'
     LEFT JOIN M_BASIC_CODETABLE T21
	     ON T1.ZCZRJYPT = T21.CODE
	    AND T21.CODE_TABLE_CODE= 'A0120'
     LEFT JOIN M_BASIC_CODETABLE T22
  	   ON T1.ZCZRDJPT = T22.CODE
	    AND T22.CODE_TABLE_CODE = 'A0024'
     LEFT JOIN M_BASIC_CODETABLE T23
	     ON T1.ZJJYDSLB = T23.CODE
	    AND T23.CODE_TABLE_CODE = 'M0039'
	    AND T23.ISVALUE='是'
     LEFT JOIN M_BASIC_CODETABLE T13
	     ON T1.CZQWJFL = T13.CODE
	    AND T13.CODE_TABLE_CODE = 'A0007'
     LEFT JOIN M_BASIC_CODETABLE T14
	     ON T1.SFZZG = T14.CODE
	    AND T14.CODE_TABLE_CODE= 'A0010'
     LEFT JOIN M_BASIC_CODETABLE T29
	     ON T1.SFSC = T29.CODE
	    AND T29.CODE_TABLE_CODE= 'A0010'
    WHERE T1.DATA_DATE = V_P_DATE
      AND T1.RN = 1;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,JYWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_TRANSFER T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
--插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
     V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_FGB_TRANSFER;
/

