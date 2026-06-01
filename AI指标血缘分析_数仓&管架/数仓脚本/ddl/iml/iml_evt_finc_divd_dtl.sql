/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_finc_divd_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_finc_divd_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_finc_divd_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_divd_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(60) -- 产品编号
    ,ta_cd varchar2(30) -- TA代码
    ,cfm_dt date -- 确认日期
    ,ta_cfm_flow_num varchar2(60) -- TA确认流水号
    ,bus_cd varchar2(30) -- 业务代码
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,finc_cust_id varchar2(60) -- 理财客户编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,finc_acct_id varchar2(60) -- 理财账户编号
    ,cust_id varchar2(60) -- 交易客户编号
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,ta_tran_acct_id varchar2(60) -- TA交易账户编号
    ,divd_base number(18,6) -- 分红基数
    ,corp_divd number(18,8) -- 单位分红
    ,divd_way_cd varchar2(30) -- 分红方式代码
    ,bonus_tot_amt number(30,2) -- 红利总金额
    ,curr_cd varchar2(30) -- 币种代码
    ,actl_bonus number(30,2) -- 实发红利
    ,eqty_rgst_dt date -- 权益登记日期
    ,divd_dt date -- 分红日期
    ,ex_righ_dt date -- 除权日期
    ,aft_tran_lot number(18,6) -- 交易后份额
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
grant select on ${iml_schema}.evt_finc_divd_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_finc_divd_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_finc_divd_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_finc_divd_dtl is '理财分红明细';
comment on column ${iml_schema}.evt_finc_divd_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_finc_divd_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_finc_divd_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_finc_divd_dtl.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_finc_divd_dtl.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_finc_divd_dtl.ta_cfm_flow_num is 'TA确认流水号';
comment on column ${iml_schema}.evt_finc_divd_dtl.bus_cd is '业务代码';
comment on column ${iml_schema}.evt_finc_divd_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_finc_divd_dtl.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.evt_finc_divd_dtl.finc_cust_id is '理财客户编号';
comment on column ${iml_schema}.evt_finc_divd_dtl.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_finc_divd_dtl.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.evt_finc_divd_dtl.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_finc_divd_dtl.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.evt_finc_divd_dtl.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.evt_finc_divd_dtl.divd_base is '分红基数';
comment on column ${iml_schema}.evt_finc_divd_dtl.corp_divd is '单位分红';
comment on column ${iml_schema}.evt_finc_divd_dtl.divd_way_cd is '分红方式代码';
comment on column ${iml_schema}.evt_finc_divd_dtl.bonus_tot_amt is '红利总金额';
comment on column ${iml_schema}.evt_finc_divd_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_finc_divd_dtl.actl_bonus is '实发红利';
comment on column ${iml_schema}.evt_finc_divd_dtl.eqty_rgst_dt is '权益登记日期';
comment on column ${iml_schema}.evt_finc_divd_dtl.divd_dt is '分红日期';
comment on column ${iml_schema}.evt_finc_divd_dtl.ex_righ_dt is '除权日期';
comment on column ${iml_schema}.evt_finc_divd_dtl.aft_tran_lot is '交易后份额';
comment on column ${iml_schema}.evt_finc_divd_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_finc_divd_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_finc_divd_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_finc_divd_dtl.etl_timestamp is 'ETL处理时间戳';
