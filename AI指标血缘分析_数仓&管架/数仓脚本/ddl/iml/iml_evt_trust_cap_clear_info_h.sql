/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_trust_cap_clear_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_trust_cap_clear_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_trust_cap_clear_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_trust_cap_clear_info_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,clear_flow_num varchar2(100) -- 清算流水号
    ,tran_dt date -- 交易日期
    ,clear_dt date -- 清算日期
    ,actl_enter_acct_dt date -- 实际入账日期
    ,bf_actl_enter_acct_dt date -- 变动前实际入账日期
    ,cfm_flow_num varchar2(100) -- 确认流水号
    ,rela_flow_num varchar2(100) -- 关联流水号
    ,intior_cd varchar2(30) -- 发起方代码
    ,tran_cd varchar2(30) -- 交易代码
    ,bus_cd varchar2(30) -- 业务代码
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,finc_cust_id varchar2(100) -- 理财客户编号
    ,bank_id varchar2(100) -- 银行编号
    ,cust_id varchar2(100) -- 交易客户编号
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,bank_acct_type_cd varchar2(30) -- 银行账户类型代码
    ,tran_chn_cd varchar2(30) -- 交易渠道编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,termn_id varchar2(100) -- 交易终端编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_belong_org_id varchar2(100) -- 交易所属机构编号
    ,ta_cd varchar2(30) -- TA代码
    ,prod_cd varchar2(30) -- 产品代码
    ,acct_dir_cd varchar2(30) -- 账务方向代码
    ,clear_amt number(30,2) -- 清算金额
    ,curr_cd varchar2(30) -- 币种代码
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,unfrz_amt number(30,2) -- 解冻金额
    ,host_tran_code varchar2(45) -- 主机交易码
    ,host_dt date -- 主机日期
    ,host_flow_num varchar2(100) -- 主机流水号
    ,froz_amt number(30,2) -- 冻结金额
    ,bal_chk_cfm_cd varchar2(30) -- 勾对确认代码
    ,cap_cate_cd varchar2(30) -- 资金类别代码
    ,pric_prft_flg varchar2(10) -- 本金收益标志
    ,cfm_lot number(30,3) -- 确认份额
    ,pric number(30,2) -- 本金
    ,prod_acct_num varchar2(100) -- 产品账号
    ,prod_acct_type_cd varchar2(30) -- 产品账户类型代码
    ,memo_comnt varchar2(375) -- 摘要说明
    ,status_cd varchar2(30) -- 状态代码
    ,init_clear_flow_num varchar2(100) -- 原清算流水号
    ,return_code varchar2(45) -- 返回码
    ,return_info varchar2(375) -- 返回信息
    ,intfc_proc_flg_cd varchar2(30) -- 接口处理标志代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_trust_cap_clear_info_h to ${icl_schema};
grant select on ${iml_schema}.evt_trust_cap_clear_info_h to ${idl_schema};
grant select on ${iml_schema}.evt_trust_cap_clear_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_trust_cap_clear_info_h is '信托资金清算信息历史';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.clear_flow_num is '清算流水号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.actl_enter_acct_dt is '实际入账日期';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.bf_actl_enter_acct_dt is '变动前实际入账日期';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.cfm_flow_num is '确认流水号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.intior_cd is '发起方代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.bus_cd is '业务代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.finc_cust_id is '理财客户编号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.bank_id is '银行编号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.bank_acct_type_cd is '银行账户类型代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.tran_chn_cd is '交易渠道编号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.termn_id is '交易终端编号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.tran_belong_org_id is '交易所属机构编号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.prod_cd is '产品代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.acct_dir_cd is '账务方向代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.clear_amt is '清算金额';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.unfrz_amt is '解冻金额';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.host_tran_code is '主机交易码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.host_dt is '主机日期';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.froz_amt is '冻结金额';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.bal_chk_cfm_cd is '勾对确认代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.cap_cate_cd is '资金类别代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.pric_prft_flg is '本金收益标志';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.cfm_lot is '确认份额';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.pric is '本金';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.prod_acct_num is '产品账号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.prod_acct_type_cd is '产品账户类型代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.memo_comnt is '摘要说明';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.status_cd is '状态代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.init_clear_flow_num is '原清算流水号';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.return_code is '返回码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.return_info is '返回信息';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.intfc_proc_flg_cd is '接口处理标志代码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_trust_cap_clear_info_h.etl_timestamp is 'ETL处理时间戳';
