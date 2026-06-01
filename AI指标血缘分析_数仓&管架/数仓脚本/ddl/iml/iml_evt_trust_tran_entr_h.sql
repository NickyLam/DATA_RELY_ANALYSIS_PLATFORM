/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_trust_tran_entr_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_trust_tran_entr_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_trust_tran_entr_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_trust_tran_entr_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,entr_flow_num varchar2(100) -- 委托流水号
    ,intior_flow_num varchar2(100) -- 发起方流水号
    ,cont_id varchar2(100) -- 合约编号
    ,appl_dt date -- 申请日期
    ,appl_tm timestamp -- 申请时间
    ,sys_dt date -- 系统日期
    ,seller_id varchar2(100) -- 销售商编号
    ,tran_code varchar2(45) -- 交易码
    ,ctrl_flg varchar2(250) -- 控制标志
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_open_acct_org_id varchar2(100) -- 交易账户开户机构编号
    ,ta_cd varchar2(30) -- TA代码
    ,finc_acct_id varchar2(100) -- 理财账户编号
    ,finc_cust_id varchar2(100) -- 理财客户编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,bank_id varchar2(100) -- 银行编号
    ,cust_id varchar2(100) -- 交易客户编号
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,intnal_acct_id varchar2(100) -- 内部账户编号
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,tran_med_type_cd varchar2(30) -- 交易介质类型代码
    ,tran_med_id varchar2(100) -- 交易介质编号
    ,tran_chn_cd varchar2(30) -- 交易渠道编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,finc_prod_id varchar2(100) -- 理财产品编号
    ,prod_curr_cd varchar2(30) -- 产品币种代码
    ,prod_cate_cd varchar2(30) -- 产品类别代码
    ,charge_way_cd varchar2(30) -- 收费方式代码
    ,rela_tran_dt date -- 关联交易日期
    ,rela_tran_flow_num varchar2(100) -- 关联交易流水号
    ,tran_amt number(30,2) -- 交易金额
    ,cust_grouping_cd varchar2(30) -- 客户分组代码
    ,acct_status_cd varchar2(30) -- 账务状态代码
    ,init_tran_chn_cd varchar2(30) -- 原交易渠道代码
    ,init_tran_org_id varchar2(100) -- 原交易机构编号
    ,tran_lot number(30,8) -- 交易份额
    ,huge_redem_proc_cd varchar2(30) -- 巨额赎回处理代码
    ,redem_mode_cd varchar2(30) -- 赎回模式代码
    ,divd_way_cd varchar2(30) -- 分红方式代码
    ,froz_rs_cd varchar2(30) -- 冻结原因代码
    ,target_bank_acct_id varchar2(100) -- 目标银行账户编号
    ,cust_risk_level_cd varchar2(30) -- 客户风险等级代码
    ,prod_risk_level_cd varchar2(30) -- 产品风险等级代码
    ,cfm_dt date -- 确认日期
    ,ta_cfm_flow_num varchar2(100) -- TA确认流水号
    ,cfm_lot number(30,8) -- 确认份额
    ,send_host_flow_num varchar2(100) -- 发送主机流水号
    ,host_check_entry_dt date -- 主机对账日期
    ,init_tran_host_check_entry_dt date -- 原交易主机对账日期
    ,host_tran_code varchar2(45) -- 主机交易码
    ,host_dt date -- 主机日期
    ,host_flow_num varchar2(100) -- 主机流水号
    ,supv_nomal_flg varchar2(10) -- 监管正常标志
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,return_code varchar2(45) -- 返回码
    ,return_info varchar2(375) -- 返回信息
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,accpt_way_cd varchar2(30) -- 受理方式代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_trust_tran_entr_h to ${icl_schema};
grant select on ${iml_schema}.evt_trust_tran_entr_h to ${idl_schema};
grant select on ${iml_schema}.evt_trust_tran_entr_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_trust_tran_entr_h is '信托交易委托历史';
comment on column ${iml_schema}.evt_trust_tran_entr_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.entr_flow_num is '委托流水号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.intior_flow_num is '发起方流水号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.cont_id is '合约编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_trust_tran_entr_h.appl_tm is '申请时间';
comment on column ${iml_schema}.evt_trust_tran_entr_h.sys_dt is '系统日期';
comment on column ${iml_schema}.evt_trust_tran_entr_h.seller_id is '销售商编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.tran_code is '交易码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.ctrl_flg is '控制标志';
comment on column ${iml_schema}.evt_trust_tran_entr_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.tran_open_acct_org_id is '交易账户开户机构编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.finc_cust_id is '理财客户编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.bank_id is '银行编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.intnal_acct_id is '内部账户编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.tran_med_type_cd is '交易介质类型代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.tran_med_id is '交易介质编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.tran_chn_cd is '交易渠道编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.prod_curr_cd is '产品币种代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.prod_cate_cd is '产品类别代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.charge_way_cd is '收费方式代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.rela_tran_dt is '关联交易日期';
comment on column ${iml_schema}.evt_trust_tran_entr_h.rela_tran_flow_num is '关联交易流水号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_trust_tran_entr_h.cust_grouping_cd is '客户分组代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.acct_status_cd is '账务状态代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.init_tran_chn_cd is '原交易渠道代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.init_tran_org_id is '原交易机构编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.tran_lot is '交易份额';
comment on column ${iml_schema}.evt_trust_tran_entr_h.huge_redem_proc_cd is '巨额赎回处理代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.redem_mode_cd is '赎回模式代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.divd_way_cd is '分红方式代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.froz_rs_cd is '冻结原因代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.target_bank_acct_id is '目标银行账户编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.cust_risk_level_cd is '客户风险等级代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.prod_risk_level_cd is '产品风险等级代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_trust_tran_entr_h.ta_cfm_flow_num is 'TA确认流水号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.cfm_lot is '确认份额';
comment on column ${iml_schema}.evt_trust_tran_entr_h.send_host_flow_num is '发送主机流水号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.host_check_entry_dt is '主机对账日期';
comment on column ${iml_schema}.evt_trust_tran_entr_h.init_tran_host_check_entry_dt is '原交易主机对账日期';
comment on column ${iml_schema}.evt_trust_tran_entr_h.host_tran_code is '主机交易码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.host_dt is '主机日期';
comment on column ${iml_schema}.evt_trust_tran_entr_h.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.supv_nomal_flg is '监管正常标志';
comment on column ${iml_schema}.evt_trust_tran_entr_h.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_trust_tran_entr_h.return_code is '返回码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.return_info is '返回信息';
comment on column ${iml_schema}.evt_trust_tran_entr_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.accpt_way_cd is '受理方式代码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_trust_tran_entr_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_trust_tran_entr_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_trust_tran_entr_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_trust_tran_entr_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_trust_tran_entr_h.etl_timestamp is 'ETL处理时间戳';
