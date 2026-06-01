/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_consmt_fund_tran_cfm_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_consmt_fund_tran_cfm_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_consmt_fund_tran_cfm_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_consmt_fund_tran_cfm_evt(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,ta_cd varchar2(30) -- TA代码
    ,cfm_dt date -- 确认日期
    ,ta_cfm_flow_num varchar2(60) -- TA确认流水号
    ,init_cfm_flow_num varchar2(60) -- 原确认流水号
    ,intior_cd varchar2(30) -- 发起方代码
    ,appl_dt date -- 申请日期
    ,appl_tm timestamp -- 申请时间
    ,clear_dt date -- 清算日期
    ,appl_flow_num varchar2(60) -- 申请流水号
    ,tran_code varchar2(45) -- 交易码
    ,bus_cd varchar2(30) -- 业务代码
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,tran_belong_org_id varchar2(100) -- 交易所属机构编号
    ,tran_chn_cd varchar2(30) -- 交易渠道编号
    ,finc_cust_id varchar2(60) -- 理财客户编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,finc_acct_id varchar2(60) -- 理财账户编号
    ,cust_id varchar2(60) -- 交易客户编号
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,ta_tran_acct_id varchar2(60) -- TA交易账户编号
    ,tran_med_type_cd varchar2(30) -- 交易介质类型代码
    ,tran_med_id varchar2(60) -- 交易介质编号
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,finc_prod_id varchar2(60) -- 理财产品编号
    ,charge_way_cd varchar2(30) -- 收费方式代码
    ,prod_nv number(30,8) -- 产品净值
    ,tran_price number(26,12) -- 交易价格
    ,tran_amt number(30,2) -- 交易金额
    ,curr_cd varchar2(30) -- 币种代码
    ,cfm_amt number(30,2) -- 确认金额
    ,tran_lot number(18,6) -- 交易份额
    ,cfm_lot number(18,6) -- 确认份额
    ,huge_redem_proc_cd varchar2(30) -- 巨额赎回处理代码
    ,force_redem_rs_cd varchar2(30) -- 强行赎回原因代码
    ,cotin_froz_amt number(18,6) -- 继续冻结金额
    ,lot_accu_accum number(18,6) -- 份额累积积数
    ,dtl_flg varchar2(30) -- 明细标志
    ,froz_rs_cd varchar2(30) -- 冻结原因代码
    ,tran_dir_cd varchar2(30) -- 转换方向代码
    ,divd_way_cd varchar2(30) -- 分红方式代码
    ,return_code varchar2(45) -- 返回码
    ,return_info varchar2(1000) -- 返回信息
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,rela_dt date -- 关联日期
    ,rela_flow_num varchar2(60) -- 关联流水号
    ,intior_flow_num varchar2(60) -- 发起方流水号
    ,cont_id varchar2(60) -- 合约编号
    ,host_dt date -- 主机日期
    ,host_flow_num varchar2(60) -- 主机流水号
    ,tran_post_lot number(18,6) -- 交易后份额
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,comm_fee number(30,2) -- 手续费
    ,agent_fee number(18,6) -- 代理费
    ,bank_comm_fee number(30,2) -- 银行手续费
    ,target_prod_id varchar2(60) -- 目标产品编号
    ,target_prod_nv number(30,8) -- 目标产品净值
    ,target_prod_price number(30,8) -- 目标产品价格
    ,target_prod_cfm_lot number(30,8) -- 目标产品确认份额
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
grant select on ${iml_schema}.evt_consmt_fund_tran_cfm_evt to ${icl_schema};
grant select on ${iml_schema}.evt_consmt_fund_tran_cfm_evt to ${idl_schema};
grant select on ${iml_schema}.evt_consmt_fund_tran_cfm_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_consmt_fund_tran_cfm_evt is '代销基金交易确认事件';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.ta_cfm_flow_num is 'TA确认流水号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.init_cfm_flow_num is '原确认流水号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.intior_cd is '发起方代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.appl_tm is '申请时间';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_code is '交易码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.bus_cd is '业务代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_belong_org_id is '交易所属机构编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_chn_cd is '交易渠道编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.finc_cust_id is '理财客户编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_med_type_cd is '交易介质类型代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_med_id is '交易介质编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.charge_way_cd is '收费方式代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.prod_nv is '产品净值';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_price is '交易价格';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.cfm_amt is '确认金额';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_lot is '交易份额';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.cfm_lot is '确认份额';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.huge_redem_proc_cd is '巨额赎回处理代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.force_redem_rs_cd is '强行赎回原因代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.cotin_froz_amt is '继续冻结金额';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.lot_accu_accum is '份额累积积数';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.dtl_flg is '明细标志';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.froz_rs_cd is '冻结原因代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_dir_cd is '转换方向代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.divd_way_cd is '分红方式代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.return_code is '返回码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.return_info is '返回信息';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.rela_dt is '关联日期';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.intior_flow_num is '发起方流水号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.cont_id is '合约编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.host_dt is '主机日期';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_post_lot is '交易后份额';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.comm_fee is '手续费';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.agent_fee is '代理费';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.bank_comm_fee is '银行手续费';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.target_prod_id is '目标产品编号';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.target_prod_nv is '目标产品净值';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.target_prod_price is '目标产品价格';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.target_prod_cfm_lot is '目标产品确认份额';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_consmt_fund_tran_cfm_evt.etl_timestamp is 'ETL处理时间戳';
