CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_INTNAL_ACCT(I_P_DATE IN INTEGER,
                                                      O_ERRCODE OUT VARCHAR2
                                                      )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_INTNAL_ACCT
  *  功能描述：内部账户
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_INTNAL_ACCT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20241031  YJY      新增旅行通相关字段
  *             3    20241111  YJY      核心系统通知内部户的旅行通标志不进行打标：旅行通卡资金统一放入账号610001149828下
                                        经评估监管模型自己对内部户的旅行通卡进行判断打标。
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_INTNAL_ACCT'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_INTNAL_ACCT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-内部账户';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_INTNAL_ACCT
    (ETL_DT                           --数据日期
    ,LP_ID                            --法人编号
    ,ACCT_ID                          --账户编号
    ,SUB_ACCT_NUM                     --子户号
    ,MAIN_ACCT_ID                     --主账户编号
    ,ACCT_CARD_NO                     --账户卡号
    ,OLD_ACCT_ID                      --旧账户编号
    ,OLD_SUB_ACCT_NUM                 --旧子户号
    ,PROD_ID                          --产品编号
    ,STD_PROD_ID                      --标准产品编号
    ,CURR_CD                          --币种代码
    ,ACCT_NAME                        --账户名称
    ,OPEN_FLOW_NUM                    --开户流水号
    ,CLOS_ACCT_FLOW_NUM               --销户流水号
    ,BELONG_ORG_ID                    --所属机构编号
    ,LAST_TRAN_DT                     --上次交易日期
    ,LAST_TRAN_FLOW_NUM               --上次交易流水号
    ,ACCTING_CD                       --会计核算代码
    ,SUBJ_ID                          --科目编号
    ,BAL_DIR_CD                       --余额方向代码
    ,ACCT_STATUS_CD                   --账户状态代码
    ,OPEN_ACCT_DT                     --开户日期
    ,CLOS_ACCT_DT                     --销户日期
    ,IN_OUT_TAB_FLG                   --表内外标志
    ,SUSPD_WRTOFF_FLG                 --挂销账标志
    ,ON_ACCT_TENOR                    --挂账期限
    ,WRTOFF_WAY_CD                    --销账方式代码
    ,BUS_CODE_SER_NUM                 --业务编码序列号
    ,GL_ACCT_FLG                      --总账账户标志
    ,INTNAL_ACCT_CHAR_CD              --内部账户性质代码
    ,CAP_CHAR_CD                      --资金性质代码
    ,ACCT_BAL                         --账户余额
    ,CL_CURR_ACCT_BAL                 --折本币账户余额
    ,EAR_D_BAL                        --日初余额
    ,EAR_M_BAL                        --月初余额
    ,EAR_S_BAL                        --季初余额
    ,EAR_Y_BAL                        --年初余额
    ,M_ACM_BAL                        --月累计余额
    ,S_ACM_BAL                        --季累计余额
    ,Y_ACM_BAL                        --年累计余额
    ,CL_CURR_EAR_D_BAL                --折本币日初余额
    ,CL_CURR_EAR_M_BAL                --折本币月初余额
    ,CL_CURR_EAR_S_BAL                --折本币季初余额
    ,CL_CURR_EAR_Y_BAL                --折本币年初余额
    ,CL_CURR_Y_ACM_BAL                --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL          --折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL          --折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL          --折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL          --折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL                --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL          --折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL          --折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL          --折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL                --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL          --折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL          --折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL          --折本币年初月累计余额
    ,Y_AVG_BAL                        --年日均余额
    ,Q_AVG_BAL                        --季日均余额
    ,M_AVG_BAL                        --月日均余额
    ,CL_CURR_Y_AVG_BAL                --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL                --折本币季日均余额
    ,CL_CURR_M_AVG_BAL                --折本币月日均余额
    ,JOB_CD                           --任务代码
    ,ETL_TIMESTAMP                    --数据处理时间
    ,ACCT_ATTR_CD                     --账户属性代码            ADD BY YJY 20241031
   ,INT_ACCR_FLG                      --计息标志                ADD BY YJY 20241031
   ,TRAVEL_CARD_ACCT_FLG              --旅行通账户标志          ADD BY YJY 20241031
   ,TRAVEL_CARD_VALID_DT              --旅行通卡有效期          ADD BY YJY 20241031
   ,ACCT_CLS_CD                       --账户分类代码            ADD BY YJY 20241031
   ,OPEN_ACCT_CHN_TYPE_CD             --开户渠道编号            ADD BY YJY 20241031
   ,REG_ACCT_TYPE_CD                  --定期账户类型代码        ADD BY YJY 20241031
   ,BUS_MGMT_CLS_CD                   --业务管理分类代码        ADD BY YJY 20241031
   ,ACCT_USAGE_CD                     --账户用途代码            ADD BY YJY 20241031
   ,LAST_MODIF_TELLER_ID              --上次修改柜员编号        ADD BY YJY 20241031
   ,TD_INT_EXPNS                      --当日利息支出            ADD BY YJY 20241031
   ,INT_EXPNS_SUBJ_ID                 --利息支出科目编号        ADD BY YJY 20241031
   ,ACCT_INSTIT_ID                    --账务机构编号            ADD BY YJY 20241031
   ,CURRT_ACRU_INT                    --当期应计利息            ADD BY YJY 20241031
    )
  SELECT ETL_DT                      --数据日期
        ,LP_ID                       --法人编号
        ,ACCT_ID                     --账户编号
        ,SUB_ACCT_NUM                --子户号
        ,MAIN_ACCT_ID                --主账户编号
        ,ACCT_CARD_NO                --账户卡号
        ,OLD_ACCT_ID                 --旧账户编号
        ,OLD_SUB_ACCT_NUM            --旧子户号
        ,PROD_ID                     --产品编号
        ,STD_PROD_ID                 --标准产品编号
        ,CURR_CD                     --币种代码
        ,ACCT_NAME                   --账户名称
        ,OPEN_FLOW_NUM               --开户流水号
        ,CLOS_ACCT_FLOW_NUM          --销户流水号
        ,BELONG_ORG_ID               --所属机构编号
        ,LAST_TRAN_DT                --上次交易日期
        ,LAST_TRAN_FLOW_NUM          --上次交易流水号
        ,ACCTING_CD                  --会计核算代码
        ,SUBJ_ID                     --科目编号
        ,BAL_DIR_CD                  --余额方向代码
        ,ACCT_STATUS_CD              --账户状态代码
        ,OPEN_ACCT_DT                --开户日期
        ,CLOS_ACCT_DT                --销户日期
        ,IN_OUT_TAB_FLG              --表内外标志
        ,SUSPD_WRTOFF_FLG            --挂销账标志
        ,ON_ACCT_TENOR               --挂账期限
        ,WRTOFF_WAY_CD               --销账方式代码
        ,BUS_CODE_SER_NUM            --业务编码序列号
        ,GL_ACCT_FLG                 --总账账户标志
        ,INTNAL_ACCT_CHAR_CD         --内部账户性质代码
        ,CAP_CHAR_CD                 --资金性质代码
        ,ACCT_BAL                    --账户余额
        ,CL_CURR_ACCT_BAL            --折本币账户余额
        ,EAR_D_BAL                   --日初余额
        ,EAR_M_BAL                   --月初余额
        ,EAR_S_BAL                   --季初余额
        ,EAR_Y_BAL                   --年初余额
        ,M_ACM_BAL                   --月累计余额
        ,S_ACM_BAL                   --季累计余额
        ,Y_ACM_BAL                   --年累计余额
        ,CL_CURR_EAR_D_BAL           --折本币日初余额
        ,CL_CURR_EAR_M_BAL           --折本币月初余额
        ,CL_CURR_EAR_S_BAL           --折本币季初余额
        ,CL_CURR_EAR_Y_BAL           --折本币年初余额
        ,CL_CURR_Y_ACM_BAL           --折本币年累计余额
        ,CL_CURR_EAR_D_Y_ACM_BAL     --折本币日初年累计余额
        ,CL_CURR_EAR_M_Y_ACM_BAL     --折本币月初年累计余额
        ,CL_CURR_EAR_S_Y_ACM_BAL     --折本币季初年累计余额
        ,CL_CURR_EAR_Y_Y_ACM_BAL     --折本币年初年累计余额
        ,CL_CURR_S_ACM_BAL           --折本币季累计余额
        ,CL_CURR_EAR_D_S_ACM_BAL     --折本币日初季累计余额
        ,CL_CURR_EAR_S_S_ACM_BAL     --折本币季初季累计余额
        ,CL_CURR_EAR_Y_S_ACM_BAL     --折本币年初季累计余额
        ,CL_CURR_M_ACM_BAL           --折本币月累计余额
        ,CL_CURR_EAR_D_M_ACM_BAL     --折本币日初月累计余额
        ,CL_CURR_EAR_M_M_ACM_BAL     --折本币月初月累计余额
        ,CL_CURR_EAR_Y_M_ACM_BAL     --折本币年初月累计余额
        ,Y_AVG_BAL                   --年日均余额
        ,Q_AVG_BAL                   --季日均余额
        ,M_AVG_BAL                   --月日均余额
        ,CL_CURR_Y_AVG_BAL           --折本币年日均余额
        ,CL_CURR_Q_AVG_BAL           --折本币季日均余额
        ,CL_CURR_M_AVG_BAL           --折本币月日均余额
        ,JOB_CD                      --任务代码
        ,ETL_TIMESTAMP               --数据处理时间
        ,ACCT_ATTR_CD                --账户属性代码            ADD BY YJY 20241031
        ,INT_ACCR_FLG                --计息标志                ADD BY YJY 20241031
        ,CASE WHEN MAIN_ACCT_ID = '610001149828' THEN '1'
              WHEN MAIN_ACCT_ID NOT IN ('610001149828') THEN '0'  -- MOD BY 20241111
              ELSE TRAVEL_CARD_ACCT_FLG
          END  AS  TRAVEL_CARD_ACCT_FLG   --旅行通账户标志          ADD BY YJY 20241031
        ,TRAVEL_CARD_VALID_DT        --旅行通卡有效期          ADD BY YJY 20241031
        ,ACCT_CLS_CD                 --账户分类代码            ADD BY YJY 20241031
        ,OPEN_ACCT_CHN_TYPE_CD       --开户渠道编号            ADD BY YJY 20241031
        ,REG_ACCT_TYPE_CD            --定期账户类型代码        ADD BY YJY 20241031
        ,BUS_MGMT_CLS_CD             --业务管理分类代码        ADD BY YJY 20241031
        ,ACCT_USAGE_CD               --账户用途代码            ADD BY YJY 20241031
        ,LAST_MODIF_TELLER_ID        --上次修改柜员编号        ADD BY YJY 20241031
        ,TD_INT_EXPNS                --当日利息支出            ADD BY YJY 20241031
        ,INT_EXPNS_SUBJ_ID           --利息支出科目编号        ADD BY YJY 20241031
        ,ACCT_INSTIT_ID              --账务机构编号            ADD BY YJY 20241031
        ,CURRT_ACRU_INT              --当期应计利息            ADD BY YJY 20241031
    FROM ICL.V_CMM_INTNAL_ACCT --视图-内部账户
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_INTNAL_ACCT', '', O_ERRCODE);

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

END ETL_O_ICL_CMM_INTNAL_ACCT;
/

