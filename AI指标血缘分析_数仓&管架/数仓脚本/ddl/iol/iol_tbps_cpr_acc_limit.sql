/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_acc_limit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_acc_limit
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_acc_limit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_acc_limit(
    cal_ecifno varchar2(32) -- 客户号
    ,cal_accno varchar2(32) -- 账号
    ,cal_userno varchar2(32) -- 用户顺序号
    ,cal_argname varchar2(32) -- 属性名
    ,cal_argvalue varchar2(1024) -- 属性值
    ,cal_channel varchar2(16) -- 渠道
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbps_cpr_acc_limit to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_acc_limit to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_acc_limit to ${idl_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_acc_limit is '账户级限额设置表';
comment on column ${iol_schema}.tbps_cpr_acc_limit.cal_ecifno is '客户号';
comment on column ${iol_schema}.tbps_cpr_acc_limit.cal_accno is '账号';
comment on column ${iol_schema}.tbps_cpr_acc_limit.cal_userno is '用户顺序号';
comment on column ${iol_schema}.tbps_cpr_acc_limit.cal_argname is '属性名';
comment on column ${iol_schema}.tbps_cpr_acc_limit.cal_argvalue is '属性值';
comment on column ${iol_schema}.tbps_cpr_acc_limit.cal_channel is '渠道';
comment on column ${iol_schema}.tbps_cpr_acc_limit.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_acc_limit.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_acc_limit.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_acc_limit.etl_timestamp is 'ETL处理时间戳';
