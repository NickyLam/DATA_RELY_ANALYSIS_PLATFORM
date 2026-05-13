CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_INTELLGE_BRAC_BUS_FLOW (I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 智能网点业务流水表
  **存储过程名称：    ETL_INIT_O_IML_EVT_INTELLGE_BRAC_BUS_FLOW
  **存储过程创建日期：20221130
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
 AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_INTELLGE_BRAC_BUS_FLOW'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_DATE DATE;
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  V_MONTH_START_DATE:=TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');


  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE    := TO_DATE(I_P_DATE,'YYYY-MM-DD');

  --清理当天数据
  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IML_EVT_INTELLGE_BRAC_BUS_FLOW';

 INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_INTELLGE_BRAC_BUS_FLOW NOLOGGING
    (
          EVT_ID  --事件编号
          ,BUS_FLOW_NUM  --业务流水号
          ,LP_ID  --法人编号
          ,CHN_DT  --渠道日期
          ,OVA_FLOW_NUM  --全局流水号
          ,UPS_FLOW_NUM  --上游流水号
          ,SYS_FLOW_NUM  --系统流水号
          ,SERV_FLOW_NUM  --服务流水号
          ,PLAT_FLOW_NUM  --平台流水号
          ,CHN_ID  --渠道编号
          ,CHN_TM  --渠道时间
          ,CHN_IP_ADDR  --渠道IP地址
          ,CHN_TRAN_CODE  --渠道交易编码
          ,CHN_TRAN_NAME  --渠道交易名称
          ,TRAN_TYPE_CD  --交易类型代码
          ,TRAN_ORG_ID  --交易机构编号
          ,TRAN_ORG_NAME  --交易机构名称
          ,HIGH_LOW_TELLER_FLG  --高低柜标志
          ,TRAN_TELLER_ID  --交易柜员编号
          ,TRAN_TELLER_NAME  --交易柜员姓名
          ,AUTH_TELLER_ID  --授权柜员编号
          ,AUTH_TELLER_NAME  --授权柜员姓名
          ,AUTH_FLOW_NUM  --授权流水号
          ,AUTH_MODE_CD  --授权模式代码
          ,LONG_FLOW_TRAN_FLG  --长流程交易标志
					,CUST_TYPE  --客户类型代码
					,CUST_ID  --客户编号
					,CUST_NAME  --客户名称
					,CERT_TYPE_CD  --证件类型代码
					,CERT_NO  --证件号码
					,ACCT_ID  --账户编号
					,ACCT_NUM_NAME  --账号名称
					,TRAN_CURR_CD  --交易币种代码
					,TRAN_AMT  --交易金额
					,DEBIT_CRDT_FLG  --借贷标志
					,CASH_TRANS_FLG  --现转标志
					,CUST_NETW_VRFCTION_REST_CD  --客户联网核查结果代码
					,FACE_RECN_REST_CD  --人脸识别结果代码
					,FACE_RECN_SCORE  --人脸识别分数
					,CNTPTY_CATE_CD  --交易对手类别代码
					,CNTPTY_ID  --交易对手编号
					,CNTPTY_CUST_ACCT_NUM  --交易对手客户账号
					,CNTPTY_NAME  --交易对手名称
					,AGENT_FLG  --代理标志
					,AGENT_NAME  --代办人名称
					,AGENT_CERT_TYPE_CD  --代办人证件类型代码
					,AGENT_CERT_NO  --代办人证件号码
					,AGENT_CONT_NUM  --代办人联系号码
					,AGENT_NATION_CD  --代办人国籍代码
					,AGENT_GENDER_CD  --代办人性别代码
					,AGENT_CAREER_CD  --代办人职业代码
					,AGENT_LICEN_ISSUE_AUTHO_ADDR  --代办人发证机关地址
					,AGENT_CONT_ADDR  --代办人联系地址
					,AGENT_CERT_START_DT  --代办人证件开始日期
					,AGENT_CERT_EXP_DT  --交易代办人证件到期日期
					,AGENT_NETW_VRFCTION_REST_CD  --代办人联网核查结果代码
					,AGENT_FACE_RECN_REST_CD  --代办人人脸识别结果代码
					,AGENT_FACE_RECN_SCORE  --代办人人脸识别分数
					,AGENT_RS_DESCB  --代办原因描述
					,VOUCH_MATRL_QTTY  --凭证资料数量
					,BLEND_WAY_CD  --勾兑方式代码
					,BLEND_STATUS_CD  --勾兑状态代码
					,TRAN_STATUS_CD  --交易状态代码
					,TRAN_DT  --交易日期
					,TRAN_TM  --交易时间
					,HIGH_RISK_FLG  --高风险标志
					,DESCB  --描述
					,MANUAL_BLEND_FLG  --手工勾兑标志
					,BUS_APV_FLOW_NUM  --业务审批流水号
					,SPCS_TURN_LOC_FLG  --后援中心转本地标志
					,RELA_BUS_FLOW_NUM  --关联业务流水号
					,BRCH_INIT_APPL_LOC_FLG  --分行主动申请本地标志
					,SPCS_APPL_FLG  --后援申请撤退标志
					,BLIP_SCENE_CODE  --影像场景码
					,BLIP_ID  --影像编号
					,APP_NUM  --应用编号
					,ETL_DT  --ETL处理日期
					--,SRC_TABLE_NAME  --源表名称
					--,JOB_CD  --任务编码
					--,ETL_TIMESTAMP  --ETL处理时间戳
    )
     SELECT /*+PARALLEL*/
					EVT_ID  --事件编号
					,BUS_FLOW_NUM  --业务流水号
					,LP_ID  --法人编号
					,CHN_DT  --渠道日期
					,OVA_FLOW_NUM  --全局流水号
					,UPS_FLOW_NUM  --上游流水号
					,SYS_FLOW_NUM  --系统流水号
					,SERV_FLOW_NUM  --服务流水号
					,PLAT_FLOW_NUM  --平台流水号
					,CHN_ID  --渠道编号
					,CHN_TM  --渠道时间
					,CHN_IP_ADDR  --渠道IP地址
					,CHN_TRAN_CODE  --渠道交易编码
					,CHN_TRAN_NAME  --渠道交易名称
					,TRAN_TYPE_CD  --交易类型代码
					,TRAN_ORG_ID  --交易机构编号
					,TRAN_ORG_NAME  --交易机构名称
					,HIGH_LOW_TELLER_FLG  --高低柜标志
					,TRAN_TELLER_ID  --交易柜员编号
					,TRAN_TELLER_NAME  --交易柜员姓名
					,AUTH_TELLER_ID  --授权柜员编号
					,AUTH_TELLER_NAME  --授权柜员姓名
					,AUTH_FLOW_NUM  --授权流水号
					,AUTH_MODE_CD  --授权模式代码
					,LONG_FLOW_TRAN_FLG  --长流程交易标志
					,CUST_TYPE  --客户类型代码
					,CUST_ID  --客户编号
					,CUST_NAME  --客户名称
					,CERT_TYPE_CD  --证件类型代码
					,CERT_NO  --证件号码
					,ACCT_ID  --账户编号
					,ACCT_NUM_NAME  --账号名称
					,TRAN_CURR_CD  --交易币种代码
					,TRAN_AMT  --交易金额
					,DEBIT_CRDT_FLG  --借贷标志
					,CASH_TRANS_FLG  --现转标志
					,CUST_NETW_VRFCTION_REST_CD  --客户联网核查结果代码
					,FACE_RECN_REST_CD  --人脸识别结果代码
					,FACE_RECN_SCORE  --人脸识别分数
					,CNTPTY_CATE_CD  --交易对手类别代码
					,CNTPTY_ID  --交易对手编号
					,CNTPTY_CUST_ACCT_NUM  --交易对手客户账号
					,CNTPTY_NAME  --交易对手名称
					,AGENT_FLG  --代理标志
					,AGENT_NAME  --代办人名称
					,AGENT_CERT_TYPE_CD  --代办人证件类型代码
					,AGENT_CERT_NO  --代办人证件号码
					,AGENT_CONT_NUM  --代办人联系号码
					,AGENT_NATION_CD  --代办人国籍代码
					,AGENT_GENDER_CD  --代办人性别代码
					,AGENT_CAREER_CD  --代办人职业代码
					,AGENT_LICEN_ISSUE_AUTHO_ADDR  --代办人发证机关地址
					,AGENT_CONT_ADDR  --代办人联系地址
					,AGENT_CERT_START_DT  --代办人证件开始日期
					,AGENT_CERT_EXP_DT  --交易代办人证件到期日期
					,AGENT_NETW_VRFCTION_REST_CD  --代办人联网核查结果代码
					,AGENT_FACE_RECN_REST_CD  --代办人人脸识别结果代码
					,AGENT_FACE_RECN_SCORE  --代办人人脸识别分数
					,AGENT_RS_DESCB  --代办原因描述
					,VOUCH_MATRL_QTTY  --凭证资料数量
					,BLEND_WAY_CD  --勾兑方式代码
					,BLEND_STATUS_CD  --勾兑状态代码
					,TRAN_STATUS_CD  --交易状态代码
					,TRAN_DT  --交易日期
					,TRAN_TM  --交易时间
					,HIGH_RISK_FLG  --高风险标志
					,DESCB  --描述
					,MANUAL_BLEND_FLG  --手工勾兑标志
					,BUS_APV_FLOW_NUM  --业务审批流水号
					,SPCS_TURN_LOC_FLG  --后援中心转本地标志
					,RELA_BUS_FLOW_NUM  --关联业务流水号
					,BRCH_INIT_APPL_LOC_FLG  --分行主动申请本地标志
					,SPCS_APPL_FLG  --后援申请撤退标志
					,BLIP_SCENE_CODE  --影像场景码
					,BLIP_ID  --影像编号
					,APP_NUM  --应用编号
					,ETL_DT  --ETL处理日期
					--,SRC_TABLE_NAME  --源表名称
					--,JOB_CD  --任务编码
					--,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_EVT_INTELLGE_BRAC_BUS_FLOW   --智能网点业务流水表视图


   ;
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


END ETL_INIT_O_IML_EVT_INTELLGE_BRAC_BUS_FLOW;
/

