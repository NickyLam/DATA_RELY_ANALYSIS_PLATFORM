CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_EVT_ONL_BANK_TRAN_DTL (I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 网上银行转账明细表
  **存储过程名称：    ETL_M_MRPT_EVT_ONL_BANK_TRAN_DTL
  **存储过程创建日期：20221213
  **存储过程创建人：  阳娟
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
AS
  -- 定义变量 --
  I_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_EVT_ONL_BANK_TRAN_DTL'; -- 程序名称
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
  V_TAB_NAME := 'M_MRPT_EVT_ONL_BANK_TRAN_DTL'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  I_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_EVT_ONL_BANK_TRAN_DTL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
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
  V_SQL :='TRUNCATE TABLE M_MRPT_EVT_ONL_BANK_TRAN_DTL';
  EXECUTE IMMEDIATE V_SQL;

  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;

  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  I_STEP_DESC := '-- 数据落地到目标表 --';
  D_STARTTIME := SYSDATE;
 INSERT /*+APPEND*/ INTO RRP_MDL.M_MRPT_EVT_ONL_BANK_TRAN_DTL NOLOGGING
    (
     DATA_DT                             --数据日期
    ,LP_ID                               --法人编号
    ,TRAN_FLOW_NUM                       --转账流水号
    ,WHOLE_UNIFY_CUST_ID                 --全行统一客户编号
    ,TRAN_DT                             --交易日期
    ,TRAN_TM                             --交易时间
    ,TRAN_CODE                           --交易码
    ,TRAN_OPER_TYPE_CD                   --交易操作类型代码
    ,TRAN_RETURN_CODE                    --交易返回码
    ,FAIL_RS                             --失败原因
    ,TRAN_AMT                            --交易金额
    ,CURR_CD                             --币种代码
    ,COMM_FEE                            --手续费
    ,PAY_ACCT_NUM                        --付款账号
    ,PAY_ACCT_NAME                       --付款账户名称
    ,PAY_ACCT_TYPE_CD                    --付款账户类型代码
    ,RECVBL_NUM                          --收款账号
    ,RECVBL_NUM_NAME                     --收款账号名称
    ,RECVBL_ACCT_TYPE_CD                 --收款账户类型代码
    ,RECVER_BANK_NO                      --收款人银行行号
    ,RECVER_BANK_NAME                    --收款人银行名称
    ,RECVER_PROV_CD                      --收款人省份代码
    ,RECVER_PROV_NAME                    --收款人省份名称
    ,RECVER_CITY_CD                      --收款人城市代码
    ,RECVER_CITY_NAME                    --收款人城市名称
    ,PLAN_FOMULT_TM                      --计划制定时间
    ,PLAN_TYPE_CD                        --计划类型代码
    ,TRAN_FREQ_CD                        --交易频率代码
    ,NEXT_EXEC_DT                        --下一次执行日期
    ,PRECON_PLAN_STATUS_CD               --预约计划状态代码
    ,TM_OR_FF_BEGIN_DT                   --定时或定频起始日期
    ,TM_OR_FF_CLOSING_DT                 --定时或定频截止日期
    ,LMT_ATTR_CD                         --限额属性代码
    ,SAVE_CERT_WAY_CD                    --安全认证方式代码
    ,USAGE_COMNT                         --用途说明
    ,ONL_BANK_TRAN_FLOW_NUM              --网银交易流水号
    ,RECVER_NICKNA                       --收款人昵称
    ,ATM_EQUIP_ID                        --ATM设备编号
    ,ST_MSG_ADVISE_MOBILE_NO             --短信通知手机号码
    ,BRAC_ID                             --网点编号
    ,BRAC_NAME                           --网点名称
    ,DEPT_CD                             --部门代码
    ,TRAN_OUT_ROUTE_ID                   --转出路由编号
    ,REMIT_WAY_ID                        --汇路编号
    ,REMIT_WAY_NAME                      --汇路名称
    ,NEXT_DAY_TRAN_OUT_FLG               --次日转出标志
    ,TRAN_MOBILE_NO                      --转账手机号码
    ,CRDT_CARD_REPAY_FLG                 --信用卡还款标志
    ,USER_SEQ_ID                         --用户顺序编号
    ,REMARK                              --备注
    --,TRAN_ORDER_NO                       --交易订单号
    --,CHAIN_WAY_TRACK_NO                  --链路跟踪号
    ,ETL_DT                              --数据日期
    ,SRC_TABLE_NAME                      --源表名称
    ,JOB_CD                              --任务代码
    --,ETL_TIMESTAMP                       --数据处理时间
    )
     SELECT /*+PARALLEL*/
     V_P_DATE
    ,LP_ID                               --法人编号
    ,TRAN_FLOW_NUM                       --转账流水号
    ,WHOLE_UNIFY_CUST_ID                 --全行统一客户编号
    ,TRAN_DT                             --交易日期
    ,TRAN_TM                             --交易时间
    ,TRAN_CODE                           --交易码
    ,TRAN_OPER_TYPE_CD                   --交易操作类型代码
    ,TRAN_RETURN_CODE                    --交易返回码
    ,FAIL_RS                             --失败原因
    ,TRAN_AMT                            --交易金额
    ,CURR_CD                             --币种代码
    ,COMM_FEE                            --手续费
    ,PAY_ACCT_NUM                        --付款账号
    ,PAY_ACCT_NAME                       --付款账户名称
    ,PAY_ACCT_TYPE_CD                    --付款账户类型代码
    ,RECVBL_NUM                          --收款账号
    ,RECVBL_NUM_NAME                     --收款账号名称
    ,RECVBL_ACCT_TYPE_CD                 --收款账户类型代码
    ,RECVER_BANK_NO                      --收款人银行行号
    ,RECVER_BANK_NAME                    --收款人银行名称
    ,RECVER_PROV_CD                      --收款人省份代码
    ,RECVER_PROV_NAME                    --收款人省份名称
    ,RECVER_CITY_CD                      --收款人城市代码
    ,RECVER_CITY_NAME                    --收款人城市名称
    ,PLAN_FOMULT_TM                      --计划制定时间
    ,PLAN_TYPE_CD                        --计划类型代码
    ,TRAN_FREQ_CD                        --交易频率代码
    ,NEXT_EXEC_DT                        --下一次执行日期
    ,PRECON_PLAN_STATUS_CD               --预约计划状态代码
    ,TM_OR_FF_BEGIN_DT                   --定时或定频起始日期
    ,TM_OR_FF_CLOSING_DT                 --定时或定频截止日期
    ,LMT_ATTR_CD                         --限额属性代码
    ,SAVE_CERT_WAY_CD                    --安全认证方式代码
    ,USAGE_COMNT                         --用途说明
    ,ONL_BANK_TRAN_FLOW_NUM              --网银交易流水号
    ,RECVER_NICKNA                       --收款人昵称
    ,ATM_EQUIP_ID                        --ATM设备编号
    ,ST_MSG_ADVISE_MOBILE_NO             --短信通知手机号码
    ,BRAC_ID                             --网点编号
    ,BRAC_NAME                           --网点名称
    ,DEPT_CD                             --部门代码
    ,TRAN_OUT_ROUTE_ID                   --转出路由编号
    ,REMIT_WAY_ID                        --汇路编号
    ,REMIT_WAY_NAME                      --汇路名称
    ,NEXT_DAY_TRAN_OUT_FLG               --次日转出标志
    ,TRAN_MOBILE_NO                      --转账手机号码
    ,CRDT_CARD_REPAY_FLG                 --信用卡还款标志
    ,USER_SEQ_ID                         --用户顺序编号
    ,REMARK                              --备注
    --,TRAN_ORDER_NO                       --交易订单号
    --,CHAIN_WAY_TRACK_NO                  --链路跟踪号
    ,ETL_DT                              --数据日期
    ,SRC_TABLE_NAME                      --源表名称
    ,JOB_CD                              --任务代码
    --,ETL_TIMESTAMP                       --数据处理时间
    FROM RRP_MDL.O_IML_EVT_ONL_BANK_TRAN_DTL     --网上银行转账明细表视图
   WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')

   ;
  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_STARTTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

   -- 程序跑批结束记录 --
   I_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_STARTTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     D_STARTTIME := SYSDATE;
   /*I_STEP := I_STEP + 1;
     I_STEP_DESC := '-- 程序跑批异常 --';*/
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_STARTTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);


END ETL_M_MRPT_EVT_ONL_BANK_TRAN_DTL;
/

