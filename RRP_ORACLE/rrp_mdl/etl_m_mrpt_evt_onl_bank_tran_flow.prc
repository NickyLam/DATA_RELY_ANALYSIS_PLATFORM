CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_EVT_ONL_BANK_TRAN_FLOW (I_P_DATE IN INTEGER, --跑批日期
                                                               O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 网上银行交易流水表
  **存储过程名称：    ETL_M_MRPT_EVT_ONL_BANK_TRAN_FLOW
  **存储过程创建日期：20221215
  **存储过程创建人：  YANGJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
 AS
  -- 定义变量 --
  I_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_EVT_ONL_BANK_TRAN_FLOW'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  D_STARTTIME DATE; -- 处理开始时间
  D_ENDTIME DATE;   -- 处理结束时间
  I_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_SQL       VARCHAR2(2000); -- 动态sql
  I_STEP_DESC VARCHAR2(200); --任务名称
  V_PART_NAME VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME  VARCHAR2(100);  --表名称
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_EVT_ONL_BANK_TRAN_FLOW'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  I_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE M_MRPT_EVT_ONL_BANK_TRAN_FLOW ';  -- MODIFY 20230704  增加删数重跑，数仓接口表每天跑全量
  --DELETE FROM M_MRPT_EVT_ONL_BANK_TRAN_FLOW T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
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
  DELETE FROM RRP_MDL.M_MRPT_EVT_ONL_BANK_TRAN_FLOW T WHERE  TO_DATE(T.DATA_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND TO_DATE(T.DATA_DT,'YYYYMMDD')>= TO_DATE(V_P_DATE,'YYYYMMDD')-14 ;    --MODIFY 20231012 XMY
   
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;

  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  I_STEP_DESC := '-- 网上银行交易流水插入目标表 --';
  D_STARTTIME := SYSDATE;
 INSERT /*+APPEND*/ INTO RRP_MDL.M_MRPT_EVT_ONL_BANK_TRAN_FLOW NOLOGGING
    (
     DATA_DT                                   --数据日期
    ,EVT_ID                                    --事件编号
    ,LP_ID                                     --法人编号
    ,FLOW_NUM                                  --流水号
    ,TRAN_DT                                   --交易日期
    ,TRAN_TM                                   --交易时间
    ,TRAN_CODE                                 --交易码
    ,ONL_BANK_TRAN_STATUS_CD                   --网上银行交易状态代码
    ,TRAN_RETURN_CODE                          --交易返回码
    ,FAIL_RS                                   --失败原因
    ,TRAN_ACCT_NUM                             --交易账号
    ,TRAN_AMT                                  --交易金额
    ,CURR_CD                                   --币种代码
    ,WHOLE_UNIFY_CUST_ID                       --全行统一客户编号
    ,TRAN_CHN_CD                               --交易渠道代码
    ,CHN_SEND_FLOW_NUM                         --渠道发送流水号
    ,SORC_SYS_FLOW_NUM                         --源系统流水号
    ,CORE_TRAN_FLOW_NUM                        --核心交易流水号
    ,COMM_FEE                                  --手续费
    ,VISIT_FLOW_NUM                            --访问流水号
    ,CORE_TRAN_DT                              --核心交易日期
    ,CUST_IP_NUM                               --客户IP号
    ,CURR_SERVER_HOST_NAME                     --当前服务器主机名
    ,CUST_TERMN_MAC_ADDR                       --客户终端MAC地址
    ,CUST_TERMN_OPER_SYS_EDIT_NUM              --客户终端操作系统版本号
    ,CUST_TERMN_BROW                           --客户终端浏览器
    ,CUST_TERMN_EQUIP_MODEL                    --客户终端设备型号
    ,CUST_TERMN_EQUIP_ID                       --客户终端设备编号
    ,LOGON_SESSION_ID                          --登陆session编号
    ,RELA_FLOW_NUM                             --关联流水号
    ,TRAN_JNL_INFO                             --交易日志信息
    ,TRAN_TYPE_CODE                            --交易类型码
    ,CUST_NAME                                 --客户名称
    ,SAVE_CERT_WAY_CD                          --安全认证方式代码
    ,SPLT_FLOW_NUM                             --拆笔流水号
    ,CAMP_JOB_NO                               --营销工号
    ,PBC_FLOW_NUM                              --人行流水号
    --,USER_SEQ_ID                               --用户顺序编号
   --,TRAN_ORDER_NO                             --交易订单号
    --,CHAIN_WAY_TRACK_NO                        --链路跟踪号
    --,SYS_FLOW_NUM                              --系统流水号
    --,CHN_ID                                    --渠道编号
    ,ETL_DT                                    --数据日期
    ,SRC_TABLE_NAME                            --源表名称
    ,JOB_CD                                    --任务代码
   -- ,ETL_TIMESTAMP                             --数据处理时间
    )
     SELECT /*+PARALLEL*/
     V_P_DATE                                  --数据日期
    ,EVT_ID                                    --事件编号
    ,LP_ID                                     --法人编号
    ,FLOW_NUM                                  --流水号
    ,TRAN_DT                                   --交易日期
    ,TRAN_TM                                   --交易时间
    ,TRAN_CODE                                 --交易码
    ,ONL_BANK_TRAN_STATUS_CD                   --网上银行交易状态代码
    ,TRAN_RETURN_CODE                          --交易返回码
    ,FAIL_RS                                   --失败原因
    ,TRAN_ACCT_NUM                             --交易账号
    ,TRAN_AMT                                  --交易金额
    ,CURR_CD                                   --币种代码
    ,WHOLE_UNIFY_CUST_ID                       --全行统一客户编号
    ,TRAN_CHN_CD                               --交易渠道代码
    ,CHN_SEND_FLOW_NUM                         --渠道发送流水号
    ,SORC_SYS_FLOW_NUM                         --源系统流水号
    ,CORE_TRAN_FLOW_NUM                        --核心交易流水号
    ,COMM_FEE                                  --手续费
    ,VISIT_FLOW_NUM                            --访问流水号
    ,CORE_TRAN_DT                              --核心交易日期
    ,CUST_IP_NUM                               --客户IP号
    ,CURR_SERVER_HOST_NAME                     --当前服务器主机名
    ,CUST_TERMN_MAC_ADDR                       --客户终端MAC地址
    ,CUST_TERMN_OPER_SYS_EDIT_NUM              --客户终端操作系统版本号
    ,CUST_TERMN_BROW                           --客户终端浏览器
    ,CUST_TERMN_EQUIP_MODEL                    --客户终端设备型号
    ,CUST_TERMN_EQUIP_ID                       --客户终端设备编号
    ,LOGON_SESSION_ID                          --登陆session编号
    ,RELA_FLOW_NUM                             --关联流水号
    ,TRAN_JNL_INFO                             --交易日志信息
    ,TRAN_TYPE_CODE                            --交易类型码
    ,CUST_NAME                                 --客户名称
    ,SAVE_CERT_WAY_CD                          --安全认证方式代码
    ,SPLT_FLOW_NUM                             --拆笔流水号
    ,CAMP_JOB_NO                               --营销工号
    ,PBC_FLOW_NUM                              --人行流水号
    --,USER_SEQ_ID                               --用户顺序编号
    --,TRAN_ORDER_NO                             --交易订单号
    --,CHAIN_WAY_TRACK_NO                        --链路跟踪号
    --,SYS_FLOW_NUM                              --系统流水号
    --,CHN_ID                                    --渠道编号
    ,ETL_DT                                    --数据日期
    ,SRC_TABLE_NAME                            --源表名称
    ,JOB_CD                                    --任务代码
   -- ,ETL_TIMESTAMP                             --数据处理时间
    FROM RRP_MDL.O_IML_EVT_ONL_BANK_TRAN_FLOW
    WHERE ETL_DT>= TO_DATE(V_P_DATE,'YYYYMMDD')-14 
    AND ETL_DT<=TO_DATE(V_P_DATE,'YYYYMMDD')

   ;
  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

   -- 程序跑批结束记录 --
   I_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     D_ENDTIME := SYSDATE;
   /*I_STEP := I_STEP + 1;
     I_STEP_DESC := '-- 程序跑批异常 --';*/
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);


END ETL_M_MRPT_EVT_ONL_BANK_TRAN_FLOW;
/

