CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO
  *  功能描述：对公贷款额度合同补充信息
  *  创建日期：20221210
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221210  梅炜      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO'; -- 程序名称
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
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO ';
  /*-- EXECUTE IMMEDIATE ('ALTER TABLE '||'O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
 /* V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE, 'O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  */

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-对公贷款额度合同补充信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO
  (
       ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,CONT_ID  --合同编号
      ,COL_TURN_MARGIN_ACCT_NUM  --押品转保证金账号
      ,TENOR_TYPE_CD  --期限类型代码
      ,LMT_KIND_CD  --额度种类代码
      ,GROUP_LMT_CTRL_MODE_CD  --集团额度管控模式代码
      ,MAJOR_LOAN_CLS_CD  --专业贷款分类代码
      ,PRTCPT_WAY_CD  --参与方式代码
      ,CRDT_RG_CD  --授信区域代码
      ,INVEST_WAY_CD  --投资方式代码
      ,RISK_EXPOSE_CLS  --风险暴露分类
      ,PUBLIC_CRDT_FLG  --公开授信标志
      ,FIN_SYS_CONT_FLG  --融资合同标志
      ,FROZ_FLG  --冻结标志
      ,ESTATE_FIN_FLG  --房地产融资标志
      ,INVO_GOVER_CLASS_FIN_FLG1  --政府类融资标志
      ,CONSM_SERV_CLASS_FIN_FLG  --消费服务类融资标志
      ,BR_BUILD_IFIN_FLG  --一带一路建设投融资标志
      ,GREEN_CRDT_FIN_FLG  --绿色信贷融资标志
      ,CLASS_CRDT_FLG  --类信贷标志
      ,DISTR_ORG_ID  --放款机构编号
      ,LMT_INVALID_DT  --额度失效日期
      ,LMT_UNDER_BUS_LATEST_EXP_DT  --额度项下业务最迟到期日期
      ,LMT_NEXT_BUS_HIGT_PM_RAT  --额度下业务最高抵质押率
      ,LMT_NEXT_BUS_INIT_MARGIN_RATIO  --额度下业务初始保证金比例
      ,LMT_NEXT_BUS_INT_RAT_LOWT_FLO_VAL  --额度下业务利率最低浮动值
      ,LMT_NEXT_BUS_SIG_MAX_AMT  --额度下业务单笔最大金额
      ,LMT_NEXT_BUS_LONT_TENOR  --额度下业务最长期限
      ,LMT_NEXT_BUS_EXT_TENOR  --额度下业务延展期限
      ,BUS_CURR_RANGE  --业务币种范围
      ,LMT_USE_COND_DESCB  --额度使用条件描述
      ,SYN_LOAN_TOT_AMT  --银团贷款总金额
      ,ONL_LMT  --线上额度
      ,STAT_USE_OPEN_BAL  --统计用敞口余额
      ,LMT_NMAL_AMT  --额度名义金额
      ,LMT_OPEN_AMT  --额度敞口金额
      ,USED_NMAL_AMT  --已用名义金额
      ,USED_OPEN_AMT  --已用敞口金额
      ,AVAL_NMAL_AMT  --可用名义金额
      ,AVAL_OPEN_AMT  --可用敞口金额
      ,LOWER_OCUP_UP_LEVEL_CRDT_OPEN_AMT  --下层占用上层授信敞口金额
      ,LOWER_OCUP_UP_LEVEL_CRDT_NMAL_AMT  --下层占用上层授信名义金额
      ,JOB_CD  --任务代码

     )
     SELECT
        ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,CONT_ID  --合同编号
      ,COL_TURN_MARGIN_ACCT_NUM  --押品转保证金账号
      ,TENOR_TYPE_CD  --期限类型代码
      ,LMT_KIND_CD  --额度种类代码
      ,GROUP_LMT_CTRL_MODE_CD  --集团额度管控模式代码
      ,MAJOR_LOAN_CLS_CD  --专业贷款分类代码
      ,PRTCPT_WAY_CD  --参与方式代码
      ,CRDT_RG_CD  --授信区域代码
      ,INVEST_WAY_CD  --投资方式代码
      ,RISK_EXPOSE_CLS  --风险暴露分类
      ,PUBLIC_CRDT_FLG  --公开授信标志
      ,FIN_SYS_CONT_FLG  --融资合同标志
      ,FROZ_FLG  --冻结标志
      ,ESTATE_FIN_FLG  --房地产融资标志
      ,INVO_GOVER_CLASS_FIN_FLG1  --政府类融资标志
      ,CONSM_SERV_CLASS_FIN_FLG  --消费服务类融资标志
      ,BR_BUILD_IFIN_FLG  --一带一路建设投融资标志
      ,GREEN_CRDT_FIN_FLG  --绿色信贷融资标志
      ,CLASS_CRDT_FLG  --类信贷标志
      ,DISTR_ORG_ID  --放款机构编号
      ,LMT_INVALID_DT  --额度失效日期
      ,LMT_UNDER_BUS_LATEST_EXP_DT  --额度项下业务最迟到期日期
      ,LMT_NEXT_BUS_HIGT_PM_RAT  --额度下业务最高抵质押率
      ,LMT_NEXT_BUS_INIT_MARGIN_RATIO  --额度下业务初始保证金比例
      ,LMT_NEXT_BUS_INT_RAT_LOWT_FLO_VAL  --额度下业务利率最低浮动值
      ,LMT_NEXT_BUS_SIG_MAX_AMT  --额度下业务单笔最大金额
      ,LMT_NEXT_BUS_LONT_TENOR  --额度下业务最长期限
      ,LMT_NEXT_BUS_EXT_TENOR  --额度下业务延展期限
      ,BUS_CURR_RANGE  --业务币种范围
      ,LMT_USE_COND_DESCB  --额度使用条件描述
      ,SYN_LOAN_TOT_AMT  --银团贷款总金额
      ,ONL_LMT  --线上额度
      ,STAT_USE_OPEN_BAL  --统计用敞口余额
      ,LMT_NMAL_AMT  --额度名义金额
      ,LMT_OPEN_AMT  --额度敞口金额
      ,USED_NMAL_AMT  --已用名义金额
      ,USED_OPEN_AMT  --已用敞口金额
      ,AVAL_NMAL_AMT  --可用名义金额
      ,AVAL_OPEN_AMT  --可用敞口金额
      ,LOWER_OCUP_UP_LEVEL_CRDT_OPEN_AMT  --下层占用上层授信敞口金额
      ,LOWER_OCUP_UP_LEVEL_CRDT_NMAL_AMT  --下层占用上层授信名义金额
      ,JOB_CD  --任务代码
    FROM ICL.V_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO
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

  END ETL_INIT_O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO;
/

