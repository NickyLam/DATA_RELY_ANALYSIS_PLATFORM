CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_G12_RESCHED
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_G12_RESCHED
  *  功能描述：本表反映年初对公贷款由正常贷款转不良贷款情况和年初不良贷款转正常贷款情况。
               将发生迁徙的贷款分为重组调整和非重组调整两类进行统计。
               重组调整是指历史上曾被重组调整过的贷款，重新由正常贷款转为不良贷款（或由不良贷款转为正 常贷款）部分，
               非重组调整是指由正常贷款转为不良贷款（或由不良贷款转为正 常贷款）部分中历史上未被重组调整过的贷款。
  *  创建日期：20221107
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_FGB_G12_RESCHED --贷款重组模型（G12）
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221107   liuyu      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_G12_RESCHED';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  --V_LAST_DAT   VARCHAR2(8);      -- 当月月末
  --V_YESTADAY   VARCHAR2(8);      -- 上日
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  --V_MONTH_START_DATE DATE;       --系统时间对应月初日期
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  --V_YESTADAY   := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT   := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  --V_MONTH_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM');
  V_TAB_NAME := 'A_FGB_G12_RESCHED'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期


  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

 -- DELETE FROM A_FGB_G12_RESCHED T WHERE T.BGRQ = V_P_DATE;--普通表的重跑处理

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
  ETL_PARTITION_ADD(I_P_DATE, 'A_FGB_G12_RESCHED', '1', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||'A_FGB_G12_RESCHED'||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入G12重组信息';
  V_STARTTIME := SYSDATE;

  /* INSERT INTO A_FGB_G12_RESCHED
					 (
					  BGRQ,								--报告日期
					  JYWYM,							--交易唯一码
					  KHWYM,							--客户唯一码
					  ZWJGBH,							--机构编号
					  ZWJGMC,							--机构名称
					  NCWJFL,							--年初五级分类
					  NCTJYE,							--年初统计余额（元）
					  BNCZSDWJFL,					--本年重组时点五级分类
					  BNCZSDTJYE,					--本年重组时点统计余额（元）
					  WJFL,								--五级分类
					  TJYE,								--统计余额（元）
					  YQTSQJ,							--逾期天数区间
					  TJYWPZ,							--统计业务品种
					  CZSDJE,							--重组上调金额（元）
					  SFBNXCZFADK 				--是否本年新重组方案贷款
					 )
     SELECT
     				V_P_DATE										 	 AS BGRQ, 										--报告日期
     				A.RCPT_ID      					  		 AS JYWYM, 										--交易唯一码
     				A.CUST_ID										   AS KHWYM,									  --客户唯一码
     				A.ORG_ID 							  			 AS ZWJGBH,										--机构编号
     				E.ORG_NM        						   AS ZWJGMC,										--机构名称
     				CASE WHEN B.LVL5_CL = '01' THEN '正常类'
                 WHEN B.LVL5_CL = '02' THEN '关注类'
                 WHEN B.LVL5_CL = '03' THEN '次级类'
                 WHEN B.LVL5_CL = '04' THEN '可疑类'
                 WHEN B.LVL5_CL = '05' THEN '损失类'
            END     							         AS NCWJFL,									  --年初五级分类
     				B.LOAN_BAL*U.EXRT 			       AS NCTJYE,									  --年初统计余额（元）
     				CASE WHEN B1.LVL5_CL = '01' THEN '正常类'
                 WHEN B1.LVL5_CL = '02' THEN '关注类'
                 WHEN B1.LVL5_CL = '03' THEN '次级类'
                 WHEN B1.LVL5_CL = '04' THEN '可疑类'
                 WHEN B1.LVL5_CL = '05' THEN '损失类'
            END     		   				         AS BNCZSDWJFL,								--本年重组时点五级分类
     				B1.LOAN_BAL*U.EXRT			       AS BNCZSDTJYE,							  --本年重组时点统计余额（元）
     				CASE WHEN A.LVL5_CL = '01' THEN '正常类'
                 WHEN A.LVL5_CL = '02' THEN '关注类'
                 WHEN A.LVL5_CL = '03' THEN '次级类'
                 WHEN A.LVL5_CL = '04' THEN '可疑类'
                 WHEN A.LVL5_CL = '05' THEN '损失类'
            END     							         AS WJFL,											--五级分类
     				A.LOAN_BAL*U.EXRT   			     AS TJYE,											--统计余额（元）
     				CASE WHEN TRIM(A.OVD_DAYS) IS NULL  OR A.OVD_DAYS <=0 THEN '01'
                         WHEN A.OVD_DAYS<=30    THEN '02'
                         WHEN A.OVD_DAYS>30  AND A.OVD_DAYS<=60   THEN '03'
                         WHEN A.OVD_DAYS>60  AND A.OVD_DAYS<=90   THEN '04'
                         WHEN A.OVD_DAYS>90  AND A.OVD_DAYS<=180  THEN '05'
                         WHEN A.OVD_DAYS>180 AND A.OVD_DAYS<=270  THEN '06'
                         WHEN A.OVD_DAYS>270 AND A.OVD_DAYS<=360  THEN '07'
                         WHEN A.OVD_DAYS>360                     THEN '08'
             END                           AS YQTSQJ,                    --逾期天数区间 码表编号A0036
             TRIM(P11.TAR_VALUE_NAME)      AS TJYWPZ,                    --统计业务品种
             ''                            AS CZSTJE,                    --重组上调金额（元）
             ''                            AS SFBNXCZFNDK                --是否本年新重组方案贷款
        FROM S_LOAN A --贷款借据信息表
      --=====从补录表取重组标志 START =======
       INNER JOIN (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY JYWYM ORDER BY JYWYM ) AS RN
                     FROM M_ADD_DG_003_MONEY T
                    WHERE DATA_DATE = V_P_DATE ) T -- 补录表
          ON T.JYWYM = A.RCPT_ID
         AND T.RN = 1
         AND T.DATA_DATE = V_P_DATE
      --=======从补录表取重组标志 END =======
        LEFT JOIN S_LOAN B --贷款借据信息表（取年初数据）
          ON A.RCPT_ID = B.RCPT_ID
         AND B.DATA_SRC IN ('对公信贷')
         AND B.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Y') - 1,
                                 'YYYYMMDD')
        LEFT JOIN M_LOAN_CONT_INFO C --贷款合同信息表
          ON A.CONT_ID = C.CONT_ID
         AND C.DATA_DT = A.DATA_DT
        LEFT JOIN S_LOAN B1 --取重组时点数据
          ON A.RCPT_ID = B1.RCPT_ID
         AND B1.DATA_SRC IN ('对公信贷')
         AND B1.DATA_DT = C.CONT_START_DT
         AND TRUNC(TO_DATE(C.CONT_START_DT, 'YYYYMMDD'), 'Y') =
             TRUNC(TO_DATE(A.DATA_DT, 'YYYYMMDD'), 'Y')
        LEFT JOIN M_PUM_ORG_INFO E --机构表
          ON A.ORG_ID = E.ORG_ID
         AND E.DATA_DT= A.DATA_DT
        LEFT JOIN M_PUM_EXRT_INFO U --汇率表
          ON U.BASE_CUR = A.CUR --基准币种
         AND U.CNV_CUR = 'CNY' --折算币种
         AND U.DATA_DT = A.DATA_DT
        LEFT JOIN CODE_MAP P11 --账户类型
         ON TRIM(A.LOAN_BIZ_TYP) = P11.TAR_VALUE_CODE
        AND P11.SRC_CLASS_CODE='T0001'
			  AND P11.MOD_FLG = 'EAST'
       WHERE A.DATA_DT = V_P_DATE
         AND A.DATA_SRC IN ('对公信贷')
         AND C.LOAN_HAPP_TYPE_CD IN ('0204', --债务重组
                                    '0201', --展期
                                    '0202') --借新还旧
      ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;*/


-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,JYWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_G12_RESCHED T
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

  END ETL_A_FGB_G12_RESCHED;
/

