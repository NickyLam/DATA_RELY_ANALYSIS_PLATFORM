/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_agt_wl_distr_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_agt_wl_distr_info
whenever sqlerror continue none;
drop table ${idl_schema}.aml_agt_wl_distr_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_agt_wl_distr_info(
    etl_dt date -- 数据日期   
    ,distr_id varchar2(60) -- 放款编号   
    ,appl_id varchar2(100) -- 申请编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,agt_id varchar2(100) -- 协议编号   
    ,dubil_id varchar2(100) -- 借据编号   
    ,prod_id varchar2(60) -- 产品编号   
    ,cust_id varchar2(60) -- 客户编号   
    ,cust_name varchar2(100) -- 客户名称   
    ,appl_amt number(30,2) -- 申请金额   
    ,appl_dt date -- 申请日期   
    ,distr_dt date -- 放款日期   
    ,open_acct_bank_name varchar2(100) -- 开户银行名称   
    ,open_acct_card_no varchar2(100) -- 开户卡号   
    ,repay_acct_name varchar2(100) -- 还款账户名称   
    ,repay_acct_card_no varchar2(100) -- 还款账户卡号   
    ,loan_perds number(10) -- 贷款期数   
    ,loan_int_rat number(18,8) -- 贷款利率   
    ,serv_int_rat number(18,8) -- 服务利率   
    ,inst_comm_fee_rat number(18,6) -- 分期手续费率   
    ,serv_fee number(30,2) -- 服务费用   
    ,distr_amt number(30,2) -- 放款金额   
    ,inst_comm_fee_amt number(30,2) -- 分期手续费金额   
    ,distr_way_cd varchar2(30) -- 放款方式代码   
    ,appl_status_cd varchar2(10) -- 申请状态代码   
    ,tran_status_cd varchar2(20) -- 转账状态代码   
    ,manu_apv_flg varchar2(10) -- 人工审批标志   
    ,obank_card_flg varchar2(10) -- 他行卡标志   
    ,fail_oper_flow_cd varchar2(10) -- 失败操作流程代码   
    ,open_acct_bind_mobile_no varchar2(60) -- 开户绑定手机号码   
    ,obank_card_tran_flow_num varchar2(60) -- 他行卡转账流水号   
    ,pay_order_no varchar2(60) -- 支付订单号   
    ,loan_tran_flow_num varchar2(60) -- 贷款交易流水号   
    ,glob_tran_flow_num varchar2(60) -- 全局交易流水号   
    ,host_crdt_flow_num varchar2(60) -- 主机贷记流水号   
    ,host_debit_flow_num varchar2(60) -- 主机借记流水号   
    ,froz_tran_dt date -- 冻结交易日期   
    ,froz_tran_flow_id varchar2(60) -- 冻结交易流水编号   
    ,distr_mode_cd varchar2(30) -- 放款模式代码   
    ,noth_rpp_conti_old_dubil_id varchar2(100) -- 无还本续贷旧借据编号   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识   
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
grant select on ${idl_schema}.aml_agt_wl_distr_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_agt_wl_distr_info is '网贷放款信息';
comment on column ${idl_schema}.aml_agt_wl_distr_info.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_agt_wl_distr_info.distr_id is '放款编号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.appl_id is '申请编号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.lp_id is '法人编号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.agt_id is '协议编号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.dubil_id is '借据编号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.prod_id is '产品编号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.cust_id is '客户编号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.cust_name is '客户名称';
comment on column ${idl_schema}.aml_agt_wl_distr_info.appl_amt is '申请金额';
comment on column ${idl_schema}.aml_agt_wl_distr_info.appl_dt is '申请日期';
comment on column ${idl_schema}.aml_agt_wl_distr_info.distr_dt is '放款日期';
comment on column ${idl_schema}.aml_agt_wl_distr_info.open_acct_bank_name is '开户银行名称';
comment on column ${idl_schema}.aml_agt_wl_distr_info.open_acct_card_no is '开户卡号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.repay_acct_name is '还款账户名称';
comment on column ${idl_schema}.aml_agt_wl_distr_info.repay_acct_card_no is '还款账户卡号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.loan_perds is '贷款期数';
comment on column ${idl_schema}.aml_agt_wl_distr_info.loan_int_rat is '贷款利率';
comment on column ${idl_schema}.aml_agt_wl_distr_info.serv_int_rat is '服务利率';
comment on column ${idl_schema}.aml_agt_wl_distr_info.inst_comm_fee_rat is '分期手续费率';
comment on column ${idl_schema}.aml_agt_wl_distr_info.serv_fee is '服务费用';
comment on column ${idl_schema}.aml_agt_wl_distr_info.distr_amt is '放款金额';
comment on column ${idl_schema}.aml_agt_wl_distr_info.inst_comm_fee_amt is '分期手续费金额';
comment on column ${idl_schema}.aml_agt_wl_distr_info.distr_way_cd is '放款方式代码';
comment on column ${idl_schema}.aml_agt_wl_distr_info.appl_status_cd is '申请状态代码';
comment on column ${idl_schema}.aml_agt_wl_distr_info.tran_status_cd is '转账状态代码';
comment on column ${idl_schema}.aml_agt_wl_distr_info.manu_apv_flg is '人工审批标志';
comment on column ${idl_schema}.aml_agt_wl_distr_info.obank_card_flg is '他行卡标志';
comment on column ${idl_schema}.aml_agt_wl_distr_info.fail_oper_flow_cd is '失败操作流程代码';
comment on column ${idl_schema}.aml_agt_wl_distr_info.open_acct_bind_mobile_no is '开户绑定手机号码';
comment on column ${idl_schema}.aml_agt_wl_distr_info.obank_card_tran_flow_num is '他行卡转账流水号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.pay_order_no is '支付订单号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.loan_tran_flow_num is '贷款交易流水号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.glob_tran_flow_num is '全局交易流水号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.host_crdt_flow_num is '主机贷记流水号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.host_debit_flow_num is '主机借记流水号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.froz_tran_dt is '冻结交易日期';
comment on column ${idl_schema}.aml_agt_wl_distr_info.froz_tran_flow_id is '冻结交易流水编号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.distr_mode_cd is '放款模式代码';
comment on column ${idl_schema}.aml_agt_wl_distr_info.noth_rpp_conti_old_dubil_id is '无还本续贷旧借据编号';
comment on column ${idl_schema}.aml_agt_wl_distr_info.create_dt is '创建日期';
comment on column ${idl_schema}.aml_agt_wl_distr_info.update_dt is '更新日期';
comment on column ${idl_schema}.aml_agt_wl_distr_info.id_mark is '删除标识';
comment on column ${idl_schema}.aml_agt_wl_distr_info.job_cd is '任务代码';
comment on column ${idl_schema}.aml_agt_wl_distr_info.etl_timestamp is '数据处理时间';