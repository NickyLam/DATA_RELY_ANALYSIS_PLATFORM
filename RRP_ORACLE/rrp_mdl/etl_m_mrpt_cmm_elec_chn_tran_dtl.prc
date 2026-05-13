CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_CMM_ELEC_CHN_TRAN_DTL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_CMM_ELEC_CHN_TRAN_DTL
  *  功能描述：电子渠道交易明细
  *  创建日期：20221212
  *  开发人员：阳娟
  *  来源表： RRP_DML.O_ICL_CMM_ELEC_CHN_TRAN_DTL
  *  目标表： M_MRPT_CMM_ELEC_CHN_TRAN_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221212  阳娟     首次创建
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_CMM_ELEC_CHN_TRAN_DTL'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  D_STARTTIME DATE; -- 处理开始时间
  --D_ENDTIME DATE;   -- 处理结束时间
  I_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_SQL       VARCHAR2(2000); -- 动态sql
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PART_NAME VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME  VARCHAR2(100);  --表名称

BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_CMM_ELEC_CHN_TRAN_DTL'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_CMM_ELEC_CHN_TRAN_DTL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;

  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  --ETL_PARTITION_DROP(V_P_DATE,V_TAB_NAME,O_ERRCODE);--分区表的重跑处理
  END IF ;*/
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  --D_ENDTIME := SYSDATE;

  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_STARTTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-电子渠道交易明细';
  D_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_MRPT_CMM_ELEC_CHN_TRAN_DTL
  (    DATA_DT  --数据日期
      ,LP_ID  --法人编号
      ,TRAN_FLOW_NUM  --交易流水号
      ,OVA_CHN_FLOW_NUM  --全局渠道流水号
      ,CORE_TRAN_FLOW_NUM  --核心交易流水号
      ,SORC_SYS_FLOW_NUM  --源系统流水号
      ,OSB_TRAN_FLOW_NUM  --OSB交易流水号
      ,RELA_TIMING_TASK_ID  --关联定时任务编号
      ,CHN_CD  --渠道代码
      ,TRAN_DT  --交易日期
      ,TRAN_TM  --交易时间
      ,CORE_TRAN_DT  --核心交易日期
      ,TRAN_TYPE_CODE  --交易类型编码
      ,TRAN_STATUS_CD  --交易状态代码
      ,TRAN_RETURN_CODE  --交易返回码
      ,TRAN_ACCT_ID  --交易账户编号
      ,TRAN_ACCT_NAME  --交易账户名称
      ,TRAN_AMT  --交易金额
      ,CURR_CD  --币种代码
      ,ELEC_CHN_USER_ID  --电子渠道用户编号
      ,CUST_ID  --客户编号
      ,TERMN_IP_ADDR  --终端IP地址
      ,TRAN_COMM_FEE  --交易手续费
      ,TERMN_MAC_ADDR  --终端MAC地址
      ,TERMN_EQUIP_MODEL  --终端设备型号
      ,TERMN_EQUIP_ID  --终端设备编号
      ,CNTPTY_ACCT_ID  --交易对手账户编号
      ,CNTPTY_ACCT_NAME  --交易对手账户名称
      ,CNTPTY_ACCT_OPEN_BANK_NUM  --交易对手账户开户行号
      ,CNTPTY_ACCT_OPEN_BANK_NAME  --交易对手账户开户行名
      ,CNTPTY_ACCT_PROV_CD  --交易对手账户省份代码
      ,CNTPTY_ACCT_CITY_CD  --交易对手账户城市代码
      ,MEMO_CD  --摘要代码
      ,MEMO_DESCB  --摘要描述
      ,TRAN_BATCH_NO  --交易批次号
      ,TRAN_ORG_ID  --交易机构编号
      ,CAMP_EMPLY_ID  --营销员工编号
      ,OLBK_TRAN_SRC_CD  --网银交易来源代码
    ,JOB_CD --任务代码
    )
    SELECT

      TO_CHAR(ETL_DT,'YYYYMMDD')  --数据日期
      ,LP_ID  --法人编号
      ,TRAN_FLOW_NUM  --交易流水号
      ,OVA_CHN_FLOW_NUM  --全局渠道流水号
      ,CORE_TRAN_FLOW_NUM  --核心交易流水号
      ,SORC_SYS_FLOW_NUM  --源系统流水号
      ,OSB_TRAN_FLOW_NUM  --OSB交易流水号
      ,RELA_TIMING_TASK_ID  --关联定时任务编号
      ,CHN_CD  --渠道代码
      ,TRAN_DT  --交易日期
      ,TRAN_TM  --交易时间
      ,CORE_TRAN_DT  --核心交易日期
      ,TRAN_TYPE_CODE  --交易类型编码
      ,TRAN_STATUS_CD  --交易状态代码
      ,TRAN_RETURN_CODE  --交易返回码
      ,TRAN_ACCT_ID  --交易账户编号
      ,TRAN_ACCT_NAME  --交易账户名称
      ,TRAN_AMT  --交易金额
      ,CURR_CD  --币种代码
      ,ELEC_CHN_USER_ID  --电子渠道用户编号
      ,CUST_ID  --客户编号
      ,TERMN_IP_ADDR  --终端IP地址
      ,TRAN_COMM_FEE  --交易手续费
      ,TERMN_MAC_ADDR  --终端MAC地址
      ,TERMN_EQUIP_MODEL  --终端设备型号
      ,TERMN_EQUIP_ID  --终端设备编号
      ,CNTPTY_ACCT_ID  --交易对手账户编号
      ,CNTPTY_ACCT_NAME  --交易对手账户名称
      ,CNTPTY_ACCT_OPEN_BANK_NUM  --交易对手账户开户行号
      ,CNTPTY_ACCT_OPEN_BANK_NAME  --交易对手账户开户行名
      ,CNTPTY_ACCT_PROV_CD  --交易对手账户省份代码
      ,CNTPTY_ACCT_CITY_CD  --交易对手账户城市代码
      ,MEMO_CD  --摘要代码
      ,MEMO_DESCB  --摘要描述
      ,TRAN_BATCH_NO  --交易批次号
      ,TRAN_ORG_ID  --交易机构编号
      ,CAMP_EMPLY_ID  --营销员工编号
      ,OLBK_TRAN_SRC_CD  --网银交易来源代码
    ,JOB_CD --任务代码
    FROM RRP_MDL.O_ICL_CMM_ELEC_CHN_TRAN_DTL  --视图-电子渠道交易明细
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   I_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   D_STARTTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_STARTTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_STARTTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     D_STARTTIME := SYSDATE;
 /* I_STEP := I_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';*/
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_STARTTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_M_MRPT_CMM_ELEC_CHN_TRAN_DTL;
/

