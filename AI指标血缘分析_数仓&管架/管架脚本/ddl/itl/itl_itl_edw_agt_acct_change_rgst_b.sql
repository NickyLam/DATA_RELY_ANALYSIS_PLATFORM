/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_agt_acct_change_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_agt_acct_change_rgst_b
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_agt_acct_change_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_agt_acct_change_rgst_b(
    etl_dt date -- 数据日期
    ,agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,old_acct_id varchar2(60) -- 旧账户编号
    ,new_acct_id varchar2(60) -- 新账户编号
    ,tran_dt date -- 交易日期
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,advised_midgrod_flg varchar2(10) -- 已通知中台标志
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,etl_timestamp timestamp -- ETL处理时间戳
    ,job_cd  varchar2(10) -- 任务编码
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_agt_acct_change_rgst_b to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_agt_acct_change_rgst_b is '账号更换登记簿';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.agt_id is '协议编号';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.old_acct_id is '旧账户编号';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.new_acct_id is '新账户编号';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.tran_dt is '交易日期';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.tran_flow_num is '交易流水号';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.advised_midgrod_flg is '已通知中台标志';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.tran_org_id is '交易机构编号';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.tran_teller_id is '交易柜员编号';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.etl_timestamp is 'ETL处理时间戳';
comment on column ${itl_schema}.itl_edw_agt_acct_change_rgst_b.job_cd is '任务编码';