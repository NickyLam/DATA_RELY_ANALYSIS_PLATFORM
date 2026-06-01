/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scfs_biz_inter_bank_fact_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scfs_biz_inter_bank_fact_inf
whenever sqlerror continue none;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scfs_biz_inter_bank_fact_inf(
    id number(6) -- 主键id
    ,bank_fact_id varchar2(32) -- 跨行再保理编号
    ,bank_fact_type varchar2(10) -- 业务类型
    ,coop_no varchar2(32) -- 协议编号
    ,fact_bank_num varchar2(32) -- 保理行行号
    ,fact_bank_nm varchar2(300) -- 保理行行名
    ,re_fact_bank_num varchar2(32) -- 再保理行行号
    ,re_fact_bank_nm varchar2(300) -- 再保理行行名
    ,bay_out_rate number(20,2) -- 买断利率
    ,bay_out_rate_amt number(20,2) -- 买断利息
    ,fee_amt number(20,2) -- 手续费
    ,buss_term varchar2(32) -- 业务期限
    ,start_date date -- 起息日
    ,sell_date date -- 卖出日
    ,re_fact_fnc_term_date date -- 再保理融资到期日
    ,bay_out_net_amt number(20,6) -- 买断净额（转让净价）
    ,bay_out_amt number(20,6) -- 买断金额（合计）
    ,credit_risk_guar_bank varchar2(300) -- 信用风险担保行
    ,wthr_pre_coll_int varchar2(10) -- 是否预收息
    ,re_fact_bank_comfirm_deadline date -- 再保理行确认截止日期
    ,bay_out_pay_term varchar2(8) -- 买断净额支付期限（天）
    ,recv_acc_num varchar2(32) -- 收款账号
    ,recv_acc_nm varchar2(300) -- 收款账户名
    ,open_bank_num varchar2(32) -- 开户行行号
    ,open_bank_nm varchar2(300) -- 开户行行名
    ,large_pay_acc_num varchar2(32) -- 大额支付号
    ,contact_name varchar2(64) -- 联系人
    ,contact_phone varchar2(32) -- 电话
    ,email varchar2(32) -- 邮箱
    ,charge_serial_num varchar2(4000) -- 收费序号（费用编号）
    ,pcs_st_cd varchar2(10) -- 流程状态代码
    ,interface_push_st_cd varchar2(10) -- 交易状态
    ,transfer_st_cd varchar2(10) -- 回款划出状态
    ,amorize_register_st_cd varchar2(10) -- 摊销登记状态
    ,opin varchar2(2000) -- 意见
    ,tenant_id varchar2(32) -- 租户id
    ,create_time date -- 创建时间
    ,create_user varchar2(32) -- 创建人
    ,update_time date -- 更新时间
    ,update_user varchar2(32) -- 更新人
    ,expd_id varchar2(32) -- 扩展编号
    ,del_ind varchar2(1) -- 删除标志
    ,version number(10) -- 版本号
    ,rspb_psn_id varchar2(32) -- 经办人编号
    ,hdl_inst_id varchar2(32) -- 经办机构编号
    ,hdl_dt date -- 经办日期（营业日）
    ,refund_mark_out_date date -- 回款划出日期
    ,interest_pay_amt number(20,6) -- 应付利息
    ,refund_mark_out_seq_no varchar2(64) -- 回款划出转账流水号
    ,refund_mark_out_dt date -- 回款划出转账日期
    ,refund_mark_out_platf_trx_seq varchar2(64) -- 回款划出转账平台流水号
    ,refund_mark_out_platf_trx_dt date -- 回款划出转账平台交易日期
    ,refund_mark_out_pay_acc_no varchar2(64) -- 回款划出付款人账号
    ,refund_mark_out_pay_acc_nm varchar2(300) -- 回款划出付款人名称
    ,refund_mark_out_pay_acc_amt number(20,2) -- 回款划出付款账户余额
    ,refund_mark_out_to_bank_no varchar2(64) -- 回款划出收款方银行编号
    ,refund_mark_out_to_acc_no varchar2(64) -- 回款划出收款人账号
    ,refund_mark_out_to_acc_nm varchar2(300) -- 回款划出收款人名称
    ,refund_mark_out_info varchar2(2000) -- 回款划出附言
    ,sell_org_num varchar2(32) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.scfs_biz_inter_bank_fact_inf to ${iml_schema};
grant select on ${iol_schema}.scfs_biz_inter_bank_fact_inf to ${icl_schema};
grant select on ${iol_schema}.scfs_biz_inter_bank_fact_inf to ${idl_schema};
grant select on ${iol_schema}.scfs_biz_inter_bank_fact_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.scfs_biz_inter_bank_fact_inf is '跨行再保理信息表';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.id is '主键id';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.bank_fact_id is '跨行再保理编号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.bank_fact_type is '业务类型';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.coop_no is '协议编号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.fact_bank_num is '保理行行号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.fact_bank_nm is '保理行行名';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.re_fact_bank_num is '再保理行行号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.re_fact_bank_nm is '再保理行行名';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.bay_out_rate is '买断利率';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.bay_out_rate_amt is '买断利息';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.fee_amt is '手续费';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.buss_term is '业务期限';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.start_date is '起息日';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.sell_date is '卖出日';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.re_fact_fnc_term_date is '再保理融资到期日';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.bay_out_net_amt is '买断净额（转让净价）';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.bay_out_amt is '买断金额（合计）';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.credit_risk_guar_bank is '信用风险担保行';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.wthr_pre_coll_int is '是否预收息';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.re_fact_bank_comfirm_deadline is '再保理行确认截止日期';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.bay_out_pay_term is '买断净额支付期限（天）';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.recv_acc_num is '收款账号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.recv_acc_nm is '收款账户名';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.open_bank_num is '开户行行号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.open_bank_nm is '开户行行名';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.large_pay_acc_num is '大额支付号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.contact_name is '联系人';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.contact_phone is '电话';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.email is '邮箱';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.charge_serial_num is '收费序号（费用编号）';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.pcs_st_cd is '流程状态代码';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.interface_push_st_cd is '交易状态';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.transfer_st_cd is '回款划出状态';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.amorize_register_st_cd is '摊销登记状态';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.opin is '意见';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.tenant_id is '租户id';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.create_time is '创建时间';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.create_user is '创建人';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.update_time is '更新时间';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.update_user is '更新人';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.expd_id is '扩展编号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.del_ind is '删除标志';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.version is '版本号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.rspb_psn_id is '经办人编号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.hdl_inst_id is '经办机构编号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.hdl_dt is '经办日期（营业日）';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_date is '回款划出日期';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.interest_pay_amt is '应付利息';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_seq_no is '回款划出转账流水号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_dt is '回款划出转账日期';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_platf_trx_seq is '回款划出转账平台流水号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_platf_trx_dt is '回款划出转账平台交易日期';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_pay_acc_no is '回款划出付款人账号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_pay_acc_nm is '回款划出付款人名称';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_pay_acc_amt is '回款划出付款账户余额';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_to_bank_no is '回款划出收款方银行编号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_to_acc_no is '回款划出收款人账号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_to_acc_nm is '回款划出收款人名称';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.refund_mark_out_info is '回款划出附言';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.sell_org_num is '';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.start_dt is '开始时间';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.end_dt is '结束时间';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.id_mark is '增删标志';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_inf.etl_timestamp is 'ETL处理时间戳';
