CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_INTSTL_ACCT(I_P_DATE IN INTEGER,
                                                      O_ERRCODE OUT VARCHAR2
                                                      )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_INTSTL_ACCT
  *  功能描述：国结账户
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IML.V_AGT_INTSTL_ACCT
  *  目标表： O_IML_AGT_INTSTL_ACCT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  *             2    20241227  YJY      优化脚本
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_INTSTL_ACCT'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_IML_AGT_INTSTL_ACCT T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_INTSTL_ACCT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-国结账户';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_INTSTL_ACCT
    ( AGT_ID			            --交易账户编号
      ,LP_ID			            --法人编号
      ,ACCT_PRIOR_LEVEL_CD	  --
      ,ACCT_CURR_CD			      --账户币种代码
      ,BANK_ACCT_ID			      --银行账户编号
      ,ACCT_BANK_ID			      --
      ,ACCT_BANK_NAME			    --
      ,ACCT_BANK_TYPE_CD			--
      ,ACCT_BANK_PARTY_ID			--
      ,OPEN_ORG_ACCT_ID			  --
      ,OPEN_ORG_ACCT_NAME			--
      ,OPEN_ORG_ACCT_TYPE_CD	--
      ,OPEN_ACCT_ORG_PARTY_ID	--
      ,POS_ACCT_FLG			      --
      ,PAY_BACK_FLG			      --
      ,DEL_FLG			          --删除标志
      ,EDIT_ID			          --版本编号
      ,DEBIT_CRDT_DIR_CD			--借贷方向代码
      ,ACCT_BANK_FLG			    --
      ,SWIFT_ACCT_NAME			  --
      ,HXB_ACCT_FLG			      --我行账户标志
      ,ACCT_BANK_BIC_CODE			--
      ,INTER_BANK_ACCT_ID			--
      ,ENTY_GROUP_ID			    --实体组编号
      ,ACCT_NUM_NAME_COMNT		--
      ,ACCT_USAGE_TYPE_CD			--
      ,SUBJ_CD			          --科目代码
      ,ACCT_TYPE_CD			      --账户类型代码
      ,BELONG_ORG_ID			    --所属机构编号
      ,EC_IDF_CD			        --钞汇标识代码
      ,PROD_NAME			        --产品名称
      ,FORI_EXCH_ACCT_CHAR_CD	--
      ,STD_PROD_ID			      --标准产品编号
      ,SUB_ACCT_NUM			      --子户号
      ,CREATE_DT			        --创建日期
      ,UPDATE_DT			        --更新日期
      ,ETL_DT			            --数据日期
      ,ID_MARK			          --增删标志
      ,SRC_TABLE_NAME			    --源表名称
      ,JOB_CD			            --任务代码
    )
  SELECT 
       AGT_ID			            --交易账户编号
      ,LP_ID			            --法人编号
      ,ACCT_PRIOR_LEVEL_CD	  --
      ,ACCT_CURR_CD			      --账户币种代码
      ,BANK_ACCT_ID			      --银行账户编号
      ,ACCT_BANK_ID			      --
      ,ACCT_BANK_NAME			    --
      ,ACCT_BANK_TYPE_CD			--
      ,ACCT_BANK_PARTY_ID			--
      ,OPEN_ORG_ACCT_ID			  --
      ,OPEN_ORG_ACCT_NAME			--
      ,OPEN_ORG_ACCT_TYPE_CD	--
      ,OPEN_ACCT_ORG_PARTY_ID	--
      ,POS_ACCT_FLG			      --
      ,PAY_BACK_FLG			      --
      ,DEL_FLG			          --删除标志
      ,EDIT_ID			          --版本编号
      ,DEBIT_CRDT_DIR_CD			--借贷方向代码
      ,ACCT_BANK_FLG			    --
      ,SWIFT_ACCT_NAME			  --
      ,HXB_ACCT_FLG			      --我行账户标志
      ,ACCT_BANK_BIC_CODE			--
      ,INTER_BANK_ACCT_ID			--
      ,ENTY_GROUP_ID			    --实体组编号
      ,ACCT_NUM_NAME_COMNT		--
      ,ACCT_USAGE_TYPE_CD			--
      ,SUBJ_CD			          --科目代码
      ,ACCT_TYPE_CD			      --账户类型代码
      ,BELONG_ORG_ID			    --所属机构编号
      ,EC_IDF_CD			        --钞汇标识代码
      ,PROD_NAME			        --产品名称
      ,FORI_EXCH_ACCT_CHAR_CD	--
      ,STD_PROD_ID			      --标准产品编号
      ,SUB_ACCT_NUM			      --子户号
      ,CREATE_DT			        --创建日期
      ,UPDATE_DT			        --更新日期
      ,ETL_DT			            --数据日期
      ,ID_MARK			          --增删标志
      ,SRC_TABLE_NAME			    --源表名称
      ,JOB_CD			            --任务代码
    FROM IML.V_AGT_INTSTL_ACCT  --视图-国结账户
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_INTSTL_ACCT', '', O_ERRCODE);

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

END ETL_O_IML_AGT_INTSTL_ACCT;
/

