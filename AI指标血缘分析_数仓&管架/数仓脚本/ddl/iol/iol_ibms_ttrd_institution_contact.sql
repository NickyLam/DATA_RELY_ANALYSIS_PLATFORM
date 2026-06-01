/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_institution_contact
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_institution_contact
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_institution_contact purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_institution_contact(
    i_id number(22,0) -- 
    ,c_id number(22,0) -- 
    ,c_prop varchar2(12) -- 
    ,c_name varchar2(75) -- 
    ,c_tel varchar2(30) -- 
    ,c_cellphone varchar2(30) -- 
    ,c_email varchar2(150) -- 
    ,c_i_id number(22,0) -- 
    ,cfets_trader_id varchar2(75) -- 交易员id
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
grant select on ${iol_schema}.ibms_ttrd_institution_contact to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_contact to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_contact to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_contact to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_institution_contact is '机构联系人信息表';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.i_id is '';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.c_id is '';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.c_prop is '';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.c_name is '';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.c_tel is '';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.c_cellphone is '';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.c_email is '';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.c_i_id is '';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.cfets_trader_id is '交易员id';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_institution_contact.etl_timestamp is 'ETL处理时间戳';
