/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_onl_bank_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_onl_bank_tran_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_onl_bank_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_onl_bank_tran_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_flow_num varchar2(100) -- 转账流水号
    ,whole_unify_cust_id varchar2(60) -- 全行统一客户编号
    ,tran_dt date -- 交易日期
    ,tran_tm varchar2(20) -- 交易时间
    ,tran_code varchar2(100) -- 交易码
    ,tran_oper_type_cd varchar2(10) -- 交易操作类型代码
    ,tran_return_code varchar2(100) -- 交易返回码
    ,fail_rs varchar2(2000) -- 失败原因
    ,tran_amt number(30,2) -- 交易金额
    ,curr_cd varchar2(10) -- 币种代码
    ,comm_fee number(30,2) -- 手续费
    ,pay_acct_num varchar2(60) -- 付款账号
    ,pay_acct_name varchar2(100) -- 付款账户名称
    ,pay_acct_type_cd varchar2(10) -- 付款账户类型代码
    ,recvbl_num varchar2(60) -- 收款账号
    ,recvbl_num_name varchar2(200) -- 收款账号名称
    ,recvbl_acct_type_cd varchar2(10) -- 收款账户类型代码
    ,recver_bank_no varchar2(60) -- 收款人银行行号
    ,recver_bank_name varchar2(500) -- 收款人银行名称
    ,recver_prov_cd varchar2(60) -- 收款人省份代码
    ,recver_prov_name varchar2(100) -- 收款人省份名称
    ,recver_city_cd varchar2(60) -- 收款人城市代码
    ,recver_city_name varchar2(200) -- 收款人城市名称
    ,plan_fomult_tm varchar2(20) -- 计划制定时间
    ,plan_type_cd varchar2(10) -- 计划类型代码
    ,tran_freq_cd varchar2(10) -- 交易频率代码
    ,next_exec_dt date -- 下一次执行日期
    ,precon_plan_status_cd varchar2(10) -- 预约计划状态代码
    ,tm_or_ff_begin_dt date -- 定时或定频起始日期
    ,tm_or_ff_closing_dt date -- 定时或定频截止日期
    ,lmt_attr_cd varchar2(100) -- 限额属性代码
    ,save_cert_way_cd varchar2(10) -- 安全认证方式代码
    ,usage_comnt varchar2(200) -- 用途说明
    ,onl_bank_tran_flow_num varchar2(100) -- 网银交易流水号
    ,recver_nickna varchar2(100) -- 收款人昵称
    ,atm_equip_id varchar2(60) -- ATM设备编号
    ,st_msg_advise_mobile_no varchar2(60) -- 短信通知手机号码
    ,brac_id varchar2(60) -- 网点编号
    ,brac_name varchar2(500) -- 网点名称
    ,dept_cd varchar2(10) -- 部门代码
    ,tran_out_route_id varchar2(60) -- 转出路由编号
    ,remit_way_id varchar2(60) -- 汇路编号
    ,remit_way_name varchar2(100) -- 汇路名称
    ,next_day_tran_out_flg varchar2(10) -- 次日转出标志
    ,tran_mobile_no varchar2(60) -- 转账手机号码
    ,crdt_card_repay_flg varchar2(10) -- 信用卡还款标志
    ,user_seq_id varchar2(60) -- 用户顺序编号
    ,remark varchar2(250) -- 备注
    ,tran_order_no varchar2(60) -- 交易订单号
    ,chain_way_track_no varchar2(100) -- 链路跟踪号
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
grant select on ${iml_schema}.evt_onl_bank_tran_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_onl_bank_tran_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_onl_bank_tran_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_onl_bank_tran_dtl is '网上银行转账明细';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tran_flow_num is '转账流水号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.whole_unify_cust_id is '全行统一客户编号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tran_code is '交易码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tran_oper_type_cd is '交易操作类型代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tran_return_code is '交易返回码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.fail_rs is '失败原因';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.comm_fee is '手续费';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.pay_acct_num is '付款账号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.pay_acct_name is '付款账户名称';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.pay_acct_type_cd is '付款账户类型代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.recvbl_num is '收款账号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.recvbl_num_name is '收款账号名称';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.recvbl_acct_type_cd is '收款账户类型代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.recver_bank_no is '收款人银行行号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.recver_bank_name is '收款人银行名称';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.recver_prov_cd is '收款人省份代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.recver_prov_name is '收款人省份名称';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.recver_city_cd is '收款人城市代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.recver_city_name is '收款人城市名称';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.plan_fomult_tm is '计划制定时间';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.plan_type_cd is '计划类型代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tran_freq_cd is '交易频率代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.next_exec_dt is '下一次执行日期';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.precon_plan_status_cd is '预约计划状态代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tm_or_ff_begin_dt is '定时或定频起始日期';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tm_or_ff_closing_dt is '定时或定频截止日期';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.lmt_attr_cd is '限额属性代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.save_cert_way_cd is '安全认证方式代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.usage_comnt is '用途说明';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.onl_bank_tran_flow_num is '网银交易流水号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.recver_nickna is '收款人昵称';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.atm_equip_id is 'ATM设备编号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.st_msg_advise_mobile_no is '短信通知手机号码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.brac_id is '网点编号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.brac_name is '网点名称';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.dept_cd is '部门代码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tran_out_route_id is '转出路由编号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.remit_way_id is '汇路编号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.remit_way_name is '汇路名称';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.next_day_tran_out_flg is '次日转出标志';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tran_mobile_no is '转账手机号码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.crdt_card_repay_flg is '信用卡还款标志';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.user_seq_id is '用户顺序编号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.remark is '备注';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.tran_order_no is '交易订单号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.chain_way_track_no is '链路跟踪号';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_onl_bank_tran_dtl.etl_timestamp is 'ETL处理时间戳';
