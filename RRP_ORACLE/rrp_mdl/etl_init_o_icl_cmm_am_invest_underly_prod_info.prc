CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_AM_INVEST_UNDERLY_PROD_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_AM_INVEST_UNDERLY_PROD_INFO
  *  功能描述：资管投资标的产品信息
  *  创建日期：20221008
  *  开发人员：MW
  *  来源表：
  *  目标表：  O_ICL_CMM_AM_INVEST_UNDERLY_PROD_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_AM_INVEST_UNDERLY_PROD_INFO'; -- 程序名称
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
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_AM_INVEST_UNDERLY_PROD_INFO ';
  /*-- EXECUTE IMMEDIATE ('ALTER TABLE '||'O_ICL_CMM_AM_INVEST_UNDERLY_PROD_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '1';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
 /* V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE, 'O_ICL_CMM_AM_INVEST_UNDERLY_PROD_INFO', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  */

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-资管投资标的产品信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_AM_INVEST_UNDERLY_PROD_INFO
  (
        ETL_DT  --数据日期
        ,LP_ID  --法人编号
        ,PROD_ID  --产品编号
        ,STD_PROD_ID  --标准产品编号
        ,PROD_CATE_CD  --产品类别代码
        ,PROD_ABBR  --产品简称
        ,PROD_FNAME  --产品全称
        ,PRFT_MODE_CD  --收益模式代码
        ,COUPON_BREED_CD  --息票品种代码
        ,FIN_PROD_ID  --金融产品编号
        ,ISSUE_PRICE  --发行价格
        ,ISSUE_SIZE  --发行规模
        ,ISSUE_CURR_CD  --发行币种代码
        ,OVERS_FLG  --境外标志
        ,TRAN_SITE_CD  --交易场所代码
        ,TRAN_CALN_CD  --交易日历代码
        ,ISSUE_WAY_CD  --发行模式代码
        ,CSNER_ID  --委托人编号
        ,TRUSTEE_ID  --托管人编号
        ,ISSUER_ID  --发行人编号
        ,MGER_ID  --管理人编号
        ,FINER_ID  --融资人编号
        ,ISSUE_DT  --出票日期
        ,VALUE_DT  --起息日期
        ,EXP_DT  --到期日期
        ,PROD_TENOR  --产品期限
        ,ACTL_EXP_DT  --实际到期日期
        ,SUBTN_FLG  --永续标志
        ,SUBTN_CLAUS  --永续条款
        ,CONTN_WEIGHT_FLG  --含权标志
        ,BRKEVN_FLG  --保本标志
        ,RGST_TRUST_ORG_CD  --登记托管机构代码
        ,FIN_INST_ISSUE_FLG  --金融机构发行标志
        ,GUARTOR_ID  --担保人编号
        ,PURCH_CFM_TENOR  --申购确认期限
        ,REDEM_CFM_TENOR  --赎回确认期限
        ,SUB_DEBT_FLG  --次级债标志
        ,INVEST_CHAR_TYPE_CD  --投资性质类型代码
        ,FAC_VAL  --票面面值
        ,CITY_BOND_FLG  --城投债标志
        ,CITY_BOND_LEV_CD  --城投债级别代码
        ,ASSET_SRC_CD  --资产来源代码
        ,DISTR_BRCH_ID  --放款分行编号
        ,CLEAR_PED_CD  --清算周期代码
        ,PROJ_DIR_INDUS_CATEGY_CD  --项目投向行业门类代码
        ,PROJ_DIR_INDUS_GEN_CD  --项目投向行业大类代码
        ,BANK_INT_PROD_LEVEL2_CLS_CD  --产品二级分类
        ,BANK_INT_PROD_LEVEL3_CLS_CD  --产品三级分类
        ,BANK_INT_PROD_LEVEL4_CLS_CD  --产品四级分类
        ,BANK_INT_PROD_LEVEL5_CLS_CD  --产品五级分类
        ,ACTL_CRDT_MAIN_ID  --实际授信主体编号
        ,PED_DAYS  --周期天数
        ,AM_PLAN_TYPE_CD  --资管计划类型代码
        ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
        ,PROD_BAL  --产品余额
        ,PROD_NV  --产品净值
        ,JOB_CD  --任务代码


     )
     SELECT
        ETL_DT  --数据日期
        ,LP_ID  --法人编号
        ,PROD_ID  --产品编号
        ,STD_PROD_ID  --标准产品编号
        ,PROD_CATE_CD  --产品类别代码
        ,PROD_ABBR  --产品简称
        ,PROD_FNAME  --产品全称
        ,PRFT_MODE_CD  --收益模式代码
        ,COUPON_BREED_CD  --息票品种代码
        ,FIN_PROD_ID  --金融产品编号
        ,ISSUE_PRICE  --发行价格
        ,ISSUE_SIZE  --发行规模
        ,ISSUE_CURR_CD  --发行币种代码
        ,OVERS_FLG  --境外标志
        ,TRAN_SITE_CD  --交易场所代码
        ,TRAN_CALN_CD  --交易日历代码
        ,ISSUE_WAY_CD  --发行模式代码
        ,CSNER_ID  --委托人编号
        ,TRUSTEE_ID  --托管人编号
        ,ISSUER_ID  --发行人编号
        ,MGER_ID  --管理人编号
        ,FINER_ID  --融资人编号
        ,ISSUE_DT  --出票日期
        ,VALUE_DT  --起息日期
        ,EXP_DT  --到期日期
        ,PROD_TENOR  --产品期限
        ,ACTL_EXP_DT  --实际到期日期
        ,SUBTN_FLG  --永续标志
        ,SUBTN_CLAUS  --永续条款
        ,CONTN_WEIGHT_FLG  --含权标志
        ,BRKEVN_FLG  --保本标志
        ,RGST_TRUST_ORG_CD  --登记托管机构代码
        ,FIN_INST_ISSUE_FLG  --金融机构发行标志
        ,GUARTOR_ID  --担保人编号
        ,PURCH_CFM_TENOR  --申购确认期限
        ,REDEM_CFM_TENOR  --赎回确认期限
        ,SUB_DEBT_FLG  --次级债标志
        ,INVEST_CHAR_TYPE_CD  --投资性质类型代码
        ,FAC_VAL  --票面面值
        ,CITY_BOND_FLG  --城投债标志
        ,CITY_BOND_LEV_CD  --城投债级别代码
        ,ASSET_SRC_CD  --资产来源代码
        ,DISTR_BRCH_ID  --放款分行编号
        ,CLEAR_PED_CD  --清算周期代码
        ,PROJ_DIR_INDUS_CATEGY_CD  --项目投向行业门类代码
        ,PROJ_DIR_INDUS_GEN_CD  --项目投向行业大类代码
        ,BANK_INT_PROD_LEVEL2_CLS_CD  --产品二级分类
        ,BANK_INT_PROD_LEVEL3_CLS_CD  --产品三级分类
        ,BANK_INT_PROD_LEVEL4_CLS_CD  --产品四级分类
        ,BANK_INT_PROD_LEVEL5_CLS_CD  --产品五级分类
        ,ACTL_CRDT_MAIN_ID  --实际授信主体编号
        ,PED_DAYS  --周期天数
        ,AM_PLAN_TYPE_CD  --资管计划类型代码
        ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
        ,PROD_BAL  --产品余额
        ,PROD_NV  --产品净值
        ,JOB_CD  --任务代码
    FROM ICL.V_CMM_AM_INVEST_UNDERLY_PROD_INFO
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


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

  END ETL_INIT_O_ICL_CMM_AM_INVEST_UNDERLY_PROD_INFO;
/

