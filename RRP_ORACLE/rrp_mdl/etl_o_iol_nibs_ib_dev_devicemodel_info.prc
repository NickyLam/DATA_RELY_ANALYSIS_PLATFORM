CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NIBS_IB_DEV_DEVICEMODEL_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NIBS_IB_DEV_DEVICEMODEL_INFO
  *  功能描述：设备型号表
  *  创建日期：20251126
  *  开发人员：于敬艺
  *  来源表： IOL.V_NIBS_IB_DEV_DEVICEMODEL_INFO
  *  目标表： O_IOL_NIBS_IB_DEV_DEVICEMODEL_INFO
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NIBS_IB_DEV_DEVICEMODEL_INFO'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NIBS_IB_DEV_DEVICEMODEL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-设备型号表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NIBS_IB_DEV_DEVICEMODEL_INFO NOLOGGING
    (      DEVICEMODEL              --设备型号
          ,DEVICETYPENUM            --设备类型
          ,DOYOUNEEDGETIN           --是否需领入 : 0-否 1-是 标志为是的则需要走激活流程
          ,DEVICEBRAND              --设备品牌
          ,SERVICEPROVNUM           --厂商编号
          ,DEVMODULELIST            --模块列表
          ,DEVDISBOXNUM             --废钞箱个数
          ,DEVBOXNUM                --钞箱个数
          ,MAINUSERNUM              --创建人
          ,MAINBRANCHNUM            --创建人所属机构
          ,STARTDATE                --创建日期
          ,STARTTIME                --创建时间
          ,MODIFYUSER               --最后修改人
          ,MODIFYUSERBRNO           --最后修改人所属机构
          ,MODIFDATE                --最后修改日期
          ,MODIFTIME                --最后修改时间
          ,DEFECTSLIABILITYPERIOD   --保修期(月)
          ,NOTE1                    --备注1
          ,NOTE2                    --备注2
          ,NOTE3                    --备注3
          ,NOTE4                    --备注4
          ,NOTE5                    --备注5
          ,DEVMODELID               --型号id
          ,DEVCARDBOX               --卡箱个数
          ,CREATOR                  --创建人
          ,CREATORBRNO              --创建人所属机构
          ,ETL_DT                   --数据日期
          ,ETL_TIMESTAMP            --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
           DEVICEMODEL              --设备型号
          ,DEVICETYPENUM            --设备类型
          ,DOYOUNEEDGETIN           --是否需领入 : 0-否 1-是 标志为是的则需要走激活流程
          ,DEVICEBRAND              --设备品牌
          ,SERVICEPROVNUM           --厂商编号
          ,DEVMODULELIST            --模块列表
          ,DEVDISBOXNUM             --废钞箱个数
          ,DEVBOXNUM                --钞箱个数
          ,MAINUSERNUM              --创建人
          ,MAINBRANCHNUM            --创建人所属机构
          ,STARTDATE                --创建日期
          ,STARTTIME                --创建时间
          ,MODIFYUSER               --最后修改人
          ,MODIFYUSERBRNO           --最后修改人所属机构
          ,MODIFDATE                --最后修改日期
          ,MODIFTIME                --最后修改时间
          ,DEFECTSLIABILITYPERIOD   --保修期(月)
          ,NOTE1                    --备注1
          ,NOTE2                    --备注2
          ,NOTE3                    --备注3
          ,NOTE4                    --备注4
          ,NOTE5                    --备注5
          ,DEVMODELID               --型号id
          ,DEVCARDBOX               --卡箱个数
          ,CREATOR                  --创建人
          ,CREATORBRNO              --创建人所属机构
          ,ETL_DT                   --数据日期
          ,ETL_TIMESTAMP            --ETL处理时间戳
    FROM IOL.V_NIBS_IB_DEV_DEVICEMODEL_INFO   --设备型号表
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');  

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

  END ETL_O_IOL_NIBS_IB_DEV_DEVICEMODEL_INFO;
/

