/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_otheridentitytype
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_otheridentitytype
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_otheridentitytype purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_otheridentitytype(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,pbc_tngncr_pts_tpcd varchar2(9) -- 人行二代证件类型代码:pa01cd01
    ,crrptenqd_psn_crdt_no varchar2(90) -- 信用报告被查询人证件号码:pa01ci01
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
grant select on ${iol_schema}.cqss_i_r_otheridentitytype to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_otheridentitytype to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_otheridentitytype to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_otheridentitytype to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_otheridentitytype is '二代其他身份标识';
comment on column ${iol_schema}.cqss_i_r_otheridentitytype.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_otheridentitytype.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_otheridentitytype.pbc_tngncr_pts_tpcd is '人行二代证件类型代码:pa01cd01';
comment on column ${iol_schema}.cqss_i_r_otheridentitytype.crrptenqd_psn_crdt_no is '信用报告被查询人证件号码:pa01ci01';
comment on column ${iol_schema}.cqss_i_r_otheridentitytype.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_otheridentitytype.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_otheridentitytype.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_otheridentitytype.etl_timestamp is 'ETL处理时间戳';
