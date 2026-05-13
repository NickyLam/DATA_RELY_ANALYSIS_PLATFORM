CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_EXN_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_EXN_INFO
  *  功能描述：贷款展期信息
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  ETL_INIT_M_LOAN_EXN_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220524  梅炜      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;    -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_EXN_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8);       -- 跑批数据日期
  V_STARTTIME DATE;            -- 处理开始时间
  V_ENDTIME DATE;              -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0;    -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);   -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100);    -- 来源系统
  V_STEP_DESC VARCHAR2(200);   --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_FREQ_FLAG VARCHAR2(10);    --跑批频度标识
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_EXN_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入贷款展期信息--对公';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_EXN_INFO
 (
      DATA_DT                                        --1数据日期
      ,LGL_REP_ID                                    --2法人编号
      ,CONT_ID                                       --3合同编号
      ,RCPT_ID                                       --4借据编号
      ,LOAN_EXTN_ID                                  --5贷款展期编号
      ,CUST_ID                                       --6客户编号
      ,ORG_ID                                        --7机构编号
      ,EXTN_DT                                       --8展期日期
      ,EXTN_EXP_DT                                   --9展期到期日期
      ,CUR                                           --10币种
      ,EXTN_AMT                                      --11展期金额
      ,ORIG_RATE                                     --12原利率
      ,RATE_TYP                                      --13利率类型
      ,EXTN_BASE_RATE                                --14展期基准利率
      ,RATE_FLT_VAL                                  --15利率浮动值
      ,ORIG_CONT_ID                                  --16原合同号
      ,ORIG_RCPT_NO                                  --17原借据号
      ,TRA_TLR_NO                                    --18交易柜员号
      ,GRANT_TLR_NO                                  --19授权柜员号
      ,EXTN_RATE                                     --20展期利率
      ,DEPT_LINE                                     --21部门条线
      ,DATA_SRC                                      --22数据来源
      )
      SELECT
       V_P_DATE                                     DATA_DT             --1数据日期
      ,A.LP_ID                                      LGL_REP_ID          --2法人编号
      ,A.CONT_ID                                    CONT_ID             --3合同编号
      ,A.DUBIL_NUM                                  RCPT_ID             --4借据编号
      ,A.DUBIL_NUM                                  LOAN_EXTN_ID        --5贷款展期编号
      ,A.CUST_ID                                    CUST_ID             --6客户编号
      ,A.ACCT_INSTIT_ID                             ORG_ID              --7机构编号
      ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                 EXTN_DT             --8展期日期
      ,TO_CHAR(A.RENEW_EXP_DAY,'YYYYMMDD')          EXTN_EXP_DT         --9展期到期日期
      ,A.CURR_CD                                    CUR                 --10币种
      ,NULL                                         EXTN_AMT            --11展期金额
      ,A.BASE_RAT                                   ORIG_RATE           --12原利率
      ,A.INT_RAT_BASE_TYPE_CD                       RATE_TYP            --13利率类型
      ,A.BASE_RAT                                   EXTN_BASE_RATE      --14展期基准利率
      ,A.INT_RAT_FLO_VAL                            RATE_FLT_VAL        --15利率浮动值
      ,A.CONT_ID                                    ORIG_CONT_ID        --16原合同号
      ,A.DUBIL_NUM                                  ORIG_RCPT_NO        --17原借据号
      ,B.OPER_TELLER_ID                             TRA_TLR_NO          --18交易柜员号
      ,NVL(B.OPER_TELLER_ID,RGST_TELLER_ID)         GRANT_TLR_NO        --19授权柜员号
      ,A.BASE_RAT                                   EXTN_RATE           --20展期利率
      ,NULL                                         DEPT_LINE           --21部门条线
      ,'展期-对公'                                   DATA_SRC            --22数据来源
      FROM  RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO       A  --对公贷款账户信息
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO  B  --对公贷款合同信息
        ON  A.CONT_ID  = B.CONT_ID
       AND  B.ETL_DT = A.ETL_DT
     WHERE  A.RENEW_FLG = '1'
       AND  A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');



   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入贷款展期信息--零售';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_EXN_INFO
 (
      DATA_DT                                          --1数据日期
      ,LGL_REP_ID                                      --2法人编号
      ,CONT_ID                                         --3合同编号
      ,RCPT_ID                                         --4借据编号
      ,LOAN_EXTN_ID                                    --5贷款展期编号
      ,CUST_ID                                         --6客户编号
      ,ORG_ID                                          --7机构编号
      ,EXTN_DT                                         --8展期日期
      ,EXTN_EXP_DT                                     --9展期到期日期
      ,CUR                                             --10币种
      ,EXTN_AMT                                        --11展期金额
      ,ORIG_RATE                                       --12原利率
      ,RATE_TYP                                        --13利率类型
      ,EXTN_BASE_RATE                                  --14展期基准利率
      ,RATE_FLT_VAL                                    --15利率浮动值
      ,ORIG_CONT_ID                                    --16原合同号
      ,ORIG_RCPT_NO                                    --17原借据号
      ,TRA_TLR_NO                                      --18交易柜员号
      ,GRANT_TLR_NO                                    --19授权柜员号
      ,EXTN_RATE                                       --20展期利率
      ,DEPT_LINE                                       --21部门条线
      ,DATA_SRC                                        --22数据来源
      )
      SELECT
       V_P_DATE                                        DATA_DT          --1数据日期
      ,A.LP_ID                                         LGL_REP_ID       --2法人编号
      ,A.CONT_ID                                       CONT_ID          --3合同编号
      ,A.DUBIL_NUM                                     RCPT_ID          --4借据编号
      ,A.DUBIL_NUM                                     LOAN_EXTN_ID     --5贷款展期编号
      ,A.CUST_ID                                       CUST_ID          --6客户编号
      ,A.ACCT_INSTIT_ID                                ORG_ID           --7机构编号
      ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                    EXTN_DT          --8展期日期
      ,TO_CHAR(A.RENEW_EXP_DT,'YYYYMMDD')              EXTN_EXP_DT      --9展期到期日期
      ,A.CURR_CD                                       CUR              --10币种
      ,NULL                                            EXTN_AMT         --11展期金额
      ,A.BASE_RAT                                      ORIG_RATE        --12原利率
      ,A.INT_RAT_BASE_TYPE_CD                          RATE_TYP         --13利率类型
      ,A.BASE_RAT                                      EXTN_BASE_RATE   --14展期基准利率
      ,A.INT_RAT_FLO_VAL                               RATE_FLT_VAL     --15利率浮动值
      ,A.CONT_ID                                       ORIG_CONT_ID     --16原合同号
      ,A.DUBIL_NUM                                     ORIG_RCPT_NO     --17原借据号
      ,B.CUST_MGR_ID                                   TRA_TLR_NO       --18交易柜员号
      ,B.CUST_MGR_ID                                   GRANT_TLR_NO     --19授权柜员号
      ,A.BASE_RAT                                      EXTN_RATE        --20展期利率
      ,NULL                                            DEPT_LINE        --21部门条线
      ,'展期-零售'                                      DATA_SRC         --22数据来源
      FROM
      RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO             A  --零售贷款账户信息
      LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO  B  --对公贷款合同信息
        ON  A.CONT_ID  = B.CONT_ID
       AND  B.ETL_DT = A.ETL_DT
     WHERE A.RENEW_FLG = '1'
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');



   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

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
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_LOAN_EXN_INFO;
/

