CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_AP_REGISTER_INFO_H(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_AP_REGISTER_INFO_H
  *  功能描述：单户资产登记信息历史
  *  创建日期：20230905
  *  开发人员：HULIJUAN
  *  来源表： IML.V_AGT_AP_REGISTER_INFO_H
  *  目标表： O_IML_AGT_AP_REGISTER_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1     20230905  HULIJUAN 首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_AP_REGISTER_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_AP_REGISTER_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-单户资产登记信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_AP_REGISTER_INFO_H
    (AGT_ID                         --协议编号
    ,LP_ID                          --法人编号
    ,FLOW_NUM                       --流水号
    ,PROP_ID                        --方案编号
    ,PROP_NAME                      --方案名称
    ,CUST_NAME                      --客户名称
    ,DISP_TYPE_CD                   --处置类型代码
    ,CONT_AMT                       --合同金额
    ,CONT_BAL                       --合同余额
    ,FIN_ACCT_RECVBL                --财务应收款
    ,IN_BS_INT_BAL                  --表内利息余额
    ,OFF_BS_INT_BAL                 --表外利息余额
    ,CRED_RHT_AMT                   --债权金额
    ,TRAN_AMT                       --转让金额
    ,SELLER_INVSTG_AGENT_ORG_NAME   --卖方尽职调查中介机构名称
    ,BUYER_NAME                     --买受人名称
    ,SUIT_STAGE_LAW_FEE_AMT         --诉讼阶段法律性费用金额
    ,CKWRF_ASSET_PRIC_BAL           --账销案存资产本金余额
    ,CKWRF_ASSET_INBSOVERINT_BAL    --账销案存资产表内欠息余额
    ,CKWRF_ASSET_OFFBSOVERINT_BAL   --账销案存资产表外欠息余额
    ,PROP_DESCB                     --方案描述
    ,RISK_ASSET_COMB                --风险资产组合
    ,EXEC_STATUS_CD                 --执行状态代码
    ,PKG_DT                         --封包日期
    ,TRAN_TYPE_CD                   --转让类型代码
    ,CURR_CD                        --币种代码
    ,MODIF_POST_ORG_ID              --变更后机构编号
    ,ADVC_SUIT_FEE                  --代垫诉讼费
    ,PAY_WAY_CD                     --付款方式代码
    ,FIRST_PAY_AMT                  --首付金额
    ,RGST_TELLER_ID                 --登记柜员编号
    ,RGST_ORG_ID                    --登记机构编号
    ,RGST_DT                        --登记日期
    ,UPDATE_TELLER_ID               --更新柜员编号
    ,UPDATE_ORG_ID                  --更新机构编号
    ,UP_DATE                        --更新日期
    ,START_DT                       --开始时间
    ,END_DT                         --结束时间
    ,ID_MARK                        --增删标志
    ,SRC_TABLE_NAME                 --源表名称
    ,JOB_CD                         --任务编码
    ,ETL_TIMESTAMP                  --ETL处理时间戳
    ,TRAN_CONT_ID	                  --转让合同编号
    ,TRAN_CONT_BEGIN_DT	            --转让合同起始日期
    ,TRAN_CONT_EXP_DT	              --转让合同到期日期
    ,TRAN_TRAN_PLAT	                --转让交易平台代码
    ,TRAN_TRAN_PLAT_DESCB	          --转让交易平台描述
    ,CNTPTY_ACCT_ID	                --交易对手账户编号
    ,CNTPTY_ACCT_NAME	              --交易对手账户名称
    ,CNTPTY_TYPE_CD	                --交易对手类型代码
    ,CNTPTY_OPEN_BANK_NUM	          --交易对手开户行号
    ,CNTPTY_OPEN_BANK_NAME	        --交易对手开户行名称
    ,CNTPTY_TRAN_ACCT_DT	          --交易对手转账日期
    ,INPUT_FLG	                    --补录标志
    )
  SELECT AGT_ID                          --协议编号
        ,LP_ID                          --法人编号
        ,FLOW_NUM                       --流水号
        ,PROP_ID                        --方案编号
        ,PROP_NAME                      --方案名称
        ,CUST_NAME                      --客户名称
        ,DISP_TYPE_CD                   --处置类型代码
        ,CONT_AMT                       --合同金额
        ,CONT_BAL                       --合同余额
        ,FIN_ACCT_RECVBL                --财务应收款
        ,IN_BS_INT_BAL                  --表内利息余额
        ,OFF_BS_INT_BAL                 --表外利息余额
        ,CRED_RHT_AMT                   --债权金额
        ,TRAN_AMT                       --转让金额
        ,SELLER_INVSTG_AGENT_ORG_NAME   --卖方尽职调查中介机构名称
        ,BUYER_NAME                     --买受人名称
        ,SUIT_STAGE_LAW_FEE_AMT         --诉讼阶段法律性费用金额
        ,CKWRF_ASSET_PRIC_BAL           --账销案存资产本金余额
        ,CKWRF_ASSET_INBSOVERINT_BAL    --账销案存资产表内欠息余额
        ,CKWRF_ASSET_OFFBSOVERINT_BAL   --账销案存资产表外欠息余额
        ,PROP_DESCB                     --方案描述
        ,RISK_ASSET_COMB                --风险资产组合
        ,EXEC_STATUS_CD                 --执行状态代码
        ,PKG_DT                         --封包日期
        ,TRAN_TYPE_CD                   --转让类型代码
        ,CURR_CD                        --币种代码
        ,MODIF_POST_ORG_ID              --变更后机构编号
        ,ADVC_SUIT_FEE                  --代垫诉讼费
        ,PAY_WAY_CD                     --付款方式代码
        ,FIRST_PAY_AMT                  --首付金额
        ,RGST_TELLER_ID                 --登记柜员编号
        ,RGST_ORG_ID                    --登记机构编号
        ,RGST_DT                        --登记日期
        ,UPDATE_TELLER_ID               --更新柜员编号
        ,UPDATE_ORG_ID                  --更新机构编号
        ,UP_DATE                        --更新日期
        ,START_DT                       --开始时间
        ,END_DT                         --结束时间
        ,ID_MARK                        --增删标志
        ,SRC_TABLE_NAME                 --源表名称
        ,JOB_CD                         --任务编码
        ,ETL_TIMESTAMP                  --ETL处理时间戳
        ,TRAN_CONT_ID	                  --转让合同编号
        ,TRAN_CONT_BEGIN_DT	            --转让合同起始日期
        ,TRAN_CONT_EXP_DT	              --转让合同到期日期
        ,TRAN_TRAN_PLAT	                --转让交易平台代码
        ,TRAN_TRAN_PLAT_DESCB	          --转让交易平台描述
        ,CNTPTY_ACCT_ID	                --交易对手账户编号
        ,CNTPTY_ACCT_NAME	              --交易对手账户名称
        ,CNTPTY_TYPE_CD	                --交易对手类型代码
        ,CNTPTY_OPEN_BANK_NUM	          --交易对手开户行号
        ,CNTPTY_OPEN_BANK_NAME	        --交易对手开户行名称
        ,CNTPTY_TRAN_ACCT_DT	          --交易对手转账日期
        ,INPUT_FLG	                    --补录标志
    FROM IML.V_AGT_AP_REGISTER_INFO_H  --视图-单户资产登记信息历史
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_AP_REGISTER_INFO_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_AP_REGISTER_INFO_H;
/

