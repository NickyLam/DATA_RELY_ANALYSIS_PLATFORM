CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_CROP_LOAN_PROMIS(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_CROP_LOAN_PROMIS
  *  功能描述：法人透支签约历史
  *  创建日期：20240221
  *  开发人员：卢伟博
  *  来源表：
  *  目标表：  S_CROP_LOAN_PROMIS
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240221  卢伟博   首次创建
  *             2    20240223  卢伟博   金额数据由万元改为元
  *             3    20251111  HYF      新增是否收取贷款承诺费
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;         --处理步骤
  V_STEP_DESC VARCHAR2(100);        --处理步骤描述
  V_P_DATE    VARCHAR2(10);         --跑批数据日期
  V_STARTTIME DATE;                 --处理开始时间
  V_ENDTIME   DATE;                 --处理结束时间
  V_SQLCOUNT  INTEGER := 0;         --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);        --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);        --分区名
  V_PROC_NAME VARCHAR2(30) := 'ETL_S_CROP_LOAN_PROMIS'; --程序名称
  V_TAB_NAME  VARCHAR2(100) := 'S_CROP_LOAN_PROMIS'; --表名
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.S_CROP_LOAN_PROMIS T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'S_CROP_LOAN_PROMIS'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  RRP_MDL.ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--删除当前分区数据 --分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入对公贷款承诺信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.S_CROP_LOAN_PROMIS(
     DATA_DT          --数据日期
    ,CONT_NO          --合同编号
    ,CUST_NO          --客户编号
    ,MGMT_ORG_NO      --机构编号
    ,STD_PROD_NO      --产品编号
    ,CURR_CD          --币种代码
    ,CONT_AMT         --总额度
    ,USED_AMT         --已用额度
    ,AVAILABLE_AMT    --可用金额
    ,DISTR_DT         --起始日期
    ,EXP_DT           --到期日期
    ,CIRCL_FLG        --循环标志
    ,LOAN_PROMIS_CLS  --贷款承诺分类
    ,GROUP_NO         --组号
    ,ETL_DT           --数据日期
    ,REGD_LAND_AREA_CD --客户行政区划代码
    ,IS_COLL_LOAN_PROMIS_FEE --是否收取贷款承诺费
    )
  SELECT V_P_DATE AS DATA_DT  --数据日期
        ,A.CONT_NO            --合同编号
        ,A.CUST_NO            --客户编号
        ,A.MGMT_ORG_NO        --机构编号
        ,A.STD_PROD_NO        --产品编号
        ,A.CURR_CD            --币种代码
        ,A.CONT_AMT           --总额度
        ,A.USED_AMT           --已用额度
        ,A.AVAILABLE_AMT      --可用金额
        ,A.DISTR_DT           --起始日期
        ,A.EXP_DT             --到期日期
        ,A.CIRCL_FLG          --循环标志
        ,A.LOAN_PROMIS_CLS    --贷款承诺分类
        ,A.GROUP_NO           --组号
        ,A.ETL_DT             --数据日期
        ,FO.REGD_LAND_AREA_CD --客户行政区划代码
        ,A.IS_COLL_LOAN_PROMIS_FEE --是否收取贷款承诺费
    FROM RRP_MDL.O_RDW_RCL_CORP_LOAN_PROMIS A --视图-风险集市公司贷款承诺
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO FO
      ON FO.CUST_ID = A.CUST_NO
     AND FO.DATA_DT = V_P_DATE
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  RRP_MDL.ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_CROP_LOAN_PROMIS;
/

