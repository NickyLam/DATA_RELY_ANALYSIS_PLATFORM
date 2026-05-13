CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_DEP_ACCT_ATTACH_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                               O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明： 存款账户附加信息
  **存储过程名称：    ETL_O_ICL_CMM_DEP_ACCT_ATTACH_INFO
  **存储过程创建日期：20221128
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20231107    hulj       新增同兴赢主协议超档利率、同兴赢子协议协定利率
  *  20240428    YJY        新增异地开户标志、开户省份、开户城市
  *  20241031    YJY        新增旅行通相关字段
  *  20241204    YJY        新增医保账户标志
  *  20250208    YJY        新增现金管理类产品标志
  ****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_DEP_ACCT_ATTACH_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_DEP_ACCT_ATTACH_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-存款分户补充信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_ICL_CMM_DEP_ACCT_ATTACH_INFO NOLOGGING
    (ETL_DT                             --数据日期
    ,LP_ID                              --法人编号
    ,ACCT_ID                            --账户编号
    ,ACCT_NAME                          --账户名称
    ,CUST_ID                            --客户编号
    ,SRC_AGT_ID                         --源协议编号
    ,FX_ACCT_CHAR_CD                    --外汇账户性质代码
    ,AGT_DEP_TYPE_CD                    --协议存款类型代码
    ,ACCT_LICS_NUM                      --账户许可证号
    ,ACCT_LICS_ISSUE_DT                 --账户许可证签发日期
    ,CAP_CHAR_CD                        --资金性质代码
    ,ACCT_CLOSE_RS_DESCB                --账户关闭原因描述
    ,INIT_OPEN_ACCT_DT                  --原始开户日期
    ,INIT_EXP_DT                        --原始到期日期
    ,JOB_CD                             --任务代码
    ,ETL_TIMESTAMP                      --数据处理时间
    ,TXY_MAIN_AGT_FILES_INT_RAT         --同兴赢主协议超档利率
    ,TXY_SUB_AGT_AGREE_INT_RAT          --同兴赢子协议协定利率
    ,REMOTE_OPEN_ACCT_FLG              --异地开户标志 ADD BY YJY 20240428
    ,OPEN_ACCT_PROV                    --开户省份     ADD BY YJY 20240428
    ,OPEN_ACCT_CITY                    --开户城市     ADD BY YJY 20240428
    ,SUPV_TYPE_CD                      --监管类型代码           add by yjy 20241031
    ,L_SIX_M_NO_TRAN_FLG               --六个月无交易标志       add by yjy 20241031
    ,XHC_FLG                           --兴惠存标志             add by yjy 20241031
    ,CERT_PRINT_FLG                    --证实书打印标志         add by yjy 20241031
    ,TRAVEL_CARD_ACCT_FLG              --旅行通账户标志         add by yjy 20241031
    ,TRAVEL_CARD_VALID_DT              --旅行通卡有效期         add by yjy 20241031
    ,PRECON_WDRAW_FLG                  --预约支取标志           add by yjy 20241031
    ,PRECON_WDRAW_DT                   --预约支取日期           add by yjy 20241031
    ,PRECON_PAYOFF_DT                  --预约结清日期           add by yjy 20241031
    ,HEAT_INSU_ACCT_FLG                --医保账户标志           add by yjy 20241204
    ,SUB_ACCT_INT_RAT_FLOAT_RATIO      --协定存款利率浮动比例   add by yjy 20241031
    ,SUB_ACCT_INT_RAT_FLOAT_POINT      --协定存款利率浮动点数   add by yjy 20241031
    ,DELAY_PAY_INT_INT_FLOAT_POINT     --延期付息利息浮动点     add by yjy 20241031
    ,CAP_POOL_AGT_RAT                  --资金池协议利率         add by yjy 20241031
    ,LONG_HANG_AMT                     --久悬金额               add by yjy 20241031
    ,APOT_TENOR_AMT                    --约期金额               add by yjy 20241031
    ,APOT_TENOR_START_DT               --约期开始日期           add by yjy 20241031
    ,APOT_TENOR_END_DT                 --约期结束日期           add by yjy 20241031   
    ,CASH_MANAGE_FLG                   --现金管理类产品标志     ADD BY YJY 20250208
    )
  SELECT /*+PARALLEL*/
         ETL_DT                             --数据日期
        ,LP_ID                              --法人编号
        ,ACCT_ID                            --账户编号
        ,ACCT_NAME                          --账户名称
        ,CUST_ID                            --客户编号
        ,SRC_AGT_ID                         --源协议编号
        ,FX_ACCT_CHAR_CD                    --外汇账户性质代码
        ,AGT_DEP_TYPE_CD                    --协议存款类型代码
        ,ACCT_LICS_NUM                      --账户许可证号
        ,ACCT_LICS_ISSUE_DT                 --账户许可证签发日期
        ,CAP_CHAR_CD                        --资金性质代码
        ,ACCT_CLOSE_RS_DESCB                --账户关闭原因描述
        ,INIT_OPEN_ACCT_DT                  --原始开户日期
        ,INIT_EXP_DT                        --原始到期日期
        ,JOB_CD                             --任务代码
        ,ETL_TIMESTAMP                      --数据处理时间
        ,TXY_MAIN_AGT_FILES_INT_RAT         --同兴赢主协议超档利率
        ,TXY_SUB_AGT_AGREE_INT_RAT          --同兴赢子协议协定利率
        ,REMOTE_OPEN_ACCT_FLG               --异地开户标志 ADD BY YJY 20240428
        ,OPEN_ACCT_PROV                     --开户省份     ADD BY YJY 20240428
        ,OPEN_ACCT_CITY                     --开户城市     ADD BY YJY 20240428
        ,SUPV_TYPE_CD                      --监管类型代码           add by yjy 20241031
        ,L_SIX_M_NO_TRAN_FLG               --六个月无交易标志       add by yjy 20241031
        ,XHC_FLG                           --兴惠存标志             add by yjy 20241031
        ,CERT_PRINT_FLG                    --证实书打印标志         add by yjy 20241031
        ,REPLACE(TRAVEL_CARD_ACCT_FLG,'-','0') AS TRAVEL_CARD_ACCT_FLG --旅行通账户标志         add by yjy 20241031
        ,TRAVEL_CARD_VALID_DT              --旅行通卡有效期         add by yjy 20241031
        ,PRECON_WDRAW_FLG                  --预约支取标志           add by yjy 20241031
        ,PRECON_WDRAW_DT                   --预约支取日期           add by yjy 20241031
        ,PRECON_PAYOFF_DT                  --预约结清日期           add by yjy 20241031
        ,HEAT_INSU_ACCT_FLG                --医保账户标志           add by yjy 20241204
        ,SUB_ACCT_INT_RAT_FLOAT_RATIO      --协定存款利率浮动比例   add by yjy 20241031
        ,SUB_ACCT_INT_RAT_FLOAT_POINT      --协定存款利率浮动点数   add by yjy 20241031
        ,DELAY_PAY_INT_INT_FLOAT_POINT     --延期付息利息浮动点     add by yjy 20241031
        ,CAP_POOL_AGT_RAT                  --资金池协议利率         add by yjy 20241031
        ,LONG_HANG_AMT                     --久悬金额               add by yjy 20241031
        ,APOT_TENOR_AMT                    --约期金额               add by yjy 20241031
        ,APOT_TENOR_START_DT               --约期开始日期           add by yjy 20241031
        ,APOT_TENOR_END_DT                 --约期结束日期           add by yjy 20241031   
        ,CASH_MANAGE_FLG                   --现金管理类产品标志     ADD BY YJY 20250208
    FROM ICL.V_CMM_DEP_ACCT_ATTACH_INFO --存款分户补充信息_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_DEP_ACCT_ATTACH_INFO', '', O_ERRCODE);

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

END ETL_O_ICL_CMM_DEP_ACCT_ATTACH_INFO;
/

