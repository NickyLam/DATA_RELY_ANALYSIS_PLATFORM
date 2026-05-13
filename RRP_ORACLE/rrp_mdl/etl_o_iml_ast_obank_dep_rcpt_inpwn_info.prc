CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AST_OBANK_DEP_RCPT_INPWN_INFO(I_P_DATE IN INTEGER,
                                                                    O_ERRCODE OUT VARCHAR2
                                                                    )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AST_OBANK_DEP_RCPT_INPWN_INFO
  *  功能描述：他行存单质押信息
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IML.V_AST_OBANK_DEP_RCPT_INPWN_INFO
  *  目标表： O_IML_AST_OBANK_DEP_RCPT_INPWN_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  *             2    20250522  YJY      优化脚本，剔除失效数据
  *             3    20251020  YJY      作业下线
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AST_OBANK_DEP_RCPT_INPWN_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  
  /*  --MOD BY YJY 20251020
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AST_OBANK_DEP_RCPT_INPWN_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AST_OBANK_DEP_RCPT_INPWN_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-他行存单质押信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AST_OBANK_DEP_RCPT_INPWN_INFO
    (ASSET_ID			    --资产编号
    ,LP_ID			      --法人编号
    ,VOUCH_ID			    --凭证编号
    ,AVAL_AMT			    --可用金额
    ,BANK_NAME	      --银行名称
    ,BANK_RGST_CD	    --银行注册地代码
    ,EXT_RATING_DT    --外部评级日期
    ,EXT_RATING_REST_CD			--外部评级结果代码
    ,EFFECT_DT			  --生效日期
    ,EXP_DT			      --到期日期
    ,DEP_TERM			    --存期
    ,INT_RAT			    --利率
    ,PRIC_AMT			    --本金金额
    ,CURR_CD			    --币种代码
    ,CREATE_DT			  --创建日期
    ,UPDATE_DT			  --更新日期
    ,ETL_DT			      --etl处理日期
    ,ID_MARK			    --增删标志
    ,SRC_TABLE_NAME		--源表名称
    ,JOB_CD			      --任务编码
    ,ETL_TIMESTAMP		--etl处理时间戳
    ,REMARK			      --备注
    )
  SELECT 
     ASSET_ID			    --资产编号
    ,LP_ID			      --法人编号
    ,VOUCH_ID			    --凭证编号
    ,AVAL_AMT			    --可用金额
    ,BANK_NAME	      --银行名称
    ,BANK_RGST_CD	    --银行注册地代码
    ,EXT_RATING_DT    --外部评级日期
    ,EXT_RATING_REST_CD			--外部评级结果代码
    ,EFFECT_DT			  --生效日期
    ,EXP_DT			      --到期日期
    ,DEP_TERM			    --存期
    ,INT_RAT			    --利率
    ,PRIC_AMT			    --本金金额
    ,CURR_CD			    --币种代码
    ,CREATE_DT			  --创建日期
    ,UPDATE_DT			  --更新日期
    ,ETL_DT			      --etl处理日期
    ,ID_MARK			    --增删标志
    ,SRC_TABLE_NAME		--源表名称
    ,JOB_CD			      --任务编码
    ,ETL_TIMESTAMP		--etl处理时间戳
    ,REMARK			      --备注
    FROM IML.V_AST_OBANK_DEP_RCPT_INPWN_INFO  --视图_他行存单质押信息
    WHERE ID_MARK <> 'D';  --MOD BY YJY 20250522

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AST_OBANK_DEP_RCPT_INPWN_INFO', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  
  */
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

END ETL_O_IML_AST_OBANK_DEP_RCPT_INPWN_INFO;
/

