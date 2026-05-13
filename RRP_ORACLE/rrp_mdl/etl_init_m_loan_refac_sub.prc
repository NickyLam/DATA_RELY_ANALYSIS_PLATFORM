CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_REFAC_SUB(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
  /***********************************************************************
    **  存储过程详细说明：支小再贷款子表
    **  存储过程名称:  ETL_INIT_M_LOAN_REFAC_SUB
    **  存储过程创建日期:2022-07-13
    **  存储过程创建人：MW
    **  调用方法:
         DECLARE
           I_P_DATE INTEGER;
           O_ERRCODE  CHAR(5);
         BEGIN
           I_P_DATE := '20220307';
           ETL_INIT_M_LOAN_REFAC_SUB(I_P_DATE, O_ERRCODE);
         END;
    **  输入参数:   I_P_DATE
    **  输出参数:   O_ERRCODE
    **  返回值:     O_ERRCODE
    **  修改日期          修改项目        修改原因           修改人
    **  20220825          修改表结构和取数逻辑               徐畅欣
  ***********************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_REFAC_SUB'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE; -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_REFAC_SUB'; --表名
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
  V_STEP      := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入支小贷款子表数据信息';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.M_LOAN_REFAC_SUB
    (DATA_DT,                                            --数据日期
     LGL_REP_ID,                                         --法人编号
     ORG_ID,                                             --机构编号
     ORG_NM,                                             --机构名称
     CUST_ID,                                            --客户编号
     DUBIL_ID,                                           --借据编号
     BELONG_LAND_PBC_NAME,                               --所属地人民银行名称
     BELONG_LAND_PBC_FIN_INST_CODE,                      --所属地人民银行金融机构编码
     PYM_ACC,                                            --资金划出账户
     PBC_CRED_RHT_TYP,                                   --人民银行债权类型
     RECVBL_ACCT_ID,                                     --资金划入账户
     CORP_PHONE_NUM,                                     --单位联系电话
     CORP_ADDR,                                          --单位地址
     PMO_TYP,                                            --抵质押物类型
     PMO_CONT_ID,                                        --抵质押物合同编号
     PMO_AMT_EVLTION,                                    --抵质押物金额（估值）
     CRED_RHT_BAL,                                       --再贷款金额
     PBL_INT,                                            --再贷款应付利息
     DEPT_LINE,                                          --部门条线
     DATA_SRC,                                           --数据来源
     BELONG_LAND_PBC_CORP_PRINC_NAM,                     --所属地人民银行机构负责人姓名
     REFAC_CONT_ID                                       --再贷款合同编号
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')         AS DATA_DT,              --数据日期
         A.LP_ID                              AS LGL_REP_ID,           --法人编号
         --A.APPL_ORG_ID                        AS ORG_ID,               --机构编号
         B.ORG_ID1                            AS ORG_ID,               --机构编号
         --A.ORG_NAME                           AS ORG_NM,               --机构名称
         B.ORG_NAME                           AS ORG_NM,               --机构名称
         A.CUST_ID                            AS CUST_ID,              --客户编号
         A.DUBIL_ID                           AS DUBIL_ID,             --借据编号
         A.BELONG_LAND_PBC_NAME               AS BELONG_LAND_PBC_NAME, --所属地人民银行名称
         A.BELONG_LAND_PBC_FIN_INST_CODE      AS BELONG_LAND_PBC_FIN_INST_CODE,--所属地人民银行金融机构编码
         A.PBC_PAY_ACCT_ID                    AS PYM_ACC,              --资金划出账户
         A.PBC_CRED_RHT_TYPE_DESCB            AS PBC_CRED_RHT_TYP,     --人民银行债权类型
         A.RECVBL_ACCT_ID                     AS RECVBL_ACCT_ID,       --资金划入账户
         A.CORP_PHONE_NUM                     AS CORP_PHONE_NUM,       --单位联系电话
         A.CORP_ADDR                          AS CORP_ADDR,            --单位地址
         A.PMO_TYPE_CD                        AS PMO_TYP,              --抵质押物类型
         A.PMO_CONT_ID                        AS PMO_CONT_ID,          --抵质押物合同编号
         A.PMO_AMT_EVLTION                    AS PMO_AMT_EVLTION,      --抵质押物金额（估值）
         A.REFAC_AMT                          AS CRED_RHT_BAL,         --再贷款金额
         --根据陈明明意见，支小再贷款的利息=债权余额 * 使用利率 / 4
         --ROUND(A.REFAC_AMT*A.USE_INT_RAT/4,2) AS PBL_INT,              --再贷款应付利息
         --MD BY 20220909 XUCX  根据陈明明意见修改为债权余额*使用年利率/365*当季实际用款天数
         ROUND(
             (CASE WHEN A.REFAC_EXP_DT > TO_DATE(V_P_DATE,'YYYY/MM/DD')  THEN TO_DATE(V_P_DATE,'YYYY/MM/DD')  ELSE A.REFAC_EXP_DT END
              - CASE WHEN A.REFAC_DISTR_DT < TRUNC(TO_DATE(V_P_DATE,'YYYY/MM/DD') ,'Q')-1 THEN TRUNC(TO_DATE(V_P_DATE,'YYYY/MM/DD') ,'Q')-1 ELSE A.REFAC_DISTR_DT END)
              * A.REFAC_AMT * A.USE_INT_RAT / 365, 2
              )                               AS PBL_INT,      --再贷款应付利息
         --'02'                                 AS DEPT_LINE,    --部门条线
         '800919'                             AS DEPT_LINE,    --部门条线 --风险管理部
         SUBSTR(A.JOB_CD,0,4)                 AS DATA_SRC,     --数据来源
         A.BELONG_LAND_PBC_CORP_PRINC_NAME    AS BELONG_LAND_PBC_CORP_PRINC_NAM, --所属地人民银行机构负责人姓名
         A.REFAC_CONT_ID                      AS REFAC_CONT_ID --再贷款合同编号
    FROM RRP_MDL.O_ICL_CMM_REFAC_LOAN_ATTACH_INFO A --支小再贷款补充信息
    LEFT JOIN RRP_MDL.ORG_CONFIG B --内部机构信息表
      ON B.ORG_ID = A.APPL_ORG_ID
   WHERE A.REFAC_DISTR_DT <= TO_DATE(V_P_DATE,'YYYY/MM/DD')  --再贷款发放日期
     /*AND A.REFAC_EXP_DT > TRUNC(TO_DATE(V_P_DATE,'YYYY/MM/DD') ,'Q')  --再贷款到期日期*/
     AND A.REFAC_EXP_DT >= TO_DATE(V_P_DATE,'YYYY/MM/DD')   --再贷款到期日期
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYY/MM/DD') ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

        -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, DUBIL_ID,PMO_CONT_ID,REFAC_CONT_ID,COUNT(1)
      FROM M_LOAN_REFAC_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, DUBIL_ID,PMO_CONT_ID,REFAC_CONT_ID
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
  ETL_YUSYS_LOG(V_P_DATE,
                V_SYSTEM,
                V_PROC_NAME,
                V_STARTTIME,
                V_ENDTIME,
                V_STEP,
                V_STEP_DESC,
                V_SQLCOUNT,
                O_ERRCODE,
                '');

  -- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE   := '1';
    V_ENDTIME   := SYSDATE;
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,
                  V_SYSTEM,
                  V_PROC_NAME,
                  V_STARTTIME,
                  V_ENDTIME,
                  V_STEP,
                  V_STEP_DESC,
                  V_SQLCOUNT,
                  O_ERRCODE,
                  V_SQLMSG);

END ETL_INIT_M_LOAN_REFAC_SUB;
/

