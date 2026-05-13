CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_BANK_PC_EDIT_TRAN_FLOW(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                 )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_BANK_PC_EDIT_TRAN_FLOW
  *  功能描述：银行PC版交易流水
  *  创建日期：20221210
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_EVT_BANK_PC_EDIT_TRAN_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221210  梅炜     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_BANK_PC_EDIT_TRAN_FLOW'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_EVT_BANK_PC_EDIT_TRAN_FLOW T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_BANK_PC_EDIT_TRAN_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-银行PC版交易流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_BANK_PC_EDIT_TRAN_FLOW
    (EVT_ID                             --事件编号
    ,LP_ID                              --法人编号
    ,FLOW_NUM                           --流水号
    ,TRAN_TM                            --交易时间
    ,TRAN_DT                            --交易日期
    ,TRAN_CODE                          --交易码
    ,TRAN_ORDER                         --交易命令
    ,UNIFY_CUST_ID                      --统一客户编号
    ,USER_SEQ_NUM                       --用户顺序号
    ,TRAN_CHN_CD                        --交易渠道代码
    ,CUST_NAME                          --客户姓名
    ,MENU_ID                            --菜单ID
    ,TRAN_STATUS_CD                     --交易状态代码
    ,TRAN_RETURN_CODE                   --交易返回编码
    ,FAIL_RS_DESCB                      --失败原因描述
    ,TRAN_ACCT_NUM                      --交易账号
    ,TRAN_AMT                           --交易金额
    ,CURR_CD                            --币种代码
    ,CHN_SEND_FLOW_ID                   --渠道发送流水编号
    ,SORC_SYS_FLOW_ID                   --源系统流水编号
    ,CORE_TRAN_FLOW_ID                  --核心交易流水编号
    ,COMM_FEE                           --手续费
    ,PARENT_FLOW_ID                     --父流水编号
    ,SRC_FLOW_SEQ_ID                    --来源流水顺序编号
    ,AUTH_REFUSE_RS                     --授权拒绝原因
    ,VISIT_FLOW_ID                      --访问流水编号
    ,CORE_TRAN_DT                       --核心交易日期
    ,CALLOUT_TRAN_CODE                  --被调方交易码
    ,CUST_IP                            --客户IP
    ,CURR_SERVER_HOST_NAME              --当前服务器主机名称
    ,REQ_SRC_SERVER_IP                  --请求来源服务器IP
    ,CUST_TERMN_MAC_ADDR                --客户终端MAC地址
    ,CUST_TERMN_OPER_SYS                --客户终端操作系统
    ,CUST_TERMN_BROW                    --客户终端浏览器
    ,CUST_TERMN_EQUIP_MODEL             --客户终端设备型号
    ,CUST_TERMN_EQUIP_ID                --客户终端设备ID
    ,SESSION_ID                         --会话ID
    ,RELA_FLOW_ID                       --关联流水编号
    ,SAVE_CERT_WAY_CD                   --安全认证方式代码
    ,AUTH_STATUS_CD                     --授权状态代码
    ,BANK_AGENT_FLG                     --银行代办标志
    ,AUTH_ROLE_SEQ_NUM                  --授权角色序号
    ,SUBMIT_CORE_DT                     --提交核心日期
    ,SUBMIT_CORE_TM                     --提交核心时间
    ,TRAN_TOT_QTTY                      --交易总数量
    ,REMARK                             --备注
    ,BUS_FLOW_NUM                       --业务流水号
    ,CHAIN_WAY_TRACK_NO                 --链路跟踪号
    ,UPS_FLOW_NUM                       --上游流水号
    ,ETL_DT                             --ETL处理日期
    ,SRC_TABLE_NAME                     --源表名称
    ,JOB_CD                             --任务编码
    ,ETL_TIMESTAMP                      --ETL处理时间戳
    )
  SELECT 
     EVT_ID                             --事件编号
    ,LP_ID                              --法人编号
    ,FLOW_NUM                           --流水号
    ,TRAN_TM                            --交易时间
    ,TRAN_DT                            --交易日期
    ,TRAN_CODE                          --交易码
    ,TRAN_ORDER                         --交易命令
    ,UNIFY_CUST_ID                      --统一客户编号
    ,USER_SEQ_NUM                       --用户顺序号
    ,TRAN_CHN_CD                        --交易渠道代码
    ,CUST_NAME                          --客户姓名
    ,MENU_ID                            --菜单ID
    ,TRAN_STATUS_CD                     --交易状态代码
    ,TRAN_RETURN_CODE                   --交易返回编码
    ,FAIL_RS_DESCB                      --失败原因描述
    ,TRAN_ACCT_NUM                      --交易账号
    ,TRAN_AMT                           --交易金额
    ,CURR_CD                            --币种代码
    ,CHN_SEND_FLOW_ID                   --渠道发送流水编号
    ,SORC_SYS_FLOW_ID                   --源系统流水编号
    ,CORE_TRAN_FLOW_ID                  --核心交易流水编号
    ,COMM_FEE                           --手续费
    ,PARENT_FLOW_ID                     --父流水编号
    ,SRC_FLOW_SEQ_ID                    --来源流水顺序编号
    ,AUTH_REFUSE_RS                     --授权拒绝原因
    ,VISIT_FLOW_ID                      --访问流水编号
    ,CORE_TRAN_DT                       --核心交易日期
    ,CALLOUT_TRAN_CODE                  --被调方交易码
    ,CUST_IP                            --客户IP
    ,CURR_SERVER_HOST_NAME              --当前服务器主机名称
    ,REQ_SRC_SERVER_IP                  --请求来源服务器IP
    ,CUST_TERMN_MAC_ADDR                --客户终端MAC地址
    ,CUST_TERMN_OPER_SYS                --客户终端操作系统
    ,CUST_TERMN_BROW                    --客户终端浏览器
    ,CUST_TERMN_EQUIP_MODEL             --客户终端设备型号
    ,CUST_TERMN_EQUIP_ID                --客户终端设备ID
    ,SESSION_ID                         --会话ID
    ,RELA_FLOW_ID                       --关联流水编号
    ,SAVE_CERT_WAY_CD                   --安全认证方式代码
    ,AUTH_STATUS_CD                     --授权状态代码
    ,BANK_AGENT_FLG                     --银行代办标志
    ,AUTH_ROLE_SEQ_NUM                  --授权角色序号
    ,SUBMIT_CORE_DT                     --提交核心日期
    ,SUBMIT_CORE_TM                     --提交核心时间
    ,TRAN_TOT_QTTY                      --交易总数量
    ,REMARK                             --备注
    ,BUS_FLOW_NUM                       --业务流水号
    ,CHAIN_WAY_TRACK_NO                 --链路跟踪号
    ,UPS_FLOW_NUM                       --上游流水号
    ,ETL_DT                             --ETL处理日期
    ,SRC_TABLE_NAME                     --源表名称
    ,JOB_CD                             --任务编码
    ,ETL_TIMESTAMP                      --ETL处理时间戳
    FROM IML.V_EVT_BANK_PC_EDIT_TRAN_FLOW  --视图-银行PC版交易流水
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_BANK_PC_EDIT_TRAN_FLOW', '', O_ERRCODE);

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

END ETL_O_IML_EVT_BANK_PC_EDIT_TRAN_FLOW;
/

