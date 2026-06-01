/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_distr_finc_tran_cfm_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_distr_finc_tran_cfm_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_distr_finc_tran_cfm_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_distr_finc_tran_cfm_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_cd varchar2(30) -- 业务代码
    ,ta_cfm_flow_num varchar2(60) -- TA确认流水号
    ,appl_flow_num varchar2(60) -- 申请流水号
    ,seller_id varchar2(60) -- 销售商编号
    ,bank_id varchar2(60) -- 银行编号
    ,brch_id varchar2(60) -- 分行编号
    ,cfm_dt date -- 确认日期
    ,appl_dt date -- 申请日期
    ,finc_acct_id varchar2(60) -- 理财账户编号
    ,ta_tran_acct_id varchar2(60) -- TA交易账户编号
    ,src_prod_id varchar2(60) -- 源产品编号
    ,finc_prod_id varchar2(60) -- 理财产品编号
    ,charge_way_cd varchar2(30) -- 收费方式代码
    ,cfm_amt number(30,2) -- 确认金额
    ,cfm_lot number(30,8) -- 确认份额
    ,prod_nv number(30,8) -- 产品净值
    ,cfm_froz_amt number(30,2) -- 确认冻结金额
    ,cfm_unfrz_amt number(30,2) -- 确认解冻金额
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,finc_cust_id varchar2(60) -- 理财客户编号
    ,invest_prft number(30,2) -- 投资收益
    ,unpaid_prft number(30,2) -- 未付收益
    ,bank_prft number(30,2) -- 银行收益
    ,appl_amt number(30,2) -- 申请金额
    ,appl_lot number(30,8) -- 申请份额
    ,tran_post_lot number(30,8) -- 交易后份额
    ,ta_init_flg varchar2(30) -- TA发起标志
    ,proc_sucs_flg varchar2(30) -- 处理成功标志
    ,return_code varchar2(45) -- 返回码
    ,return_info varchar2(150) -- 返回信息
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
grant select on ${iml_schema}.evt_distr_finc_tran_cfm_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_distr_finc_tran_cfm_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_distr_finc_tran_cfm_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_distr_finc_tran_cfm_dtl is '分销理财交易确认明细';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.bus_cd is '业务代码';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.ta_cfm_flow_num is 'TA确认流水号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.seller_id is '销售商编号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.bank_id is '银行编号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.brch_id is '分行编号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.src_prod_id is '源产品编号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.charge_way_cd is '收费方式代码';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.cfm_amt is '确认金额';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.cfm_lot is '确认份额';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.prod_nv is '产品净值';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.cfm_froz_amt is '确认冻结金额';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.cfm_unfrz_amt is '确认解冻金额';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.finc_cust_id is '理财客户编号';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.invest_prft is '投资收益';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.unpaid_prft is '未付收益';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.bank_prft is '银行收益';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.appl_amt is '申请金额';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.appl_lot is '申请份额';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.tran_post_lot is '交易后份额';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.ta_init_flg is 'TA发起标志';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.proc_sucs_flg is '处理成功标志';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.return_code is '返回码';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.return_info is '返回信息';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_distr_finc_tran_cfm_dtl.etl_timestamp is 'ETL处理时间戳';
