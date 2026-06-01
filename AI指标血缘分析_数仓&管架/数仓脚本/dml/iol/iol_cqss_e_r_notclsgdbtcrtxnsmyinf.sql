/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_notclsgdbtcrtxnsmyinf
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
drop table ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf_ex purge;
alter table ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,astdsp_bsn_acc -- 资产处置业务账户数:EB02AS01
    ,astdsp_bsn_bal -- 资产处置业务余额:EB02AJ01
    ,rctly_oc_displ_dt -- 最近一次处置日期:EB02AR01
    ,adcsh_bsn_acc -- 垫款业务账户数:EB02AS02
    ,adcsh_bsn_bal -- 垫款业务余额:EB02AJ02
    ,adcshrctlyocrepydyprd -- 垫款最近一次还款日期:EB02AR02
    ,cur_odue_tamt -- 当前逾期总额(逾期总额):EB02AJ03
    ,cur_odue_pnp -- 当前逾期本金(逾期本金):EB02AJ04
    ,odin_adoth -- 逾期利息及其他:EB02AJ05
    ,othrdbtcrtclsyentrnum -- 其他借贷交易分类汇总条目数量:EB02AS03
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,astdsp_bsn_acc -- 资产处置业务账户数:EB02AS01
    ,astdsp_bsn_bal -- 资产处置业务余额:EB02AJ01
    ,rctly_oc_displ_dt -- 最近一次处置日期:EB02AR01
    ,adcsh_bsn_acc -- 垫款业务账户数:EB02AS02
    ,adcsh_bsn_bal -- 垫款业务余额:EB02AJ02
    ,adcshrctlyocrepydyprd -- 垫款最近一次还款日期:EB02AR02
    ,cur_odue_tamt -- 当前逾期总额(逾期总额):EB02AJ03
    ,cur_odue_pnp -- 当前逾期本金(逾期本金):EB02AJ04
    ,odin_adoth -- 逾期利息及其他:EB02AJ05
    ,othrdbtcrtclsyentrnum -- 其他借贷交易分类汇总条目数量:EB02AS03
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_notclsgdbtcrtxnsmyinf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);