/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a57tappconf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a57tappconf
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a57tappconf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a57tappconf(
    type varchar2(15) -- 参数类型
    ,id varchar2(48) -- 参数id
    ,value varchar2(96) -- 参数值
    ,memo varchar2(96) -- 备注
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
grant select on ${iol_schema}.mpcs_a57tappconf to ${iml_schema};
grant select on ${iol_schema}.mpcs_a57tappconf to ${icl_schema};
grant select on ${iol_schema}.mpcs_a57tappconf to ${idl_schema};
grant select on ${iol_schema}.mpcs_a57tappconf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a57tappconf is '';
comment on column ${iol_schema}.mpcs_a57tappconf.type is '参数类型';
comment on column ${iol_schema}.mpcs_a57tappconf.id is '参数id';
comment on column ${iol_schema}.mpcs_a57tappconf.value is '参数值';
comment on column ${iol_schema}.mpcs_a57tappconf.memo is '备注';
comment on column ${iol_schema}.mpcs_a57tappconf.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a57tappconf.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a57tappconf.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a57tappconf.etl_timestamp is 'ETL处理时间戳';
