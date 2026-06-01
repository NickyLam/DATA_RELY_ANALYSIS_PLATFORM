/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_point_mall_pay_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_point_mall_pay_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_point_mall_pay_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_point_mall_pay_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,indent_flow_num varchar2(100) -- 订单流水号
    ,indent_id varchar2(250) -- 订单编号
    ,tran_dt date -- 交易日期
    ,tran_code varchar2(100) -- 交易码
    ,tran_descb varchar2(500) -- 交易描述
    ,tran_flow_num varchar2(250) -- 交易流水号
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,agency_id varchar2(100) -- 代理商编号
    ,mercht_id varchar2(100) -- 商户编号
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,merchd_type_cd varchar2(30) -- 商品类型代码
    ,mode_pay_cd varchar2(30) -- 支付方式代码
    ,indent_tot_amt number(30,2) -- 订单总金额
    ,indent_tot_point number(30,2) -- 订单总积分
    ,point_type_cd varchar2(60) -- 积分类型代码
    ,indent_eqty_point number(30,2) -- 订单权益积分
    ,indent_tot_welfare_gold number(30,2) -- 订单总福利金
    ,surp_welfare_gold number(30,2) -- 剩余福利金
    ,surp_aval_amt number(30,2) -- 剩余可用金额
    ,surp_aval_point number(30,2) -- 剩余可用积分
    ,surp_aval_eqty_point number(30,2) -- 剩余可用权益积分
    ,pay_card_num varchar2(60) -- 支付卡号
    ,pay_card_open_acct_org_id varchar2(250) -- 支付卡开户机构编号
    ,card_name varchar2(500) -- 卡名称
    ,card_type_cd varchar2(30) -- 卡类型代码
    ,ibank_no varchar2(60) -- 联行号
    ,bank_name varchar2(500) -- 银行名称
    ,pay_sucs_dt date -- 付款成功日期
    ,comb_pay_reb_sucs_flg varchar2(10) -- 组合支付回滚成功标志
    ,advise_sucs_flg varchar2(10) -- 通知成功标志
    ,pay_fail_advise_cnt number(10) -- 支付失败通知次数
    ,check_bal_flg varchar2(10) -- 检查余额标志
    ,dispatch_status_cd varchar2(30) -- 发货状态代码
    ,rtn_goods_init_indent_flow_num varchar2(100) -- 退货原订单流水号
    ,rtn_goods_init_indent_tran_dt date -- 退货原订单交易日期
    ,init_tran_order_no varchar2(250) -- 原交易订单号
    ,init_indent_tran_dt date -- 原订单交易日期
    ,resp_code varchar2(100) -- 响应码
    ,resp_descb varchar2(500) -- 响应描述
    ,valid_flg varchar2(10) -- 有效标志
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
grant select on ${iml_schema}.evt_point_mall_pay_flow to ${icl_schema};
grant select on ${iml_schema}.evt_point_mall_pay_flow to ${idl_schema};
grant select on ${iml_schema}.evt_point_mall_pay_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_point_mall_pay_flow is '积分商城订单流水';
comment on column ${iml_schema}.evt_point_mall_pay_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.indent_flow_num is '订单流水号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.indent_id is '订单编号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_point_mall_pay_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_point_mall_pay_flow.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_point_mall_pay_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_point_mall_pay_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_point_mall_pay_flow.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.agency_id is '代理商编号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.merchd_type_cd is '商品类型代码';
comment on column ${iml_schema}.evt_point_mall_pay_flow.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.evt_point_mall_pay_flow.indent_tot_amt is '订单总金额';
comment on column ${iml_schema}.evt_point_mall_pay_flow.indent_tot_point is '订单总积分';
comment on column ${iml_schema}.evt_point_mall_pay_flow.point_type_cd is '积分类型代码';
comment on column ${iml_schema}.evt_point_mall_pay_flow.indent_eqty_point is '订单权益积分';
comment on column ${iml_schema}.evt_point_mall_pay_flow.indent_tot_welfare_gold is '订单总福利金';
comment on column ${iml_schema}.evt_point_mall_pay_flow.surp_welfare_gold is '剩余福利金';
comment on column ${iml_schema}.evt_point_mall_pay_flow.surp_aval_amt is '剩余可用金额';
comment on column ${iml_schema}.evt_point_mall_pay_flow.surp_aval_point is '剩余可用积分';
comment on column ${iml_schema}.evt_point_mall_pay_flow.surp_aval_eqty_point is '剩余可用权益积分';
comment on column ${iml_schema}.evt_point_mall_pay_flow.pay_card_num is '支付卡号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.pay_card_open_acct_org_id is '支付卡开户机构编号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.card_name is '卡名称';
comment on column ${iml_schema}.evt_point_mall_pay_flow.card_type_cd is '卡类型代码';
comment on column ${iml_schema}.evt_point_mall_pay_flow.ibank_no is '联行号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.bank_name is '银行名称';
comment on column ${iml_schema}.evt_point_mall_pay_flow.pay_sucs_dt is '付款成功日期';
comment on column ${iml_schema}.evt_point_mall_pay_flow.comb_pay_reb_sucs_flg is '组合支付回滚成功标志';
comment on column ${iml_schema}.evt_point_mall_pay_flow.advise_sucs_flg is '通知成功标志';
comment on column ${iml_schema}.evt_point_mall_pay_flow.pay_fail_advise_cnt is '支付失败通知次数';
comment on column ${iml_schema}.evt_point_mall_pay_flow.check_bal_flg is '检查余额标志';
comment on column ${iml_schema}.evt_point_mall_pay_flow.dispatch_status_cd is '发货状态代码';
comment on column ${iml_schema}.evt_point_mall_pay_flow.rtn_goods_init_indent_flow_num is '退货原订单流水号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.rtn_goods_init_indent_tran_dt is '退货原订单交易日期';
comment on column ${iml_schema}.evt_point_mall_pay_flow.init_tran_order_no is '原交易订单号';
comment on column ${iml_schema}.evt_point_mall_pay_flow.init_indent_tran_dt is '原订单交易日期';
comment on column ${iml_schema}.evt_point_mall_pay_flow.resp_code is '响应码';
comment on column ${iml_schema}.evt_point_mall_pay_flow.resp_descb is '响应描述';
comment on column ${iml_schema}.evt_point_mall_pay_flow.valid_flg is '有效标志';
comment on column ${iml_schema}.evt_point_mall_pay_flow.start_dt is '开始时间';
comment on column ${iml_schema}.evt_point_mall_pay_flow.end_dt is '结束时间';
comment on column ${iml_schema}.evt_point_mall_pay_flow.id_mark is '增删标志';
comment on column ${iml_schema}.evt_point_mall_pay_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_point_mall_pay_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_point_mall_pay_flow.etl_timestamp is 'ETL处理时间戳';
