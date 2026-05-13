CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_FDW_FML_F03_INT_INCOME_EXPNS_INFO(I_P_DATE IN INTEGER,
                                                                    O_ERRCODE OUT VARCHAR2
                                                                    )
  /**************************************************************************
  *  程序名称：ETL_O_FDW_FML_F03_INT_INCOME_EXPNS_INFO
  *  功能描述：利息收支信息
  *  创建日期：20221228
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  O_FDW_FML_F03_INT_INCOME_EXPNS_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221228  梅炜      首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';           --处理步骤
  V_P_DATE    VARCHAR2(8);              --跑批数据日期
  V_STARTTIME DATE;                     --处理开始时间
  V_ENDTIME   DATE;                     --处理结束时间
  V_SQLCOUNT  INTEGER := 0;             --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);            --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);            --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_FDW_FML_F03_INT_INCOME_EXPNS_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_FDW_FML_F03_INT_INCOME_EXPNS_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--普通表的重跑处理
  EXECUTE IMMEDIATE ('TRUNCATE TABLE O_FDW_FML_F03_INT_INCOME_EXPNS_INFO');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-利息收支信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_FDW_FML_F03_INT_INCOME_EXPNS_INFO
   ( RELA_FIELD                  --关联字段
    ,BUS_TYPE_CD                 --业务类型代码
    ,CURR_CD                     --币种代码
    ,ACCTS_ORG_NO                --账务机构编号
    ,STD_PROD_NO                 --标准产品编号
    ,PRIN_SUBJ_NO                --本金科目编号
    ,INT_INCOME_EXPNSSUBJ_NO     --利息收支科目编号
    ,INT_ADJ_INCOME_EXPNS_SUBJ_NO--利息调整收支科目编号
    ,SPD_PL_SUBJ_NO              --价差损益科目编号
    ,EVHA_VAL_CHAG_PL_SUBJ_NO    --公允价值变动损益科目编号
    ,TAX_FEE                     --税额
    ,INT_INCOME_EXPNS_D          --当日利息收支
    ,INT_INCOME_EXPNS_M          --当月利息收支
    ,INT_INCOME_EXPNS_Q          --当季利息收支
    ,INT_INCOME_EXPNS_Y          --当年利息收支
    ,INT_ADJ_INCOME_EXPNS_D      --当日利息调整收支
    ,INT_ADJ_INCOME_EXPNS_M      --当月利息调整收支
    ,INT_ADJ_INCOME_EXPNS_Q      --当季利息调整收支
    ,INT_ADJ_INCOME_EXPNS_Y      --当年利息调整收支
    ,SPD_PL_D                    --当日价差损益
    ,SPD_PL_M                    --当月价差损益
    ,SPD_PL_Q                    --当季价差损益
    ,SPD_PL_Y                    --当年价差损益
    ,EVHA_VAL_CHAG_PL_D          --当日公允价值变动损益
    ,EVHA_VAL_CHAG_PL_M          --当月公允价值变动损益
    ,EVHA_VAL_CHAG_PL_Q          --当季公允价值变动损益
    ,EVHA_VAL_CHAG_PL_Y          --当年公允价值变动损益
    ,SOURCE_TABLE                --来源表
    ,ETL_DT                      --数据日期
    ,ETL_TIMESTAMP               --ETL处理时间戳
    ,INT_INCOME_EXPNS_D_SL       --当日利息收支(税前)
    ,INT_ADJ_INCOME_EXPNS_D_SL    --当日利息调整收支(税前)
    )
  SELECT 
     RELA_FIELD                  --关联字段
    ,BUS_TYPE_CD                 --业务类型代码
    ,CURR_CD                     --币种代码
    ,ACCTS_ORG_NO                --账务机构编号
    ,STD_PROD_NO                 --标准产品编号
    ,PRIN_SUBJ_NO                --本金科目编号
    ,INT_INCOME_EXPNSSUBJ_NO     --利息收支科目编号
    ,INT_ADJ_INCOME_EXPNS_SUBJ_NO--利息调整收支科目编号
    ,SPD_PL_SUBJ_NO              --价差损益科目编号
    ,EVHA_VAL_CHAG_PL_SUBJ_NO    --公允价值变动损益科目编号
    ,TAX_FEE                     --税额
    ,INT_INCOME_EXPNS_D          --当日利息收支
    ,INT_INCOME_EXPNS_M          --当月利息收支
    ,INT_INCOME_EXPNS_Q          --当季利息收支
    ,INT_INCOME_EXPNS_Y          --当年利息收支
    ,INT_ADJ_INCOME_EXPNS_D      --当日利息调整收支
    ,INT_ADJ_INCOME_EXPNS_M      --当月利息调整收支
    ,INT_ADJ_INCOME_EXPNS_Q      --当季利息调整收支
    ,INT_ADJ_INCOME_EXPNS_Y      --当年利息调整收支
    ,SPD_PL_D                    --当日价差损益
    ,SPD_PL_M                    --当月价差损益
    ,SPD_PL_Q                    --当季价差损益
    ,SPD_PL_Y                    --当年价差损益
    ,EVHA_VAL_CHAG_PL_D          --当日公允价值变动损益
    ,EVHA_VAL_CHAG_PL_M          --当月公允价值变动损益
    ,EVHA_VAL_CHAG_PL_Q          --当季公允价值变动损益
    ,EVHA_VAL_CHAG_PL_Y          --当年公允价值变动损益
    ,SOURCE_TABLE                --来源表
    ,ETL_DT                      --数据日期
    ,ETL_TIMESTAMP               --ETL处理时间戳
    ,INT_INCOME_EXPNS_D_SL       --当日利息收支(税前)
    ,INT_ADJ_INCOME_EXPNS_D_SL    --当日利息调整收支(税前)
    FROM FDW.V_FML_F03_INT_INCOME_EXPNS_INFO   --视图-利息收支信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_FDW_FML_F03_INT_INCOME_EXPNS_INFO', '', O_ERRCODE);

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

END ETL_O_FDW_FML_F03_INT_INCOME_EXPNS_INFO;
/

