CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_APP_INFO
(I_P_DATE IN INTEGER, --跑批日期
 O_ERRCODE OUT VARCHAR2  --错误代码
 )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_APP_INFO
  *  功能描述：贷款申请信息
  *  创建日期：20220519
  *  开发人员：梅炜
  *  来源表：  O_ICL_CMM_RETL_LOAN_APPL_INFO
               O_ICL_CMM_RETL_LOAN_DUBIL_INFO
               O_ICL_CMM_UNITE_WL_APPL_INFO
               O_ICL_CMM_UNITE_WL_DUBIL_INFO
               O_ICL_CMM_CORP_LOAN_APPL_INFO
               O_ICL_CMM_CORP_LOAN_DUBIL_INFO
  *  目标表：  M_LOAN_APP_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220519  梅炜     首次创建
  *             2    20221119  MW       根据评审结果修改
                3    20230220  LIUYU    对公逻辑段新增字段 可售产品 额度产品
  ***************************************************************************/
  IS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_APP_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200);  --任务描述
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_APP_INFO'; --表名
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
  V_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '贷款申请信息—零售贷款部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_LOAN_APP_INFO
  (
  DATA_DT  --数据日期
  ,LGL_REP_ID  --法人编号
  ,APP_ID   --申请编号
  ,ORG_ID   --机构编号
  ,CUST_ID  --客户编号
  ,APP_DT   --申请日期
  ,CUR      --币种
  ,APP_AMT  --申请金额
  ,APRV_AMT  --批准金额
  ,LOAN_BIZ_TYP --贷款业务类型
  ,APP_STAT  --申请状态
  ,DEPT_LINE  --部门条线
  ,DATA_SRC  --数据来源
  ,BUSINFOEXISTFLAG --是否有效工商信息
    )
   SELECT --针对大表可以写SELECT /*PRALLEL(4)*/
        V_P_DATE                         DATA_DT                --数据日期
       ,A.LP_ID                          LGL_REP_ID             --法人编号
       ,A.LOAN_APPL_FLOW_NUM             APP_ID                 --申请编号
       ,A.BELONG_ORG_ID                  ORG_ID                 --机构编号
       ,A.CUST_ID                        CUST_ID                --客户编号
       ,TO_CHAR(A.FIRST_TRIAL_APPL_DT,'YYYYMMDD')
                                         APP_DT                 --申请日期
       ,/*A.CURR_CD*/NULL                CUR                    --币种
       ,A.APPL_AMT                       APP_AMT                --申请金额
       ,A.FINAL_JUD_APV_LMT              APRV_AMT               --批准金额
       ,A.PROD_ID                        LOAN_BIZ_TYP           --贷款业务类别
       ,A.FIRST_TRIAL_APV_STATUS_CD      APP_STA                --申请状态
       ,NULL                             DEPT_LINE              --部门条线
       ,'零售贷款'                        DATA_SRC               --数据来源
       ,NULL                             BUSINFOEXISTFLAG       --是否有效工商信息
   FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO A        --零售贷款申请信息表
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;        --记录正常日志

   V_STEP := 4; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '贷款申请信息--联合网贷部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_LOAN_APP_INFO
  (
   DATA_DT                                                            --数据日期
  ,LGL_REP_ID                                                         --法人编号
  ,APP_ID                                                             --申请编号
  ,ORG_ID                                                             --机构编号
  ,CUST_ID                                                            --客户编号
  ,APP_DT                                                             --申请日期
  ,CUR                                                                --币种
  ,APP_AMT                                                            --申请金额
  ,APRV_AMT                                                           --批准金额
  ,LOAN_BIZ_TYP                                                       --贷款业务类型
  ,APP_STAT                                                           --申请状态
  ,DEPT_LINE                                                          --部门条线
  ,DATA_SRC                                                          	--数据来源
  ,CRDL_NO                                                            --身份证号
  ,BUSINFOEXISTFLAG                                                   --是否有效工商信息
    )
   SELECT --针对大表可以写SELECT /*PRALLEL(4)*/
          V_P_DATE                            DATA_DT                  	--数据日期
         ,A.LP_ID                             LGL_REP_ID                --法人编号
         ,A.LOAN_APPL_FLOW_NUM                APP_ID                    --申请编号
         ,A.BELONG_ORG_ID                     ORG_ID                    --机构编号
         ,A.CUST_ID                           CUST_ID                   --客户编号
         ,TO_CHAR(A.APV_START_TM,'YYYYMMDD')  APP_DT                    --申请日期
         ,NULL                                CUR                       --币种
         ,A.APPL_AMT                          APP_AMT                   --申请金额
         ,A.APV_AMT                           APRV_AMT                  --批准金额
         ,A.PROD_ID                           LOAN_BIZ_TYP              --贷款业务类别
         ,A.APV_STATUS_CD                     APP_STAT                  --申请状态
         ,'800919'                            DEPT_LINE                 --部门条线
         ,'联合网贷'                          DATA_SRC                  --数据来源
         ,A.CERT_ID                           CRDL_NO                   --证件号
         ,T2.BUSINFOEXISTFLAG                 BUSINFOEXISTFLAG          --是否有效工商信息
     FROM RRP_MDL.O_ICL_CMM_UNITE_WL_APPL_INFO A        --联合网贷申请信息表
     LEFT JOIN RRP_MDL.O_IOL_ICMS_MYBK_CS_EXTENT_INFO       T2       --网商贷初审扩展信息
       ON A.LOAN_APPL_FLOW_NUM = T2.SERNO
      AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;        --记录正常日志

   V_STEP := 5; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '贷款申请信息--对公贷款部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_LOAN_APP_INFO
  (
  DATA_DT                                                                   --数据日期
  ,LGL_REP_ID                                                               --法人编号
  ,APP_ID                                                                   --申请编号
  ,ORG_ID                                                                   --机构编号
  ,CUST_ID                                                                  --客户编号
  ,APP_DT                                                                   --申请日期
  ,CUR                                                                      --币种
  ,APP_AMT                                                                  --申请金额
  ,APRV_AMT                                                                 --批准金额
  ,LOAN_BIZ_TYP                                                             --贷款业务类型
  ,APP_STAT                                                                 --申请状态
  ,DEPT_LINE                                                                --部门条线
  ,DATA_SRC                                                                 --数据来源
  ,LOAN_HAPP_TYPE_CD                                                        --贷款发生类型
  ,LMT_UNDER_SELLBL_PROD_ID                                                 --可售产品
  ,STD_PROD_ID                                                              --额度产品
    )
   SELECT --针对大表可以写SELECT /*PRALLEL(4)*/
        V_P_DATE                         DATA_DT                            --数据日期
       ,A.LP_ID                          LGL_REP_ID                         --法人编号
       ,A.LOAN_APPL_FLOW_NUM             APP_ID                             --申请编号
       ,A.OPER_ORG_CD                    ORG_ID                             --机构编号
       ,A.CUST_ID                        CUST_ID                            --客户编号
       ,TO_CHAR(A.APPL_DT,'YYYYMMDD')    APP_DT                             --申请日期
       ,A.CURR_CD                        CUR                                --币种
       ,A.APPL_AMT                       APP_AMT                            --申请金额
       ,A.LATEST_APV_AMT                 APRV_AMT                           --批准金额
       ,A.STD_PROD_ID                    LOAN_BIZ_TYP                       --贷款业务类别
       ,/*NVL(CM.TAR_VALUE_CODE,A.APV_REST_FLOW_NUM)*/
        A.APV_REST_FLOW_NUM              APP_STA                            --申请状态
       ,NULL                             DEPT_LINE                          --部门条线
       ,'对公信贷'                       DATA_SRC                           --数据来源
       ,A.HAPP_TYPE_CD                   LOAN_HAPP_TYPE_CD                  --贷款发生类型
       ,A.LMT_UNDER_SELLBL_PROD_ID       LMT_UNDER_SELLBL_PROD_ID           --可售产品
       ,A.STD_PROD_ID                    STD_PROD_ID                        --额度产品
   FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO A        --对公贷款申请信息表
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;        --记录正常日志

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
   V_STEP := 6;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_LOAN_APP_INFO;
/

