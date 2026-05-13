CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_CONL_BK_SIGN_INFO(I_P_DATE IN INTEGER,
                                                            O_ERRCODE OUT VARCHAR2
                                                            )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_CONL_BK_SIGN_INFO
  *  功能描述：企业网银签约信息
  *  创建日期：20221210
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  O_ICL_CMM_CONL_BK_SIGN_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221210  梅炜      首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_CONL_BK_SIGN_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  O_ERRCODE := '0';

  -- 支持重跑 --
  V_STEP := 0;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_CONL_BK_SIGN_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'O_ICL_CMM_CONL_BK_SIGN_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  /*V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE, 'O_ICL_CMM_CONL_BK_SIGN_INFO', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);*/

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-企业网银签约信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CONL_BK_SIGN_INFO
    (ETL_DT                   --数据日期
    ,LP_ID                    --法人编号
    ,CUST_ID                  --客户编号
    ,CUST_CN_NAME             --客户中文名称
    ,CUST_EN_NAME             --客户英文名称
    ,OPEN_ACCT_TM             --开户时间
    ,OPEN_ACCT_BRCH_ID        --开户分行编号
    ,OPEN_ACCT_BRAC_ID        --开户网点编号
    ,BELONG_BRAC_ID           --归属网点编号
    ,OPEN_ACCT_OPERR_ID       --开户操作员编号
    ,SIGN_CHN_CD              --签约渠道代码
    ,CUST_MGR_ID              --客户经理编号
    ,GROUP_CUST_FLG           --集团客户标志
    ,CASH_CTRL_FLG            --现金控制标志
    ,SUP_CHAIN_SYS_FLG        --供应链系统标志
    ,SIGN_YQT_FLG             --签约银企通标志
    ,ONL_BANK_CUST_TYPE_CD    --网银客户类型代码
    ,ONL_BANK_CUST_STATUS_CD  --网银客户状态代码
    ,CERT_TYPE_CD             --证件类型代码
    ,CERT_NO                  --证件号码
    ,ORGNZ_CD                 --组织机构代码
    ,LEGAL_REP_NAME           --法人代表名称
    ,LP_CERT_TYPE_CD          --法人证件类型代码
    ,LP_CERT_NO               --法人证件号码
    ,LP_TEL_NUM               --法人电话号码
    ,LP_CERT_EXP_DT           --法人证件到期日期
    ,EDIT_FLG                 --版本标志
    ,POSTA_ADDR               --通讯地址
    ,TEL_NUM                  --电话号码
    ,FAX_NUM                  --传真号码
    ,ZIP_CD                   --邮政编码
    ,CHARGE_ACCT_ID           --收费账户编号
    ,CHARGE_CURR_CD           --收费币种代码
    ,FINAL_TRAN_TM            --最后交易时间
    ,STATUS_MODIF_DESCB_INFO  --状态变更描述信息
    ,SIGN_YQT_TM              --签约银企通时间
    ,OA_WRTOFF_TM             --OA注销时间
    ,INIT_OA_ID               --原OA编号
    ,OA_REIM_RELA_ACCT_ID     --OA报销关联账户编号
    ,ONL_BANK_TRAN_LMT        --网银转账限额
    ,JOB_CD                   --任务代码
    ,ETL_TIMESTAMP            --数据处理时间
    )
  SELECT 
     ETL_DT                   --数据日期
    ,LP_ID                    --法人编号
    ,CUST_ID                  --客户编号
    ,CUST_CN_NAME             --客户中文名称
    ,CUST_EN_NAME             --客户英文名称
    ,OPEN_ACCT_TM             --开户时间
    ,OPEN_ACCT_BRCH_ID        --开户分行编号
    ,OPEN_ACCT_BRAC_ID        --开户网点编号
    ,BELONG_BRAC_ID           --归属网点编号
    ,OPEN_ACCT_OPERR_ID       --开户操作员编号
    ,SIGN_CHN_CD              --签约渠道代码
    ,CUST_MGR_ID              --客户经理编号
    ,GROUP_CUST_FLG           --集团客户标志
    ,CASH_CTRL_FLG            --现金控制标志
    ,SUP_CHAIN_SYS_FLG        --供应链系统标志
    ,SIGN_YQT_FLG             --签约银企通标志
    ,ONL_BANK_CUST_TYPE_CD    --网银客户类型代码
    ,ONL_BANK_CUST_STATUS_CD  --网银客户状态代码
    ,CERT_TYPE_CD             --证件类型代码
    ,CERT_NO                  --证件号码
    ,ORGNZ_CD                 --组织机构代码
    ,LEGAL_REP_NAME           --法人代表名称
    ,LP_CERT_TYPE_CD          --法人证件类型代码
    ,LP_CERT_NO               --法人证件号码
    ,LP_TEL_NUM               --法人电话号码
    ,LP_CERT_EXP_DT           --法人证件到期日期
    ,EDIT_FLG                 --版本标志
    ,POSTA_ADDR               --通讯地址
    ,TEL_NUM                  --电话号码
    ,FAX_NUM                  --传真号码
    ,ZIP_CD                   --邮政编码
    ,CHARGE_ACCT_ID           --收费账户编号
    ,CHARGE_CURR_CD           --收费币种代码
    ,FINAL_TRAN_TM            --最后交易时间
    ,STATUS_MODIF_DESCB_INFO  --状态变更描述信息
    ,SIGN_YQT_TM              --签约银企通时间
    ,OA_WRTOFF_TM             --OA注销时间
    ,INIT_OA_ID               --原OA编号
    ,OA_REIM_RELA_ACCT_ID     --OA报销关联账户编号
    ,ONL_BANK_TRAN_LMT        --网银转账限额
    ,JOB_CD                   --任务代码
    ,ETL_TIMESTAMP            --数据处理时间
    FROM ICL.V_CMM_CONL_BK_SIGN_INFO
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_ICL_CMM_CONL_BK_SIGN_INFO;
/

