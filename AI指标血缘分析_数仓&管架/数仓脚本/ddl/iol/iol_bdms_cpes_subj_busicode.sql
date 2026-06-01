/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_subj_busicode
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_subj_busicode
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_subj_busicode purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_subj_busicode(
    subj_no varchar2(45) -- 科目号
    ,subj_name varchar2(300) -- 科目名称
    ,busi_code varchar2(24) -- 业务编码
    ,misc varchar2(192) -- 备注
    ,amount_type varchar2(3) -- 金额类型
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
grant select on ${iol_schema}.bdms_cpes_subj_busicode to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_subj_busicode to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_subj_busicode to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_subj_busicode to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_subj_busicode is '业务编码和科目关系';
comment on column ${iol_schema}.bdms_cpes_subj_busicode.subj_no is '科目号';
comment on column ${iol_schema}.bdms_cpes_subj_busicode.subj_name is '科目名称';
comment on column ${iol_schema}.bdms_cpes_subj_busicode.busi_code is '业务编码';
comment on column ${iol_schema}.bdms_cpes_subj_busicode.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_subj_busicode.amount_type is '金额类型';
comment on column ${iol_schema}.bdms_cpes_subj_busicode.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_subj_busicode.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_subj_busicode.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_subj_busicode.etl_timestamp is 'ETL处理时间戳';
