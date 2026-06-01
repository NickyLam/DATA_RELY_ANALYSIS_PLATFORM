/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_specialeventinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_specialeventinfo
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_specialeventinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_specialeventinfo(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,mo varchar2(11) -- 月份:pd01gr01
    ,spcl_ev_tp varchar2(9) -- 特殊事件类型:pd01gd01
    ,multi_tenancy_id varchar2(30) -- 多实体标识
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
grant select on ${iol_schema}.cqss_i_r_specialeventinfo to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_specialeventinfo to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_specialeventinfo to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_specialeventinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_specialeventinfo is '二代借贷账户特殊事件说明信息';
comment on column ${iol_schema}.cqss_i_r_specialeventinfo.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_specialeventinfo.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_specialeventinfo.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_specialeventinfo.mo is '月份:pd01gr01';
comment on column ${iol_schema}.cqss_i_r_specialeventinfo.spcl_ev_tp is '特殊事件类型:pd01gd01';
comment on column ${iol_schema}.cqss_i_r_specialeventinfo.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_specialeventinfo.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_specialeventinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_specialeventinfo.etl_timestamp is 'ETL处理时间戳';
