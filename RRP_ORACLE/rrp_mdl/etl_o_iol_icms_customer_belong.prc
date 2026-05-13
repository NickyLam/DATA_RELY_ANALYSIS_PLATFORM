CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_CUSTOMER_BELONG(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_CUSTOMER_BELONG
  *  功能描述：客户管辖权限信息表
  *  创建日期：20251126
  *  开发人员：于敬艺
  *  来源表： IOL.V_ICMS_CUSTOMER_BELONG
  *  目标表： O_IOL_ICMS_CUSTOMER_BELONG
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251126  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_CUSTOMER_BELONG'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_CUSTOMER_BELONG';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-客户管辖权限信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_CUSTOMER_BELONG NOLOGGING
    (       CUSTOMERID      --客户编号
           ,BELONGORGID     --机构编号
           ,BELONGUSERID    --员工编号
           ,EDITRIGHT       --信息维护权
           ,REMARK          --备注
           ,INPUTORGID      --登记机构
           ,INPUTUSERID     --登记人
           ,VIEWRIGHT       --信息查看权
           ,UPDATEUSERID    --更新人
           ,CORPORGID       --法人机构编号
           ,BUSINESSRIGHT   --业务办理权
           ,INPUTDATE       --登记日期
           ,BUSINESSRIGHT1  --非标业务申办权
           ,MANAGERIGHT     --主办权
           ,UPDATEDATE      --更新日期
           ,MIGTFLAG        --迁移标志：crsrcrilcupl
           ,UPDATEORGID     --更新机构
           ,MIGTOLDVALUE    --迁移数据-参数转换前字段值
           ,START_DT        --开始时间
           ,END_DT          --结束时间
           ,ID_MARK         --增删标志
           ,ETL_TIMESTAMP   --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
             CUSTOMERID      --客户编号
           ,BELONGORGID     --机构编号
           ,BELONGUSERID    --员工编号
           ,EDITRIGHT       --信息维护权
           ,REMARK          --备注
           ,INPUTORGID      --登记机构
           ,INPUTUSERID     --登记人
           ,VIEWRIGHT       --信息查看权
           ,UPDATEUSERID    --更新人
           ,CORPORGID       --法人机构编号
           ,BUSINESSRIGHT   --业务办理权
           ,INPUTDATE       --登记日期
           ,BUSINESSRIGHT1  --非标业务申办权
           ,MANAGERIGHT     --主办权
           ,UPDATEDATE      --更新日期
           ,MIGTFLAG        --迁移标志：crsrcrilcupl
           ,UPDATEORGID     --更新机构
           ,MIGTOLDVALUE    --迁移数据-参数转换前字段值
           ,START_DT        --开始时间
           ,END_DT          --结束时间
           ,ID_MARK         --增删标志
           ,ETL_TIMESTAMP   --ETL处理时间戳
    FROM IOL.V_ICMS_CUSTOMER_BELONG   --客户管辖权限信息表
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

  END ETL_O_IOL_ICMS_CUSTOMER_BELONG;
/

