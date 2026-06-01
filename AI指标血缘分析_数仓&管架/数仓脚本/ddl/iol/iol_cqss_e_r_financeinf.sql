/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_financeinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_financeinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_financeinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_financeinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id number(14,0) -- 征信上级记录编号(上级序号)
    ,cr_fnc_idx_id varchar2(15) -- 征信财务指标编号
    ,cr_fnc_idx_val number(15,0) -- 征信财务指标值
    ,crt_dt_tm date -- 创建日期时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cqss_e_r_financeinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_financeinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_financeinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_financeinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_financeinf is '财务报表信息表';
comment on column ${iol_schema}.cqss_e_r_financeinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_financeinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_financeinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_financeinf.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_financeinf.cr_fnc_idx_id is '征信财务指标编号';
comment on column ${iol_schema}.cqss_e_r_financeinf.cr_fnc_idx_val is '征信财务指标值';
comment on column ${iol_schema}.cqss_e_r_financeinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_financeinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_financeinf.etl_timestamp is 'ETL处理时间戳';
