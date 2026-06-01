/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_trust_tran_cfm_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_trust_tran_cfm_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_trust_tran_cfm_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_trust_tran_cfm_evt(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,ta_cd varchar2(30) -- TA代码
    ,cfm_dt date -- 确认日期
    ,ta_cfm_flow_num varchar2(100) -- TA确认流水号
    ,init_cfm_flow_num varchar2(100) -- 原确认流水号
    ,intior_type_cd varchar2(30) -- 发起方类型代码
    ,tran_dt date -- 交易日期
    ,tran_tm varchar2(10) -- 交易时间
    ,clear_dt date -- 清算日期
    ,flow_num varchar2(100) -- 流水号
    ,tran_cd varchar2(30) -- 交易代码
    ,bus_cd varchar2(30) -- 业务代码
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,tran_chn_cd varchar2(30) -- 交易渠道编号
    ,termn_id varchar2(50) -- 交易终端编号
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,finc_cust_id varchar2(60) -- 理财客户编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,finc_acct_id varchar2(60) -- 理财账户编号
    ,cust_id varchar2(60) -- 交易客户编号
    ,bank_acct_id varchar2(60) -- 银行账户编号
    ,ta_tran_acct_id varchar2(60) -- TA交易账户编号
    ,tran_med_type_cd varchar2(30) -- 交易介质类型代码
    ,tran_med_id varchar2(60) -- 交易介质编号
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,prod_id varchar2(60) -- 产品编号
    ,charge_way_cd varchar2(30) -- 收费方式代码
    ,prod_nv number(18,8) -- 产品净值
    ,tran_price number(18,6) -- 交易价格
    ,tran_amt number(18,6) -- 交易金额
    ,stl_curr_cd varchar2(30) -- 结算币种代码
    ,cfm_amt number(30,2) -- 确认金额
    ,tran_lot number(18,6) -- 交易份额
    ,cfm_lot number(18,6) -- 确认份额
    ,need_huge_redem_proc_flg varchar2(30) -- 需要巨额赎回处理标志
    ,force_redem_rs varchar2(150) -- 强行赎回原因
    ,comm_discnt number(18,6) -- 佣金折扣
    ,tot_cost number(18,6) -- 总费用
    ,comm_fee number(18,6) -- 手续费
    ,stamp_tax number(18,6) -- 印花税
    ,int_tax number(18,6) -- 利息税
    ,tran_fee number(18,6) -- 过户费
    ,agent_fee number(18,6) -- 代理费
    ,back_end_charge number(18,6) -- 后端收费
    ,other_fee_1 number(18,6) -- 其他费用1
    ,other_fee_2 number(18,6) -- 其他费用2
    ,cfm_prft number(18,6) -- 确认收益
    ,mgmt_fee number(18,6) -- 管理费
    ,cotin_froz_amt number(18,6) -- 继续冻结金额
    ,dtl_flg varchar2(30) -- 明细标志
    ,end_type_cd varchar2(30) -- 结束类型代码
    ,froz_rs_cd varchar2(30) -- 冻结原因代码
    ,tran_dir_cd varchar2(30) -- 转换方向代码
    ,int_amt number(18,6) -- 利息金额
    ,int_turn_lot number(18,6) -- 利息转份额
    ,divd_way_cd varchar2(30) -- 分红方式代码
    ,memo_comnt varchar2(375) -- 摘要说明
    ,return_code varchar2(45) -- 返回码
    ,err_info varchar2(375) -- 错误信息
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,rela_dt date -- 关联日期
    ,rela_flow_num varchar2(60) -- 关联流水号
    ,bank_comm_fee number(18,6) -- 银行手续费
    ,intior_flow_num varchar2(60) -- 发起方流水号
    ,cont_id varchar2(60) -- 合约编号
    ,host_tran_cd varchar2(30) -- 主机交易代码
    ,host_dt date -- 主机日期
    ,host_flow_num varchar2(60) -- 主机流水号
    ,tran_post_lot number(18,6) -- 交易后份额
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
grant select on ${iml_schema}.evt_trust_tran_cfm_evt to ${icl_schema};
grant select on ${iml_schema}.evt_trust_tran_cfm_evt to ${idl_schema};
grant select on ${iml_schema}.evt_trust_tran_cfm_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_trust_tran_cfm_evt is '信托交易确认事件';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.ta_cfm_flow_num is 'TA确认流水号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.init_cfm_flow_num is '原确认流水号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.intior_type_cd is '发起方类型代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.flow_num is '流水号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.bus_cd is '业务代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_chn_cd is '交易渠道编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.termn_id is '交易终端编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.finc_cust_id is '理财客户编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_med_type_cd is '交易介质类型代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_med_id is '交易介质编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.prod_id is '产品编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.charge_way_cd is '收费方式代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.prod_nv is '产品净值';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_price is '交易价格';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.stl_curr_cd is '结算币种代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.cfm_amt is '确认金额';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_lot is '交易份额';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.cfm_lot is '确认份额';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.need_huge_redem_proc_flg is '需要巨额赎回处理标志';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.force_redem_rs is '强行赎回原因';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.comm_discnt is '佣金折扣';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tot_cost is '总费用';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.comm_fee is '手续费';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.stamp_tax is '印花税';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.int_tax is '利息税';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_fee is '过户费';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.agent_fee is '代理费';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.back_end_charge is '后端收费';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.other_fee_1 is '其他费用1';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.other_fee_2 is '其他费用2';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.cfm_prft is '确认收益';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.mgmt_fee is '管理费';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.cotin_froz_amt is '继续冻结金额';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.dtl_flg is '明细标志';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.end_type_cd is '结束类型代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.froz_rs_cd is '冻结原因代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_dir_cd is '转换方向代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.int_amt is '利息金额';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.int_turn_lot is '利息转份额';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.divd_way_cd is '分红方式代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.memo_comnt is '摘要说明';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.return_code is '返回码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.err_info is '错误信息';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.rela_dt is '关联日期';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.bank_comm_fee is '银行手续费';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.intior_flow_num is '发起方流水号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.cont_id is '合约编号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.host_tran_cd is '主机交易代码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.host_dt is '主机日期';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.tran_post_lot is '交易后份额';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.start_dt is '开始时间';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.end_dt is '结束时间';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.id_mark is '增删标志';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_trust_tran_cfm_evt.etl_timestamp is 'ETL处理时间戳';
