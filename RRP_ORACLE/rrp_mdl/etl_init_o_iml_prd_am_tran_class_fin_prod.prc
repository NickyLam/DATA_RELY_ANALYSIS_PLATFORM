CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_PRD_AM_TRAN_CLASS_FIN_PROD (I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 资管交易类金融产品表
  **存储过程名称：    ETL_INIT_O_IML_PRD_AM_TRAN_CLASS_FIN_PROD
  **存储过程创建日期：20221130
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
 AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_PRD_AM_TRAN_CLASS_FIN_PROD'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_DATE DATE;
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  V_MONTH_START_DATE:=TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');


  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE    := TO_DATE(I_P_DATE,'YYYY-MM-DD');

  --清理当天数据
 -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IML_PRD_AM_TRAN_CLASS_FIN_PROD';
  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE   O_IML_PRD_AM_TRAN_CLASS_FIN_PROD T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ;

 INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_PRD_AM_TRAN_CLASS_FIN_PROD NOLOGGING
    (
      PROD_ID                              --产品编号
     ,LP_ID                                --法人编号
     ,FIN_PROD_ID                          --金融产品编号
     ,BRCH_SEQ_NUM                         --分支序号
     ,PROD_CATE_CD                         --产品类别代码
     ,PRFT_MODE_CD                         --收益模式代码
     ,BRCH_TYPE_CD                         --分支类型代码
     ,PASS_ID                              --通道编号
     ,NATI_PRIC                            --名义本金
     ,PRIC_CURR_CD                         --本金币种代码
     ,VALUE_DT                             --起息日期
     ,EXP_DT                               --到期日期
     ,TENOR_DAYS                           --期限天数
     ,INT_RAT_TYPE_CD                      --利率类型代码
     ,FIX_INT_RAT                          --固定利率
     ,FLOAT_INT_RAT_BASE_ID                --浮动利率基准编号
     ,INT_ACCR_BASE_CD                     --计息基础代码
     ,EXP_PRIC                             --到期本金
     ,EXP_INT                              --到期利息
     ,EXP_AMT                              --到期金额
     ,BRKEVN_FLG                           --保本标志
     ,INIT_PROD_ID                         --原产品编号
     ,TRAN_SITE_CD                         --交易场所代码
     ,TRAN_CALN_CD                         --交易日历代码
     ,TENOR_BREED_CD                       --期限品种代码
     ,CNTPTY_ID                            --交易对手编号
     ,CREATE_TM                            --创建时间
     ,UPDATE_TM                            --更新时间
     ,EXP_CORP_NET_PRICE                   --到期单位净价
     ,EXP_CORP_INT                         --到期单位利息
     ,EXP_CORP_FULL_PRICE                  --到期单位全价
     ,EXP_PRFT                             --到期收益
     ,EXP_STL_WAY_CD                       --到期结算方式代码
     ,FST_DLVY_DT                          --首期交付日期
     ,EXP_DLVY_DT                          --到期交付日期
     ,CONT_ID                              --合同编号
     ,ACTL_POSES_ACCT_DAYS                 --实际占款天数
     ,PD_ID                                --期次编号
     ,CONT_NAME                            --合同名称
     ,RGST_TRUST_ORG_CD                    --登记托管机构代码
     ,COL_CNT                              --押品数
     ,ATTACH_CLAUS                         --补充条款
     ,PROVI_PNLT_FLG                       --计提罚息标志
     ,PNLT_PROVI_BASE                      --罚息计提基数
     ,ETL_DT                               --数据日期
     ,SRC_TABLE_NAME                       --源表名称
     ,JOB_CD                               --任务代码
     ,ETL_TIMESTAMP                        --数据处理时间

    )
     SELECT /*+PARALLEL*/
      PROD_ID                              --产品编号
     ,LP_ID                                --法人编号
     ,FIN_PROD_ID                          --金融产品编号
     ,BRCH_SEQ_NUM                         --分支序号
     ,PROD_CATE_CD                         --产品类别代码
     ,PRFT_MODE_CD                         --收益模式代码
     ,BRCH_TYPE_CD                         --分支类型代码
     ,PASS_ID                              --通道编号
     ,NATI_PRIC                            --名义本金
     ,PRIC_CURR_CD                         --本金币种代码
     ,VALUE_DT                             --起息日期
     ,EXP_DT                               --到期日期
     ,TENOR_DAYS                           --期限天数
     ,INT_RAT_TYPE_CD                      --利率类型代码
     ,FIX_INT_RAT                          --固定利率
     ,FLOAT_INT_RAT_BASE_ID                --浮动利率基准编号
     ,INT_ACCR_BASE_CD                     --计息基础代码
     ,EXP_PRIC                             --到期本金
     ,EXP_INT                              --到期利息
     ,EXP_AMT                              --到期金额
     ,BRKEVN_FLG                           --保本标志
     ,INIT_PROD_ID                         --原产品编号
     ,TRAN_SITE_CD                         --交易场所代码
     ,TRAN_CALN_CD                         --交易日历代码
     ,TENOR_BREED_CD                       --期限品种代码
     ,CNTPTY_ID                            --交易对手编号
     ,CREATE_TM                            --创建时间
     ,UPDATE_TM                            --更新时间
     ,EXP_CORP_NET_PRICE                   --到期单位净价
     ,EXP_CORP_INT                         --到期单位利息
     ,EXP_CORP_FULL_PRICE                  --到期单位全价
     ,EXP_PRFT                             --到期收益
     ,EXP_STL_WAY_CD                       --到期结算方式代码
     ,FST_DLVY_DT                          --首期交付日期
     ,EXP_DLVY_DT                          --到期交付日期
     ,CONT_ID                              --合同编号
     ,ACTL_POSES_ACCT_DAYS                 --实际占款天数
     ,PD_ID                                --期次编号
     ,CONT_NAME                            --合同名称
     ,RGST_TRUST_ORG_CD                    --登记托管机构代码
     ,COL_CNT                              --押品数
     ,ATTACH_CLAUS                         --补充条款
     ,PROVI_PNLT_FLG                       --计提罚息标志
     ,PNLT_PROVI_BASE                      --罚息计提基数
     ,ETL_DT                               --数据日期
     ,SRC_TABLE_NAME                       --源表名称
     ,JOB_CD                               --任务代码
     ,ETL_TIMESTAMP                        --数据处理时间
    FROM IML.V_PRD_AM_TRAN_CLASS_FIN_PROD   --资管交易类金融产品表--视图

   ;
  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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


END ETL_INIT_O_IML_PRD_AM_TRAN_CLASS_FIN_PROD;
/

