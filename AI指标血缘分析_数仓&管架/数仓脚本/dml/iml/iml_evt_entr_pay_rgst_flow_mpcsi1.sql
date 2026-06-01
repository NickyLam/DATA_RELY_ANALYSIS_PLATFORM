/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_entr_pay_rgst_flow_mpcsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_entr_pay_rgst_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_entr_pay_rgst_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_entr_pay_rgst_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_entr_pay_rgst_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_tm -- 交易时间
    ,flow_num -- 流水号
    ,tran_code -- 交易码
    ,core_tran_code -- 核心交易码
    ,mgmt_org_id -- 管理机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,bank_int_flg -- 行内标志
    ,origi_bank_no -- 发起行行号
    ,payer_open_dept_id -- 付款人开户行部门编号
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人名称
    ,pay_bank_name -- 付款行名称
    ,recv_bank_no -- 收款行行号
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人名称
    ,recv_bank_name -- 收款行名称
    ,money_usage_descb -- 款项用途描述
    ,vouch_type_cd -- 凭证类型代码
    ,dubil_id -- 借据编号
    ,stop_pay_dt -- 止付日期
    ,stop_pay_flow_num -- 止付流水号
    ,core_tran_dt -- 核心交易日期
    ,core_tran_flow_num -- 核心交易流水号
    ,init_tran_dt -- 原交易日期
    ,init_flow_num -- 原流水号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,prod_cd -- 产品代码
    ,acct_ety_code -- 会计分录编码
    ,chn_cd -- 渠道代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_entr_pay_rgst_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a09tentrustedpaylog-1
insert into ${iml_schema}.evt_entr_pay_rgst_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_tm -- 交易时间
    ,flow_num -- 流水号
    ,tran_code -- 交易码
    ,core_tran_code -- 核心交易码
    ,mgmt_org_id -- 管理机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,bank_int_flg -- 行内标志
    ,origi_bank_no -- 发起行行号
    ,payer_open_dept_id -- 付款人开户行部门编号
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人名称
    ,pay_bank_name -- 付款行名称
    ,recv_bank_no -- 收款行行号
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人名称
    ,recv_bank_name -- 收款行名称
    ,money_usage_descb -- 款项用途描述
    ,vouch_type_cd -- 凭证类型代码
    ,dubil_id -- 借据编号
    ,stop_pay_dt -- 止付日期
    ,stop_pay_flow_num -- 止付流水号
    ,core_tran_dt -- 核心交易日期
    ,core_tran_flow_num -- 核心交易流水号
    ,init_tran_dt -- 原交易日期
    ,init_flow_num -- 原流水号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,prod_cd -- 产品代码
    ,acct_ety_code -- 会计分录编码
    ,chn_cd -- 渠道代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201003'||P1.OPDT||P1.SEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.timeformat_max(P1.OPDT||P1.TRNTM) -- 交易时间
    ,P1.SEQNO -- 流水号
    ,P1.TRNCD -- 交易码
    ,P1.HOSTTRNCD -- 核心交易码
    ,P1.MAGEBRN -- 管理机构编号
    ,P1.TLRNO -- 交易柜员编号
    ,P1.AUTHTLRNO -- 授权柜员编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CCY END -- 币种代码
    ,P1.TRNAMT -- 交易金额
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TRNSTAT END -- 交易状态代码
    ,P1.IOFLAG -- 行内标志
    ,P1.SNDBRN -- 发起行行号
    ,P1.PAYBRN -- 付款人开户行部门编号
    ,P1.PAYACCT -- 付款人账号
    ,P1.PAYNAME -- 付款人名称
    ,P1.PAYBKNM -- 付款行名称
    ,P1.RCVBRN -- 收款行行号
    ,P1.INCOACCT -- 收款人账号
    ,P1.INCONAME -- 收款人名称
    ,P1.RCVBKNM -- 收款行名称
    ,P1.MEMO -- 款项用途描述
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.VOUTYPE END -- 凭证类型代码
    ,P1.LNCFNO -- 借据编号
    ,${iml_schema}.DATEFORMAT_max(P1.ZFDATE) -- 止付日期
    ,P1.ZFSQNO -- 止付流水号
    ,${iml_schema}.DATEFORMAT_max(P1.HOSTDT) -- 核心交易日期
    ,P1.HOSTSEQNO -- 核心交易流水号
    ,${iml_schema}.DATEFORMAT_max(P1.ORAOPDT) -- 原交易日期
    ,P1.ORASEQNO -- 原流水号
    ,P1.ERRCODE -- 返回码
    ,P1.ERRMS -- 返回信息
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.PRODCD END -- 产品代码
    ,P1.ABSCDE -- 会计分录编码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.SRCSYSID END -- 渠道代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a09tentrustedpaylog' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a09tentrustedpaylog p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CCY = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A09TENTRUSTEDPAYLOG'
        AND R1.SRC_FIELD_EN_NAME= 'CCY'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_ENTR_PAY_RGST_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TRNSTAT = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A09TENTRUSTEDPAYLOG'
        AND R2.SRC_FIELD_EN_NAME= 'TRNSTAT'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_ENTR_PAY_RGST_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.VOUTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A09TENTRUSTEDPAYLOG'
        AND R3.SRC_FIELD_EN_NAME= 'VOUTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_ENTR_PAY_RGST_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'VOUCH_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.PRODCD = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A09TENTRUSTEDPAYLOG'
        AND R5.SRC_FIELD_EN_NAME= 'PRODCD'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_ENTR_PAY_RGST_FLOW'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'PROD_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.SRCSYSID = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A09TENTRUSTEDPAYLOG'
        AND R4.SRC_FIELD_EN_NAME= 'SRCSYSID'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_ENTR_PAY_RGST_FLOW'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CHN_CD'
where  1 = 1 
    and opdt='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_entr_pay_rgst_flow truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_entr_pay_rgst_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_entr_pay_rgst_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_entr_pay_rgst_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_entr_pay_rgst_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_entr_pay_rgst_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);