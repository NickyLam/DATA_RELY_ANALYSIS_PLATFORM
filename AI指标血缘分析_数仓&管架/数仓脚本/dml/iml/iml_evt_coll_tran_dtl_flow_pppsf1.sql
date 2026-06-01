/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_coll_tran_dtl_flow_pppsf1
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
drop table ${iml_schema}.evt_coll_tran_dtl_flow_pppsf1_tm purge;
alter table ${iml_schema}.evt_coll_tran_dtl_flow add partition p_pppsf1 values ('pppsf1')(
        subpartition p_pppsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_coll_tran_dtl_flow modify partition p_pppsf1
    add subpartition p_pppsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_coll_tran_dtl_flow_pppsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ova_flow_num -- 全局流水号
    ,tran_batch_no -- 交易批次号
    ,tran_sub_batch_no -- 交易子批次号
    ,seq_num -- 序号
    ,chn_id -- 渠道编号
    ,mercht_tran_flow_num -- 商户交易流水号
    ,mercht_tran_dt -- 商户交易日期
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_type_cd -- 交易类型代码
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,actl_tran_amt -- 实际交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,pay_acct_id -- 支付账户编号
    ,pay_acct_name -- 支付账户名称
    ,pt_type_cd -- 支付工具类型代码
    ,pay_act_cd -- 支付动作代码
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,recver_agt_id -- 收款方协议编号
    ,tran_postsc -- 交易附言
    ,core_batch_no -- 核心批次号
    ,core_acct_status_cd -- 核心账务状态代码
    ,core_tran_flow_num -- 核心交易流水号
    ,core_req_flow_num -- 核心请求流水号
    ,core_dt -- 核心日期
    ,pass_sys_abbr -- 通道系统简称
    ,plat_return_code -- 平台返回码
    ,plat_return_code_descb -- 平台返回码描述
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,call_sys_id -- 调用系统编号
    ,fir_create_dt -- 首次创建日期
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_coll_tran_dtl_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ppps_t_txn_batch_detail-1
insert into ${iml_schema}.evt_coll_tran_dtl_flow_pppsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ova_flow_num -- 全局流水号
    ,tran_batch_no -- 交易批次号
    ,tran_sub_batch_no -- 交易子批次号
    ,seq_num -- 序号
    ,chn_id -- 渠道编号
    ,mercht_tran_flow_num -- 商户交易流水号
    ,mercht_tran_dt -- 商户交易日期
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_type_cd -- 交易类型代码
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,actl_tran_amt -- 实际交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,pay_acct_id -- 支付账户编号
    ,pay_acct_name -- 支付账户名称
    ,pt_type_cd -- 支付工具类型代码
    ,pay_act_cd -- 支付动作代码
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,recver_agt_id -- 收款方协议编号
    ,tran_postsc -- 交易附言
    ,core_batch_no -- 核心批次号
    ,core_acct_status_cd -- 核心账务状态代码
    ,core_tran_flow_num -- 核心交易流水号
    ,core_req_flow_num -- 核心请求流水号
    ,core_dt -- 核心日期
    ,pass_sys_abbr -- 通道系统简称
    ,plat_return_code -- 平台返回码
    ,plat_return_code_descb -- 平台返回码描述
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,call_sys_id -- 调用系统编号
    ,fir_create_dt -- 首次创建日期
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401040'||P1.BATCH_NO||P1.TXN_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.GLOBAL_NO -- 全局流水号
    ,P1.BATCH_NO -- 交易批次号
    ,P1.SUB_BATCH_NO -- 交易子批次号
    ,P1.DETAIL_NO -- 序号
    ,nvl(trim(P1.MCHT_NO),'0000') -- 渠道编号
    ,P1.TRAN_NO -- 商户交易流水号
    ,${iml_schema}.dateformat_max2(P1.TRAN_DATE||P1.TRAN_TIME) -- 商户交易日期
    ,P1.TXN_NO -- 交易流水号
    ,${iml_schema}.dateformat_max2(P1.TXN_DATE||P1.TXN_TIME) -- 交易日期
    ,nvl(trim(P1.BIZ_TYPE),'OT') -- 交易类型代码
    ,nvl(trim(P1.SMRYCD),'-') -- 交易码
    ,nvl(trim(P1.STATUS),'-') -- 交易状态代码
    ,P1.AMOUNT -- 交易金额
    ,P1.REAL_AMOUNT -- 实际交易金额
    ,P1.TELLER_NO -- 交易柜员编号
    ,P1.TRANS_ORG_NO -- 交易机构编号
    ,P1.ACCOUNT_NUMBER -- 支付账户编号
    ,P1.ACCOUNT_NAME -- 支付账户名称
    ,nvl(trim(P1.PAYMENT_METHOD_TYPE_ID),'-') -- 支付工具类型代码
    ,nvl(trim(P1.PAYMENT_ACTION),'-') -- 支付动作代码
    ,P1.OPP_ACCOUNT_NUMBER -- 交易对手账户编号
    ,P1.OPP_ACCOUNT_NAME -- 交易对手账户名称
    ,P1.PROTOCOL_NO -- 收款方协议编号
    ,P1.PURPOSE -- 交易附言
    ,P1.HOST_BATCH_NO -- 核心批次号
    ,nvl(trim(P1.HOST_STATUS),'UNKNOWN') -- 核心账务状态代码
    ,P1.HOST_NO -- 核心交易流水号
    ,P1.HOST_REQ_NO -- 核心请求流水号
    ,${iml_schema}.dateformat_max2(P1.HOST_DATE||P1.HOST_TIME) -- 核心日期
    ,P1.PMC_CODE -- 通道系统简称
    ,P1.RET_CODE -- 平台返回码
    ,P1.RET_MSG -- 平台返回码描述
    ,P1.AUTH_TELLER_NO -- 授权柜员编号
    ,P1.CHECK_TELLER_NO -- 复核柜员编号
    ,P1.CONSUMER_ID -- 调用系统编号
    ,P1.CREATE_TIME -- 首次创建日期
    ,P1.UPDATE_TIME -- 最后更新日期
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ppps_t_txn_batch_detail' -- 源表名称
    ,'pppsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ppps_t_txn_batch_detail p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_coll_tran_dtl_flow truncate partition p_pppsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_coll_tran_dtl_flow exchange subpartition p_pppsf1_${batch_date} with table ${iml_schema}.evt_coll_tran_dtl_flow_pppsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_coll_tran_dtl_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_coll_tran_dtl_flow_pppsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_coll_tran_dtl_flow', partname => 'p_pppsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);