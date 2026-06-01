/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_financebasicinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_financebasicinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_financebasicinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_financebasicinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,inf_unit_tp varchar2(45) -- 信息单元类型
    ,fnrpt_prj_id varchar2(9) -- 财务报表编号
    ,bsmgt_inst_tp varchar2(5) -- 业务管理机构类型
    ,bsmgt_insid varchar2(192) -- 业务管理机构代码
    ,yr_yyyy varchar2(6) -- 报表年份
    ,rpt_tp varchar2(14) -- 报表类型
    ,rptfrmtp_sbdvsn varchar2(5) -- 报表类型细分
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
grant select on ${iol_schema}.cqss_e_r_financebasicinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_financebasicinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_financebasicinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_financebasicinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_financebasicinf is '财务报表基础表';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.inf_unit_tp is '信息单元类型';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.fnrpt_prj_id is '财务报表编号';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.bsmgt_inst_tp is '业务管理机构类型';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.bsmgt_insid is '业务管理机构代码';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.yr_yyyy is '报表年份';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.rpt_tp is '报表类型';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.rptfrmtp_sbdvsn is '报表类型细分';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_financebasicinf.etl_timestamp is 'ETL处理时间戳';
