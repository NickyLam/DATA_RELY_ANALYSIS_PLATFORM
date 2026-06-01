/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_froz_stop_pay_rgst_b
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
drop table ${iol_schema}.ifcs_froz_stop_pay_rgst_b_ex purge;
alter table ${iol_schema}.ifcs_froz_stop_pay_rgst_b add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ifcs_froz_stop_pay_rgst_b;

-- 2.3 insert data to ex table
create table ${iol_schema}.ifcs_froz_stop_pay_rgst_b_ex nologging
compress
as
select * from ${iol_schema}.ifcs_froz_stop_pay_rgst_b where 0=1;

insert /*+ append */ into ${iol_schema}.ifcs_froz_stop_pay_rgst_b_ex(
    froz_dt -- 冻结日期
    ,froz_flow_num -- 冻结流水
    ,seq_num -- 顺序号
    ,tran_flow_num -- 交易流水
    ,rec_type -- 记录类别
    ,bus_type -- 业务方式
    ,status_cd -- 状态
    ,acct_id -- 账号
    ,dep_prod_sub_acct_id -- 子户号
    ,acct_name -- 客户名
    ,appl_froz_amt -- 申请冻结金额
    ,surp_froz_amt -- 剩余冻结金额
    ,froz_end_dt -- 冻结截至日
    ,proof_type -- 证明类别
    ,proof_id -- 证明书号
    ,froz_rs -- 冻结原因
    ,exec_org_cd -- 执行机关
    ,exec_cert_type_01 -- 执行证件一
    ,exec_cert_no_01 -- 执行号码一
    ,exec_cert_type_02 -- 执行证件二
    ,exec_cert_no_02 -- 执行号码二
    ,exec_ps_01 -- 执行人一
    ,exec_ps_02 -- 执行人二
    ,operr_no -- 操作员
    ,tran_org -- 交易机构
    ,chn_cd -- 渠道码
    ,froz_tm -- 冻结时间
    ,ori_tran_flow -- 平台上送交易流水
    ,law_enforce_type -- 执法部门类型
    ,law_enforce_name -- 执法部门名称
    ,deduct_doc_type -- 划扣通知书类型
    ,deduct_doc_code -- 划扣通知书编号
    ,blacklist_type -- 黑名单类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    froz_dt -- 冻结日期
    ,froz_flow_num -- 冻结流水
    ,seq_num -- 顺序号
    ,tran_flow_num -- 交易流水
    ,rec_type -- 记录类别
    ,bus_type -- 业务方式
    ,status_cd -- 状态
    ,acct_id -- 账号
    ,dep_prod_sub_acct_id -- 子户号
    ,acct_name -- 客户名
    ,appl_froz_amt -- 申请冻结金额
    ,surp_froz_amt -- 剩余冻结金额
    ,froz_end_dt -- 冻结截至日
    ,proof_type -- 证明类别
    ,proof_id -- 证明书号
    ,froz_rs -- 冻结原因
    ,exec_org_cd -- 执行机关
    ,exec_cert_type_01 -- 执行证件一
    ,exec_cert_no_01 -- 执行号码一
    ,exec_cert_type_02 -- 执行证件二
    ,exec_cert_no_02 -- 执行号码二
    ,exec_ps_01 -- 执行人一
    ,exec_ps_02 -- 执行人二
    ,operr_no -- 操作员
    ,tran_org -- 交易机构
    ,chn_cd -- 渠道码
    ,froz_tm -- 冻结时间
    ,ori_tran_flow -- 平台上送交易流水
    ,law_enforce_type -- 执法部门类型
    ,law_enforce_name -- 执法部门名称
    ,deduct_doc_type -- 划扣通知书类型
    ,deduct_doc_code -- 划扣通知书编号
    ,blacklist_type -- 黑名单类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifcs_froz_stop_pay_rgst_b
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifcs_froz_stop_pay_rgst_b exchange partition p_${batch_date} with table ${iol_schema}.ifcs_froz_stop_pay_rgst_b_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_froz_stop_pay_rgst_b to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifcs_froz_stop_pay_rgst_b_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_froz_stop_pay_rgst_b',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);