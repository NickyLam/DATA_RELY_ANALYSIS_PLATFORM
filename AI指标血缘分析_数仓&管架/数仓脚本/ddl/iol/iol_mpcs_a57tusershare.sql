/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a57tusershare
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a57tusershare
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a57tusershare purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a57tusershare(
    custno varchar2(48) -- 客户号
    ,acctno varchar2(48) -- 结算账号
    ,usershare varchar2(48) -- 用户总份额
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
grant select on ${iol_schema}.mpcs_a57tusershare to ${iml_schema};
grant select on ${iol_schema}.mpcs_a57tusershare to ${icl_schema};
grant select on ${iol_schema}.mpcs_a57tusershare to ${idl_schema};
grant select on ${iol_schema}.mpcs_a57tusershare to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a57tusershare is '';
comment on column ${iol_schema}.mpcs_a57tusershare.custno is '客户号';
comment on column ${iol_schema}.mpcs_a57tusershare.acctno is '结算账号';
comment on column ${iol_schema}.mpcs_a57tusershare.usershare is '用户总份额';
comment on column ${iol_schema}.mpcs_a57tusershare.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a57tusershare.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a57tusershare.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a57tusershare.etl_timestamp is 'ETL处理时间戳';
