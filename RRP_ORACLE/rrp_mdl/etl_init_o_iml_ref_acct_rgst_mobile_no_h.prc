CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_REF_ACCT_RGST_MOBILE_NO_H (I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_REF_ACCT_RGST_MOBILE_NO_H
  *  功能描述：客户账户注册手机号历史
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IML.V_REF_ACCT_RGST_MOBILE_NO_H
  *  目标表： O_IML_REF_ACCT_RGST_MOBILE_NO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_REF_ACCT_RGST_MOBILE_NO_H'; -- 程序名称
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
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_REF_ACCT_RGST_MOBILE_NO_H  ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_REF_ACCT_RGST_MOBILE_NO_H ';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-客户账户注册手机号历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_REF_ACCT_RGST_MOBILE_NO_H
  (
      mobile_no  --手机号码
      ,cert_type_cd  --证件类型代码
      ,cert_no  --证件号码
      ,acct_num  --账号
      ,acct_name  --账户名称
      ,acct_num_rgst_attr_cd  --账号注册属性代码
      ,onl_bank_sys_open_bank_no  --网银系统开户行行号
      ,acct_open_bank_no  --账户开户行行号
      ,acct_clear_bank_no  --账户清算行行号
      ,rgst_tm  --登记时间
      ,mobile_no_status_cd  --手机号状态代码
      ,start_dt  --开始时间
      ,end_dt  --结束时间
      ,id_mark  --增删标志
      ,src_table_name  --源表名称
      ,job_cd  --任务编码
     -- ,etl_timestamp  --etl处理时间戳


    )
    SELECT
      mobile_no  --手机号码
      ,cert_type_cd  --证件类型代码
      ,cert_no  --证件号码
      ,acct_num  --账号
      ,acct_name  --账户名称
      ,acct_num_rgst_attr_cd  --账号注册属性代码
      ,onl_bank_sys_open_bank_no  --网银系统开户行行号
      ,acct_open_bank_no  --账户开户行行号
      ,acct_clear_bank_no  --账户清算行行号
      ,rgst_tm  --登记时间
      ,mobile_no_status_cd  --手机号状态代码
      ,start_dt  --开始时间
      ,end_dt  --结束时间
      ,id_mark  --增删标志
      ,src_table_name  --源表名称
      ,job_cd  --任务编码
    --  ,etl_timestamp  --etl处理时间戳

    FROM IML.V_REF_ACCT_RGST_MOBILE_NO_H
      --视图-客户账户注册手机号历史
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

  END ETL_INIT_O_IML_REF_ACCT_RGST_MOBILE_NO_H ;
/

