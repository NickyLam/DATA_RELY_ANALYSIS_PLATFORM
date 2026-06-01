/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_admnpnshrcrd
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
drop table ${iol_schema}.cqss_e_r_admnpnshrcrd_ex purge;
alter table ${iol_schema}.cqss_e_r_admnpnshrcrd add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_admnpnshrcrd truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_admnpnshrcrd_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_admnpnshrcrd where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_admnpnshrcrd_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_inf_id -- 征信信息编号:EF040I01
    ,inst_nm -- 机构名称(处罚机构名称):EF040Q01
    ,pnsh_wrtdcs_no -- 处罚决定书文号:EF040I02
    ,admnpnshillg_bhvr_dsc -- 行政处罚违法行为描述(违法行为):EF040Q02
    ,pnsh_dcd_dsc -- 处罚决定描述(处罚决定):EF040Q03
    ,cr_admn_pnsh_efdt -- 征信行政处罚生效日期(处罚日期):EF040R01
    ,cr_admn_pnsh_amt -- 征信行政处罚金额(处罚金额):EF040J01
    ,admn_pnsh_exec_stndsc -- 行政处罚执行情况描述(处罚执行情况):EF040Q04
    ,cradmnpnshanrcnsdrslt -- 征信行政处罚行政复议结果(行政复议结果):EF040Q05
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_inf_id -- 征信信息编号:EF040I01
    ,inst_nm -- 机构名称(处罚机构名称):EF040Q01
    ,pnsh_wrtdcs_no -- 处罚决定书文号:EF040I02
    ,admnpnshillg_bhvr_dsc -- 行政处罚违法行为描述(违法行为):EF040Q02
    ,pnsh_dcd_dsc -- 处罚决定描述(处罚决定):EF040Q03
    ,cr_admn_pnsh_efdt -- 征信行政处罚生效日期(处罚日期):EF040R01
    ,cr_admn_pnsh_amt -- 征信行政处罚金额(处罚金额):EF040J01
    ,admn_pnsh_exec_stndsc -- 行政处罚执行情况描述(处罚执行情况):EF040Q04
    ,cradmnpnshanrcnsdrslt -- 征信行政处罚行政复议结果(行政复议结果):EF040Q05
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_admnpnshrcrd
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_admnpnshrcrd exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_admnpnshrcrd_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_admnpnshrcrd to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_admnpnshrcrd_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_admnpnshrcrd',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);