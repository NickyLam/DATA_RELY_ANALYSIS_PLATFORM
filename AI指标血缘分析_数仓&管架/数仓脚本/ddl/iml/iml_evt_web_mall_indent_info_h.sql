/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_web_mall_indent_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_web_mall_indent_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_web_mall_indent_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_web_mall_indent_info_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,indent_flow_num varchar2(100) -- 订单流水号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,init_indent_flow_num varchar2(100) -- 原订单流水号
    ,init_indent_tran_dt date -- 原订单交易日期
    ,tran_dt date -- 交易日期
    ,tran_tm date -- 交易时间
    ,tran_code varchar2(45) -- 交易码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,pay_sucs_dt date -- 付款成功日期
    ,pay_sucs_tm date -- 付款成功时间
    ,resp_code varchar2(45) -- 响应码
    ,resp_code_descb varchar2(1500) -- 响应码描述
    ,pay_card_num varchar2(100) -- 支付卡号
    ,card_name varchar2(375) -- 卡名称
    ,ibank_no varchar2(100) -- 银行联行号
    ,bank_name varchar2(375) -- 银行名称
    ,card_type_cd varchar2(30) -- 卡类型代码
    ,recv_bill_brch_id varchar2(100) -- 收单分行编号
    ,caller_ova_flow_num varchar2(100) -- 调用方全局流水号
    ,caller_onl_ova_flow_num varchar2(100) -- 调用方联机全局流水号
    ,dispatch_status_cd varchar2(30) -- 发货状态代码
    ,pick_goods_way_cd varchar2(30) -- 提货方式代码
    ,mercht_no varchar2(100) -- 商户号
    ,recver_name varchar2(150) -- 收货人名称
    ,recver_mobile_no varchar2(20) -- 收货人手机号码
    ,recver_local_prov varchar2(90) -- 收货人所在省
    ,recver_local_city varchar2(90) -- 收货人所在市
    ,recver_local_rg_county varchar2(90) -- 收货人所在区县
    ,recver_local_town varchar2(90) -- 收货人所在镇
    ,recver_dtl_addr varchar2(750) -- 收货人详细地址
    ,indent_tot_amt number(30,2) -- 订单总金额
    ,indent_point_type_cd varchar2(30) -- 订单积分类型代码
    ,indent_tot_point number(30,2) -- 订单总积分
    ,fregt_amt number(30,2) -- 运费金额
    ,cust_id varchar2(100) -- 交易客户编号
    ,cust_name varchar2(375) -- 客户名称
    ,cust_open_acct_org_id varchar2(100) -- 客户开户机构编号
    ,bank_cust_mgr_id varchar2(100) -- 银行客户经理编号
    ,tot_comm_fee_inco number(30,2) -- 总手续费收入
    ,agency_id varchar2(100) -- 代理商编号
    ,pay_card_open_org_id varchar2(500) -- 支付卡开户机构编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,surp_aval_amt number(30,2) -- 剩余可用金额
    ,surp_aval_point number(30,2) -- 剩余可用积分
    ,point_mall_order_no varchar2(100) -- 积分商城订单号
    ,merchd_type_cd varchar2(30) -- 商品类型代码
    ,remark varchar2(500) -- 备注
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
grant select on ${iml_schema}.evt_web_mall_indent_info_h to ${icl_schema};
grant select on ${iml_schema}.evt_web_mall_indent_info_h to ${idl_schema};
grant select on ${iml_schema}.evt_web_mall_indent_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_web_mall_indent_info_h is '网上商城订单信息历史';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.indent_flow_num is '订单流水号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.init_indent_flow_num is '原订单流水号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.init_indent_tran_dt is '原订单交易日期';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.tran_code is '交易码';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.pay_sucs_dt is '付款成功日期';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.pay_sucs_tm is '付款成功时间';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.resp_code is '响应码';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.resp_code_descb is '响应码描述';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.pay_card_num is '支付卡号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.card_name is '卡名称';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.ibank_no is '银行联行号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.bank_name is '银行名称';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.card_type_cd is '卡类型代码';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.recv_bill_brch_id is '收单分行编号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.caller_ova_flow_num is '调用方全局流水号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.caller_onl_ova_flow_num is '调用方联机全局流水号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.dispatch_status_cd is '发货状态代码';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.pick_goods_way_cd is '提货方式代码';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.mercht_no is '商户号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.recver_name is '收货人名称';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.recver_mobile_no is '收货人手机号码';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.recver_local_prov is '收货人所在省';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.recver_local_city is '收货人所在市';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.recver_local_rg_county is '收货人所在区县';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.recver_local_town is '收货人所在镇';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.recver_dtl_addr is '收货人详细地址';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.indent_tot_amt is '订单总金额';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.indent_point_type_cd is '订单积分类型代码';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.indent_tot_point is '订单总积分';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.fregt_amt is '运费金额';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.cust_open_acct_org_id is '客户开户机构编号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.bank_cust_mgr_id is '银行客户经理编号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.tot_comm_fee_inco is '总手续费收入';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.agency_id is '代理商编号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.pay_card_open_org_id is '支付卡开户机构编号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.surp_aval_amt is '剩余可用金额';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.surp_aval_point is '剩余可用积分';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.point_mall_order_no is '积分商城订单号';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.merchd_type_cd is '商品类型代码';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.remark is '备注';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_web_mall_indent_info_h.etl_timestamp is 'ETL处理时间戳';
