/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_bank_credit_rel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_bank_credit_rel
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_bank_credit_rel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_bank_credit_rel(
    id number(22) -- 
    ,bank_id number(22) -- 同业额度银行id
    ,bank_name varchar2(192) -- 银行名称
    ,union_no varchar2(24) -- 联行号
    ,remark varchar2(96) -- 备注
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
grant select on ${iol_schema}.bdps_bank_credit_rel to ${iml_schema};
grant select on ${iol_schema}.bdps_bank_credit_rel to ${icl_schema};
grant select on ${iol_schema}.bdps_bank_credit_rel to ${idl_schema};
grant select on ${iol_schema}.bdps_bank_credit_rel to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_bank_credit_rel is '同业客理-总行和联行关系表';
comment on column ${iol_schema}.bdps_bank_credit_rel.id is '';
comment on column ${iol_schema}.bdps_bank_credit_rel.bank_id is '同业额度银行id';
comment on column ${iol_schema}.bdps_bank_credit_rel.bank_name is '银行名称';
comment on column ${iol_schema}.bdps_bank_credit_rel.union_no is '联行号';
comment on column ${iol_schema}.bdps_bank_credit_rel.remark is '备注';
comment on column ${iol_schema}.bdps_bank_credit_rel.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_bank_credit_rel.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_bank_credit_rel.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_bank_credit_rel.etl_timestamp is 'ETL处理时间戳';
