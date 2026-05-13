CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_CNCL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_CNCL_INFO
  *  功能描述：资产核销信息
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  ETL_M_LOAN_CNCL_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220524  梅炜      首次创建
  *             2    20221114  HULJ      增加数据重复校验
  *             3    20221123  MW        修改数据范围，增加全部回收标志、销户日期
  *             4    20230129  MW        修改金额字段，增加NVL，调整代码格式
  *             5    20230906  LIP       增加差额核销数据
  *             6    20240229  HYF       修改联合网贷机构号取借据表账务机构号
  *             7    20240718  HYF       修改END_DT 过滤条件
  *             8    20250219  YJY       新增对公联合网贷的判断
  *             9    20250521  YJY       修改联合网贷部分的借据号，取核心借据编号
  *            10    20250725  YJY       回退联合网贷部分的借据号
  *            11    20250903  HYF       调整对公差额核销逻辑从不良问题贷款余额变动信息取数
  *            12    20251114  HYF       新增收益权转让部分零售差额核销逻辑
  *            13    20251120  YJY       新增203050100002-微众对公联合贷（微业贷4.0）产品
               14    20260417  lwb       月末该表跑第二次时在ETL_STATE插入   ETL_M_LOAN_CNCL_INFO_MONTH
  ***********************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;              --处理步骤
  V_P_DATE    VARCHAR2(8);               --跑批数据日期
  V_STARTTIME DATE;                      --处理开始时间
  V_ENDTIME   DATE;                      --处理结束时间
  V_SQLCOUNT  INTEGER := 0;              --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);             --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);             --任务名称
  V_PART_NAME VARCHAR2(100);             --分区名
  V_SQLCOUNT2 INTEGER;                   --modify by lwb
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_CNCL_INFO'; --表名
  V_PROC_NAME VARCHAR2(30) := 'ETL_M_LOAN_CNCL_INFO';  --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_LOAN_CNCL_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_LOAN_CNCL_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := 2;
  V_STEP_DESC := '插入资产核销信息--对公贷款';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_CNCL_INFO
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,CONT_ID                  --合同编号
    ,RCPT_ID                  --借据编号
    ,CUST_ID                  --客户编号
    ,ORG_ID                   --机构编号
    ,AST_TYP                  --资产类型
    ,CNCL_DT                  --核销日期
    ,CUR                      --币种
    ,CNCL_LN_PRIN             --实核贷款本金
    ,CNCL_IN_TAM_INT          --实核表内利息
    ,CNCL_OUT_TAM_INT         --实核表外利息
    ,RETRV_FLG                --收回标志
    ,RETRV_TYP                --收回类型
    ,CNCL_RETRV_DT            --核销收回日期
    ,CNCL_RETRV_PRIN          --实核收回本金
    ,CNCL_RETRV_IN_TAM_INT    --实核收回表内利息
    ,CNCL_RETRV_OUT_TAM_INT   --实核收回表外利息
    ,RCMM_LOAN_FLG            --重组贷款标志
    ,RETRV_EMP_NO             --收回员工号
    ,CNCL_RETRV_TLR_NO        --核销收回柜员号
    ,REMARKS                  --备注
    ,FULL_CNCL_FLG            --全额核销标志
    ,BATCH_CNCL_FLG           --批量核销标志
    ,CNCL_STAT                --核销状态
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    ,ALL_RETRA_FLG            --全部收回标志
    ,CLOS_ACCT_DT             --销户日期
    )
  SELECT  V_P_DATE                                   AS DATA_DT                  --数据日期
         ,A.LP_ID                                    AS LGL_REP_ID               --法人编号
         ,A.CONT_ID                                  AS CONT_ID                  --合同编号
         ,A.DUBIL_NUM                                AS RCPT_ID                  --借据编号
         ,A.CUST_ID                                  AS CUST_ID                  --客户编号
         ,A.ACCT_INSTIT_ID                           AS ORG_ID                   --机构编号
         ,'02'                                       AS AST_TYP                  --资产类型 --01 个人贷款 02 对公贷款
         ,TO_CHAR(B.FIR_WRT_OFF_DT,'YYYYMMDD')       AS CNCL_DT                  --核销日期
         ,B.CURR_CD                                  AS CUR                      --币种
         ,NVL(B.ACTL_WRTOFF_LOAN_PRIC,0)             AS CNCL_LN_PRIN             --实核贷款本金
         ,NVL(B.ACTL_WRTOFF_IN_BS_INT,0)             AS CNCL_IN_TAB_INT          --实核表内利息
         ,NVL(B.ACTL_WRTOFF_OFF_BS_INT,0)            AS CNCL_OUT_TAB_INT         --实核表外利息
         ,CASE WHEN NVL(B.WRT_OFF_RETRA_PRIC,0) + NVL(B.WRT_OFF_RETRA_ADVC_FEE,0) + NVL(B.WRT_OFF_RETRA_IN_BS_INT,0) + NVL(B.WRT_OFF_RETRA_OFF_BS_INT,0) >0
               THEN 'Y'
               ELSE 'N'
           END                                       AS RETRV_FLG                --收回标志
         ,CASE WHEN B.ALL_RETRA_FLG = '1' THEN 'Y'
               ELSE 'N'
           END                                       AS RETRV_TYP                --收回类型
         ,NVL(TO_CHAR(B.FINAL_WRT_OFF_RETRA_DT,'YYYYMMDD'),'99991231') AS CNCL_RETRV_DT --核销收回日期
         ,NVL(B.WRT_OFF_RETRA_PRIC,0)                AS CNCL_RETRV_PRIN          --实核收回本金
         ,NVL(B.WRT_OFF_RETRA_IN_BS_INT,0)           AS CNCL_RETRV_IN_TAB_INT    --实核收回表内利息
         ,NVL(B.WRT_OFF_RETRA_OFF_BS_INT,0)          AS CNCL_RETRV_OUT_TAB_INT   --实核收回表外利息
         ,NULL                                       AS RCMB_LOAN_FLG            --重组贷款标志
         ,B.APPL_TELLER_ID                           AS RETRV_EMP_NO             --收回员工号
         ,B.APPL_TELLER_ID                           AS CNCL_RETRV_TLR_NO        --核销收回柜员号
         ,NULL                                       AS REMARKS                  --备注
         ,NULL                                       AS FULL_CNCL_FLG            --全额核销标志
         ,NULL                                       AS BATCH_CNCL_FLG           --批量核销标志
         ,CASE WHEN B.ALL_RETRA_FLG = '1' THEN '02'
               WHEN B.ALL_RETRA_FLG = '0' THEN '01'
           END                                       AS CNCL_STAT                --核销状态
         ,'800919'                                   AS DEPT_LINE                --部门条线/*风险管理部*/
         ,'对公贷款'                                 AS DATA_SRC                 --数据来源
         ,B.ALL_RETRA_FLG                            AS ALL_RETRA_FLG            --全部收回标志
         ,TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')         AS CLOS_ACCT_DT             --销户日期
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO B --贷款核销信息
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 3;
  V_STEP_DESC := '插入资产核销信息--零售贷款';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_CNCL_INFO
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,CONT_ID                  --合同编号
    ,RCPT_ID                  --借据编号
    ,CUST_ID                  --客户编号
    ,ORG_ID                   --机构编号
    ,AST_TYP                  --资产类型
    ,CNCL_DT                  --核销日期
    ,CUR                      --币种
    ,CNCL_LN_PRIN             --实核贷款本金
    ,CNCL_IN_TAM_INT          --实核表内利息
    ,CNCL_OUT_TAM_INT         --实核表外利息
    ,RETRV_FLG                --收回标志
    ,RETRV_TYP                --收回类型
    ,CNCL_RETRV_DT            --核销收回日期
    ,CNCL_RETRV_PRIN          --实核收回本金
    ,CNCL_RETRV_IN_TAM_INT    --实核收回表内利息
    ,CNCL_RETRV_OUT_TAM_INT   --实核收回表外利息
    ,RCMM_LOAN_FLG            --重组贷款标志
    ,RETRV_EMP_NO             --收回员工号
    ,CNCL_RETRV_TLR_NO        --核销收回柜员号
    ,REMARKS                  --备注
    ,FULL_CNCL_FLG            --全额核销标志
    ,BATCH_CNCL_FLG           --批量核销标志
    ,CNCL_STAT                --核销状态
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    ,ALL_RETRA_FLG            --全部收回标志
    ,CLOS_ACCT_DT             --销户日期
    )
  SELECT  V_P_DATE                                   AS DATA_DT                  --数据日期
         ,A.LP_ID                                    AS LGL_REP_ID               --法人编号
         ,A.CONT_ID                                  AS CONT_ID                  --合同编号
         ,A.DUBIL_NUM                                AS RCPT_ID                  --借据编号
         ,A.CUST_ID                                  AS CUST_ID                  --客户编号
         ,A.ACCT_INSTIT_ID                           AS ORG_ID                   --机构编号
         ,'01'                                       AS AST_TYP                  --资产类型 --01 个人贷款 02 对公贷款
         ,TO_CHAR(B.FIR_WRT_OFF_DT,'YYYYMMDD')       AS CNCL_DT                  --核销日期
         ,B.CURR_CD                                  AS CUR                      --币种
         ,NVL(B.ACTL_WRTOFF_LOAN_PRIC,0)             AS CNCL_LN_PRIN             --实核贷款本金
         ,NVL(B.ACTL_WRTOFF_IN_BS_INT,0)             AS CNCL_IN_TAB_INT          --实核表内利息
         ,NVL(B.ACTL_WRTOFF_OFF_BS_INT,0)            AS CNCL_OUT_TAB_INT         --实核表外利息
         ,CASE WHEN NVL(B.WRT_OFF_RETRA_PRIC,0) + NVL(B.WRT_OFF_RETRA_ADVC_FEE,0) + NVL(B.WRT_OFF_RETRA_IN_BS_INT,0) + NVL(B.WRT_OFF_RETRA_OFF_BS_INT,0) >0
               THEN 'Y'
               ELSE 'N'
           END                                       AS RETRV_FLG                --收回标志
         ,CASE WHEN B.ALL_RETRA_FLG = '1' THEN 'Y'
               ELSE 'N'
           END                                       AS RETRV_TYP                --收回类型
         ,NVL(TO_CHAR(B.FINAL_WRT_OFF_RETRA_DT,'YYYYMMDD'),'99991231') AS CNCL_RETRV_DT --核销收回日期
         ,NVL(B.WRT_OFF_RETRA_PRIC,0)                AS CNCL_RETRV_PRIN          --实核收回本金
         ,NVL(B.WRT_OFF_RETRA_IN_BS_INT,0)           AS CNCL_RETRV_IN_TAB_INT    --实核收回表内利息
         ,NVL(B.WRT_OFF_RETRA_OFF_BS_INT,0)          AS CNCL_RETRV_OUT_TAB_INT   --实核收回表外利息
         ,NULL                                       AS RCMB_LOAN_FLG            --重组贷款标志
         ,B.APPL_TELLER_ID                           AS RETRV_EMP_NO             --收回员工号
         ,B.APPL_TELLER_ID                           AS CNCL_RETRV_TLR_NO        --核销收回柜员号
         ,NULL                                       AS REMARKS                  --备注
         ,NULL                                       AS FULL_CNCL_FLG            --全额核销标志
         ,NULL                                       AS BATCH_CNCL_FLG           --批量核销标志
         ,CASE WHEN B.ALL_RETRA_FLG = '1' THEN '02'                    
               WHEN B.ALL_RETRA_FLG = '0' THEN '01'
           END                                       AS CNCL_STAT                --核销状态
         ,'800924'                                   AS DEPT_LINE                --部门条线/*零售信贷部(普惠金融部)*/
         ,'零售贷款'                                 AS DATA_SRC                 --数据来源
         ,B.ALL_RETRA_FLG                            AS ALL_RETRA_FLG            --全部收回标志
         ,TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')         AS CLOS_ACCT_DT             --销户日期 --ADD BY MW 20221123
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO B --贷款核销信息
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 4;
  V_STEP_DESC := '插入资产核销信息--联合网贷';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_CNCL_INFO
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,CONT_ID                  --合同编号
    ,RCPT_ID                  --借据编号
    ,CUST_ID                  --客户编号
    ,ORG_ID                   --机构编号
    ,AST_TYP                  --资产类型
    ,CNCL_DT                  --核销日期
    ,CUR                      --币种
    ,CNCL_LN_PRIN             --实核贷款本金
    ,CNCL_IN_TAM_INT          --实核表内利息
    ,CNCL_OUT_TAM_INT         --实核表外利息
    ,RETRV_FLG                --收回标志
    ,RETRV_TYP                --收回类型
    ,CNCL_RETRV_DT            --核销收回日期
    ,CNCL_RETRV_PRIN          --实核收回本金
    ,CNCL_RETRV_IN_TAM_INT    --实核收回表内利息
    ,CNCL_RETRV_OUT_TAM_INT   --实核收回表外利息
    ,RCMM_LOAN_FLG            --重组贷款标志
    ,RETRV_EMP_NO             --收回员工号
    ,CNCL_RETRV_TLR_NO        --核销收回柜员号
    ,REMARKS                  --备注
    ,FULL_CNCL_FLG            --全额核销标志
    ,BATCH_CNCL_FLG           --批量核销标志
    ,CNCL_STAT                --核销状态
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    ,ALL_RETRA_FLG            --全部收回标志
    ,CLOS_ACCT_DT             --销户日期
    )
  SELECT  V_P_DATE                                    AS DATA_DT                  --数据日期
         ,A.LP_ID                                     AS LGL_REP_ID               --法人编号
         ,A.CONT_ID                                   AS CONT_ID                  --合同编号
         /*,A.DUBIL_ID                                  RCPT_ID                     --借据编号*/
         /* ,B.CORE_DUBIL_ID                             AS RCPT_ID                 --借据编号 MOD BY YJY 20250521 取联合网贷的核心借据号 */
         ,A.DUBIL_ID                                  RCPT_ID                     --借据编号 MOD BY YJY 20250725
         --MOD BY LIP 20230803
         ,B.CUST_ID                                   AS CUST_ID                  --客户编号
         ,NVL(B.ACCT_INSTIT_ID,A.BELONG_ORG_ID)       AS ORG_ID                   --机构编号
         ,'01'                                        AS AST_TYP                  --资产类型 --01 个人贷款 02 对公贷款
         ,TO_CHAR(A.FIR_WRT_OFF_DT,'YYYYMMDD')        AS CNCL_DT                  --核销日期
         ,A.CURR_CD                                   AS CUR                      --币种
         ,NVL(A.ACTL_WRTOFF_LOAN_PRIC,0)              AS CNCL_LN_PRIN             --实核贷款本金
         ,NVL(A.ACTL_WRTOFF_IN_BS_INT,0)              AS CNCL_IN_TAB_INT          --实核表内利息
         ,NVL(A.ACTL_WRTOFF_OFF_BS_INT,0)             AS CNCL_OUT_TAB_INT         --实核表外利息
         ,CASE WHEN NVL(A.WRT_OFF_RETRA_PRIC,0) + NVL(A.WRT_OFF_RETRA_IN_BS_INT,0) + NVL(A.WRT_OFF_RETRA_OFF_BS_INT,0) + NVL(A.WRT_OFF_RETRA_ADVC_FEE,0) >0
               THEN 'Y'
               ELSE 'N'
           END                                        AS RETRV_FLG                --收回标志
         ,CASE WHEN A.ALL_RETRA_FLG = '1' THEN 'Y'
               ELSE 'N'
           END                                        AS RETRV_TYP                --收回类型
         ,NVL(TO_CHAR(A.FINAL_WRT_OFF_RETRA_DT,'YYYYMMDD'),'99991231') AS CNCL_RETRV_DT --核销收回日期
         ,NVL(A.WRT_OFF_RETRA_PRIC,0)                 AS CNCL_RETRV_PRIN          --实核收回本金
         ,NVL(A.WRT_OFF_RETRA_IN_BS_INT,0)            AS CNCL_RETRV_IN_TAB_INT    --实核收回表内利息
         ,NVL(A.WRT_OFF_RETRA_OFF_BS_INT,0)           AS CNCL_RETRV_OUT_TAB_INT   --实核收回表外利息
         ,NULL                                        AS RCMB_LOAN_FLG            --重组贷款标志
         ,A.APPL_TELLER_ID                            AS RETRV_EMP_NO             --收回员工号
         ,A.APPL_TELLER_ID                            AS CNCL_RETRV_TLR_NO        --核销收回柜员号
         ,NULL                                        AS REMARKS                  --备注
         ,NULL                                        AS FULL_CNCL_FLG            --全额核销标志
         ,NULL                                        AS BATCH_CNCL_FLG           --批量核销标志
         ,CASE WHEN A.ALL_RETRA_FLG = '1' THEN '02'
               WHEN A.ALL_RETRA_FLG = '0' THEN '01'
           END                                        AS CNCL_STAT                --核销状态
         ,'800924'                                    AS DEPT_LINE                --部门条线/*零售信贷部(普惠金融部)*/
         ,CASE WHEN B.STD_PROD_ID IN ('203050100001','203050100002') THEN '对公联合网贷' -- MOD BY YJY 20250219 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
               ELSE '联合网贷' 
           END                                        AS DATA_SRC                 --数据来源
         ,A.ALL_RETRA_FLG                             AS ALL_RETRA_FLG            --全部收回标志
         ,TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')             AS CLOS_ACCT_DT             --销户日期 --ADD BY MW 20221123
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO A --联合网贷核销信息
   INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO B --联合网贷借据信息
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  --保留原对公差额核销逻辑，往期历史有数
  V_STEP := 5;
  V_STEP_DESC := '插入资产核销信息--差额核销';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_CNCL_INFO
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,CONT_ID                  --合同编号
    ,RCPT_ID                  --借据编号
    ,CUST_ID                  --客户编号
    ,ORG_ID                   --机构编号
    ,AST_TYP                  --资产类型
    ,CNCL_DT                  --核销日期
    ,CUR                      --币种
    ,CNCL_LN_PRIN             --实核贷款本金
    ,CNCL_IN_TAM_INT          --实核表内利息
    ,CNCL_OUT_TAM_INT         --实核表外利息
    ,RETRV_FLG                --收回标志
    ,RETRV_TYP                --收回类型
    ,CNCL_RETRV_DT            --核销收回日期
    ,CNCL_RETRV_PRIN          --实核收回本金
    ,CNCL_RETRV_IN_TAM_INT    --实核收回表内利息
    ,CNCL_RETRV_OUT_TAM_INT   --实核收回表外利息
    ,RCMM_LOAN_FLG            --重组贷款标志
    ,RETRV_EMP_NO             --收回员工号
    ,CNCL_RETRV_TLR_NO        --核销收回柜员号
    ,REMARKS                  --备注
    ,FULL_CNCL_FLG            --全额核销标志
    ,BATCH_CNCL_FLG           --批量核销标志
    ,CNCL_STAT                --核销状态
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    ,ALL_RETRA_FLG            --全部收回标志
    ,CLOS_ACCT_DT             --销户日期
    )
    WITH CL_RECEIPT AS (
  SELECT TB.ETL_DT,T1.CMISLOAN_NO,TB.TRAN_REF_NO AS REFERENCE,TB.LOAN_NUM,T1.INTERNAL_KEY,
         TO_DATE(REPLACE(SUBSTR(T1.TRAN_TIMESTAMP, 1, 10), '-', ''), 'YYYYMMDD') ZRRQ,
         ROW_NUMBER() OVER(PARTITION BY T1.CMISLOAN_NO/*,TB.LOAN_NUM*/ ORDER BY 1) RN
    FROM RRP_MDL.O_IOL_NCBS_CL_TRANSFER_DETAIL T1
   INNER JOIN IML.V_EVT_REPAY_FLOW TB --IOL.NCBS_CL_RECEIPT 因O_IML_EVT_REPAY_FLOW表中数据只有一天，改为取数仓视图
      ON TB.LOAN_NUM = T1.LOAN_NO
     AND TB.LOAN_REPAY_TYPE_CD IN ('PO') --CD2567 结清
     /*AND TB.ETL_DT = TO_DATE(REPLACE(SUBSTR(T1.TRAN_TIMESTAMP, 1, 10), '-', ''), 'YYYYMMDD')
     AND TB.ETL_DT >= TO_DATE('20230502','YYYYMMDD')*/
     AND TB.BUS_TRAN_DT = TO_DATE(REPLACE(SUBSTR(T1.TRAN_TIMESTAMP,1,10),'-',''),'YYYYMMDD')
     AND TB.BUS_TRAN_DT >= TO_DATE('20230502','YYYYMMDD')
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --数仓调整成全量表了
   WHERE T1.ASSET_ACCT_STATUS = 'S'
     AND T1.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD'))
  SELECT  V_P_DATE                                    AS DATA_DT                  --数据日期
         ,TA.LP_ID                                    AS LGL_REP_ID               --法人编号
         ,NVL(TF.CONT_ID,TG.CONT_ID)                  AS CONT_ID                  --合同编号
         ,NVL(TF.DUBIL_NUM,TG.DUBIL_NUM)              AS RCPT_ID                  --借据编号
         ,NVL(TF.CUST_ID,TG.CUST_ID)                  AS CUST_ID                  --客户编号
         ,NVL(TF.ACCT_INSTIT_ID,TG.ACCT_INSTIT_ID)    AS ORG_ID                   --机构编号
         ,CASE WHEN TF.DUBIL_NUM IS NOT NULL THEN '01'
               WHEN TG.DUBIL_NUM IS NOT NULL THEN '02'
           END                                        AS AST_TYP                  --资产类型 --01 个人贷款 02 对公贷款
         ,TO_CHAR(TC.ZRRQ,'YYYYMMDD')                 AS CNCL_DT                  --核销日期
         ,NVL(TF.CURR_CD,TG.CURR_CD)                  AS CUR                      --币种
         ,NVL(TD.TRANAM,0)                            AS CNCL_LN_PRIN             --实核贷款本金
         ,NVL(TE.TRANAM,0)                            AS CNCL_IN_TAB_INT          --实核表内利息
         ,0                                           AS CNCL_OUT_TAB_INT         --实核表外利息
         ,'N'                                         AS RETRV_FLG                --收回标志
         ,'N'                                         AS RETRV_TYP                --收回类型
         ,'99991231'                                  AS CNCL_RETRV_DT            --核销收回日期
         ,0                                           AS CNCL_RETRV_PRIN          --实核收回本金
         ,0                                           AS CNCL_RETRV_IN_TAB_INT    --实核收回表内利息
         ,0                                           AS CNCL_RETRV_OUT_TAB_INT   --实核收回表外利息
         ,NULL                                        AS RCMB_LOAN_FLG            --重组贷款标志
         ,NULL                                        AS RETRV_EMP_NO             --收回员工号
         ,NULL                                        AS CNCL_RETRV_TLR_NO        --核销收回柜员号
         ,NULL                                        AS REMARKS                  --备注
         ,NULL                                        AS FULL_CNCL_FLG            --全额核销标志
         ,NULL                                        AS BATCH_CNCL_FLG           --批量核销标志
         --MOD BY 20231110 根据张家伟口径调整：差额核销借据的核销状态是完全终结
         ,'02'                                        AS CNCL_STAT                --核销状态
         ,CASE WHEN TF.DUBIL_NUM IS NOT NULL THEN '800924'
               WHEN TG.DUBIL_NUM IS NOT NULL THEN '800919'
           END                                        AS DEPT_LINE                --部门条线
         ,CASE WHEN TF.DUBIL_NUM IS NOT NULL THEN '零售贷款差额核销'
               WHEN TG.DUBIL_NUM IS NOT NULL THEN '对公贷款差额核销'
           END                                        AS DATA_SRC                 --数据来源
         ,NULL                                        AS ALL_RETRA_FLG            --全部收回标志
         ,CASE WHEN TF.DUBIL_NUM IS NOT NULL THEN TO_CHAR(TF.CLOS_ACCT_DT,'YYYYMMDD')
               WHEN TG.DUBIL_NUM IS NOT NULL THEN TO_CHAR(TG.CLOS_ACCT_DT,'YYYYMMDD')
           END                                        AS CLOS_ACCT_DT             --销户日期
    FROM RRP_MDL.O_IML_AGT_AP_REGISTER_INFO_H TA --单户资产登记信息历史 PRDICMS.AP_REGISTER_PROGRAM
   INNER JOIN RRP_MDL.O_IML_AGT_AP_TRANSFER_INFO_H TB --资产转让债权信息历史 PRDICMS.AP_TRANSFER_INFO
      ON TB.DISP_PROP_ID = TA.PROP_ID
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN CL_RECEIPT TC --关联核心表取流水号
      ON TC.CMISLOAN_NO = TB.OBJ_ID
     AND TC.RN = 1
   INNER JOIN IOL.V_TGLS_GLA_VCHR_H TD --核算中台表 --因 O_IOL_TGLS_GLA_VCHR_H 只保留一天数据，所以用数仓的视图
      ON TD.SOURSQ = TC.REFERENCE
     AND TD.STACID = 1
     AND TD.SYSTID = 'NCBS'
     AND TD.AMNTCD = 'D'
     AND TD.ITEMCD = '19020101' --有减值准备的就是差额核销的数据
     AND TD.ETL_DT = TC.ZRRQ
    LEFT JOIN IOL.V_TGLS_GLA_VCHR_H TE --核算中台表 --因 O_IOL_TGLS_GLA_VCHR_H 只保留一天数据，所以用数仓的视图
      ON TE.SOURSQ = TC.REFERENCE
     AND TE.STACID = 1
     AND TE.SYSTID = 'NCBS'
     AND TE.AMNTCD = 'D'
     AND TE.ITEMCD LIKE '113208%' --应收未收利息
     AND TE.ETL_DT = TC.ZRRQ
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO TF --零售贷款账户信息
      ON TF.ACCT_ID = TC.INTERNAL_KEY
     AND TF.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO TG --对公贷款账户信息
      ON TG.ACCT_ID = TC.INTERNAL_KEY
     AND TG.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TA.EXEC_STATUS_CD = '1'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --补充对公差额核销从不良问题贷款余额变动信息出数 ADD BY 20250903
  V_STEP := 6;
  V_STEP_DESC := '插入资产核销信息--对公差额核销';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_CNCL_INFO
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,CONT_ID                  --合同编号
    ,RCPT_ID                  --借据编号
    ,CUST_ID                  --客户编号
    ,ORG_ID                   --机构编号
    ,AST_TYP                  --资产类型
    ,CNCL_DT                  --核销日期
    ,CUR                      --币种
    ,CNCL_LN_PRIN             --实核贷款本金
    ,CNCL_IN_TAM_INT          --实核表内利息
    ,CNCL_OUT_TAM_INT         --实核表外利息
    ,RETRV_FLG                --收回标志
    ,RETRV_TYP                --收回类型
    ,CNCL_RETRV_DT            --核销收回日期
    ,CNCL_RETRV_PRIN          --实核收回本金
    ,CNCL_RETRV_IN_TAM_INT    --实核收回表内利息
    ,CNCL_RETRV_OUT_TAM_INT   --实核收回表外利息
    ,RCMM_LOAN_FLG            --重组贷款标志
    ,RETRV_EMP_NO             --收回员工号
    ,CNCL_RETRV_TLR_NO        --核销收回柜员号
    ,REMARKS                  --备注
    ,FULL_CNCL_FLG            --全额核销标志
    ,BATCH_CNCL_FLG           --批量核销标志
    ,CNCL_STAT                --核销状态
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    ,ALL_RETRA_FLG            --全部收回标志
    ,CLOS_ACCT_DT             --销户日期
    )
  WITH TMP AS (
  SELECT  A.DUBIL_ID DUBIL_ID
         ,MAX(A.BAL_CHAG_DATE) CNCL_DT
         ,SUM(A.PRIC_AMT) AS CNCL_LN_PRIN
         ,SUM(A.INT_AMT) AS CNCL_IN_TAB_INT
    FROM RRP_MDL.O_ICL_CMM_LOAN_BAL_CHG_INFO A
   WHERE A.DISP_WAY_CD = '03' --差额
     AND A.BUS_LINE_CD = '01' --对公
     AND A.ETL_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
     GROUP BY A.DUBIL_ID
     )
  SELECT  V_P_DATE                                    AS DATA_DT                  --数据日期
         ,TG.LP_ID                                    AS LGL_REP_ID               --法人编号
         ,TG.CONT_ID                                  AS CONT_ID                  --合同编号
         ,TG.DUBIL_NUM                                AS RCPT_ID                  --借据编号
         ,TG.CUST_ID                                  AS CUST_ID                  --客户编号
         ,TG.ACCT_INSTIT_ID                           AS ORG_ID                   --机构编号
         ,'02'                                        AS AST_TYP                  --资产类型 --01 个人贷款 02 对公贷款
         ,TO_CHAR(T.CNCL_DT,'YYYYMMDD')               AS CNCL_DT                  --核销日期
         ,TG.CURR_CD                                  AS CUR                      --币种
         ,NVL(T.CNCL_LN_PRIN,0)                       AS CNCL_LN_PRIN             --实核贷款本金
         ,NVL(T.CNCL_IN_TAB_INT,0)                    AS CNCL_IN_TAB_INT          --实核表内利息
         ,0                                           AS CNCL_OUT_TAB_INT         --实核表外利息
         ,'N'                                         AS RETRV_FLG                --收回标志
         ,'N'                                         AS RETRV_TYP                --收回类型
         ,'99991231'                                  AS CNCL_RETRV_DT            --核销收回日期
         ,0                                           AS CNCL_RETRV_PRIN          --实核收回本金
         ,0                                           AS CNCL_RETRV_IN_TAB_INT    --实核收回表内利息
         ,0                                           AS CNCL_RETRV_OUT_TAB_INT   --实核收回表外利息
         ,NULL                                        AS RCMB_LOAN_FLG            --重组贷款标志
         ,NULL                                        AS RETRV_EMP_NO             --收回员工号
         ,NULL                                        AS CNCL_RETRV_TLR_NO        --核销收回柜员号
         ,NULL                                        AS REMARKS                  --备注
         ,NULL                                        AS FULL_CNCL_FLG            --全额核销标志
         ,NULL                                        AS BATCH_CNCL_FLG           --批量核销标志
         ,'02'                                        AS CNCL_STAT                --核销状态
         ,'800919'                                    AS DEPT_LINE                --部门条线
         ,'对公贷款差额核销'                          AS DATA_SRC                 --数据来源
         ,NULL                                        AS ALL_RETRA_FLG            --全部收回标志
         ,TO_CHAR(TG.CLOS_ACCT_DT,'YYYYMMDD')         AS CLOS_ACCT_DT             --销户日期
    FROM RRP_MDL.TMP T --对公差额核销
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO TG --对公贷款账户信息
      ON TG.DUBIL_NUM = T.DUBIL_ID
     AND TG.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE 1=1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  --补充收益权转让零售差额核销部分 ADD BY 20251114
  V_STEP := 6;
  V_STEP_DESC := '插入资产核销信息--收益权转让零售差额核销';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_CNCL_INFO
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,CONT_ID                  --合同编号
    ,RCPT_ID                  --借据编号
    ,CUST_ID                  --客户编号
    ,ORG_ID                   --机构编号
    ,AST_TYP                  --资产类型
    ,CNCL_DT                  --核销日期
    ,CUR                      --币种
    ,CNCL_LN_PRIN             --实核贷款本金
    ,CNCL_IN_TAM_INT          --实核表内利息
    ,CNCL_OUT_TAM_INT         --实核表外利息
    ,RETRV_FLG                --收回标志
    ,RETRV_TYP                --收回类型
    ,CNCL_RETRV_DT            --核销收回日期
    ,CNCL_RETRV_PRIN          --实核收回本金
    ,CNCL_RETRV_IN_TAM_INT    --实核收回表内利息
    ,CNCL_RETRV_OUT_TAM_INT   --实核收回表外利息
    ,RCMM_LOAN_FLG            --重组贷款标志
    ,RETRV_EMP_NO             --收回员工号
    ,CNCL_RETRV_TLR_NO        --核销收回柜员号
    ,REMARKS                  --备注
    ,FULL_CNCL_FLG            --全额核销标志
    ,BATCH_CNCL_FLG           --批量核销标志
    ,CNCL_STAT                --核销状态
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    ,ALL_RETRA_FLG            --全部收回标志
    ,CLOS_ACCT_DT             --销户日期
    )
  SELECT  V_P_DATE                                    AS DATA_DT                  --数据日期
         ,T3.LP_ID                                    AS LGL_REP_ID               --法人编号
         ,T3.CONT_ID                                  AS CONT_ID                  --合同编号
         ,T3.DUBIL_NUM                                AS RCPT_ID                  --借据编号
         ,T3.CUST_ID                                  AS CUST_ID                  --客户编号
         ,T3.ACCT_INSTIT_ID                           AS ORG_ID                   --机构编号
         --,'02'                                        AS AST_TYP                  --资产类型 --01 个人贷款 02 对公贷款
         ,'01'                                        AS AST_TYP                  --资产类型 --01 个人贷款 02 对公贷款 MOD BY LIP 20260112
         ,TO_CHAR(T3.ASSET_TRAN_DT,'YYYYMMDD')        AS CNCL_DT                  --核销日期
         ,T3.CURR_CD                                  AS CUR                      --币种
         ,NVL(T2.PKG_ASSET_BAL,0)-NVL(T2.TRAN_COSDETN,0)     
                                                      AS CNCL_LN_PRIN             --实核贷款本金
         ,T3.IN_BS_INT                                AS CNCL_IN_TAB_INT          --实核表内利息
         ,0                                           AS CNCL_OUT_TAB_INT         --实核表外利息
         ,'N'                                         AS RETRV_FLG                --收回标志
         ,'N'                                         AS RETRV_TYP                --收回类型
         ,'99991231'                                  AS CNCL_RETRV_DT            --核销收回日期
         ,0                                           AS CNCL_RETRV_PRIN          --实核收回本金
         ,0                                           AS CNCL_RETRV_IN_TAB_INT    --实核收回表内利息
         ,0                                           AS CNCL_RETRV_OUT_TAB_INT   --实核收回表外利息
         ,NULL                                        AS RCMB_LOAN_FLG            --重组贷款标志
         ,NULL                                        AS RETRV_EMP_NO             --收回员工号
         ,NULL                                        AS CNCL_RETRV_TLR_NO        --核销收回柜员号
         ,NULL                                        AS REMARKS                  --备注
         ,NULL                                        AS FULL_CNCL_FLG            --全额核销标志
         ,NULL                                        AS BATCH_CNCL_FLG           --批量核销标志
         ,'02'                                        AS CNCL_STAT                --核销状态
         ,'800924'                                    AS DEPT_LINE                --部门条线
         ,'零售贷款差额核销'                          AS DATA_SRC                 --数据来源
         ,NULL                                        AS ALL_RETRA_FLG            --全部收回标志
         ,TO_CHAR(T3.CLOS_ACCT_DT,'YYYYMMDD')         AS CLOS_ACCT_DT             --销户日期
    FROM RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO T1 --资产证券化转让合同信息
   INNER JOIN RRP_MDL.O_ICL_CMM_ABS_BASE_ASSET_INFO T2 --资产证券化基础资产信息
      ON T2.CONT_ID = T1.CONT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T3  --零售贷款账户信息
      ON T3.DUBIL_NUM = T2.DUBIL_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   --增加过滤资产证券化标志,无需剔除卖断 MOD BY 20251124
   WHERE T2.ASSET_STATUS_CD = '70' --资产状态代码:70 已转让已记账 
     --AND NVL(TRIM(T3.ASSET_TRAN_FLG),'0') <> '1' --资产转让标志 无需剔除卖断 MOD BY 20251124 
     AND NVL(TRIM(T3.ABS_FLG), '0') = '1' --资产证券化标志 --ASSET_TRAN_FLG = 1 表示卖断 ADD BY 20251114
     AND T1.ASSET_POOL_STATUS_CD <> '100' --资产池状态代码(剔除 100 已终结) ADD BY 20251114
     AND T1.ASSET_POOL_TYPE_CD = '001' --零售
     AND (NVL(T2.PKG_ASSET_BAL,0)-NVL(T2.TRAN_COSDETN,0)) <> 0
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY HYF 20251119 特殊场景处理
  V_STEP      := 6;
  V_STEP_DESC := '删除全额核销后差额核销的数据';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.M_LOAN_CNCL_INFO T
   WHERE EXISTS (SELECT 1 FROM (
                   SELECT RCPT_ID,COUNT(1) FROM RRP_MDL.M_LOAN_CNCL_INFO
                    WHERE DATA_DT = V_P_DATE
                    GROUP BY RCPT_ID
                   HAVING COUNT(1) > 1) TA
                 WHERE TA.RCPT_ID = T.RCPT_ID)
     AND T.DATA_SRC IN ('对公贷款','零售贷款')
     AND DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := 7;
  V_STEP_DESC := '查询数据是否重复';
  WITH TMP1 AS (
    SELECT DATA_DT,RCPT_ID,COUNT(1)
      FROM RRP_MDL.M_LOAN_CNCL_INFO T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,RCPT_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     V_SQLMSG   := 'M_LOAN_CNCL_INFO数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
  
  
  --月末该表跑第二次时在ETL_STATE插入   ETL_M_LOAN_CNCL_INFO_MONTH  20260417 MODIFY BY LWB
  /*V_STEP      := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE,V_TAB_NAME,V_PART_NAME,O_ERRCODE);

  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));*/
   --程序跑批结束记录
  V_STEP_DESC := '-- 程序跑批结束 --';
    WITH TMP2 AS (
  SELECT COUNT(1) M FROM RRP_MDL.ETL_STATE
   WHERE ETL_DATE = V_P_DATE
     AND PROC_NAME = 'ETL_M_LOAN_CNCL_INFO')
  SELECT NVL(M,0) INTO V_SQLCOUNT2 FROM TMP2;

  IF TO_DATE(V_P_DATE,'YYYYMMDD') = LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')) AND V_SQLCOUNT2 >= 1 THEN
    INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
    VALUES (V_P_DATE,'ETL_M_LOAN_CNCL_INFO_MONTH',TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
    COMMIT;
  END IF;

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');


--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_CNCL_INFO;
/

