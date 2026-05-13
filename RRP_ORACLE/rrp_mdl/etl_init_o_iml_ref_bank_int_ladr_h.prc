CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_REF_BANK_INT_LADR_H(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_REF_BANK_INT_LADR_H
  *  功能描述：行内利率阶梯历史
  *  创建日期：20221222
  *  开发人员：梅炜
  *  来源表： IML.V_REF_BANK_INT_LADR_H
  *  目标表： O_IML_REF_BANK_INT_LADR_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221222  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_REF_BANK_INT_LADR_H'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_REF_BANK_INT_LADR_H ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_REF_BANK_INT_LADR_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-行内利率阶梯历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_REF_BANK_INT_LADR_H
  (
        LADR_SEQ_NUM  --阶梯序号
        ,LP_ID  --法人编号
        ,ORG_ID  --机构编号
        ,CURR_CD  --币种代码
        ,BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
        ,YEAR_BASE_DAYS  --年基准天数
        ,EFFECT_DT  --生效日期
        ,INVALID_DT  --失效日期
        ,BASE_RAT_TYPE_ID  --基准利率类型编号
        ,BASE_EXCH_RAT  --基础汇率
        ,PED_FREQ_CD  --周期频率代码
        ,EH_ISSUE_DAYS  --每期天数
        ,LADR_AMT  --阶梯金额
        ,BANK_INT_INT_RAT  --行内利率
        ,INT_RAT_DISCNT  --利率折扣
        ,FLOAT_RATIO  --浮动比例
        ,FLOAT_POINT  --浮动点数
        ,MAX_CU_RATIO  --最大上浮比例
        ,MIN_CU_RATIO  --最小上浮比例
        ,MIN_INT_RAT  --最小利率
        ,MAX_INT_RAT  --最大利率
        ,MAX_FLOAT_POINT  --浮动点差上限
        ,MIN_FLOAT_POINT  --浮动点差下限
        ,MAX_FLOAT_RATIO  --最大下浮比例
        ,MIN_FLOAT_RATIO  --最小下浮比例
        ,START_DT  --开始时间
        ,END_DT  --结束时间
        ,ID_MARK  --增删标志
        ,SRC_TABLE_NAME  --源表名称
        ,JOB_CD  --任务编码
        ,ETL_TIMESTAMP  --ETL处理时间戳

    )
    SELECT
        LADR_SEQ_NUM  --阶梯序号
        ,LP_ID  --法人编号
        ,ORG_ID  --机构编号
        ,CURR_CD  --币种代码
        ,BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
        ,YEAR_BASE_DAYS  --年基准天数
        ,EFFECT_DT  --生效日期
        ,INVALID_DT  --失效日期
        ,BASE_RAT_TYPE_ID  --基准利率类型编号
        ,BASE_EXCH_RAT  --基础汇率
        ,PED_FREQ_CD  --周期频率代码
        ,EH_ISSUE_DAYS  --每期天数
        ,LADR_AMT  --阶梯金额
        ,BANK_INT_INT_RAT  --行内利率
        ,INT_RAT_DISCNT  --利率折扣
        ,FLOAT_RATIO  --浮动比例
        ,FLOAT_POINT  --浮动点数
        ,MAX_CU_RATIO  --最大上浮比例
        ,MIN_CU_RATIO  --最小上浮比例
        ,MIN_INT_RAT  --最小利率
        ,MAX_INT_RAT  --最大利率
        ,MAX_FLOAT_POINT  --浮动点差上限
        ,MIN_FLOAT_POINT  --浮动点差下限
        ,MAX_FLOAT_RATIO  --最大下浮比例
        ,MIN_FLOAT_RATIO  --最小下浮比例
        ,START_DT  --开始时间
        ,END_DT  --结束时间
        ,ID_MARK  --增删标志
        ,SRC_TABLE_NAME  --源表名称
        ,JOB_CD  --任务编码
        ,ETL_TIMESTAMP  --ETL处理时间戳

    FROM IML.V_REF_BANK_INT_LADR_H  --视图-行内利率阶梯历史
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

  END ETL_INIT_O_IML_REF_BANK_INT_LADR_H;
/

