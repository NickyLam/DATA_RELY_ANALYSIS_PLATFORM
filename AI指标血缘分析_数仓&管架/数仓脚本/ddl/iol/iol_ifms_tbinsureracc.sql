/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbinsureracc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbinsureracc
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbinsureracc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsureracc(
    ta_code varchar2(14) -- ta代码
    ,branch_no varchar2(24) -- 机构编号
    ,curr_type varchar2(5) -- 币种
    ,acc_type varchar2(5) -- 账号类型0-内部户1-保险公司账户2-代收传账户
    ,account_no varchar2(48) -- 账号
    ,account_name varchar2(120) -- 账号名称
    ,account_openno varchar2(24) -- 账号行号
    ,account_open varchar2(90) -- 账号开户行名称
    ,reserve1 varchar2(375) -- 备用字段1
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
grant select on ${iol_schema}.ifms_tbinsureracc to ${iml_schema};
grant select on ${iol_schema}.ifms_tbinsureracc to ${icl_schema};
grant select on ${iol_schema}.ifms_tbinsureracc to ${idl_schema};
grant select on ${iol_schema}.ifms_tbinsureracc to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbinsureracc is '保险公司账号表';
comment on column ${iol_schema}.ifms_tbinsureracc.ta_code is 'ta代码';
comment on column ${iol_schema}.ifms_tbinsureracc.branch_no is '机构编号';
comment on column ${iol_schema}.ifms_tbinsureracc.curr_type is '币种';
comment on column ${iol_schema}.ifms_tbinsureracc.acc_type is '账号类型0-内部户1-保险公司账户2-代收传账户';
comment on column ${iol_schema}.ifms_tbinsureracc.account_no is '账号';
comment on column ${iol_schema}.ifms_tbinsureracc.account_name is '账号名称';
comment on column ${iol_schema}.ifms_tbinsureracc.account_openno is '账号行号';
comment on column ${iol_schema}.ifms_tbinsureracc.account_open is '账号开户行名称';
comment on column ${iol_schema}.ifms_tbinsureracc.reserve1 is '备用字段1';
comment on column ${iol_schema}.ifms_tbinsureracc.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbinsureracc.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbinsureracc.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbinsureracc.etl_timestamp is 'ETL处理时间戳';
