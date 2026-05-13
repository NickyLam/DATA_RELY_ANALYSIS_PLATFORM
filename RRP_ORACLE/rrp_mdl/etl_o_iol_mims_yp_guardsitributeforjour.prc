CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_MIMS_YP_GUARDSITRIBUTEFORJOUR (I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 按业务规则分配G13结果表
  **存储过程名称：    ETL_O_IOL_MIMS_YP_GUARDSITRIBUTEFORJOUR
  **存储过程创建日期：20221128
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
     20241010    于敬艺     新增分配等级 1:一级分配 2:二级分配、业务品种名称字段
  *  20241231    YJY        优化脚本
  *  20251020    YJY        作业下线
  ******************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_MIMS_YP_GUARDSITRIBUTEFORJOUR'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  BEGIN
  
  /*  --MOD BY YJY 20251020
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_MIMS_YP_GUARDSITRIBUTEFORJOUR';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-按业务规则分配G13结果表';
  V_STARTTIME := SYSDATE;
  INSERT  INTO RRP_MDL.O_IOL_MIMS_YP_GUARDSITRIBUTEFORJOUR NOLOGGING
    (
      SCCODE               --押品编号
     ,CONTRACTNO           --合同号
     ,BALANCE              --合同余额
     ,DISTVALUE            --贷款分配价值
     ,CONTGUARTYPE         --合同主担保方式
     ,GUARTYPE             --押品类型
     ,CREDITTYPE           --业务品种
     ,BARSIGN              --条线
     ,INTERINDUSTRY        --行业
     ,CUSTSCALE            --规模
     ,REPORTTYPE           --表内表外标识
     ,DEPTCODE             --所属机构
     ,FIVECLASS            --五级分类
     ,CREDNO               --借据号
     ,BAL                  --借据余额
     ,CONFMAMT             --分配我行确认价值
     ,FIRSTCONFMAMT        --分配初评我行确认价值
     ,DATECODE
     ,START_DT             --开始时间
     ,END_DT               --结束时间
     ,ID_MARK              --增删标志
     ,CREDLEVEL            --分配等级 1:一级分配 2:二级分配  ADD BY YJY 20241010
     ,CREDITNAME           --业务品种名称  ADD BY YJY 20241010
    )
  SELECT 
      SCCODE               --押品编号
     ,CONTRACTNO           --合同号
     ,BALANCE              --合同余额
     ,DISTVALUE            --贷款分配价值
     ,CONTGUARTYPE         --合同主担保方式
     ,GUARTYPE             --押品类型
     ,CREDITTYPE           --业务品种
     ,BARSIGN              --条线
     ,INTERINDUSTRY        --行业
     ,CUSTSCALE            --规模
     ,REPORTTYPE           --表内表外标识
     ,DEPTCODE             --所属机构
     ,FIVECLASS            --五级分类
     ,CREDNO               --借据号
     ,BAL                  --借据余额
     ,CONFMAMT             --分配我行确认价值
     ,FIRSTCONFMAMT        --分配初评我行确认价值
     ,DATECODE
     ,START_DT             --开始时间
     ,END_DT               --结束时间
     ,ID_MARK              --增删标志
     ,CREDLEVEL            --分配等级 1:一级分配 2:二级分配  ADD BY YJY 20241010
     ,CREDITNAME           --业务品种名称  ADD BY YJY 20241010
    FROM IOL.V_MIMS_YP_GUARDSITRIBUTEFORJOUR   --按业务规则分配G13结果表_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D'
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


   */
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


END ETL_O_IOL_MIMS_YP_GUARDSITRIBUTEFORJOUR;
/

