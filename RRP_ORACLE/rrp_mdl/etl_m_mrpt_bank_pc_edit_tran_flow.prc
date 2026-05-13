CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_BANK_PC_EDIT_TRAN_FLOW(I_P_DATE IN INTEGER,
                       O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_BANK_PC_EDIT_TRAN_FLOW
  *  功能描述：银行PC版交易流水
  *  创建日期：2023/01/06
  *  开发人员：HDY
  *  来源表：  RRP_MDL.O_IML_EVT_BANK_PC_EDIT_TRAN_FLOW  银行PC版交易流水

  *  目标表：  M_MRPT_BANK_PC_EDIT_TRAN_FLOW
  *
  *  配置表：
  *  修改情况：1  2023/01/06  HDY   首次创建
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数
  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100) := 'ETL_M_MRPT_BANK_PC_EDIT_TRAN_FLOW' ;-- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  V_TAB_NAME    VARCHAR2(100);  --表名称
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;

BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_MRPT_BANK_PC_EDIT_TRAN_FLOW'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE M_MRPT_BANK_PC_EDIT_TRAN_FLOW ';  --MODIFY 20230704 增加删除重跑，数仓接口表每天跑全量
  --DELETE FROM M_MRPT_BANK_PC_EDIT_TRAN_FLOW T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
 -- DELETE FROM RPT_MRPT_RESULT T WHERE T.DATA_DATE = V_P_DATE AND T.RPT_NO = V_RPT_NO;--手工报表指标结果表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CRD_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

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
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  V_STEP_DESC := '--M层数据落地 银行PC版交易流水--';
  D_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_MRPT_BANK_PC_EDIT_TRAN_FLOW NOLOGGING
             (DATA_DT                       --01  数据日期
              ,EVT_ID                       --02  事件编号
              ,LP_ID                        --03  法人编号
              ,FLOW_NUM                     --04  流水号
              ,TRAN_TM                      --05  交易时间
              ,TRAN_DT                      --06  交易日期
              ,TRAN_CODE                    --07  交易码
              ,TRAN_ORDER                   --08  交易命令
              ,UNIFY_CUST_ID                --09  统一客户编号
              ,USER_SEQ_NUM                 --10  用户顺序号
              ,TRAN_CHN_CD                  --11  交易渠道代码
              ,CUST_NAME                    --12  客户姓名
              ,MENU_ID                      --13  菜单id
              ,TRAN_STATUS_CD               --14  交易状态代码
              ,TRAN_RETURN_CODE             --15  交易返回编码
              ,FAIL_RS_DESCB                --16  失败原因描述
              ,TRAN_ACCT_NUM                --17  交易账号
              ,TRAN_AMT                     --18  交易金额
              ,CURR_CD                      --19  币种代码
              ,CHN_SEND_FLOW_ID             --20  渠道发送流水编号
              ,SORC_SYS_FLOW_ID             --21  源系统流水编号
              ,CORE_TRAN_FLOW_ID            --22  核心交易流水编号
              ,COMM_FEE                     --23  手续费
              ,PARENT_FLOW_ID               --24  父流水编号
              ,SRC_FLOW_SEQ_ID              --25  来源流水顺序编号
              ,AUTH_REFUSE_RS               --26  授权拒绝原因
              ,VISIT_FLOW_ID                --27  访问流水编号
              ,CORE_TRAN_DT                 --28  核心交易日期
              ,CALLOUT_TRAN_CODE            --29  被调方交易码
              ,CUST_IP                      --30  客户ip
              ,CURR_SERVER_HOST_NAME        --31  当前服务器主机名称
              ,REQ_SRC_SERVER_IP            --32  请求来源服务器ip
              ,CUST_TERMN_MAC_ADDR          --33  客户终端mac地址
              ,CUST_TERMN_OPER_SYS          --34  客户终端操作系统
              ,CUST_TERMN_BROW              --35  客户终端浏览器
              ,CUST_TERMN_EQUIP_MODEL       --36  客户终端设备型号
              ,CUST_TERMN_EQUIP_ID          --37  客户终端设备id
              ,SESSION_ID                   --38  会话id
              ,RELA_FLOW_ID                 --39  关联流水编号
              ,SAVE_CERT_WAY_CD             --40  安全认证方式代码
              ,AUTH_STATUS_CD               --41  授权状态代码
              ,BANK_AGENT_FLG               --42  银行代办标志
              ,AUTH_ROLE_SEQ_NUM            --43  授权角色序号
              ,SUBMIT_CORE_DT               --44  提交核心日期
              ,SUBMIT_CORE_TM               --45  提交核心时间
              ,TRAN_TOT_QTTY                --46  交易总数量
              ,REMARK                       --47  备注
              ,BUS_FLOW_NUM                 --48  业务流水号
              ,CHAIN_WAY_TRACK_NO           --49  链路跟踪号
              ,UPS_FLOW_NUM                 --50  上游流水号
              ,ETL_DT                       --51  etl处理日期
              ,SRC_TABLE_NAME               --52  源表名称
              ,JOB_CD                       --53  任务编码
              ,ETL_TIMESTAMP                --54  etl处理时间戳
       )
      SELECT  V_P_DATE                      --01  数据日期
              ,EVT_ID                       --02  事件编号
              ,LP_ID                        --03  法人编号
              ,FLOW_NUM                     --04  流水号
              ,TRAN_TM                      --05  交易时间
              ,TRAN_DT                      --06  交易日期
              ,TRAN_CODE                    --07  交易码
              ,TRAN_ORDER                   --08  交易命令
              ,UNIFY_CUST_ID                --09  统一客户编号
              ,USER_SEQ_NUM                 --10  用户顺序号
              ,TRAN_CHN_CD                  --11  交易渠道代码
              ,CUST_NAME                    --12  客户姓名
              ,MENU_ID                      --13  菜单id
              ,TRAN_STATUS_CD               --14  交易状态代码
              ,TRAN_RETURN_CODE             --15  交易返回编码
              ,FAIL_RS_DESCB                --16  失败原因描述
              ,TRAN_ACCT_NUM                --17  交易账号
              ,TRAN_AMT                     --18  交易金额
              ,CURR_CD                      --19  币种代码
              ,CHN_SEND_FLOW_ID             --20  渠道发送流水编号
              ,SORC_SYS_FLOW_ID             --21  源系统流水编号
              ,CORE_TRAN_FLOW_ID            --22  核心交易流水编号
              ,COMM_FEE                     --23  手续费
              ,PARENT_FLOW_ID               --24  父流水编号
              ,SRC_FLOW_SEQ_ID              --25  来源流水顺序编号
              ,AUTH_REFUSE_RS               --26  授权拒绝原因
              ,VISIT_FLOW_ID                --27  访问流水编号
              ,CORE_TRAN_DT                 --28  核心交易日期
              ,CALLOUT_TRAN_CODE            --29  被调方交易码
              ,CUST_IP                      --30  客户ip
              ,CURR_SERVER_HOST_NAME        --31  当前服务器主机名称
              ,REQ_SRC_SERVER_IP            --32  请求来源服务器ip
              ,CUST_TERMN_MAC_ADDR          --33  客户终端mac地址
              ,CUST_TERMN_OPER_SYS          --34  客户终端操作系统
              ,CUST_TERMN_BROW              --35  客户终端浏览器
              ,CUST_TERMN_EQUIP_MODEL       --36  客户终端设备型号
              ,CUST_TERMN_EQUIP_ID          --37  客户终端设备id
              ,SESSION_ID                   --38  会话id
              ,RELA_FLOW_ID                 --39  关联流水编号
              ,SAVE_CERT_WAY_CD             --40  安全认证方式代码
              ,AUTH_STATUS_CD               --41  授权状态代码
              ,BANK_AGENT_FLG               --42  银行代办标志
              ,AUTH_ROLE_SEQ_NUM            --43  授权角色序号
              ,SUBMIT_CORE_DT               --44  提交核心日期
              ,SUBMIT_CORE_TM               --45  提交核心时间
              ,TRAN_TOT_QTTY                --46  交易总数量
              ,REMARK                       --47  备注
              ,BUS_FLOW_NUM                 --48  业务流水号
              ,CHAIN_WAY_TRACK_NO           --49  链路跟踪号
              ,UPS_FLOW_NUM                 --50  上游流水号
              ,ETL_DT                       --51  etl处理日期
              ,SRC_TABLE_NAME               --52  源表名称
              ,JOB_CD                       --53  任务编码
              ,ETL_TIMESTAMP                --54  etl处理时间戳
         FROM RRP_MDL.O_IML_EVT_BANK_PC_EDIT_TRAN_FLOW  --银行PC版交易流水
        WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --V_SQL :='TRUNCATE TABLE TMP_M_MFD_ASSURANCE_DP';
 -- EXECUTE IMMEDIATE V_SQL;

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
  --程序结束标记
  I_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    I_STEP := 4;
    V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_BANK_PC_EDIT_TRAN_FLOW;
/

