CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_CNCL_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_CNCL_INFO
  *  功能描述：资产核销信息
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  ETL_INIT_M_LOAN_CNCL_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220524  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  *             3    20221123  MW        修改数据范围，增加全部回收标志、销户日期
  *             4    20230129  MW        修改金额字段，增加NVL，调整代码格式
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP             INTEGER := 0;                            -- 处理步骤
  V_PROC_NAME        VARCHAR2(100) := 'ETL_INIT_M_LOAN_CNCL_INFO';  -- 程序名称
  V_P_DATE           VARCHAR2(8);                             -- 跑批数据日期
  V_START_DT         DATE;                                    -- 处理开始时间
  V_STARTTIME        DATE;                                    -- 处理开始时间
  V_ENDTIME          DATE;                                    -- 处理结束时间
  V_SQLCOUNT         INTEGER := 0;                            -- 更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);                           -- SQL执行描述信息
  V_SYSTEM           VARCHAR2(100);                            -- 来源系统
  V_MONTH_START_DATE DATE;                                    --系统时间对应月初日期
  V_STEP_DESC        VARCHAR2(200);                           --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  I_START_DT CHAR(8) ;       --月初日期

  BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE);                            -- 获取跑批日期
  V_SYSTEM := '监管报送';                                     -- 默认写监管报送系统，有真实来源的按实际写
  V_MONTH_START_DATE :=TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM');
  V_START_DT   := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');
  V_TAB_NAME := 'M_LOAN_CNCL_INFO'; --表名
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
  I_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(I_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(I_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  I_START_DT := TO_CHAR(TO_DATE(I_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

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
  INSERT INTO RRP_MDL.M_LOAN_CNCL_INFO
  (
     DATA_DT                                        --数据日期
    ,LGL_REP_ID                                     --法人编号
    ,CONT_ID                                        --合同编号
    ,RCPT_ID                                        --借据编号
    ,CUST_ID                                        --客户编号
    ,ORG_ID                                         --机构编号
    ,AST_TYP                                        --资产类型
    ,CNCL_DT                                        --核销日期
    ,CUR                                            --币种
    ,CNCL_LN_PRIN                                   --实核贷款本金
    ,CNCL_IN_TAM_INT                                --实核表内利息
    ,CNCL_OUT_TAM_INT                               --实核表外利息
    ,RETRV_FLG                                      --收回标志
    ,RETRV_TYP                                      --收回类型
    ,CNCL_RETRV_DT                                  --核销收回日期
    ,CNCL_RETRV_PRIN                                --实核收回本金
    ,CNCL_RETRV_IN_TAM_INT                          --实核收回表内利息
    ,CNCL_RETRV_OUT_TAM_INT                         --实核收回表外利息
    ,RCMM_LOAN_FLG                                  --重组贷款标志
    ,RETRV_EMP_NO                                   --收回员工号
    ,CNCL_RETRV_TLR_NO                              --核销收回柜员号
    ,REMARKS                                        --备注
    ,FULL_CNCL_FLG                                  --全额核销标志
    ,BATCH_CNCL_FLG                                 --批量核销标志
    ,CNCL_STAT                                      --核销状态
    ,DEPT_LINE                                      --部门条线
    ,DATA_SRC                                       --数据来源
    ,ALL_RETRA_FLG                                  --全部收回标志
    ,CLOS_ACCT_DT                                   --销户日期
    )
    SELECT
           V_P_DATE                                   DATA_DT                     --数据日期
          ,A.LP_ID                                    LGL_REP_ID                  --法人编号
          ,A.CONT_ID                                  CONT_ID                     --合同编号
          ,A.DUBIL_NUM                                RCPT_ID                     --借据编号
          ,A.CUST_ID                                  CUST_ID                     --客户编号
          ,A.ACCT_INSTIT_ID                           ORG_ID                      --机构编号
          ,'02'                                       AST_TYP                     --资产类型
          ,TO_CHAR(B.FIR_WRT_OFF_DT,'YYYYMMDD')       CNCL_DT                     --核销日期
          ,B.CURR_CD                                  CUR                         --币种
          ,NVL(B.ACTL_WRTOFF_LOAN_PRIC,0)             CNCL_LN_PRIN                --实核贷款本金
          ,NVL(B.ACTL_WRTOFF_IN_BS_INT,0)             CNCL_IN_TAB_INT             --实核表内利息
          ,NVL(B.ACTL_WRTOFF_OFF_BS_INT,0)            CNCL_OUT_TAB_INT            --实核表外利息
          /*,CASE WHEN B.ALL_RETRA_FLG = '1' THEN 'Y'
                WHEN B.ALL_RETRA_FLG = '0' THEN 'N' END  RETRV_FLG                --收回标志*/
          ,CASE WHEN NVL(B.WRT_OFF_RETRA_PRIC,0) + NVL(B.WRT_OFF_RETRA_ADVC_FEE,0) + NVL(B.WRT_OFF_RETRA_IN_BS_INT,0) + NVL(B.WRT_OFF_RETRA_OFF_BS_INT,0) >0
                THEN 'Y'
                ELSE 'N'
                END                                   RETRV_FLG                   --收回标志
          ,/*CASE WHEN B.WRT_OFF_RETRA_PRIC = B.ACTL_WRTOFF_LOAN_PRIC THEN '02' ELSE '01' END*/
           CASE WHEN B.ALL_RETRA_FLG = '1' THEN 'Y'
                ELSE 'N'
                END                                   RETRV_TYP                   --收回类型
          ,NVL(TO_CHAR(B.FINAL_WRT_OFF_RETRA_DT,'YYYYMMDD'),'99991231')
                                                      CNCL_RETRV_DT               --核销收回日期
          ,NVL(B.WRT_OFF_RETRA_PRIC,0)                CNCL_RETRV_PRIN             --实核收回本金
          ,NVL(B.WRT_OFF_RETRA_IN_BS_INT,0)           CNCL_RETRV_IN_TAB_INT       --实核收回表内利息
          ,NVL(B.WRT_OFF_RETRA_OFF_BS_INT,0)          CNCL_RETRV_OUT_TAB_INT      --实核收回表外利息
          ,NULL                                       RCMB_LOAN_FLG               --重组贷款标志
          ,B.APPL_TELLER_ID                           RETRV_EMP_NO                --收回员工号
          ,B.APPL_TELLER_ID                           CNCL_RETRV_TLR_NO           --核销收回柜员号
          ,NULL                                       REMARKS                     --备注
          ,NULL                                       FULL_CNCL_FLG               --全额核销标志
          ,NULL                                       BATCH_CNCL_FLG              --批量核销标志
          ,CASE WHEN B.ALL_RETRA_FLG  = '1' THEN   '02'
                WHEN B.ALL_RETRA_FLG  = '0' THEN   '01'
           END                                        CNCL_STAT                   --核销状态
          ,'800919'   /*风险管理部*/                  DEPT_LINE                   --部门条线
          ,'对公贷款'                                 DATA_SRC                    --数据来源
          ,B.ALL_RETRA_FLG                            ALL_RETRA_FLG               --全部收回标志
          ,TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')         CLOS_ACCT_DT                --销户日期
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO      A    --对公贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO   B    --贷款核销信息
      ON A.DUBIL_NUM = B.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资产核销信息--零售贷款';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_CNCL_INFO
  (
     DATA_DT                                         --数据日期
    ,LGL_REP_ID                                      --法人编号
    ,CONT_ID                                         --合同编号
    ,RCPT_ID                                         --借据编号
    ,CUST_ID                                         --客户编号
    ,ORG_ID                                          --机构编号
    ,AST_TYP                                         --资产类型
    ,CNCL_DT                                         --核销日期
    ,CUR                                             --币种
    ,CNCL_LN_PRIN                                    --实核贷款本金
    ,CNCL_IN_TAM_INT                                 --实核表内利息
    ,CNCL_OUT_TAM_INT                                --实核表外利息
    ,RETRV_FLG                                       --收回标志
    ,RETRV_TYP                                       --收回类型
    ,CNCL_RETRV_DT                                   --核销收回日期
    ,CNCL_RETRV_PRIN                                 --实核收回本金
    ,CNCL_RETRV_IN_TAM_INT                           --实核收回表内利息
    ,CNCL_RETRV_OUT_TAM_INT                          --实核收回表外利息
    ,RCMM_LOAN_FLG                                   --重组贷款标志
    ,RETRV_EMP_NO                                    --收回员工号
    ,CNCL_RETRV_TLR_NO                               --核销收回柜员号
    ,REMARKS                                         --备注
    ,FULL_CNCL_FLG                                   --全额核销标志
    ,BATCH_CNCL_FLG                                  --批量核销标志
    ,CNCL_STAT                                       --核销状态
    ,DEPT_LINE                                       --部门条线
    ,DATA_SRC                                        --数据来源
    ,ALL_RETRA_FLG                                   --全部收回标志
    ,CLOS_ACCT_DT                                    --销户日期
    )
    SELECT
          V_P_DATE                                   DATA_DT                 --数据日期
         ,A.LP_ID                                    LGL_REP_ID              --法人编号
         ,A.CONT_ID                                  CONT_ID                 --合同编号
         ,A.DUBIL_NUM                                RCPT_ID                 --借据编号
         ,A.CUST_ID                                  CUST_ID                 --客户编号
         ,A.ACCT_INSTIT_ID                           ORG_ID                  --机构编号
         ,'01'                                       AST_TYP                 --资产类型
         ,TO_CHAR(B.FIR_WRT_OFF_DT,'YYYYMMDD')       CNCL_DT                 --核销日期
         ,B.CURR_CD                                  CUR                     --币种
         ,NVL(B.ACTL_WRTOFF_LOAN_PRIC,0)             CNCL_LN_PRIN            --实核贷款本金
         ,NVL(B.ACTL_WRTOFF_IN_BS_INT,0)             CNCL_IN_TAB_INT         --实核表内利息
         ,NVL(B.ACTL_WRTOFF_OFF_BS_INT,0)            CNCL_OUT_TAB_INT        --实核表外利息
         ,CASE WHEN NVL(B.WRT_OFF_RETRA_PRIC,0) + NVL(B.WRT_OFF_RETRA_ADVC_FEE,0) + NVL(B.WRT_OFF_RETRA_IN_BS_INT,0) + NVL(B.WRT_OFF_RETRA_OFF_BS_INT,0) >0
               THEN 'Y'
               ELSE 'N'
          END                                        RETRV_FLG               --收回标志
         ,CASE WHEN B.ALL_RETRA_FLG = '1' THEN 'Y'
               ELSE 'N'
          END                                        RETRV_TYP               --收回类型
         ,NVL(TO_CHAR(B.FINAL_WRT_OFF_RETRA_DT,'YYYYMMDD')  ,'99991231')
                                                     CNCL_RETRV_DT           --核销收回日期
         ,NVL(B.WRT_OFF_RETRA_PRIC,0)                CNCL_RETRV_PRIN         --实核收回本金
         ,NVL(B.WRT_OFF_RETRA_IN_BS_INT,0)           CNCL_RETRV_IN_TAB_INT   --实核收回表内利息
         ,NVL(B.WRT_OFF_RETRA_OFF_BS_INT,0)          CNCL_RETRV_OUT_TAB_INT  --实核收回表外利息
         ,NULL                                       RCMB_LOAN_FLG           --重组贷款标志
         ,B.APPL_TELLER_ID                           RETRV_EMP_NO            --收回员工号
         ,B.APPL_TELLER_ID                           CNCL_RETRV_TLR_NO       --核销收回柜员号
         ,NULL                                       REMARKS                 --备注
         ,NULL                                       FULL_CNCL_FLG           --全额核销标志
         ,NULL                                       BATCH_CNCL_FLG          --批量核销标志
         ,CASE WHEN B.ALL_RETRA_FLG  = '1' THEN   '02'
               WHEN B.ALL_RETRA_FLG  = '0' THEN   '01'
               END                                   CNCL_STAT               --核销状态
         ,'800924'   /*零售信贷部(普惠金融部)*/      DEPT_LINE               --部门条线
         ,'零售贷款'                                 DATA_SRC                --数据来源
         ,B.ALL_RETRA_FLG                            ALL_RETRA_FLG           --全部收回标志
         ,TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')         CLOS_ACCT_DT            --销户日期         --ADD BY MW 20221123
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO       A     --零售贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO    B     --贷款核销信息
      ON A.DUBIL_NUM = B.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE  A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
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
  INSERT INTO RRP_MDL.M_LOAN_CNCL_INFO
  (
     DATA_DT                                --数据日期
    ,LGL_REP_ID                             --法人编号
    ,CONT_ID                                --合同编号
    ,RCPT_ID                                --借据编号
    ,CUST_ID                                --客户编号
    ,ORG_ID                                 --机构编号
    ,AST_TYP                                --资产类型
    ,CNCL_DT                                --核销日期
    ,CUR                                    --币种
    ,CNCL_LN_PRIN                           --实核贷款本金
    ,CNCL_IN_TAM_INT                        --实核表内利息
    ,CNCL_OUT_TAM_INT                       --实核表外利息
    ,RETRV_FLG                              --收回标志
    ,RETRV_TYP                              --收回类型
    ,CNCL_RETRV_DT                          --核销收回日期
    ,CNCL_RETRV_PRIN                        --实核收回本金
    ,CNCL_RETRV_IN_TAM_INT                  --实核收回表内利息
    ,CNCL_RETRV_OUT_TAM_INT                 --实核收回表外利息
    ,RCMM_LOAN_FLG                          --重组贷款标志
    ,RETRV_EMP_NO                           --收回员工号
    ,CNCL_RETRV_TLR_NO                      --核销收回柜员号
    ,REMARKS                                --备注
    ,FULL_CNCL_FLG                          --全额核销标志
    ,BATCH_CNCL_FLG                         --批量核销标志
    ,CNCL_STAT                              --核销状态
    ,DEPT_LINE                              --部门条线
    ,DATA_SRC                               --数据来源
    ,ALL_RETRA_FLG                          --全部收回标志
    ,CLOS_ACCT_DT                           --销户日期
    )
    SELECT
          V_P_DATE                                    DATA_DT                  --数据日期
         ,A.LP_ID                                     LGL_REP_ID               --法人编号
         ,A.CONT_ID                                   CONT_ID                  --合同编号
         ,A.DUBIL_ID                                  RCPT_ID                  --借据编号
         ,A.CUST_ID                                   CUST_ID                  --客户编号
         ,A.BELONG_ORG_ID                             ORG_ID                   --机构编号
         ,'01'                                        AST_TYP                  --资产类型
         ,TO_CHAR(A.FIR_WRT_OFF_DT,'YYYYMMDD')        CNCL_DT                  --核销日期
         ,A.CURR_CD                                   CUR                      --币种
         ,NVL(A.ACTL_WRTOFF_LOAN_PRIC,0)              CNCL_LN_PRIN             --实核贷款本金
         ,NVL(A.ACTL_WRTOFF_IN_BS_INT,0)              CNCL_IN_TAB_INT          --实核表内利息
         ,NVL(A.ACTL_WRTOFF_OFF_BS_INT,0)             CNCL_OUT_TAB_INT         --实核表外利息
         ,CASE WHEN NVL(A.WRT_OFF_RETRA_PRIC,0) + NVL(A.WRT_OFF_RETRA_IN_BS_INT,0) + NVL(A.WRT_OFF_RETRA_OFF_BS_INT,0) + NVL(A.WRT_OFF_RETRA_ADVC_FEE,0) >0
               THEN 'Y'
               ELSE 'N'
          END                                         RETRV_FLG                --收回标志
         ,CASE WHEN A.ALL_RETRA_FLG = '1' THEN 'Y'
                ELSE 'N'
                END                                   RETRV_TYP                --收回类型
         ,NVL(TO_CHAR(A.FINAL_WRT_OFF_RETRA_DT,'YYYYMMDD'),'99991231')
                                                      CNCL_RETRV_DT            --核销收回日期
         ,NVL(A.WRT_OFF_RETRA_PRIC,0)                 CNCL_RETRV_PRIN          --实核收回本金
         ,NVL(A.WRT_OFF_RETRA_IN_BS_INT,0)            CNCL_RETRV_IN_TAB_INT    --实核收回表内利息
         ,NVL(A.WRT_OFF_RETRA_OFF_BS_INT,0)           CNCL_RETRV_OUT_TAB_INT   --实核收回表外利息
         ,NULL                                        RCMB_LOAN_FLG            --重组贷款标志
         ,A.APPL_TELLER_ID                            RETRV_EMP_NO             --收回员工号
         ,A.APPL_TELLER_ID                            CNCL_RETRV_TLR_NO        --核销收回柜员号
         ,NULL                                        REMARKS                  --备注
         ,NULL                                        FULL_CNCL_FLG            --全额核销标志
         ,NULL                                        BATCH_CNCL_FLG           --批量核销标志
         ,CASE WHEN A.ALL_RETRA_FLG  = '1' THEN   '02'
               WHEN A.ALL_RETRA_FLG  = '0' THEN   '01'
          END                                         CNCL_STAT                --核销状态
         ,'800924'   /*零售信贷部(普惠金融部)*/       DEPT_LINE                --部门条线
         ,'联合网贷'                                  DATA_SRC                 --数据来源
         ,A.ALL_RETRA_FLG                             ALL_RETRA_FLG            --全部收回标志
         ,TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')             CLOS_ACCT_DT             --销户日期     --ADD BY MW 20221123
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO      A     --联合网贷核销信息
   INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO   B     --联合网贷借据信息
      ON A.DUBIL_ID = B.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   ;

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
    SELECT DATA_DT, RCPT_ID,COUNT(1)
      FROM M_LOAN_CNCL_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, RCPT_ID
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

  END ETL_INIT_M_LOAN_CNCL_INFO;
/

