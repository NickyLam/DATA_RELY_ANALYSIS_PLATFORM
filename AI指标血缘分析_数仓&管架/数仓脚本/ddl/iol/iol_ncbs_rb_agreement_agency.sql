/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_agency
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_agency
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_agency purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_agency(
    client_no varchar2(16) -- 客户编号
    ,agency_type varchar2(1) -- 代发代扣类型
    ,agreement_id varchar2(50) -- 协议编号
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_agreement_agency to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_agency to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_agency to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_agency to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_agency is '代发代扣签约协议表';
comment on column ${iol_schema}.ncbs_rb_agreement_agency.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_agency.agency_type is '代发代扣类型';
comment on column ${iol_schema}.ncbs_rb_agreement_agency.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_agency.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_agency.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_agency.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_agency.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_agency.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_agency.etl_timestamp is 'ETL处理时间戳';
