CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_CHN_EQUIP_INFO_H(I_P_DATE IN INTEGER,
                                                       O_ERRCODE OUT VARCHAR2
                                                       )
  /**************************************************************************
  *  程序名称：ETL_O_IML_CHN_EQUIP_INFO_H
  *  功能描述：设备信息历史
  *  创建日期：20240701
  *  开发人员：YUJINGYI
  *  来源表： IML.V_CHN_EQUIP_INFO_H
  *  目标表： O_IML_CHN_EQUIP_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240701  YJY     首次创建
  *             2    20251010  YJY     新增虚拟柜员编号、设备厂商名称
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_CHN_EQUIP_INFO_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_CHN_EQUIP_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_CHN_EQUIP_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-设备信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_CHN_EQUIP_INFO_H
    (EQUIP_ID                        --设备编号
    ,LP_ID                           --法人编号
    ,EQUIP_MODEL                     --设备型号
    ,EQUIP_TYPE_CD                   --设备类型代码
    ,EQUIP_STATUS_CD                 --设备状态代码
    ,EQUIP_USE_STATUS_CD             --设备使用状态代码
    ,IN_BANK_FLG                     --在行标志
    ,INSTALL_WAY_CD                  --安装方式代码
    ,INST_PHONE                      --安装联系电话
    ,EQUIP_ADDR                      --设备地址
    ,EQUIP_IP                        --设备IP
    ,MATN_START_DT                   --维保开始日期
    ,MATN_END_DT                     --维保结束日期
    ,EQUIP_BUY_DT                    --设备购买日期
    ,EQUIP_START_USE_DT              --设备启用日期
    ,EQUIP_STOP_DT                   --设备停止日期
    ,SELF_H_BANK_FLG                 --自助银行标志
    ,COMM_STATUS_FLG                 --通讯状态正常标志
    ,MOVE_STATUS_CD                  --运行状态代码
    ,CLEAN_CORP_ID                   --清机公司编号
    ,CLEAN_CORP_NAME                 --清机公司名称
    ,ATM_CLEAN_APPL_BIND_TELLER_ID   --ATM清机申请绑定柜员编号
    ,OUTSOURC_MGMT_FLG               --外包管理标志
    ,MIDGROD_INST_CODE               --中台装机码
    ,MIDGROD_SYNC_FLG                --中台同步标志
    ,BELONG_ORG_ID                   --所属机构编号
    ,FIR_CREATE_DT                   --首次创建日期
    ,FIR_CREATE_TELLER_ID            --首次创建柜员编号
    ,FIR_CREATOR_BELONG_ORG_ID       --首次创建人所属机构编号
    ,MATN_PS_BELONG_ORG_CD           --维护人所属机构代码
    ,FINAL_MODIF_DT                  --最后修改日期
    ,FINAL_MODIF_TELLER_ID           --最后修改柜员编号
    ,START_DT                        --开始日期
    ,END_DT                          --结束日期
    ,ID_MARK                         --删除标识
    ,SRC_TABLE_NAME                  --源表名称
    ,JOB_CD                          --任务代码
    ,ETL_TIMESTAMP                   --数据处理时间
    ,EQUIP_MANUF_NAME                --设备厂商名称  ADD BY YJY 20251010
    ,VTUAL_TELLER_ID                 --虚拟柜员编号  ADD BY YJY 20251010
    )
  SELECT EQUIP_ID                        --设备编号
        ,LP_ID                           --法人编号
        ,EQUIP_MODEL                     --设备型号
        ,EQUIP_TYPE_CD                   --设备类型代码
        ,EQUIP_STATUS_CD                 --设备状态代码
        ,EQUIP_USE_STATUS_CD             --设备使用状态代码
        ,IN_BANK_FLG                     --在行标志
        ,INSTALL_WAY_CD                  --安装方式代码
        ,INST_PHONE                      --安装联系电话
        ,EQUIP_ADDR                      --设备地址
        ,EQUIP_IP                        --设备IP
        ,MATN_START_DT                   --维保开始日期
        ,MATN_END_DT                     --维保结束日期
        ,EQUIP_BUY_DT                    --设备购买日期
        ,EQUIP_START_USE_DT              --设备启用日期
        ,EQUIP_STOP_DT                   --设备停止日期
        ,SELF_H_BANK_FLG                 --自助银行标志
        ,COMM_STATUS_FLG                 --通讯状态正常标志
        ,MOVE_STATUS_CD                  --运行状态代码
        ,CLEAN_CORP_ID                   --清机公司编号
        ,CLEAN_CORP_NAME                 --清机公司名称
        ,ATM_CLEAN_APPL_BIND_TELLER_ID   --ATM清机申请绑定柜员编号
        ,OUTSOURC_MGMT_FLG               --外包管理标志
        ,MIDGROD_INST_CODE               --中台装机码
        ,MIDGROD_SYNC_FLG                --中台同步标志
        ,BELONG_ORG_ID                   --所属机构编号
        ,FIR_CREATE_DT                   --首次创建日期
        ,FIR_CREATE_TELLER_ID            --首次创建柜员编号
        ,FIR_CREATOR_BELONG_ORG_ID       --首次创建人所属机构编号
        ,MATN_PS_BELONG_ORG_CD           --维护人所属机构代码
        ,FINAL_MODIF_DT                  --最后修改日期
        ,FINAL_MODIF_TELLER_ID           --最后修改柜员编号
        ,START_DT                        --开始日期
        ,END_DT                          --结束日期
        ,ID_MARK                         --删除标识
        ,SRC_TABLE_NAME                  --源表名称
        ,JOB_CD                          --任务代码
        ,ETL_TIMESTAMP                   --数据处理时间
        ,EQUIP_MANUF_NAME                --设备厂商名称  ADD BY YJY 20251010
        ,VTUAL_TELLER_ID                 --虚拟柜员编号  ADD BY YJY 20251010
    FROM IML.V_CHN_EQUIP_INFO_H  --视图-设备信息历史
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
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);

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

END ETL_O_IML_CHN_EQUIP_INFO_H;
/

