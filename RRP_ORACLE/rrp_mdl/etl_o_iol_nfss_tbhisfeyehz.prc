CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NFSS_TBHISFEYEHZ(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NFSS_TBHISFEYEHZ
  *  功能描述：份额余额汇总表
  *  创建日期：20251113
  *  开发人员：于敬艺
  *  来源表： IOL.V_NFSS_TBHISFEYEHZ
  *  目标表： O_IOL_NFSS_TBHISFEYEHZ
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251113  YJY     首次创建
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NFSS_TBHISFEYEHZ'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NFSS_TBHISFEYEHZ';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-份额余额汇总表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NFSS_TBHISFEYEHZ NOLOGGING
    (   SUM_DATE          --汇总日期
       ,SUM_FLAG          --汇总方式,0-按交易机构，1-按开户机构
       ,INTERNAL_BRANCH   --机构内码
       ,CLIENT_TYPE       --客户类型,1-个人客户，0-对公客户
       ,PRD_CODE          --产品代码
       ,BRANCH_NO         --机构代码
       ,TA_CODE           --TA代码
       ,TOT_VOL           --份额总数
       ,LONG_FROZEN_VOL   --长期冻结份额
       ,NAV               --产品净值
       ,CLIENT_NUM        --有效户数
       ,PRD_TYPE          --产品类别,0-基金，1-理财
       ,ETL_DT            --ETL处理日期
       ,ETL_TIMESTAMP     --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
        SUM_DATE          --汇总日期
       ,SUM_FLAG          --汇总方式,0-按交易机构，1-按开户机构
       ,INTERNAL_BRANCH   --机构内码
       ,CLIENT_TYPE       --客户类型,1-个人客户，0-对公客户
       ,PRD_CODE          --产品代码
       ,BRANCH_NO         --机构代码
       ,TA_CODE           --TA代码
       ,TOT_VOL           --份额总数
       ,LONG_FROZEN_VOL   --长期冻结份额
       ,NAV               --产品净值
       ,CLIENT_NUM        --有效户数
       ,PRD_TYPE          --产品类别,0-基金，1-理财
       ,ETL_DT            --ETL处理日期
       ,ETL_TIMESTAMP     --ETL处理时间戳
    FROM IOL.V_NFSS_TBHISFEYEHZ   --份额余额汇总表_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_O_IOL_NFSS_TBHISFEYEHZ;
/

