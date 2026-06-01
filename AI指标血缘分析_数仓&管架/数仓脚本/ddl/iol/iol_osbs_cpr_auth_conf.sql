/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_cpr_auth_conf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_cpr_auth_conf
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_cpr_auth_conf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_cpr_auth_conf(
    cac_seqno varchar2(10) -- 序号
    ,cac_ecifno varchar2(32) -- 全行统一客户号
    ,cac_currency varchar2(3) -- 币种(默认CNY)
    ,cac_accno varchar2(32) -- 账号
    ,cac_groupid varchar2(32) -- 功能分组编号
    ,cac_minamount number(15,2) -- 起点金额
    ,cac_maxamount number(15,2) -- 结束金额
    ,cac_channel varchar2(4) -- 
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
grant select on ${iol_schema}.osbs_cpr_auth_conf to ${iml_schema};
grant select on ${iol_schema}.osbs_cpr_auth_conf to ${icl_schema};
grant select on ${iol_schema}.osbs_cpr_auth_conf to ${idl_schema};
grant select on ${iol_schema}.osbs_cpr_auth_conf to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_cpr_auth_conf is '交易审核明细表';
comment on column ${iol_schema}.osbs_cpr_auth_conf.cac_seqno is '序号';
comment on column ${iol_schema}.osbs_cpr_auth_conf.cac_ecifno is '全行统一客户号';
comment on column ${iol_schema}.osbs_cpr_auth_conf.cac_currency is '币种(默认CNY)';
comment on column ${iol_schema}.osbs_cpr_auth_conf.cac_accno is '账号';
comment on column ${iol_schema}.osbs_cpr_auth_conf.cac_groupid is '功能分组编号';
comment on column ${iol_schema}.osbs_cpr_auth_conf.cac_minamount is '起点金额';
comment on column ${iol_schema}.osbs_cpr_auth_conf.cac_maxamount is '结束金额';
comment on column ${iol_schema}.osbs_cpr_auth_conf.cac_channel is '';
comment on column ${iol_schema}.osbs_cpr_auth_conf.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_cpr_auth_conf.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_cpr_auth_conf.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_cpr_auth_conf.etl_timestamp is 'ETL处理时间戳';
