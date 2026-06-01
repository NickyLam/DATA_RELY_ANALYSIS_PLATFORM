/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_jud_remit_rgst_b
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
drop table ${iol_schema}.ifcs_jud_remit_rgst_b_ex purge;
alter table ${iol_schema}.ifcs_jud_remit_rgst_b add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifcs_jud_remit_rgst_b truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifcs_jud_remit_rgst_b_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_jud_remit_rgst_b where 0=1;

insert /*+ append */ into ${iol_schema}.ifcs_jud_remit_rgst_b_ex(
    remit_dt -- 解除日期
    ,remit_flow_num -- 解除流水
    ,tran_flow_num -- 交易流水
    ,remit_way -- 解除方式
    ,remit_proof_type -- 解除证明类别
    ,proof_num -- 证明文号
    ,exec_org_cd -- 执行机关
    ,exec_cert_type_01 -- 执行人证件1
    ,exec_cert_no_01 -- 执行人证件号码1
    ,exec_cert_type_02 -- 执行人证件2
    ,exec_cert_no_02 -- 执行人证件号码2
    ,exec_ps_01 -- 执行人姓名
    ,remit_rs -- 解除原因
    ,teller_no -- 柜员
    ,org_no -- 机构
    ,init_froz_dt -- 原冻结日期
    ,init_froz_flow -- 原冻结流水
    ,remit_amt -- 解除金额
    ,exec_ps_02 -- 执行人员二
    ,remit_chn -- 解冻解止渠道
    ,remit_tm -- 解冻时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    remit_dt -- 解除日期
    ,remit_flow_num -- 解除流水
    ,tran_flow_num -- 交易流水
    ,remit_way -- 解除方式
    ,remit_proof_type -- 解除证明类别
    ,proof_num -- 证明文号
    ,exec_org_cd -- 执行机关
    ,exec_cert_type_01 -- 执行人证件1
    ,exec_cert_no_01 -- 执行人证件号码1
    ,exec_cert_type_02 -- 执行人证件2
    ,exec_cert_no_02 -- 执行人证件号码2
    ,exec_ps_01 -- 执行人姓名
    ,remit_rs -- 解除原因
    ,teller_no -- 柜员
    ,org_no -- 机构
    ,init_froz_dt -- 原冻结日期
    ,init_froz_flow -- 原冻结流水
    ,remit_amt -- 解除金额
    ,exec_ps_02 -- 执行人员二
    ,remit_chn -- 解冻解止渠道
    ,remit_tm -- 解冻时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifcs_jud_remit_rgst_b
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifcs_jud_remit_rgst_b exchange partition p_${batch_date} with table ${iol_schema}.ifcs_jud_remit_rgst_b_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_jud_remit_rgst_b to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifcs_jud_remit_rgst_b_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_jud_remit_rgst_b',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);