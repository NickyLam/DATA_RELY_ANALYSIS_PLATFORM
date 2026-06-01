/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_fncszctrlinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_fncszctrlinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_fncszctrlinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_fncszctrlinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef140i01
    ,blng_nm_rcrd varchar2(2) -- 所属名记录(所属名录):ef140d01
    ,fnc_cltp varchar2(2) -- 融资控制类型:ef140d02
    ,fnc_ctrl_anul varchar2(6) -- 融资控制年度(年度):ef140r01
    ,sz_amt number(38,0) -- 规模:ef140j01
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
grant select on ${iol_schema}.cqss_e_r_fncszctrlinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_fncszctrlinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_fncszctrlinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_fncszctrlinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_fncszctrlinf is '融资规模控制信息';
comment on column ${iol_schema}.cqss_e_r_fncszctrlinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_fncszctrlinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_fncszctrlinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_fncszctrlinf.cr_inf_id is '征信信息编号:ef140i01';
comment on column ${iol_schema}.cqss_e_r_fncszctrlinf.blng_nm_rcrd is '所属名记录(所属名录):ef140d01';
comment on column ${iol_schema}.cqss_e_r_fncszctrlinf.fnc_cltp is '融资控制类型:ef140d02';
comment on column ${iol_schema}.cqss_e_r_fncszctrlinf.fnc_ctrl_anul is '融资控制年度(年度):ef140r01';
comment on column ${iol_schema}.cqss_e_r_fncszctrlinf.sz_amt is '规模:ef140j01';
comment on column ${iol_schema}.cqss_e_r_fncszctrlinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_fncszctrlinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_fncszctrlinf.etl_timestamp is 'ETL处理时间戳';
