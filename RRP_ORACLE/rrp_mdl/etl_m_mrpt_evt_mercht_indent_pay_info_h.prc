CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_EVT_MERCHT_INDENT_PAY_INFO_H(I_P_DATE IN INTEGER,
                       O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_EVT_MERCHT_INDENT_PAY_INFO_H
  *  功能描述：商户订单支付信息历史表
  *  创建日期：2022/12/09
  *  开发人员：HDY
  *  来源表：  O_IML_EVT_MERCHT_INDENT_PAY_INFO_H 商户订单支付信息历史表

  *  目标表：  M_MRPT_EVT_MERCHT_INDENT_PAY_INFO_H
  *
  *  配置表：
  *  修改情况：1  2022/12/09  HDY   首次创建
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数
  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100) := 'ETL_M_MRPT_EVT_MERCHT_INDENT_PAY_INFO_H' ;-- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  V_SQL         VARCHAR2(2000); -- 动态sql
  V_TAB_NAME      VARCHAR2(100);  --表名称
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;
  V_Y_DATE      DATE;          --年初日期

BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_Y_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'Y');--获取年初日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_MRPT_EVT_MERCHT_INDENT_PAY_INFO_H'; --表名称
  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;

  V_SQL := 'TRUNCATE TABLE '||V_TAB_NAME;
  EXECUTE IMMEDIATE V_SQL;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  V_STEP_DESC := '--M层数据落地 商户订单支付信息历史表--';
  D_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_MRPT_EVT_MERCHT_INDENT_PAY_INFO_H
             (   DATA_DT                     --01  数据日期
                ,EVT_ID                      --02  事件编号
                ,LP_ID                       --03  法人编号
                ,INTNAL_FLOW_NUM             --04  内部流水号
                ,TRAN_DT                     --05  交易日期
                ,TRAN_TM                     --06  交易时间
                ,BUS_TYPE_CD                 --07  业务类型代码
                ,BACK_END_CHN_TYPE_CD        --08  后端渠道类型代码
                ,MERCHT_ID                   --09  商户编号
                ,MERCHT_NAME                 --10  商户名称
                ,CHN_MERCHT_ID               --11  渠道商户编号
                ,CHN_SUB_MERCHT_ID           --12  渠道子商户编号
                ,CHN_INDENT_FLOW_NUM         --13  渠道订单流水号
                ,CHN_INDENT_TRAN_DT          --14  渠道订单交易日期
                ,PAY_CHN_FEE_RAT             --15  支付渠道费率
                ,PAY_FLOW_NUM                --16  支付流水号
                ,OVA_FLOW_NUM                --17  全局流水号
                ,FEE_RAT_CHN_CD              --18  费率渠道代码
                ,EXT_INDENT_ID               --19  外部订单编号
                ,INDENT_CAPTION_NAME         --20  订单标题名称
                ,INDENT_DESCB                --21  订单描述
                ,AGENCY_ID                   --22  代理商编号
                ,CURR_CD                     --23  币种代码
                ,TRAN_AMT                    --24  交易金额
                ,INDENT_BAL                  --25  订单余额
                ,INIT_INDENT_FLOW_NUM        --26  原订单流水号
                ,INIT_INDENT_TRAN_DT         --27  原订单交易日期
                ,TRAN_STATUS_CD              --28  交易状态代码
                ,PAY_SUCS_DT                 --29  付款成功日期
                ,PAY_SUCS_TM                 --30  付款成功时间
                ,RESP_CODE                   --31  响应码
                ,RESP_CODE_DESCB             --32  响应码描述
                ,RTN_GOODS_STATUS_CD         --33  退货状态代码
                ,ON_ACCT_FLG                 --34  挂账标志
                ,INDENT_VALID_TM             --35  订单有效时间
                ,PAY_BANK_CARD_ID            --36  支付银行卡编号
                ,TERMN_TYPE_CD               --37  终端类型代码
                ,RECV_BILL_BRCH_ID           --38  收单分行编号
                ,EXT_MERCHT_ID               --39  外部商户编号
                ,PAY_CHN_CD                  --40  支付渠道代码
                ,BACK_END_CHN_INDENT_ID      --41  后端渠道订单编号
                ,EPC_G_ROOM_FLG              --42  网联机房标志
                ,PAY_VOUCH_ID                --43  付款凭证编号
                ,START_DT                    --44  开始时间
                ,END_DT                      --45  结束时间
                ,ID_MARK                     --46  增删标志
                ,SRC_TABLE_NAME              --47  源表名称
                ,JOB_CD                      --48  任务编码
       )
      SELECT     V_P_DATE                    --01  数据日期
                ,EVT_ID                      --02  事件编号
                ,LP_ID                       --03  法人编号
                ,INTNAL_FLOW_NUM             --04  内部流水号
                ,TRAN_DT                     --05  交易日期
                ,TRAN_TM                     --06  交易时间
                ,BUS_TYPE_CD                 --07  业务类型代码
                ,BACK_END_CHN_TYPE_CD        --08  后端渠道类型代码
                ,MERCHT_ID                   --09  商户编号
                ,MERCHT_NAME                 --10  商户名称
                ,CHN_MERCHT_ID               --11  渠道商户编号
                ,CHN_SUB_MERCHT_ID           --12  渠道子商户编号
                ,CHN_INDENT_FLOW_NUM         --13  渠道订单流水号
                ,CHN_INDENT_TRAN_DT          --14  渠道订单交易日期
                ,PAY_CHN_FEE_RAT             --15  支付渠道费率
                ,PAY_FLOW_NUM                --16  支付流水号
                ,OVA_FLOW_NUM                --17  全局流水号
                ,FEE_RAT_CHN_CD              --18  费率渠道代码
                ,EXT_INDENT_ID               --19  外部订单编号
                ,INDENT_CAPTION_NAME         --20  订单标题名称
                ,INDENT_DESCB                --21  订单描述
                ,AGENCY_ID                   --22  代理商编号
                ,CURR_CD                     --23  币种代码
                ,TRAN_AMT                    --24  交易金额
                ,INDENT_BAL                  --25  订单余额
                ,INIT_INDENT_FLOW_NUM        --26  原订单流水号
                ,INIT_INDENT_TRAN_DT         --27  原订单交易日期
                ,TRAN_STATUS_CD              --28  交易状态代码
                ,PAY_SUCS_DT                 --29  付款成功日期
                ,PAY_SUCS_TM                 --30  付款成功时间
                ,RESP_CODE                   --31  响应码
                ,RESP_CODE_DESCB             --32  响应码描述
                ,RTN_GOODS_STATUS_CD         --33  退货状态代码
                ,ON_ACCT_FLG                 --34  挂账标志
                ,INDENT_VALID_TM             --35  订单有效时间
                ,PAY_BANK_CARD_ID            --36  支付银行卡编号
                ,TERMN_TYPE_CD               --37  终端类型代码
                ,RECV_BILL_BRCH_ID           --38  收单分行编号
                ,EXT_MERCHT_ID               --39  外部商户编号
                ,PAY_CHN_CD                  --40  支付渠道代码
                ,BACK_END_CHN_INDENT_ID      --41  后端渠道订单编号
                ,EPC_G_ROOM_FLG              --42  网联机房标志
                ,PAY_VOUCH_ID                --43  付款凭证编号
                ,START_DT                    --44  开始时间
                ,END_DT                      --45  结束时间
                ,ID_MARK                     --46  增删标志
                ,SRC_TABLE_NAME              --47  源表名称
                ,JOB_CD                      --48  任务编码
          FROM RRP_MDL.O_IML_EVT_MERCHT_INDENT_PAY_INFO_H  --商户交易明细表
         WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
           AND END_DT   > TO_DATE(V_P_DATE,'YYYYMMDD') ;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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
    D_ENDTIME := SYSDATE;
    I_STEP := 4;
    V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_EVT_MERCHT_INDENT_PAY_INFO_H;
/

