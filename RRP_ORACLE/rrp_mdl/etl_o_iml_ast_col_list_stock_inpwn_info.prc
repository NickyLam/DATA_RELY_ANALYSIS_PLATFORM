CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AST_COL_LIST_STOCK_INPWN_INFO(I_P_DATE IN INTEGER,
                                                                    O_ERRCODE OUT VARCHAR2
                                                                    )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AST_COL_LIST_STOCK_INPWN_INFO
  *  功能描述：押品上市公司股权质押信息
  *  创建日期：20221124
  *  开发人员：许晓滨
  *  来源表：
  *  目标表： O_IML_AST_COL_LIST_STOCK_INPWN_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221124  许晓滨   首次创建
  *             2    20241226  YJY      优化脚本
  *             3    20251027  YJY      新增场内质押标志、质押登记编号
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AST_COL_LIST_STOCK_INPWN_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AST_COL_LIST_STOCK_INPWN_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-押品上市公司股权质押信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AST_COL_LIST_STOCK_INPWN_INFO NOLOGGING
    (ASSET_ID                   --01 资产编号
    ,LP_ID                      --02 法人编号
    ,STOCK_CD                   --03 股票代码
    ,STOCK_NAME                 --04 股票名称
    ,CORP_NAME                  --05 公司名称
    ,ISSUER_BRWER_FLG           --06 发行人为借款人标志
    ,CORP_PREV_YEAR_MARGIN      --07 公司上年度利润
    ,STOCK_NOMAL_FLG            --08 股票正常标志
    ,STOCK_STATUS_CD            --09 股票状态代码
    ,TRAN_SITE_CD               --10 交易场所代码
    ,PUBLIC_TRAN_FLG            --11 公开交易标志
    ,HOLD_SHARES_QTTY           --12 持股数量
    ,INPWN_STOCK_QTTY           --13 质押股权数量
    ,MK_PRI                     --14 市价
    ,LAST_YEAR_SHARE_DIVD_AMT   --15 上年每股分红金额
    ,WARNING_LINE               --16 警戒线
    ,PER_SHARE_NET_ASSET        --17 每股净资产
    ,CLOSE_POS_LINE             --18 平仓线
    ,INPWN_TOT_VAL              --19 质押总价值
    ,RESTR_EXP_DT               --20 限售到期日期
    ,OTHER_COMNT                --21 其他说明
    ,CURR_CD                    --22 币种代码
    ,TRUST_BROKER_NAME          --23 托管券商名称
    ,START_DT                   --24 开始日期
    ,END_DT                     --25 结束日期
    ,ID_MARK                    --26 删除标识
    ,SRC_TABLE_NAME             --27 源表名称
    ,JOB_CD                     --28 任务编码
    ,ETD_INPWN_FLG              --29 场内质押标志  ADD BY YJY 20251027
    ,INPWN_RGST_ID              --30 质押登记编号  ADD BY YJY 20251027
    )
  SELECT /*+PARALLEL*/
         ASSET_ID                   --01 资产编号
        ,LP_ID                      --02 法人编号
        ,STOCK_CD                   --03 股票代码
        ,STOCK_NAME                 --04 股票名称
        ,CORP_NAME                  --05 公司名称
        ,ISSUER_BRWER_FLG           --06 发行人为借款人标志
        ,CORP_PREV_YEAR_MARGIN      --07 公司上年度利润
        ,STOCK_NOMAL_FLG            --08 股票正常标志
        ,STOCK_STATUS_CD            --09 股票状态代码
        ,TRAN_SITE_CD               --10 交易场所代码
        ,PUBLIC_TRAN_FLG            --11 公开交易标志
        ,HOLD_SHARES_QTTY           --12 持股数量
        ,INPWN_STOCK_QTTY           --13 质押股权数量
        ,MK_PRI                     --14 市价
        ,LAST_YEAR_SHARE_DIVD_AMT   --15 上年每股分红金额
        ,WARNING_LINE               --16 警戒线
        ,PER_SHARE_NET_ASSET        --17 每股净资产
        ,CLOSE_POS_LINE             --18 平仓线
        ,INPWN_TOT_VAL              --19 质押总价值
        ,RESTR_EXP_DT               --20 限售到期日期
        ,OTHER_COMNT                --21 其他说明
        ,CURR_CD                    --22 币种代码
        ,TRUST_BROKER_NAME          --23 托管券商名称
        ,START_DT                   --24 开始日期
        ,END_DT                     --25 结束日期
        ,ID_MARK                    --26 删除标识
        ,SRC_TABLE_NAME             --27 源表名称
        ,JOB_CD                     --28 任务编码
        ,ETD_INPWN_FLG              --29 场内质押标志  ADD BY YJY 20251027
        ,INPWN_RGST_ID              --30 质押登记编号  ADD BY YJY 20251027
    FROM IML.V_AST_COL_LIST_STOCK_INPWN_INFO   --押品上市公司股权质押信息_视图
   WHERE START_DT <= TO_DATE(I_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(I_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AST_COL_LIST_STOCK_INPWN_INFO', '', O_ERRCODE);

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

END ETL_O_IML_AST_COL_LIST_STOCK_INPWN_INFO;
/

