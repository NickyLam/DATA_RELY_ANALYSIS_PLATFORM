CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_WL_LOAN_PROMIS(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_S_WL_LOAN_PROMIS
  *  功能描述：法人透支签约历史
  *  创建日期：20240221
  *  开发人员：卢伟博
  *  来源表：
  *  目标表：  S_WL_LOAN_PROMIS
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240221  卢伟博      首次创建
                2    20240510  卢伟博     修改取数来源
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_WL_LOAN_PROMIS'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  --V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME  VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_WL_LOAN_PROMIS'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_MONTH_START_DATE:= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_WL_LOAN_PROMIS T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'S_WL_LOAN_PROMIS'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '网商贷个人风险暴露';
  V_STARTTIME := SYSDATE;

  -- 网商贷（业务确认网商贷是非循环额度）和花呗、京东金条、借呗、中台微粒贷（因已无新增业务，无未放款金额的产品）
-- 这组用于D层加工个人风险暴露用，贷款承若供数可以过滤这组数据
  insert /*+ append */ into S_WL_LOAN_PROMIS
  (
		 data_dt,    --数据日期
     lmt_cont_no,    --合同编号
     cust_no,    --客户编号
     mgmt_org_no,    --机构编号
     std_prod_no,    --产品编号
     curr_cd,    --币种代码
     crdt_lmt,    --总额度
     used_amt,    --已用额度
     available_amt,    --可用金额
     begin_dt,    --生效日期
     exp_dt,    --结束日期
     circl_flg,    --循环标志
     guar_flg,    --有担保标志
     loan_promis_cls,    --贷款承诺分类
     group_no,    --组号
     etl_dt,    --数据日期
     curr_bal    --当期余额
   )
SELECT
     V_P_DATE as data_dt --数据日期
    ,LMT_CONT_NO       --合同编号
    ,CUST_NO           --客户编号
    ,MGMT_ORG_NO       --机构编号
    ,STD_PROD_NO       --产品编号
    ,CURR_CD           --币种代码
    ,CRDT_LMT          --总额度
    ,USED_AMT          --已用额度
    ,AVAILABLE_AMT     --可用金额
    ,BEGIN_DT          --生效日期
    ,EXP_DT            --结束日期
    ,CIRCL_FLG         --循环标志
    ,GUAR_FLG          --有担保标志
    ,LOAN_PROMIS_CLS   --贷款承诺分类
    ,GROUP_NO          --组号
    ,ETL_DT            --数据日期
    ,CURR_BAL          --当期余额
    FROM RRP_MDL.O_RDW_RML_R03_WL_LOAN_PROMIS --视图-风险集市R03_网贷贷款承诺
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);



  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
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

END ETL_S_WL_LOAN_PROMIS;
/

