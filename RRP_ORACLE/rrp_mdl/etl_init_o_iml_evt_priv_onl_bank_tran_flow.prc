CREATE OR REPLACE PROCEDURE RRP_MDL."ETL_INIT_O_IML_EVT_PRIV_ONL_BANK_TRAN_FLOW" (I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 对私网上银行交易流水表
  **存储过程名称：    ETL_INIT_O_IML_EVT_PRIV_ONL_BANK_TRAN_FLOW
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_PRIV_ONL_BANK_TRAN_FLOW'; -- 程序名称
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
  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IML_EVT_PRIV_ONL_BANK_TRAN_FLOW';

 INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_PRIV_ONL_BANK_TRAN_FLOW NOLOGGING
    (
     EVT_ID                          --事件编号
    ,LP_ID                           --法人编号
    ,MAIN_FLOW_NUM                   --主流水号
    ,TRAN_FLOW_NUM                   --交易流水号
    ,OVA_FLOW_NUM                    --全局流水号
    ,WHOLE_UNIFY_CUST_ID             --全行统一客户编号
    ,CUST_NAME                       --客户名称
    ,USER_SEQ_NUM                    --用户顺序号
    ,TRAN_CODE                       --交易码
    ,BUS_GEN_CD                      --业务大类代码
    ,BUS_TYPE_CD                     --业务类型代码
    ,TRAN_DT                         --交易日期
    ,TRAN_TM                         --交易时间
    ,TRAN_ACCT_NUM                   --交易账号
    ,CURR_CD                         --币种代码
    ,TRAN_AMT                        --交易金额
    ,COMM_FEE                        --手续费
    ,SYS_ID                          --系统编号
    ,SORC_SYS_ID                     --源系统编号
    ,FOUR_CHN_CD                     --四位渠道代码
    ,TRAN_STATUS_CD                  --交易状态代码
    ,TRAN_ERR_CD                     --交易错误代码
    ,TRAN_ERR_DESCB                  --交易错误描述
    ,CORE_TRAN_FLOW_NUM              --核心交易流水号
    ,CORE_TRAN_DT                    --核心交易日期
    ,VISIT_FLOW_NUM                  --访问流水号
    ,RELA_FLOW_NUM                   --关联流水号
    ,PROC_SERVER_IP                  --处理服务器IP
    ,LOGON_NODE_ID                   --登陆节点编号
    ,SUBSTEP_TRAN_SCRT_KEY           --分步交易密钥
    ,TRAN_COMNT                      --交易说明
    ,TRAN_TYPE_CD                    --交易类型代码
    ,FUNC_MENU_ID                    --功能菜单编号
    ,CLIENT_IP                       --客户端IP
    ,CLIENT_MAC                      --客户端MAC
    ,EQUIP_ID                        --设备编号
    ,EQUIP_BRAND_NAME                --设备品牌名称
    ,EQUIP_MODEL                     --设备型号
    ,BROW_TYPE_CD                    --浏览器类型代码
    ,BROW_EDIT_NUM                   --浏览器版本号
    ,LOITDE                          --经度
    ,DIMEN                           --维度
    ,TELLER_ID                       --柜员编号
    ,TELLER_BELONG_ORG_ID            --柜员所属机构编号
    ,TRAN_REQ_TM                     --交易请求时间
    ,TRAN_RESP_TM                    --交易响应时间
    ,TRAN_ORDER_NO                   --交易订单号
    ,CHAIN_WAY_TRACK_NO              --链路跟踪号
    ,SYS_FLOW_NUM                    --系统流水号
    ,CHN_ID                          --渠道编号
    ,ETL_DT                          --数据日期
    ,SRC_TABLE_NAME                  --源表名称
    ,JOB_CD                          --任务代码
    ,ETL_TIMESTAMP                   --数据处理时间
    )
     SELECT /*+PARALLEL*/
   EVT_ID                          --事件编号
    ,LP_ID                           --法人编号
    ,MAIN_FLOW_NUM                   --主流水号
    ,TRAN_FLOW_NUM                   --交易流水号
    ,OVA_FLOW_NUM                    --全局流水号
    ,WHOLE_UNIFY_CUST_ID             --全行统一客户编号
    ,CUST_NAME                       --客户名称
    ,USER_SEQ_NUM                    --用户顺序号
    ,TRAN_CODE                       --交易码
    ,BUS_GEN_CD                      --业务大类代码
    ,BUS_TYPE_CD                     --业务类型代码
    ,TRAN_DT                         --交易日期
    ,TRAN_TM                         --交易时间
    ,TRAN_ACCT_NUM                   --交易账号
    ,CURR_CD                         --币种代码
    ,TRAN_AMT                        --交易金额
    ,COMM_FEE                        --手续费
    ,SYS_ID                          --系统编号
    ,SORC_SYS_ID                     --源系统编号
    ,FOUR_CHN_CD                     --四位渠道代码
    ,TRAN_STATUS_CD                  --交易状态代码
    ,TRAN_ERR_CD                     --交易错误代码
    ,TRAN_ERR_DESCB                  --交易错误描述
    ,CORE_TRAN_FLOW_NUM              --核心交易流水号
    ,CORE_TRAN_DT                    --核心交易日期
    ,VISIT_FLOW_NUM                  --访问流水号
    ,RELA_FLOW_NUM                   --关联流水号
    ,PROC_SERVER_IP                  --处理服务器IP
    ,LOGON_NODE_ID                   --登陆节点编号
    ,SUBSTEP_TRAN_SCRT_KEY           --分步交易密钥
    ,TRAN_COMNT                      --交易说明
    ,TRAN_TYPE_CD                    --交易类型代码
    ,FUNC_MENU_ID                    --功能菜单编号
    ,CLIENT_IP                       --客户端IP
    ,CLIENT_MAC                      --客户端MAC
    ,EQUIP_ID                        --设备编号
    ,EQUIP_BRAND_NAME                --设备品牌名称
    ,EQUIP_MODEL                     --设备型号
    ,BROW_TYPE_CD                    --浏览器类型代码
    ,BROW_EDIT_NUM                   --浏览器版本号
    ,LOITDE                          --经度
    ,DIMEN                           --维度
    ,TELLER_ID                       --柜员编号
    ,TELLER_BELONG_ORG_ID            --柜员所属机构编号
    ,TRAN_REQ_TM                     --交易请求时间
    ,TRAN_RESP_TM                    --交易响应时间
    ,TRAN_ORDER_NO                   --交易订单号
    ,CHAIN_WAY_TRACK_NO              --链路跟踪号
    ,SYS_FLOW_NUM                    --系统流水号
    ,CHN_ID                          --渠道编号
    ,ETL_DT                          --数据日期
    ,SRC_TABLE_NAME                  --源表名称
    ,JOB_CD                          --任务代码
    ,ETL_TIMESTAMP                   --数据处理时间
    FROM IML.V_EVT_PRIV_ONL_BANK_TRAN_FLOW   --视图对私网上银行交易流水表
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


END ETL_INIT_O_IML_EVT_PRIV_ONL_BANK_TRAN_FLOW;
/

