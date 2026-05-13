CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_WRITE_OFF(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_WRITE_OFF
  *  功能描述：资产核销信息
  *  创建日期：20230301
  *  开发人员：HYF
  *  来源表：
  *  目标表：  ETL_S_LOAN_WRITE_OFF
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230301  HYF      首次创建
  *             2    20240506  HYF      核销收回本金剔除冲正数据
                3    20241107  lwb      修改联合网贷的取值时间，改为T-2取数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP             INTEGER := 0;                            -- 处理步骤
  V_PROC_NAME        VARCHAR2(30) := 'ETL_S_LOAN_WRITE_OFF';  -- 程序名称
  V_P_DATE           VARCHAR2(8);                             -- 跑批数据日期
  V_START_DT         DATE;                                    -- 处理开始时间
  V_STARTTIME        DATE;                                    -- 处理开始时间
  V_ENDTIME          DATE;                                    -- 处理结束时间
  V_SQLCOUNT         INTEGER := 0;                            -- 更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);                           -- SQL执行描述信息
  V_SYSTEM           VARCHAR2(30);                            -- 来源系统
  V_MONTH_START_DATE DATE;                                    --系统时间对应月初日期
  V_STEP_DESC        VARCHAR2(200);                           --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名

  BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE);                            -- 获取跑批日期
  V_SYSTEM := '监管报送';                                     -- 默认写监管报送系统，有真实来源的按实际写
  V_MONTH_START_DATE :=TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM');
  V_START_DT   := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');
  V_TAB_NAME := 'S_LOAN_WRITE_OFF'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_WRITE_OFF T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_WRITE_OFF'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资产核销信息--对公贷款';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_WRITE_OFF
  (
          DATA_DT             --01 数据日期
         ,ORG_NUM               --02 机构号
         ,LOAN_NUM              --03 借据号
         ,ACCT_NUM              --04 合同号
         ,CUST_ID               --05 客户号
         ,DRAWDOWN_AMT          --06 实核贷款本金
         ,ACCRUAL               --07 实核表内利息
         ,ACCRUAL_OBS           --08 实核表外利息
         ,WRITE_OFF_DATE        --09 核销日期
         ,RETRIEVE_AMT          --10 核销收回本金
         ,RETRIEVE_INT          --11 核销收回表内利息
         ,RETRIEVE_INT_OBS      --12 核销收回表外利息
         ,RETRIEVE_DATE         --13 核销收回日期
         ,CURR_CD               --14 币种
         ,TH_YEAR_REVERSE_AMT   --15 本年核销贷款转回本金
         ,TH_YEAR_RETRIEVE_AMT  --16 本年核销贷款收回本金
         ,RETRIEVE_NO           --17 核销收回序号
         ,DATA_SRC              --18 数据来源
    )
    SELECT
          V_P_DATE                   AS DATA_DT             --01 数据日期
         ,A.BELONG_ORG_ID            AS ORG_NUM               --02 机构号
         ,A.DUBIL_ID                 AS LOAN_NUM              --03 借据号
         ,A.CONT_ID                  AS ACCT_NUM              --04 合同号
         ,A.CUST_ID                  AS CUST_ID               --05 客户号
         ,A.ACTL_WRTOFF_LOAN_PRIC    AS DRAWDOWN_AMT          --06 实核贷款本金
         ,A.ACTL_WRTOFF_IN_BS_INT    AS ACCRUAL               --07 实核表内利息
         ,A.ACTL_WRTOFF_OFF_BS_INT   AS ACCRUAL_OBS           --08 实核表外利息
         ,A.FIR_WRT_OFF_DT           AS WRITE_OFF_DATE        --09 核销日期
         ,D.CURRT_REPAY_PRIC         AS RETRIEVE_AMT          --10 核销收回本金
         ,D.CURRT_REPAY_INT          AS RETRIEVE_INT          --11 核销收回表内利息
         ,''                         AS RETRIEVE_INT_OBS      --12 核销收回表外利息
         ,D.REPAY_DT                 AS RETRIEVE_DATE         --13 核销收回日期
         ,A.CURR_CD                  AS CURR_CD               --14 币种
         ,B.CURRT_REPAY_PRIC         AS TH_YEAR_REVERSE_AMT   --15 本年核销贷款转回本金--MDF BY HAP 20200916 跟春雪确认按照本年核销贷款收回本金取值
         ,B.CURRT_REPAY_PRIC         AS TH_YEAR_RETRIEVE_AMT  --16 本年核销贷款收回本金
         ,RETRIEVE_NO_SEQ.NEXTVAL    AS RETRIEVE_NO           --17 核销收回序号
         ,'对公贷款'                 AS DATA_SRC              --18 数据来源
    FROM ICL.V_CMM_LOAN_WRT_OFF_INFO A   --贷款核销信息表
    INNER JOIN ICL.V_CMM_CORP_LOAN_ACCT_INFO C   --对公贷款账户信息
          ON A.DUBIL_ID = C.DUBIL_NUM
         AND A.ETL_DT = C.ETL_DT
    LEFT JOIN (SELECT REPAY_DT,DUBIL_ID
                      ,SUM(CURRT_REPAY_PRIC) AS CURRT_REPAY_PRIC
                      ,SUM(CURRT_REPAY_INT) AS CURRT_REPAY_INT
               FROM ICL.V_CMM_CORP_LOAN_REPAY_DTL  --对公贷款还款明细
               GROUP BY REPAY_DT,DUBIL_ID )D --汇总还款日当天核销收回的金额 MDF BY HAP 20210121
    ON A.DUBIL_ID = D.DUBIL_ID
    AND D.REPAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.FIR_WRT_OFF_DT <= D.REPAY_DT
    LEFT JOIN (SELECT A.DUBIL_ID
                     ,SUM(B.CURRT_REPAY_PRIC) AS CURRT_REPAY_PRIC
               FROM ICL.V_CMM_LOAN_WRT_OFF_INFO A --贷款核销信息表
               LEFT JOIN ICL.V_CMM_CORP_LOAN_REPAY_DTL B --对公贷款还款明细
               ON A.DUBIL_ID = B.DUBIL_ID
               WHERE TO_CHAR(B.REPAY_DT,'YYYY') = SUBSTR(V_P_DATE, 1, 4)
                 AND B.REPAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND A.FIR_WRT_OFF_DT <= B.REPAY_DT
                 AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               GROUP BY A.DUBIL_ID) B  --汇总本年核销收回的金额  MDF BY HAP 20210121
      ON A.DUBIL_ID = B.DUBIL_ID
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.FIR_WRT_OFF_DT IS NOT NULL;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资产核销信息--零售贷款';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_WRITE_OFF
  (
          DATA_DT             --01 数据日期
         ,ORG_NUM               --02 机构号
         ,LOAN_NUM              --03 借据号
         ,ACCT_NUM              --04 合同号
         ,CUST_ID               --05 客户号
         ,DRAWDOWN_AMT          --06 实核贷款本金
         ,ACCRUAL               --07 实核表内利息
         ,ACCRUAL_OBS           --08 实核表外利息
         ,WRITE_OFF_DATE        --09 核销日期
         ,RETRIEVE_AMT          --10 核销收回本金
         ,RETRIEVE_INT          --11 核销收回表内利息
         ,RETRIEVE_INT_OBS      --12 核销收回表外利息
         ,RETRIEVE_DATE         --13 核销收回日期
         ,CURR_CD               --14 币种
         ,TH_YEAR_REVERSE_AMT   --15 本年核销贷款转回本金
         ,TH_YEAR_RETRIEVE_AMT  --16 本年核销贷款收回本金
         ,RETRIEVE_NO           --17 核销收回序号
         ,DATA_SRC              --18 数据来源
    )
    SELECT
          V_P_DATE                   AS DATA_DT             --01 数据日期
         ,A.BELONG_ORG_ID            AS ORG_NUM               --02 机构号
         ,A.DUBIL_ID                 AS LOAN_NUM              --03 借据号
         ,A.CONT_ID                  AS ACCT_NUM              --04 合同号
         ,A.CUST_ID                  AS CUST_ID               --05 客户号
         ,A.ACTL_WRTOFF_LOAN_PRIC    AS DRAWDOWN_AMT          --06 实核贷款本金
         ,A.ACTL_WRTOFF_IN_BS_INT    AS ACCRUAL               --07 实核表内利息
         ,A.ACTL_WRTOFF_OFF_BS_INT   AS ACCRUAL_OBS           --08 实核表外利息
         ,A.FIR_WRT_OFF_DT           AS WRITE_OFF_DATE        --09 核销日期
         ,D.CURRT_REPAY_PRIC         AS RETRIEVE_AMT          --10 核销收回本金
         ,D.CURRT_REPAY_INT          AS RETRIEVE_INT          --11 核销收回表内利息
         ,''                         AS RETRIEVE_INT_OBS      --12 核销收回表外利息
         ,D.REPAY_DT                 AS RETRIEVE_DATE         --13 核销收回日期
         ,A.CURR_CD                  AS CURR_CD               --14 币种
         ,B.CURRT_REPAY_PRIC         AS TH_YEAR_REVERSE_AMT   --15 本年核销贷款转回本金--MDF BY HAP 20200916 跟春雪确认按照本年核销贷款收回本金取值
         ,B.CURRT_REPAY_PRIC         AS TH_YEAR_RETRIEVE_AMT  --16 本年核销贷款收回本金
         ,RETRIEVE_NO_SEQ.NEXTVAL    AS RETRIEVE_NO           --17 核销收回序号
         ,'零售贷款'                 AS DATA_SRC              --18 数据来源
    FROM ICL.V_CMM_LOAN_WRT_OFF_INFO A   --贷款核销信息表
    INNER JOIN ICL.V_CMM_RETL_LOAN_ACCT_INFO C   --零售贷款账户信息
          ON A.DUBIL_ID = C.DUBIL_NUM
         AND A.ETL_DT = C.ETL_DT
     LEFT JOIN (SELECT REPAY_DT,DUBIL_ID
                      ,SUM(CURRT_REPAY_PRIC) AS CURRT_REPAY_PRIC
                      ,SUM(CURRT_REPAY_INT) AS CURRT_REPAY_INT
               FROM ICL.V_CMM_RETL_LOAN_REPAY_DTL  --零售贷款还款明细
               WHERE STRK_BAL_FLG <> '1' --剔除冲正 MDF BY HAP 20240506
               GROUP BY REPAY_DT,DUBIL_ID )D --汇总还款日当天核销收回的金额 MDF BY HAP 20210121
    ON A.DUBIL_ID = D.DUBIL_ID
    AND D.REPAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.FIR_WRT_OFF_DT <= D.REPAY_DT
    LEFT JOIN (SELECT A.DUBIL_ID
                     ,SUM(B.CURRT_REPAY_PRIC) AS CURRT_REPAY_PRIC
               FROM ICL.V_CMM_LOAN_WRT_OFF_INFO A --贷款核销信息表
               LEFT JOIN ICL.V_CMM_RETL_LOAN_REPAY_DTL B --零售贷款还款明细
               ON A.DUBIL_ID = B.DUBIL_ID
               WHERE TO_CHAR(B.REPAY_DT,'YYYY') = SUBSTR(V_P_DATE, 1, 4)
                 AND B.REPAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND A.FIR_WRT_OFF_DT <= B.REPAY_DT
                 AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               GROUP BY A.DUBIL_ID) B  --汇总本年核销收回金额的  MDF BY HAP 20210121
      ON A.DUBIL_ID = B.DUBIL_ID
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.FIR_WRT_OFF_DT IS NOT NULL
	 ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := 4; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资产核销信息--联合网贷';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_WRITE_OFF
  (
          DATA_DT             --01 数据日期
         ,ORG_NUM               --02 机构号
         ,LOAN_NUM              --03 借据号
         ,ACCT_NUM              --04 合同号
         ,CUST_ID               --05 客户号
         ,DRAWDOWN_AMT          --06 实核贷款本金
         ,ACCRUAL               --07 实核表内利息
         ,ACCRUAL_OBS           --08 实核表外利息
         ,WRITE_OFF_DATE        --09 核销日期
         ,RETRIEVE_AMT          --10 核销收回本金
         ,RETRIEVE_INT          --11 核销收回表内利息
         ,RETRIEVE_INT_OBS      --12 核销收回表外利息
         ,RETRIEVE_DATE         --13 核销收回日期
         ,CURR_CD               --14 币种
         ,TH_YEAR_REVERSE_AMT   --15 本年核销贷款转回本金
         ,TH_YEAR_RETRIEVE_AMT  --16 本年核销贷款收回本金
         ,RETRIEVE_NO           --17 核销收回序号
         ,DATA_SRC              --18 数据来源
    )
    SELECT
          V_P_DATE                   AS DATA_DT             --01 数据日期
         ,A.BELONG_ORG_ID            AS ORG_NUM               --02 机构号
         ,A.DUBIL_ID                 AS LOAN_NUM              --03 借据号
         ,A.CONT_ID                  AS ACCT_NUM              --04 合同号
         ,A.CUST_ID                  AS CUST_ID               --05 客户号
         ,A.ACTL_WRTOFF_LOAN_PRIC    AS DRAWDOWN_AMT          --06 实核贷款本金
         ,A.ACTL_WRTOFF_IN_BS_INT    AS ACCRUAL               --07 实核表内利息
         ,A.ACTL_WRTOFF_OFF_BS_INT   AS ACCRUAL_OBS           --08 实核表外利息
         ,A.FIR_WRT_OFF_DT           AS WRITE_OFF_DATE        --09 核销日期
         ,NVL(D.CURRT_REPAY_PRIC,0)  AS RETRIEVE_AMT          --10 核销收回本金
         ,NVL(D.CURR_REPAY_INT,0)    AS RETRIEVE_INT          --11 核销收回表内利息
         ,''                         AS RETRIEVE_INT_OBS      --12 核销收回表外利息
         ,D.REPAY_DT                 AS RETRIEVE_DATE         --13 核销收回日期
         ,UPPER(A.CURR_CD)           AS CURR_CD               --14 币种
         ,NVL(B.CURRT_REPAY_PRIC,0)  AS TH_YEAR_REVERSE_AMT   --15 本年核销贷款转回本金--MDF BY HAP 20200916 跟春雪确认按照本年核销贷款收回本金取值
         ,NVL(B.CURRT_REPAY_PRIC,0)  AS TH_YEAR_RETRIEVE_AMT  --16 本年核销贷款收回本金
         ,RETRIEVE_NO_SEQ.NEXTVAL    AS RETRIEVE_NO           --17 核销收回序号
         ,'联合网贷'                 AS DATA_SRC              --18 数据来源
    FROM ICL.V_CMM_UNITE_WL_WRT_OFF_INFO A --联合网贷核销信息
    INNER JOIN ICL.V_CMM_UNITE_WL_DUBIL_INFO C
          ON A.DUBIL_ID = C.DUBIL_ID
         AND A.ETL_DT = C.ETL_DT
    LEFT JOIN (SELECT T.REPAY_DT,T.DUBIL_ID,
                      SUM(CURRT_REPAY_PRIC) AS CURRT_REPAY_PRIC,
                      SUM(CURR_REPAY_INT) AS CURR_REPAY_INT
                      FROM ICL.V_CMM_UNITE_WL_REPAY_DTL T
                      GROUP BY T.REPAY_DT,T.DUBIL_ID)D --联合网贷还款明细
          ON A.DUBIL_ID = D.DUBIL_ID
         AND A.FIR_WRT_OFF_DT<=D.REPAY_DT  --BY WL 20201204 经生产跑批发现核销借据核销后收回流水未打核销标志，并咨询曹宁宁联合网贷借据不存在部分核销，因此控制核销后借据的还款明细均算作核销后收回
         AND D.REPAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')-1                       --ADD BY HAP 20210121 加上时间限制
    LEFT JOIN (SELECT AA.ETL_DT
                     ,AA.DUBIL_ID
                     ,SUM(BB.CURRT_REPAY_PRIC) AS CURRT_REPAY_PRIC
                FROM ICL.V_CMM_UNITE_WL_WRT_OFF_INFO AA --联合网贷核销信息
                LEFT JOIN  ICL.V_CMM_UNITE_WL_REPAY_DTL BB  --联合网贷还款明细
                  ON AA.DUBIL_ID = BB.DUBIL_ID
            WHERE AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')-1--MODIFY BY LWB
              AND BB.REPAY_DT>= TO_DATE(SUBSTR(V_P_DATE, 1, 4)||'0101','YYYYMMDD')-1 --由于联合网贷上年末统计时未包含年末最后一天数据，因此补到今年的统计中
              AND BB.REPAY_DT<=TO_DATE(V_P_DATE,'YYYYMMDD')-1  --由于联合网贷为t+2数据，因此控制还款日期小于等于跑批日期-1，避免多取还款流水
              AND AA.FIR_WRT_OFF_DT<=BB.REPAY_DT
                --BY WL 20201204 经生产跑批发现核销借据核销后收回流水未打核销标志，并咨询曹宁宁联合网贷借据不存在部分核销，因此控制核销后借据的还款明细均算作核销后收回 取整年的核销后收回
                --AND WRT_OFF_FLG = '1'
                --AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               GROUP BY AA.ETL_DT, AA.DUBIL_ID) B
      ON A.DUBIL_ID = B.DUBIL_ID
     AND A.ETL_DT = B.ETL_DT                  --汇总本年收回金额的联合网贷还款明细
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')-1;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := 5;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, LOAN_NUM,WRITE_OFF_DATE,RETRIEVE_DATE,RETRIEVE_NO,COUNT(1)
      FROM S_LOAN_WRITE_OFF T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, LOAN_NUM ,WRITE_OFF_DATE,RETRIEVE_DATE,RETRIEVE_NO
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

 -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_LOAN_WRITE_OFF;
/

