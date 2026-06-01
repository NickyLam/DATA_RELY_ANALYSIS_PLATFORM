/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_elec_cash_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_elec_cash_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_elec_cash_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_elec_cash_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,sys_follow_id varchar2(100) -- 系统跟踪编号
    ,trader_type_cd varchar2(30) -- 交易方类型代码
    ,send_org_id varchar2(100) -- 发送机构编号
    ,proc_org_id varchar2(100) -- 受理机构编号
    ,tran_tm varchar2(30) -- 交易时间
    ,clear_dt date -- 清算日期
    ,doc_dt date -- 文件日期
    ,tran_dt date -- 交易日期
    ,card_no varchar2(60) -- 卡号
    ,card_seq_no varchar2(60) -- 卡序号
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,check_rest_cd varchar2(30) -- 校验结果代码
    ,clear_amt number(30,2) -- 清算金额
    ,clear_curr_cd varchar2(30) -- 清算币种代码
    ,clear_status_cd varchar2(30) -- 清算状态代码
    ,fee_rat number(18,6) -- 费率
    ,mercht_type_cd varchar2(30) -- 商户类型代码
    ,termn_id varchar2(100) -- 终端编号
    ,mercht_id varchar2(100) -- 商户编号
    ,init_tran_type_cd varchar2(30) -- 原交易类型代码
    ,init_sys_follow_id varchar2(100) -- 原系统跟踪编号
    ,init_tran_clear_dt date -- 原交易清算日期
    ,init_tran_tm varchar2(30) -- 原交易时间
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,card_holder_deduct_exch_rat number(18,8) -- 持卡人扣款汇率
    ,card_holder_deduct_amt number(30,2) -- 持卡人扣款金额
    ,card_holder_curr_cd varchar2(30) -- 持卡人币种代码
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,host_tran_dt date -- 主机交易日期
    ,host_tran_flow varchar2(100) -- 主机交易流水号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,err_cd varchar2(90) -- 错误码
    ,err_info_desc varchar2(750) -- 错误信息描述
    ,entry_status_cd varchar2(30) -- 记账状态代码
    ,td_rtn_goods_flg varchar2(10) -- 当天退货标志
    ,ghb_exch_fee number(30,2) -- 本方交换费
    ,tran_clear_fee number(30,2) -- 转接清算费
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
grant select on ${iml_schema}.evt_elec_cash_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_elec_cash_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_elec_cash_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_elec_cash_tran_flow is '电子现金交易流水';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.sys_follow_id is '系统跟踪编号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.trader_type_cd is '交易方类型代码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.send_org_id is '发送机构编号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.proc_org_id is '受理机构编号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.doc_dt is '文件日期';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.card_no is '卡号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.card_seq_no is '卡序号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.check_rest_cd is '校验结果代码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.clear_amt is '清算金额';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.clear_curr_cd is '清算币种代码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.clear_status_cd is '清算状态代码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.fee_rat is '费率';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.mercht_type_cd is '商户类型代码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.termn_id is '终端编号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.init_tran_type_cd is '原交易类型代码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.init_sys_follow_id is '原系统跟踪编号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.init_tran_clear_dt is '原交易清算日期';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.init_tran_tm is '原交易时间';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.card_holder_deduct_exch_rat is '持卡人扣款汇率';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.card_holder_deduct_amt is '持卡人扣款金额';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.card_holder_curr_cd is '持卡人币种代码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.host_tran_dt is '主机交易日期';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.host_tran_flow is '主机交易流水号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.err_cd is '错误码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.td_rtn_goods_flg is '当天退货标志';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.ghb_exch_fee is '本方交换费';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.tran_clear_fee is '转接清算费';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_elec_cash_tran_flow.etl_timestamp is 'ETL处理时间戳';
