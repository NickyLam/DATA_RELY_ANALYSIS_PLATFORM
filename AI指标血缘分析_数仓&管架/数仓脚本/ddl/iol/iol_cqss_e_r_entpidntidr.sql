/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_entpidntidr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_entpidntidr
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_entpidntidr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_entpidntidr(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,entp_idnt_idr_tp varchar2(3) -- 企业身份标识类型:ea01cd01
    ,entp_idnt_idr_no varchar2(180) -- 企业身份标识号码:ea01ci01
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
grant select on ${iol_schema}.cqss_e_r_entpidntidr to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_entpidntidr to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_entpidntidr to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_entpidntidr to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_entpidntidr is '二代企业身份标识';
comment on column ${iol_schema}.cqss_e_r_entpidntidr.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_entpidntidr.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_entpidntidr.entp_idnt_idr_tp is '企业身份标识类型:ea01cd01';
comment on column ${iol_schema}.cqss_e_r_entpidntidr.entp_idnt_idr_no is '企业身份标识号码:ea01ci01';
comment on column ${iol_schema}.cqss_e_r_entpidntidr.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_entpidntidr.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_entpidntidr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_entpidntidr.etl_timestamp is 'ETL处理时间戳';
