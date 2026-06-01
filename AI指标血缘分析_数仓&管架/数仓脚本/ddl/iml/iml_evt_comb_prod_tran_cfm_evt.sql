/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_comb_prod_tran_cfm_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_comb_prod_tran_cfm_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_comb_prod_tran_cfm_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_comb_prod_tran_cfm_evt(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,ta_cd varchar2(30) -- TA代码
    ,ta_cfm_flow_num varchar2(100) -- TA确认流水号
    ,cfm_dt date -- 确认日期
    ,comb_prod_id varchar2(100) -- 组合产品编号
    ,comb_prod_name varchar2(750) -- 组合产品名称
    ,finc_prod_id varchar2(100) -- 理财产品编号
    ,bank_id varchar2(100) -- 银行编号
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,ext_flow_num varchar2(100) -- 外部流水号
    ,intnal_cust_id varchar2(100) -- 内部客户编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,vtual_bank_acct_id varchar2(100) -- 虚拟银行账户编号
    ,tran_cd varchar2(60) -- 交易代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_lot number(30,8) -- 交易份额
    ,tran_tm timestamp -- 交易时间
    ,cfm_amt number(30,2) -- 确认金额
    ,cfm_lot number(30,8) -- 确认份额
    ,cfm_comm_fee number(30,2) -- 确认手续费
    ,cfm_nv number(18,8) -- 确认净值
    ,bus_cd varchar2(30) -- 业务代码
    ,intior_cd varchar2(30) -- 发起方代码
    ,deflt_divd_way_cd varchar2(30) -- 默认分红方式代码
    ,divd_dt date -- 分红日期
    ,rgst_dt date -- 登记日期
    ,modif_tm timestamp -- 修改时间
    ,return_amt number(30,2) -- 返回金额
    ,err_cd varchar2(150) -- 错误码
    ,err_info_desc varchar2(1500) -- 错误信息描述
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
grant select on ${iml_schema}.evt_comb_prod_tran_cfm_evt to ${icl_schema};
grant select on ${iml_schema}.evt_comb_prod_tran_cfm_evt to ${idl_schema};
grant select on ${iml_schema}.evt_comb_prod_tran_cfm_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_comb_prod_tran_cfm_evt is '组合产品交易确认事件';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.flow_num is '流水号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.ta_cfm_flow_num is 'TA确认流水号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.comb_prod_id is '组合产品编号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.comb_prod_name is '组合产品名称';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.bank_id is '银行编号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.ext_flow_num is '外部流水号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.intnal_cust_id is '内部客户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.cust_id is '客户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.vtual_bank_acct_id is '虚拟银行账户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.tran_lot is '交易份额';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.cfm_amt is '确认金额';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.cfm_lot is '确认份额';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.cfm_comm_fee is '确认手续费';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.cfm_nv is '确认净值';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.bus_cd is '业务代码';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.intior_cd is '发起方代码';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.deflt_divd_way_cd is '默认分红方式代码';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.divd_dt is '分红日期';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.modif_tm is '修改时间';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.return_amt is '返回金额';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.err_cd is '错误码';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_comb_prod_tran_cfm_evt.etl_timestamp is 'ETL处理时间戳';
