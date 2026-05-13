CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CPTL_REDISC_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CPTL_REDISC_INFO
  *  功能描述：再贴现信息表
  *  创建日期：20220609
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_REDISC_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220609  梅炜      首次创建
  *             2    20221114  HULJ      增加数据重复校验
  ***************************************************************************/
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
  V_TAB_NAME  VARCHAR2(100) := 'M_CPTL_REDISC_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CPTL_REDISC_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_CPTL_REDISC_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CRTL_REDISC_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入再贴现信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_REDISC_INFO
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,RCPT_ID                  --借据编号
    ,CONT_ID                  --合同编号
    ,BILL_NO                  --票据号码
    ,ORG_ID                   --机构编号
    ,REDISC_ORG_NM            --再贴现机构名称
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_FIN_ORG_ID         --交易对手金融机构编码
    ,CNTPR_PBC_NO             --交易对手行号
    ,RATE                     --利率
    ,CUR                      --币种
    ,REDISC_AMT               --再贴现金额
    ,REDISC_INT               --再贴现利息
    ,DISC_DT                  --贴现日期
    ,REDISC_DT                --再贴现日期
    ,REDISC_TYP               --再贴现类型
    ,REPO_EXP_DT              --回购到期日期
    ,REPO_AMT                 --回购金额
    ,REPO_RATE                --回购利率
    ,REPO_INT                 --回购利息
    ,CPTL_OUT_ACC_NO          --资金划出账号
    ,CPTL_IN_ACC_NO           --资金划入账号
    ,PBC_ORG_PIC_NM           --人行机构负责人姓名
    ,DEPT_LINE                --部门条线
    ,CURRT_BAL                --当期余额
    ,BILL_ACT_AMT             --实付金额
    ,REPO_DT                  --约定回购日期
    ,SUBJ_ID                  --科目编号
    ,ORG_PHONE                --再贴现机构联系电话
    ,ORG_ADDR                 --再贴现机构地址
    ,INT_ADJ_BAL              --利息调整余额
    ,CNTPTY_CUST_ID           --交易对手客户编号
    ,CURRT_ACRU_INT           --当期应计利息
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')      AS DATA_DT            --数据日期
        ,A.LP_ID                           AS LGL_REP_ID         --法人编号
        ,A.BUS_ID                          AS RCPT_ID            --借据编号
        ,A.CTR_NT_ID                       AS CONT_ID            --合同编号
        ,A.BILL_ID                         AS BILL_NO            --票据号码
        ,A.ACCT_INSTIT_ID                  AS ORG_ID             --机构编号
        ,D.ORG_NAME                        AS REDISC_ORG_NM      --再贴现机构名称 --MODIFY BY LAIHAIQIANG 20220602 修改再贴现机构取值口径
        ,A.CNTPTY_NAME                     AS CNTPR_NM           --交易对手名称
        ,NVL(CASE WHEN LENGTH(TRIM(TY.FIN_INST_CODE)) = 14 THEN TRIM(TY.FIN_INST_CODE)
                  ELSE NULL END,
             PBC.FIN_ORG_CODE)             AS CNTPR_FIN_ORG_ID   --交易对手金融机构编码 --更新 202200722 XUCX
        ,A.CNTPTY_BANK_NO                  AS CNTPR_PBC_NO       --交易对手行号
        ,A.DISCNT_INT_RAT                  AS RATE               --利率
        ,A.CURR_CD                         AS CUR                --币种
        ,A.FAC_VAL_AMT                     AS REDISC_AMT         --再贴现金额
        ,A.INT_AMT                         AS REDISC_INT         --再贴现利息
        ,NULL                              AS DISC_DT            --贴现日期
        ,TO_CHAR(A.APPL_DT,'YYYYMMDD')     AS REDISC_DT          --再贴现日期
        ,A.BUS_TYPE_CD                     AS REDISC_TYP         --再贴现类型
        ,TO_CHAR(A.REPO_DT,'YYYYMMDD')     AS REPO_EXP_DT        --回购到期日期
        ,A.REPO_AMT                        AS REPO_AMT           --回购金额
        ,NULL                              AS REPO_RATE          --回购利率
        ,NULL                              AS REPO_INT           --回购利息
        ,A.PAYER_BANK_NO                   AS CPTL_OUT_ACC_NO    --资金划出账号
        ,A.RECVER_BANK_NO                  AS CPTL_IN_ACC_NO     --资金划入账号
        ,PBC.FIN_NAME                      AS PBC_ORG_PIC_NM     --人行机构负责人
        ,'800935'                          AS DEPT_LINE          --部门条线 /*票据业务事业部'06'*/
        ,A.CURRT_BAL                       AS CURRT_BAL          --当期余额
        ,A.STL_AMT                         AS BILL_ACT_AMT       --实付金额
        ,TO_CHAR(A.REPO_DT,'YYYYMMDD')     AS REPO_DT            --回购金额
        ,A.SUBJ_ID                         AS SUBJ_ID            --科目编号
        ,CAST(D.PHONE AS VARCHAR2(30))     AS ORG_PHONE          --再贴现机构联系电话 --ADD BY 20220628 XUCX
        ,CAST(D.PHYS_ADDR AS VARCHAR2(90)) AS ORG_ADDR           --再贴现机构地址 --ADD BY 20220628 XUCX
        ,A.INT_ADJ_BAL                     AS INT_ADJ_BAL        --利息调整余额
        ,NVL(E.LP_ORG_CUST_ID,E.CUST_ID)   AS CNTPTY_CUST_ID     --交易对手客户编号
        ,A.CURRT_ACRU_INT                  AS CURRT_ACRU_INT     --当期应计利息
    FROM RRP_MDL.O_ICL_CMM_BILL_REDCST_INFO A --票据再贴现信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO D --内部机构信息表
      ON D.ORG_ID = A.ACCT_INSTIT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基本信息
      ON E.CUST_ID = A.CNTPTY_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CUST_CHAT_INFO TY --取同业机构的金融机构编码 ADD BY 20220722 XUCX
      ON TY.PARTY_ID = E.LP_ORG_CUST_ID --取法人机构的金融机构编码
     AND TY.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TY.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG_PBC PBC --人民银行机构信息补充表
      ON PBC.NAME = A.CNTPTY_NAME --人行全称
      OR PBC.ABBR_NAME = A.CNTPTY_NAME --人行简称
   WHERE A.ENTRY_STATUS_CD = '03'
     --AND A.CURRT_BAL > 0
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,RCPT_ID,COUNT(1)
    FROM RRP_MDL.M_CPTL_REDISC_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,RCPT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
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

END ETL_M_CPTL_REDISC_INFO;
/

