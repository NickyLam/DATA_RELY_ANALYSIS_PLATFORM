CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_SELF_EQUIP_INFO(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_SELF_EQUIP_INFO
  *  功能描述：自助设备信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_SELF_EQUIP_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250902  YJY      新增自助设备型号描述、设备供应商名称、设备维护商名称、设备启用日期、设备停用日期
  *             3    20251114  YJY      新增终端编号
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_SELF_EQUIP_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_SELF_EQUIP_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_SELF_EQUIP_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-自助设备信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_SELF_EQUIP_INFO
    (ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,EQUIP_ID                   --设备编号
    ,EQUIP_IP_ADDR_ID           --设备IP地址编号
    ,BELONG_ORG_ID              --所属机构编号
    ,IN_BANK_FLG                --在行标志
    ,SELF_EQUIP_MODEL           --自助设备型号
    ,SELF_EQUIP_TYPE_CD         --自助设备类型代码
    ,EQUIP_TYPE_NAME            --设备类型名称
    ,EQUIP_TYPE_NAME_CN_DESCB   --设备类型名称中文描述
    ,EQUIP_STATUS_CD            --设备状态代码
    ,EQUIP_MATNCE_ID            --设备维护商编号
    ,EQUIP_INSTALL_DT           --设备安装日期
    ,CASH_FLG                   --现金标志
    ,INSTALL_WAY_CD             --安装方式代码
    ,DIST_CD                    --行政区划代码
    ,CHN_ID                     --渠道编号
    ,EQUIP_INSTALL_ADDR         --设备安装地址
    ,EQUIP_KIND_NAME            --设备种类名称
    ,JOB_CD                     --任务代码
    ,SELF_EQUIP_MODEL_DESCB     --自助设备型号描述  ADD BY YJY 20250902
    ,EQUIP_PROVI_NAME           --设备供应商名称    ADD BY YJY 20250902
    ,EQUIP_MATNCE_NAME          --设备维护商名称    ADD BY YJY 20250902
    ,EQUIP_START_USE_DT         --设备启用日期      ADD BY YJY 20250902
    ,EQUIP_STOP_USE_DT          --设备停用日期      ADD BY YJY 20250902
    ,TERMN_ID                   --终端编号   ADD BY YJY 20251114
    )
  SELECT 
     ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,EQUIP_ID                   --设备编号
    ,EQUIP_IP_ADDR_ID           --设备IP地址编号
    ,BELONG_ORG_ID              --所属机构编号
    ,IN_BANK_FLG                --在行标志
    ,SELF_EQUIP_MODEL           --自助设备型号
    ,SELF_EQUIP_TYPE_CD         --自助设备类型代码
    ,EQUIP_TYPE_NAME            --设备类型名称
    ,EQUIP_TYPE_NAME_CN_DESCB   --设备类型名称中文描述
    ,EQUIP_STATUS_CD            --设备状态代码
    ,EQUIP_MATNCE_ID            --设备维护商编号
    ,EQUIP_INSTALL_DT           --设备安装日期
    ,CASH_FLG                   --现金标志
    ,INSTALL_WAY_CD             --安装方式代码
    ,DIST_CD                    --行政区划代码
    ,CHN_ID                     --渠道编号
    ,EQUIP_INSTALL_ADDR         --设备安装地址
    ,EQUIP_KIND_NAME            --设备种类名称
    ,JOB_CD                     --任务代码
    ,SELF_EQUIP_MODEL_DESCB     --自助设备型号描述  ADD BY YJY 20250902
    ,EQUIP_PROVI_NAME           --设备供应商名称    ADD BY YJY 20250902
    ,EQUIP_MATNCE_NAME          --设备维护商名称    ADD BY YJY 20250902
    ,EQUIP_START_USE_DT         --设备启用日期      ADD BY YJY 20250902
    ,EQUIP_STOP_USE_DT          --设备停用日期      ADD BY YJY 20250902
    ,TERMN_ID                   --终端编号   ADD BY YJY 20251114
    FROM ICL.V_CMM_SELF_EQUIP_INFO  --视图-自助设备信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_ICL_CMM_SELF_EQUIP_INFO;
/

