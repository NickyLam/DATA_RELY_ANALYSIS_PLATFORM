/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl non_red_tax_info_ctrler_tax_info_fund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund
whenever sqlerror continue none;
drop table ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund(
    etl_dt date -- 数据日期
    ,acc_type varchar2(10) -- 客户标识类型
    ,account varchar2(60) -- 客户标识
    ,trans_date date -- 交易日期
    ,client_type varchar2(10) -- 客户类型
    ,resident_tax_nation varchar2(20) -- 控制人税收居民国（地区）
    ,resident_tax_id varchar2(500) -- 控制人纳税识别号
    ,resident_tax_nation_unreason varchar2(3000) -- 控制人不能提供居民国（地区）纳税人识别号原因
    ,resident_tax_id_unreason varchar2(3000) -- 控制人未能取得纳税人识别号原因
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund to ${iel_schema};

-- comment
comment on table ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund is '非居民涉税信息控制人纳税信息表(增量)';
comment on column ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund.etl_dt is '数据日期';
comment on column ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund.acc_type is '客户标识类型';
comment on column ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund.account is '客户标识';
comment on column ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund.trans_date is '交易日期';
comment on column ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund.client_type is '客户类型';
comment on column ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund.resident_tax_nation is '控制人税收居民国（地区）';
comment on column ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund.resident_tax_id is '控制人纳税识别号';
comment on column ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund.resident_tax_nation_unreason is '控制人不能提供居民国（地区）纳税人识别号原因';
comment on column ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund.resident_tax_id_unreason is '控制人未能取得纳税人识别号原因';
comment on column ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund.job_cd is '任务编码';
comment on column ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund.etl_timestamp is 'ETL处理时间戳';