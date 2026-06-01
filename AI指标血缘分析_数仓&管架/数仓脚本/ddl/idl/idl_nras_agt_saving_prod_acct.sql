/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl nras_agt_saving_prod_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.nras_agt_saving_prod_acct
whenever sqlerror continue none;
drop table ${idl_schema}.nras_agt_saving_prod_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.nras_agt_saving_prod_acct(
    etl_dt date -- 数据日期
    ,agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,fin_acct_id varchar2(60) -- 金融账户编号
    ,sign_acct_num varchar2(60) -- 签约账号
    ,prod_acct_id varchar2(60) -- 产品账户编号
    ,org_id varchar2(60) -- 机构编号
    ,cust_id varchar2(60) -- 客户编号
    ,acct_sign_id varchar2(60) -- 账户签约编号
    ,acct_name varchar2(100) -- 账户名称
    ,curr_cd varchar2(10) -- 币种代码
    ,actl_bal number(30,2) -- 实际余额
    ,aval_bal number(30,2) -- 可用余额
    ,fin_acct_type_cd varchar2(10) -- 金融账户类型代码
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,acct_type_cd varchar2(10) -- 账户类型代码
    ,acct_dt date -- 账务日期
    ,open_acct_dt date -- 开户日期
    ,clos_acct_dt date -- 销户日期
    ,open_acct_tm timestamp -- 开户时间
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.nras_agt_saving_prod_acct to ${iel_schema};

-- comment
comment on table ${idl_schema}.nras_agt_saving_prod_acct is '储蓄产品账户';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.etl_dt is '数据日期';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.agt_id is '协议编号';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.lp_id is '法人编号';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.fin_acct_id is '金融账户编号';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.sign_acct_num is '签约账号';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.prod_acct_id is '产品账户编号';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.org_id is '机构编号';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.cust_id is '客户编号';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.acct_sign_id is '账户签约编号';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.acct_name is '账户名称';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.curr_cd is '币种代码';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.actl_bal is '实际余额';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.aval_bal is '可用余额';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.fin_acct_type_cd is '金融账户类型代码';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.acct_status_cd is '账户状态代码';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.acct_type_cd is '账户类型代码';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.acct_dt is '账务日期';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.open_acct_dt is '开户日期';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.clos_acct_dt is '销户日期';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.open_acct_tm is '开户时间';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.job_cd is '任务代码';
comment on column ${idl_schema}.nras_agt_saving_prod_acct.etl_timestamp is '数据处理时间';
