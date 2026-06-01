/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdws_a_cm_cust_nmb_login
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdws_a_cm_cust_nmb_login
whenever sqlerror continue none;
drop table ${iol_schema}.bdws_a_cm_cust_nmb_login purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdws_a_cm_cust_nmb_login(
    cust_id varchar2(4000) -- 客户号
    ,is_login_last varchar2(4000) -- 上月是否登录手机银行
    ,is_login varchar2(4000) -- 本月是否登录手机银行
    ,sleep_acct_flg varchar2(4000) -- 睡眠户标识
    ,long_hang_acct_flg varchar2(4000) -- 久悬户标识
    ,is_kjzf_sign varchar2(4000) -- 快捷支付签约
    ,kjzf_hpd_last varchar2(4000) -- 上月是否发生快捷支付
    ,kjzf_hpd varchar2(4000) -- 本月是否发生快捷支付
    ,load_date varchar2(4000) -- 分区字段
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdws_a_cm_cust_nmb_login to ${iml_schema};
grant select on ${iol_schema}.bdws_a_cm_cust_nmb_login to ${icl_schema};
grant select on ${iol_schema}.bdws_a_cm_cust_nmb_login to ${idl_schema};
grant select on ${iol_schema}.bdws_a_cm_cust_nmb_login to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdws_a_cm_cust_nmb_login is '客户活跃情况';
comment on column ${iol_schema}.bdws_a_cm_cust_nmb_login.cust_id is '客户号';
comment on column ${iol_schema}.bdws_a_cm_cust_nmb_login.is_login_last is '上月是否登录手机银行';
comment on column ${iol_schema}.bdws_a_cm_cust_nmb_login.is_login is '本月是否登录手机银行';
comment on column ${iol_schema}.bdws_a_cm_cust_nmb_login.sleep_acct_flg is '睡眠户标识';
comment on column ${iol_schema}.bdws_a_cm_cust_nmb_login.long_hang_acct_flg is '久悬户标识';
comment on column ${iol_schema}.bdws_a_cm_cust_nmb_login.is_kjzf_sign is '快捷支付签约';
comment on column ${iol_schema}.bdws_a_cm_cust_nmb_login.kjzf_hpd_last is '上月是否发生快捷支付';
comment on column ${iol_schema}.bdws_a_cm_cust_nmb_login.kjzf_hpd is '本月是否发生快捷支付';
comment on column ${iol_schema}.bdws_a_cm_cust_nmb_login.load_date is '分区字段';
comment on column ${iol_schema}.bdws_a_cm_cust_nmb_login.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdws_a_cm_cust_nmb_login.etl_timestamp is 'ETL处理时间戳';
