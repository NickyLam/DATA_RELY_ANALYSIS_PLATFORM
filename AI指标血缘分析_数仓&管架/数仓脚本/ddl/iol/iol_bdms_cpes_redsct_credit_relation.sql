/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_redsct_credit_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_redsct_credit_relation
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_redsct_credit_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_redsct_credit_relation(
    id varchar2(60) -- 
    ,mem_brh_no varchar2(15) -- 会员机构代码
    ,pcb_brh_no varchar2(15) -- 人行机构代码
    ,is_valid varchar2(2) -- 是否有效： 0 否 1 是
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
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
grant select on ${iol_schema}.bdms_cpes_redsct_credit_relation to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_credit_relation to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_credit_relation to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_credit_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_redsct_credit_relation is '再贴现授信关系信息表';
comment on column ${iol_schema}.bdms_cpes_redsct_credit_relation.id is '';
comment on column ${iol_schema}.bdms_cpes_redsct_credit_relation.mem_brh_no is '会员机构代码';
comment on column ${iol_schema}.bdms_cpes_redsct_credit_relation.pcb_brh_no is '人行机构代码';
comment on column ${iol_schema}.bdms_cpes_redsct_credit_relation.is_valid is '是否有效： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_redsct_credit_relation.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_redsct_credit_relation.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_redsct_credit_relation.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_redsct_credit_relation.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_redsct_credit_relation.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_redsct_credit_relation.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_redsct_credit_relation.etl_timestamp is 'ETL处理时间戳';
