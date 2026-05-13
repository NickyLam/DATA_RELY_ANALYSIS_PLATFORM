CREATE OR REPLACE FORCE VIEW RRP_MDL.O_IOL_TX_CNTPTY_INFO AS
SELECT T.CORE_TRAN_FLOW_NUM        --全局流水号
      ,T.BIZ_SEQ_NUM               --系统流水号
      ,T.TRA_SEQ_NO                --交易序号
      ,T.TX_CNTPTY_ACCT_NUM        --交易对手账号
      ,T.TX_CNTPTY_NAME            --交易对手名称
      ,T.CNTPTY_FIN_INST_BRAC_CD   --交易对手行号
      ,T.CNTPTY_FIN_INST_BRAC_NAME --交易对手行名
      ,T.DIST                      --对手银行所在地行政区划
      ,T.TX_CNTPTY_CERT_TYPE       --交易对手证件类型
      ,T.TX_CNTPTY_CERT_NO         --交易对手证件号码
      ,T.TX_CNTPTY_INST_TYPE       --交易对手行号类型
      ,T.START_DT                  --开始时间
      ,T.END_DT                    --结束时间
      ,T.DATA_SRC                  --数据来源
FROM (
  --资金本币系统
  SELECT T1.CORE_TRAN_FLOW_NUM         AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,T1.BIZ_SEQ_NUM                AS BIZ_SEQ_NUM               --系统流水号
        ,T1.SEQ                        AS TRA_SEQ_NO                --交易序号
        ,T1.TX_CNTPTY_ACCT_NUM         AS TX_CNTPTY_ACCT_NUM        --交易对手账号
        ,T1.TX_CNTPTY_NAME             AS TX_CNTPTY_NAME            --交易对手名称
        ,T1.CNTPTY_FIN_INST_BRAC_CD    AS CNTPTY_FIN_INST_BRAC_CD   --交易对手行号
        ,T1.CNTPTY_FIN_INST_BRAC_NAME  AS CNTPTY_FIN_INST_BRAC_NAME --交易对手行名
        ,T1.DIST                       AS DIST                      --对手银行所在地行政区划
        ,T1.TX_CNTPTY_CERT_TYPE        AS TX_CNTPTY_CERT_TYPE       --交易对手证件类型
        ,T1.TX_CNTPTY_CERT_NO          AS TX_CNTPTY_CERT_NO         --交易对手证件号码
        ,T1.CPTY_TYPE                  AS TX_CNTPTY_INST_TYPE       --交易对手行号类型
        ,T1.START_DT                   AS START_DT                  --开始时间
        ,T1.END_DT                     AS END_DT                    --结束时间
        ,'资金本币系统'                AS DATA_SRC                  --数据来源
  FROM RRP_MDL.O_IOL_CTMS_VI_TBS_ACCOUNT_CPTYS_INFO T1  --资金系统交易对手_本币
  UNION ALL
  --资金外币系统
  SELECT T1.CORE_TRAN_FLOW_NUM         AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,T1.BIZ_SEQ_NUM                AS BIZ_SEQ_NUM               --系统流水号
        ,CAST(T1.SEQ AS VARCHAR2(30))  AS TRA_SEQ_NO                --交易序号
        ,T1.TX_CNTPTY_ACCT_NUM         AS TX_CNTPTY_ACCT_NUM        --交易对手账号
        ,T1.TX_CNTPTY_NAME             AS TX_CNTPTY_NAME            --交易对手名称
        ,T1.CNTPTY_FIN_INST_BRAC_CD    AS CNTPTY_FIN_INST_BRAC_CD   --交易对手行号
        ,T1.CNTPTY_FIN_INST_BRAC_NAME  AS CNTPTY_FIN_INST_BRAC_NAME --交易对手行名
        ,T1.DIST                       AS DIST                      --对手银行所在地行政区划
        ,T1.TX_CNTPTY_CERT_TYPE        AS TX_CNTPTY_CERT_TYPE       --交易对手证件类型
        ,T1.TX_CNTPTY_CERT_NO          AS TX_CNTPTY_CERT_NO         --交易对手证件号码
        ,T1.CPTY_TYPE                  AS TX_CNTPTY_INST_TYPE       --交易对手行号类型
        ,T1.START_DT                   AS START_DT                  --开始时间
        ,T1.END_DT                     AS END_DT                    --结束时间
        ,'资金外币系统'                AS DATA_SRC                  --数据来源
  FROM RRP_MDL.O_IOL_CTMS_VI_FBS_ACCOUNT_CPTYS_INFO T1  --资金系统交易对手_外币
  UNION ALL
  --同业系统
  SELECT T1.GLOBAL_FLOW_NO             AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,T1.FLOW_NO                    AS BIZ_SEQ_NUM               --系统流水号
        ,T1.FLOW_INNER_SN              AS TRA_SEQ_NO                --交易序号
        ,T1.PARTY_ACCT_CODE            AS TX_CNTPTY_ACCT_NUM        --交易对手账号
        ,T1.PARTY_ACCT_NAME            AS TX_CNTPTY_NAME            --交易对手名称
        ,T1.PARTY_BANK_CODE            AS CNTPTY_FIN_INST_BRAC_CD   --交易对手行号
        ,T1.PARTY_BANK_NAME            AS CNTPTY_FIN_INST_BRAC_NAME --交易对手行名
        ,NULL                          AS DIST                      --对手银行所在地行政区划
        ,NULL                          AS TX_CNTPTY_CERT_TYPE       --交易对手证件类型
        ,NULL                          AS TX_CNTPTY_CERT_NO         --交易对手证件号码
        ,NULL                          AS TX_CNTPTY_INST_TYPE       --交易对手行号类型
        ,T1.START_DT                   AS START_DT                  --开始时间
        ,T1.END_DT                     AS END_DT                    --结束时间
        ,'同业系统'                    AS DATA_SRC                  --数据来源
  FROM RRP_MDL.O_IOL_IBMS_TTRD_HX_COUNTERPARTY_REGISTRY T1  --同业系统华兴交易对手登记簿
  UNION ALL
  --资管系统
  SELECT T1.CORE_TRAN_FLOW_NUM         AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,T1.BIZ_SEQ_NUM                AS BIZ_SEQ_NUM               --系统流水号
        ,T1.TRAN_NUM                   AS TRA_SEQ_NO                --交易序号
        ,T1.TX_CNTPTY_ACCT_NUM         AS TX_CNTPTY_ACCT_NUM        --交易对手账号
        ,T1.TX_CNTPTY_NAME             AS TX_CNTPTY_NAME            --交易对手名称
        ,T1.CNTPTY_FIN_INST_BRAC_CD    AS CNTPTY_FIN_INST_BRAC_CD   --交易对手行号
        ,T1.CNTPTY_FIN_INST_BRAC_NAME  AS CNTPTY_FIN_INST_BRAC_NAME --交易对手行名
        ,T1.TX_CNTPTY_DIST             AS DIST                      --对手银行所在地行政区划
        ,T1.TX_CNTPTY_CERT_TYPE        AS TX_CNTPTY_CERT_TYPE       --交易对手证件类型
        ,T1.TX_CNTPTY_CERT_NO          AS TX_CNTPTY_CERT_NO         --交易对手证件号码
        ,T1.TX_CNTPTY_CD_TYPE          AS TX_CNTPTY_INST_TYPE       --交易对手行号类型
        ,T1.START_DT                   AS START_DT                  --开始时间
        ,T1.END_DT                     AS END_DT                    --结束时间
        ,'资管系统'                    AS DATA_SRC                  --数据来源
  FROM RRP_MDL.O_IOL_FAMS_FAM_TX_CNTPTY_INFO T1  --资管系统交易对手信息
  UNION ALL
  --新票据系统
  SELECT T1.BSNSSQ                     AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,T1.TRANSQ                     AS BIZ_SEQ_NUM               --系统流水号
        ,T1.SERINO                     AS TRA_SEQ_NO                --交易序号
        ,T1.CUST_ACCT                  AS TX_CNTPTY_ACCT_NUM        --交易对手账号
        ,T1.CUST_NAME                  AS TX_CNTPTY_NAME            --交易对手名称
        ,T1.CUST_BANK_NO               AS CNTPTY_FIN_INST_BRAC_CD   --交易对手行号
        ,T1.CUST_BANK_NAME             AS CNTPTY_FIN_INST_BRAC_NAME --交易对手行名
        ,T1.PROVINCE_NO                AS DIST                      --对手银行所在地行政区划
        ,T1.CERT_TYPE                  AS TX_CNTPTY_CERT_TYPE       --交易对手证件类型
        ,T1.CERT_ID                    AS TX_CNTPTY_CERT_NO         --交易对手证件号码
        ,T1.TXN_BANK_TYPE              AS TX_CNTPTY_INST_TYPE       --交易对手行号类型
        ,T1.START_DT                   AS START_DT                  --开始时间
        ,T1.END_DT                     AS END_DT                    --结束时间
        ,'新票据系统'                  AS DATA_SRC                  --数据来源
  FROM RRP_MDL.O_IOL_BDMS_VIEW_TRANS_OPPONENT_INFO T1  --票据系统交易对手信息视图
  UNION ALL
  --国结系统
  SELECT T1.CORE_TRAN_FLOW_NUM         AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,T1.BIZ_SEQ_NUM                AS BIZ_SEQ_NUM               --系统流水号
        ,T1.BIZ_SEQ_NO                 AS TRA_SEQ_NO                --交易序号
        ,T1.TX_CNTPTY_ACCT_NUM         AS TX_CNTPTY_ACCT_NUM        --交易对手账号
        ,T1.TX_CNTPTY_NAME             AS TX_CNTPTY_NAME            --交易对手名称
        ,T1.CNTPTY_FIN_INST_BRAC_CD    AS CNTPTY_FIN_INST_BRAC_CD   --交易对手行号
        ,T1.CNTPTY_FIN_INST_BRAC_NAME  AS CNTPTY_FIN_INST_BRAC_NAME --交易对手行名
        ,T1.DIST                       AS DIST                      --对手银行所在地行政区划
        ,T1.TX_CNTPTY_CERT_TYPE        AS TX_CNTPTY_CERT_TYPE       --交易对手证件类型
        ,T1.TX_CNTPTY_CERT_NO          AS TX_CNTPTY_CERT_NO         --交易对手证件号码
        ,T1.CD_TYP                     AS TX_CNTPTY_INST_TYPE       --交易对手行号类型
        ,T1.START_DT                   AS START_DT                  --开始时间
        ,T1.END_DT                     AS END_DT                    --结束时间
        ,'国结系统'                    AS DATA_SRC                  --数据来源
  FROM RRP_MDL.O_IOL_ISBS_OPPNET T1  --国结系统对手方信息表
) T
;
comment on table RRP_MDL.O_IOL_TX_CNTPTY_INFO is '交易对手信息';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.CORE_TRAN_FLOW_NUM is '核心交易流水号';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.BIZ_SEQ_NUM is '系统流水号';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.TRA_SEQ_NO is '交易流水号';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.TX_CNTPTY_ACCT_NUM is '交易对手账号';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.TX_CNTPTY_NAME is '交易对手名称';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.CNTPTY_FIN_INST_BRAC_CD is '交易对手行号';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.CNTPTY_FIN_INST_BRAC_NAME is '交易对手行名';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.DIST is '对手银行所在地行政区划';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.TX_CNTPTY_CERT_TYPE is '交易对手证件类型';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.TX_CNTPTY_CERT_NO is '交易对手证件号码';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.START_DT is '开始时间';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.END_DT is '结束时间';
comment on column RRP_MDL.O_IOL_TX_CNTPTY_INFO.DATA_SRC is '数据来源（参见[字典:AML0045]）';

