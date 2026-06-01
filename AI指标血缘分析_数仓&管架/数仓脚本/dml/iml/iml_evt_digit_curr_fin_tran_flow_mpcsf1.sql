/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_digit_curr_fin_tran_flow_mpcsf1
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
drop table ${iml_schema}.evt_digit_curr_fin_tran_flow_mpcsf1_tm purge;
alter table ${iml_schema}.evt_digit_curr_fin_tran_flow add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_digit_curr_fin_tran_flow modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_digit_curr_fin_tran_flow_mpcsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sys_id -- 系统编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,midgrod_tran_code -- 中台交易码
    ,fin_tran_code -- 金融交易码
    ,fin_tran_dt -- 金融交易日期
    ,fin_flow_num -- 金融流水号
    ,bank_int_bus_seq_num -- 行内业务序号
    ,msg_type -- 报文类型
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_batch_no -- 交易批次号
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,pay_flow_num -- 支付流水号
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,entry_id -- 记账分录编号
    ,check_entry_dt -- 对账日期
    ,check_entry_status_cd -- 对账状态代码
    ,revs_rs -- 冲正原因
    ,init_pay_flow_num -- 原支付流水号
    ,ova_flow_num -- 全局流水号
    ,chn_id -- 渠道编号
    ,err_cd -- 错误码
    ,return_info -- 返回信息
    ,mgmt_org_id -- 管理机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_digit_curr_fin_tran_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a1stfintranlist-1
insert into ${iml_schema}.evt_digit_curr_fin_tran_flow_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sys_id -- 系统编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,midgrod_tran_code -- 中台交易码
    ,fin_tran_code -- 金融交易码
    ,fin_tran_dt -- 金融交易日期
    ,fin_flow_num -- 金融流水号
    ,bank_int_bus_seq_num -- 行内业务序号
    ,msg_type -- 报文类型
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_batch_no -- 交易批次号
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,pay_flow_num -- 支付流水号
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,entry_id -- 记账分录编号
    ,check_entry_dt -- 对账日期
    ,check_entry_status_cd -- 对账状态代码
    ,revs_rs -- 冲正原因
    ,init_pay_flow_num -- 原支付流水号
    ,ova_flow_num -- 全局流水号
    ,chn_id -- 渠道编号
    ,err_cd -- 错误码
    ,return_info -- 返回信息
    ,mgmt_org_id -- 管理机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401042'||P1.SYSCD||P1.MAINSEQ||P1.TRANSDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SYSCD -- 系统编号
    ,P1.MAINSEQ -- 中台流水号
    ,${iml_schema}.dateformat_max2(P1.TRANSDT||P1.TRANSTM) -- 中台交易日期
    ,P1.FRONTTRCD -- 中台交易码
    ,P1.HOSTTRCD -- 金融交易码
    ,${iml_schema}.dateformat_max2(P1.HOSTDATE) -- 金融交易日期
    ,P1.HOSTNBR -- 金融流水号
    ,P1.BUSINESSTRACE -- 行内业务序号
    ,P1.PCKNO -- 报文类型
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL  ELSE '@'||P1.TRNTP END -- 交易类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL     
     ELSE '@'||P1.STATUS 
END -- 交易状态代码
    ,P1.BATCHID -- 交易批次号
    ,to_number(nvl(trim(P1.TRANSAMT),'0')) -- 交易金额
    ,P1.USERID -- 交易柜员编号
    ,P1.BRCNO -- 交易机构编号
    ,P1.DATAID -- 支付流水号
    ,P1.PAYACCT -- 付款人账户编号
    ,P1.PAYNAME -- 付款人名称
    ,P1.INCOACCT -- 收款人账户编号
    ,P1.INCONAME -- 收款人名称
    ,P1.ABSCDE -- 记账分录编号
    ,${iml_schema}.dateformat_max2(P1.COLLDT) -- 对账日期
    ,nvl(trim(P1.COLSTS),'-') -- 对账状态代码
    ,P1.REVREASON -- 冲正原因
    ,P1.ORGDATAID -- 原支付流水号
    ,P1.GLOBALSEQNO -- 全局流水号
    ,nvl(trim(P1.CHNID),'-') -- 渠道编号
    ,P1.ERRCODE -- 错误码
    ,P1.ERRMS -- 返回信息
    ,P1.MAGEBRN -- 管理机构编号
    ,${iml_schema}.dateformat_max2(P1.CHANGTIME) -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a1stfintranlist' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a1stfintranlist p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TRNTP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A1STFINTRANLIST'
        AND R1.SRC_FIELD_EN_NAME= 'TRNTP'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_DIGIT_CURR_FIN_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A1STFINTRANLIST'
        AND R2.SRC_FIELD_EN_NAME= 'STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_DIGIT_CURR_FIN_TRAN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_digit_curr_fin_tran_flow truncate partition p_mpcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_digit_curr_fin_tran_flow exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_digit_curr_fin_tran_flow_mpcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_digit_curr_fin_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_digit_curr_fin_tran_flow_mpcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_digit_curr_fin_tran_flow', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);