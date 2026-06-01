/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t3b_seif_n_hst
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
drop table ${iol_schema}.amls_t3b_seif_n_hst_ex purge;
alter table ${iol_schema}.amls_t3b_seif_n_hst add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.amls_t3b_seif_n_hst;

-- 2.3 insert data to ex table
create table ${iol_schema}.amls_t3b_seif_n_hst_ex nologging
compress
as
select * from ${iol_schema}.amls_t3b_seif_n_hst where 0=1;

insert /*+ append */ into ${iol_schema}.amls_t3b_seif_n_hst_ex(
    rpt_id -- 报告编号
    ,stat_dt -- 数据日期
    ,seif_seq -- 客户序号
    ,csnm -- 客户号
    ,sevc -- 可疑主体职业（对私）或行业（对公）
    ,senm -- 可疑主体姓名/名称
    ,setp -- 可疑主体身份证件/证明文件类型
    ,oitp -- 其他身份证件/证明文件类型
    ,seid -- 可疑主体身份证件/证明文件号码
    ,stnt -- 可疑主体国籍
    ,sctl1 -- 可疑主体联系电话1
    ,sctl2 -- 可疑主体联系电话2
    ,sear1 -- 可疑主体住址/经营地址1
    ,sear2 -- 可疑主体住址/经营地址2
    ,seei1 -- 可疑主体其他联系方式1
    ,seei2 -- 可疑主体其他联系方式2
    ,srnm -- 可疑主体法定代表人姓名
    ,srit -- 可疑主体法定代表人身份证件类型
    ,orit -- 可疑主体法定代表人其他身份证件/证明文件类型
    ,srid -- 可疑主体法定代表人身份证件号码
    ,scnm -- 可疑主体控股股东或实际控制人名称
    ,scit -- 可疑主体控股股东或实际控制人身份证件/证明文件类型
    ,ocit -- 可疑主体控股股东或实际控制人其他身份证件/证明文件类型
    ,scid -- 可疑主体控股股东或实际控制人身份证件/证明文件号码
    ,bs_valid -- 可疑验证（参见[字典:AML0042]））
    ,err_type -- 1:补正，2：重报
    ,pbc_rcpt_tm -- 人行回执时间
    ,cust_type -- 客户类型
    ,org_id -- 归属机构编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    rpt_id -- 报告编号
    ,stat_dt -- 数据日期
    ,seif_seq -- 客户序号
    ,csnm -- 客户号
    ,sevc -- 可疑主体职业（对私）或行业（对公）
    ,senm -- 可疑主体姓名/名称
    ,setp -- 可疑主体身份证件/证明文件类型
    ,oitp -- 其他身份证件/证明文件类型
    ,seid -- 可疑主体身份证件/证明文件号码
    ,stnt -- 可疑主体国籍
    ,sctl1 -- 可疑主体联系电话1
    ,sctl2 -- 可疑主体联系电话2
    ,sear1 -- 可疑主体住址/经营地址1
    ,sear2 -- 可疑主体住址/经营地址2
    ,seei1 -- 可疑主体其他联系方式1
    ,seei2 -- 可疑主体其他联系方式2
    ,srnm -- 可疑主体法定代表人姓名
    ,srit -- 可疑主体法定代表人身份证件类型
    ,orit -- 可疑主体法定代表人其他身份证件/证明文件类型
    ,srid -- 可疑主体法定代表人身份证件号码
    ,scnm -- 可疑主体控股股东或实际控制人名称
    ,scit -- 可疑主体控股股东或实际控制人身份证件/证明文件类型
    ,ocit -- 可疑主体控股股东或实际控制人其他身份证件/证明文件类型
    ,scid -- 可疑主体控股股东或实际控制人身份证件/证明文件号码
    ,bs_valid -- 可疑验证（参见[字典:AML0042]））
    ,err_type -- 1:补正，2：重报
    ,pbc_rcpt_tm -- 人行回执时间
    ,cust_type -- 客户类型
    ,org_id -- 归属机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.amls_t3b_seif_n_hst
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.amls_t3b_seif_n_hst exchange partition p_${batch_date} with table ${iol_schema}.amls_t3b_seif_n_hst_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t3b_seif_n_hst to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.amls_t3b_seif_n_hst_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t3b_seif_n_hst',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);