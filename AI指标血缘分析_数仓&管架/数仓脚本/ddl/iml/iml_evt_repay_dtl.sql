/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_repay_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_repay_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_repay_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_repay_dtl(
    evt_id varchar2(250) -- 事件编号
    ,callbk_id varchar2(100) -- 回收编号
    ,advise_odd_no varchar2(60) -- 通知单号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,curr_pd number(10) -- 当前期次
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,callbk_curr_cd varchar2(30) -- 回收币种代码
    ,callbk_to_cny_exch_rat number(18,8) -- 回收对人民币汇率
    ,callbk_exch_way_cd varchar2(30) -- 回收汇兑方式代码
    ,callbk_pric number(30,2) -- 回收金额
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,tran_tm timestamp -- 交易时间
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_repay_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_repay_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_repay_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_repay_dtl is '还款明细';
comment on column ${iml_schema}.evt_repay_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_repay_dtl.callbk_id is '回收编号';
comment on column ${iml_schema}.evt_repay_dtl.advise_odd_no is '通知单号';
comment on column ${iml_schema}.evt_repay_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_repay_dtl.acct_id is '账户编号';
comment on column ${iml_schema}.evt_repay_dtl.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_repay_dtl.curr_pd is '当前期次';
comment on column ${iml_schema}.evt_repay_dtl.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.evt_repay_dtl.callbk_curr_cd is '回收币种代码';
comment on column ${iml_schema}.evt_repay_dtl.callbk_to_cny_exch_rat is '回收对人民币汇率';
comment on column ${iml_schema}.evt_repay_dtl.callbk_exch_way_cd is '回收汇兑方式代码';
comment on column ${iml_schema}.evt_repay_dtl.callbk_pric is '回收金额';
comment on column ${iml_schema}.evt_repay_dtl.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_repay_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_repay_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_repay_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_repay_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_repay_dtl.etl_timestamp is 'ETL处理时间戳';
