/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tmss_bis_acc_dtl
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tmss_bis_acc_dtl_ex purge;
alter table ${iol_schema}.tmss_bis_acc_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.tmss_bis_acc_dtl;

-- 2.3 insert data to ex table
create table ${iol_schema}.tmss_bis_acc_dtl_ex nologging
compress
as
select * from ${iol_schema}.tmss_bis_acc_dtl where 0=1;

insert /*+ append */ into ${iol_schema}.tmss_bis_acc_dtl_ex(
    id -- id
    ,bank_acc -- 本方账号
    ,acc_name -- 本方账户名
    ,bank_name -- 本方账户开户行
    ,bif_code -- 接口代码
    ,opp_acc_no -- 对方账号
    ,opp_acc_name -- 对方账户名
    ,opp_acc_bank -- 对方账户开户行
    ,cd_sign -- 借贷标志
    ,amt -- 交易金额
    ,bal -- 余额
    ,cur_id -- 币别ID
    ,uses -- 用途
    ,postscript -- 附言
    ,remark -- 备注
    ,trans_time -- 交易时间
    ,voucher_no -- 企业流水号
    ,bank_serial_no -- 银行流水号
    ,return_time -- 返回时间
    ,rb_sign -- 红蓝标志
    ,acc_no -- 业务单号
    ,import_sign -- 导出标识
    ,import_date -- 导出时间
    ,create_date -- 
    ,create_by -- 
    ,update_date -- 
    ,update_by -- 
    ,fbs_status -- 资金计划挂接状态 0未确认 1已确认 2已删除
    ,project_remark -- 项目信息
    ,settl_type -- 
    ,blend_sign -- 
    ,refund_blend_type -- 
    ,rmk -- 
    ,bill_id -- 
    ,merge_id -- 
    ,split_id -- 
    ,status -- 
    ,bus_type -- 
    ,claim_id -- 票据认领中间表id
    ,bis_dtl_no -- 
    ,bis_ebill_no -- 
    ,auto_sign -- 
    ,tenant_id -- 租户ID
    ,tally_date -- 记账日期
    ,bank_acc_child -- 本方账号子账号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- id
    ,bank_acc -- 本方账号
    ,acc_name -- 本方账户名
    ,bank_name -- 本方账户开户行
    ,bif_code -- 接口代码
    ,opp_acc_no -- 对方账号
    ,opp_acc_name -- 对方账户名
    ,opp_acc_bank -- 对方账户开户行
    ,cd_sign -- 借贷标志
    ,amt -- 交易金额
    ,bal -- 余额
    ,cur_id -- 币别ID
    ,uses -- 用途
    ,postscript -- 附言
    ,remark -- 备注
    ,trans_time -- 交易时间
    ,voucher_no -- 企业流水号
    ,bank_serial_no -- 银行流水号
    ,return_time -- 返回时间
    ,rb_sign -- 红蓝标志
    ,acc_no -- 业务单号
    ,import_sign -- 导出标识
    ,import_date -- 导出时间
    ,create_date -- 
    ,create_by -- 
    ,update_date -- 
    ,update_by -- 
    ,fbs_status -- 资金计划挂接状态 0未确认 1已确认 2已删除
    ,project_remark -- 项目信息
    ,settl_type -- 
    ,blend_sign -- 
    ,refund_blend_type -- 
    ,rmk -- 
    ,bill_id -- 
    ,merge_id -- 
    ,split_id -- 
    ,status -- 
    ,bus_type -- 
    ,claim_id -- 票据认领中间表id
    ,bis_dtl_no -- 
    ,bis_ebill_no -- 
    ,auto_sign -- 
    ,tenant_id -- 租户ID
    ,tally_date -- 记账日期
    ,bank_acc_child -- 本方账号子账号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tmss_bis_acc_dtl
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tmss_bis_acc_dtl exchange partition p_${batch_date} with table ${iol_schema}.tmss_bis_acc_dtl_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tmss_bis_acc_dtl to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tmss_bis_acc_dtl_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tmss_bis_acc_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);