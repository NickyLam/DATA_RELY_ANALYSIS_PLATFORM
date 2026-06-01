/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_fund_tran_ctl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_fund_tran_ctl
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_fund_tran_ctl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fund_tran_ctl(
    acct_class varchar2(1) -- 账户等级
    ,company varchar2(20) -- 法人
    ,ctl_attr varchar2(50) -- 控制参数
    ,ctl_desc varchar2(50) -- 控制交易类型描述
    ,ctl_parameter varchar2(20) -- 控制交易类型
    ,ctl_type varchar2(1) -- 控制方式
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
grant select on ${iol_schema}.ncbs_rb_fund_tran_ctl to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_fund_tran_ctl to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_fund_tran_ctl to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_fund_tran_ctl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_fund_tran_ctl is '账户类别交易控制表';
comment on column ${iol_schema}.ncbs_rb_fund_tran_ctl.acct_class is '账户等级';
comment on column ${iol_schema}.ncbs_rb_fund_tran_ctl.company is '法人';
comment on column ${iol_schema}.ncbs_rb_fund_tran_ctl.ctl_attr is '控制参数';
comment on column ${iol_schema}.ncbs_rb_fund_tran_ctl.ctl_desc is '控制交易类型描述';
comment on column ${iol_schema}.ncbs_rb_fund_tran_ctl.ctl_parameter is '控制交易类型';
comment on column ${iol_schema}.ncbs_rb_fund_tran_ctl.ctl_type is '控制方式';
comment on column ${iol_schema}.ncbs_rb_fund_tran_ctl.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_fund_tran_ctl.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_fund_tran_ctl.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_fund_tran_ctl.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_fund_tran_ctl.etl_timestamp is 'ETL处理时间戳';
