/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fam_tx_cntpty_info
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
drop table ${iol_schema}.fams_fam_tx_cntpty_info_ex purge;
alter table ${iol_schema}.fams_fam_tx_cntpty_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.fams_fam_tx_cntpty_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.fams_fam_tx_cntpty_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fam_tx_cntpty_info where 0=1;

insert /*+ append */ into ${iol_schema}.fams_fam_tx_cntpty_info_ex(
    cdate -- 日期
    ,core_tran_flow_num -- 全局流水号
    ,biz_seq_num -- 系统流水号
    ,tran_num -- 交易序号
    ,tx_cntpty_acct_num -- 交易对手账号
    ,tx_cntpty_name -- 交易对手名称
    ,cntpty_fin_inst_brac_cd -- 交易对手行号
    ,cntpty_fin_inst_brac_name -- 交易对手行名
    ,tx_cntpty_dist -- 对手银行所在行政区划
    ,tx_cntpty_cert_type -- 交易对手证件类型
    ,tx_cntpty_cert_no -- 交易对手证件号码
    ,tx_cntpty_cd_type -- 交易对手行号类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cdate -- 日期
    ,core_tran_flow_num -- 全局流水号
    ,biz_seq_num -- 系统流水号
    ,tran_num -- 交易序号
    ,tx_cntpty_acct_num -- 交易对手账号
    ,tx_cntpty_name -- 交易对手名称
    ,cntpty_fin_inst_brac_cd -- 交易对手行号
    ,cntpty_fin_inst_brac_name -- 交易对手行名
    ,tx_cntpty_dist -- 对手银行所在行政区划
    ,tx_cntpty_cert_type -- 交易对手证件类型
    ,tx_cntpty_cert_no -- 交易对手证件号码
    ,tx_cntpty_cd_type -- 交易对手行号类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.fams_fam_tx_cntpty_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.fams_fam_tx_cntpty_info exchange partition p_${batch_date} with table ${iol_schema}.fams_fam_tx_cntpty_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_fam_tx_cntpty_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.fams_fam_tx_cntpty_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_fam_tx_cntpty_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);