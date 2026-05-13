CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_OS_INVEST_FINC_BUS_FLOW(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_OS_INVEST_FINC_BUS_FLOW
  *  功能描述：外服投资理财业务流水
  *  创建日期：20221227
  *  开发人员：梅炜
  *  来源表： IML.V_EVT_OS_INVEST_FINC_BUS_FLOW
  *  目标表： O_IML_EVT_OS_INVEST_FINC_BUS_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221227  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_OS_INVEST_FINC_BUS_FLOW'; -- 程序名称
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
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_OS_INVEST_FINC_BUS_FLOW ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_OS_INVEST_FINC_BUS_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-外服投资理财业务流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_OS_INVEST_FINC_BUS_FLOW
  (
            EVT_ID  --事件编号
            ,LP_ID  --法人编号
            ,FLOW_NUM  --流水号
            ,TRAN_DT  --交易日期
            ,TRAN_TM  --交易时间
            ,TRAN_CODE  --交易码
            ,TRAN_STATUS_CD  --交易状态代码
            ,TRAN_RETURN_CODE  --交易返回码
            ,FAIL_RS  --失败原因
            ,TRAN_ACCT_NUM  --交易账号
            ,TRAN_AMT  --交易金额
            ,CURR_CD  --币种代码
            ,WHOLE_UNIFY_CUST_ID  --全行统一客户编号
            ,USER_SEQ_ID  --用户顺序编号
            ,TRAN_CHN_CD  --渠道系统代码
            ,CHN_SEND_FLOW_NUM  --渠道发送流水号
            ,SORC_SYS_FLOW_NUM  --源系统流水号
            ,CORE_TRAN_FLOW_NUM  --核心交易流水号
            ,COMM_FEE  --手续费
            ,VISIT_FLOW_NUM  --访问流水号
            ,CORE_TRAN_DT  --核心交易日期
            ,CUST_IP_NUM  --客户IP号
            ,CURR_SERVER_HOST_NAME  --当前服务器主机名
            ,CUST_TERMN_MAC_ADDR  --客户终端MAC地址
            ,CUST_TERMN_OPER_SYS_EDIT_NUM  --客户终端操作系统版本号
            ,CUST_TERMN_BROW  --客户终端浏览器
            ,CUST_TERMN_EQUIP_MODEL  --客户终端设备型号
            ,CUST_TERMN_EQUIP_ID  --客户终端设备编号
            ,LOGON_SESSION_ID  --登陆SESSION编号
            ,RELA_FLOW_NUM  --关联流水号
            ,TRAN_JNL_INFO  --交易日志信息
            ,TRAN_TYPE_CODE  --交易类型码
            ,CUST_NAME  --客户名称
            ,SAVE_CERT_WAY_CD  --安全认证方式代码
            ,CAMP_JOB_NO  --营销工号
            ,PBC_FLOW_NUM  --人行流水号
            ,TRAN_ORDER_NO  --交易订单号
            ,CHAIN_WAY_TRACK_NO  --链路跟踪号
            ,SYS_FLOW_NUM  --系统流水号
            ,CHN_ID  --渠道编号
            ,ETL_DT  --ETL处理日期
            ,SRC_TABLE_NAME  --源表名称
            ,JOB_CD  --任务编码
            ,ETL_TIMESTAMP  --ETL处理时间戳


    )
    SELECT
            EVT_ID  --事件编号
            ,LP_ID  --法人编号
            ,FLOW_NUM  --流水号
            ,TRAN_DT  --交易日期
            ,TRAN_TM  --交易时间
            ,TRAN_CODE  --交易码
            ,TRAN_STATUS_CD  --交易状态代码
            ,TRAN_RETURN_CODE  --交易返回码
            ,FAIL_RS  --失败原因
            ,TRAN_ACCT_NUM  --交易账号
            ,TRAN_AMT  --交易金额
            ,CURR_CD  --币种代码
            ,WHOLE_UNIFY_CUST_ID  --全行统一客户编号
            ,USER_SEQ_ID  --用户顺序编号
            ,TRAN_CHN_CD  --渠道系统代码
            ,CHN_SEND_FLOW_NUM  --渠道发送流水号
            ,SORC_SYS_FLOW_NUM  --源系统流水号
            ,CORE_TRAN_FLOW_NUM  --核心交易流水号
            ,COMM_FEE  --手续费
            ,VISIT_FLOW_NUM  --访问流水号
            ,CORE_TRAN_DT  --核心交易日期
            ,CUST_IP_NUM  --客户IP号
            ,CURR_SERVER_HOST_NAME  --当前服务器主机名
            ,CUST_TERMN_MAC_ADDR  --客户终端MAC地址
            ,CUST_TERMN_OPER_SYS_EDIT_NUM  --客户终端操作系统版本号
            ,CUST_TERMN_BROW  --客户终端浏览器
            ,CUST_TERMN_EQUIP_MODEL  --客户终端设备型号
            ,CUST_TERMN_EQUIP_ID  --客户终端设备编号
            ,LOGON_SESSION_ID  --登陆SESSION编号
            ,RELA_FLOW_NUM  --关联流水号
            ,TRAN_JNL_INFO  --交易日志信息
            ,TRAN_TYPE_CODE  --交易类型码
            ,CUST_NAME  --客户名称
            ,SAVE_CERT_WAY_CD  --安全认证方式代码
            ,CAMP_JOB_NO  --营销工号
            ,PBC_FLOW_NUM  --人行流水号
            ,TRAN_ORDER_NO  --交易订单号
            ,CHAIN_WAY_TRACK_NO  --链路跟踪号
            ,SYS_FLOW_NUM  --系统流水号
            ,CHN_ID  --渠道编号
            ,ETL_DT  --ETL处理日期
            ,SRC_TABLE_NAME  --源表名称
            ,JOB_CD  --任务编码
            ,ETL_TIMESTAMP  --ETL处理时间戳

    FROM IML.V_EVT_OS_INVEST_FINC_BUS_FLOW  --视图-外服投资理财业务流水

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

  END ETL_INIT_O_IML_EVT_OS_INVEST_FINC_BUS_FLOW;
/

