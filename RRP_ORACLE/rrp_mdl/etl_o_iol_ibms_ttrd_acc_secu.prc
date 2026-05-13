CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_ACC_SECU(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_TTRD_ACC_SECU
  *  功能描述：二级证券账户表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_IBMS_TTRD_ACC_SECU
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  *             2    20250610  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_ACC_SECU'; -- 程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_ACC_SECU';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-二级证券账户表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_ACC_SECU NOLOGGING
    ( ACCID,                   --账户代码
      ACCNAME,                 --账户名称
      CASH_ACCID,              --二级资金账户
      OWNER,                   --所有者
      TRDKIND,                 --交易目的
      TRDGRPID,                --交易组
      PS1,                     --证券账户属性1  理财销售账户对应理财产品I_CODE,其他账户则该字段为0
      PS2,                     --证券账户属性2 对应的会计账号ID
      PS3,                     --证券账户属性3 理财产品账号对应的理财产品的外部资金账号
      PS4,                     --证券账户属性4
      STATUS,                  --账户状态 0新建 11 正常 3已停用
      TRDGRP_AUTO,             --是否自动创建交易组
      IS_LOCK,                 --是否锁定
      LOCKSTATUS,              --锁定状态
      ACCFISCASUBJECT,         --等待补充
      PS5,                     --等待补充
      PS6,                     --等待补充
      PS7,                     --等待补充
      PS8,                     --等待补充
      INVEST_TYPE,             --0自有资产（自营业务）、1客户资产（代客、理财）
      ACTING_TYPE,             --会计分类:1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
      I_ID,                    --机构号
      UNIT_ID,                 --
      START_DT,                --开始时间
      END_DT,                  --结束时间
      ID_MARK                  --增删标志
     )
  SELECT /*+PARALLEL*/
          ACCID,                   --账户代码
          ACCNAME,                 --账户名称
          CASH_ACCID,              --二级资金账户
          OWNER,                   --所有者
          TRDKIND,                 --交易目的
          TRDGRPID,                --交易组
          PS1,                     --证券账户属性1  理财销售账户对应理财产品I_CODE,其他账户则该字段为0
          PS2,                     --证券账户属性2 对应的会计账号ID
          PS3,                     --证券账户属性3 理财产品账号对应的理财产品的外部资金账号
          PS4,                     --证券账户属性4
          STATUS,                  --账户状态 0新建 11 正常 3已停用
          TRDGRP_AUTO,             --是否自动创建交易组
          IS_LOCK,                 --是否锁定
          LOCKSTATUS,              --锁定状态
          ACCFISCASUBJECT,         --等待补充
          PS5,                     --等待补充
          PS6,                     --等待补充
          PS7,                     --等待补充
          PS8,                     --等待补充
          INVEST_TYPE,             --0自有资产（自营业务）、1客户资产（代客、理财）
          ACTING_TYPE,             --会计分类:1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
          I_ID,                    --机构号
          UNIT_ID,                 --
          START_DT,                --开始时间
          END_DT,                  --结束时间
          ID_MARK                  --增删标志
    FROM IOL.V_IBMS_TTRD_ACC_SECU   --二级证券账户表_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

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

  END ETL_O_IOL_IBMS_TTRD_ACC_SECU;
/

