/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_cvljdgmtrcrdinf
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
drop table ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf_ex purge;
alter table ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_inf_id -- 征信信息编号:EF020I01
    ,crjdgmtputorcdcourtnm -- 征信判决立案法院名称(立案法院名称):EF020Q01
    ,fileno -- 案号:EF020I02
    ,cr_jdgmt_putonrcrd_dt -- 征信判决立案日期(立案日期):EF020R01
    ,csoatn -- 案由:EF020Q02
    ,ltgtn_pos -- 诉讼地位:EF020D01
    ,trial_prgm -- 审判程序:EF020D02
    ,cr_jdgmt_ltgtn_obj -- 征信判决诉讼标的(诉讼标的):EF020Q03
    ,crjdgmt_ltgtn_obj_amt -- 征信判决诉讼标的金额(诉讼标的金额):EF020J01
    ,cr_jdgmt_endcs_mtdcd -- 征信判决结案方式代码(结案方式):EF020D03
    ,cr_jdgmt_jdgmt_efdt -- 征信判决判决生效日期(判决/调解生效日期):EF020R02
    ,cr_jdgmt_jdgmtrst -- 征信判决判决结果(判决/调解结果):EF020Q04
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_inf_id -- 征信信息编号:EF020I01
    ,crjdgmtputorcdcourtnm -- 征信判决立案法院名称(立案法院名称):EF020Q01
    ,fileno -- 案号:EF020I02
    ,cr_jdgmt_putonrcrd_dt -- 征信判决立案日期(立案日期):EF020R01
    ,csoatn -- 案由:EF020Q02
    ,ltgtn_pos -- 诉讼地位:EF020D01
    ,trial_prgm -- 审判程序:EF020D02
    ,cr_jdgmt_ltgtn_obj -- 征信判决诉讼标的(诉讼标的):EF020Q03
    ,crjdgmt_ltgtn_obj_amt -- 征信判决诉讼标的金额(诉讼标的金额):EF020J01
    ,cr_jdgmt_endcs_mtdcd -- 征信判决结案方式代码(结案方式):EF020D03
    ,cr_jdgmt_jdgmt_efdt -- 征信判决判决生效日期(判决/调解生效日期):EF020R02
    ,cr_jdgmt_jdgmtrst -- 征信判决判决结果(判决/调解结果):EF020Q04
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_cvljdgmtrcrdinf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_cvljdgmtrcrdinf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);