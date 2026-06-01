/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_mercht_indent_pay_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_mercht_indent_pay_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_mercht_indent_pay_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_mercht_indent_pay_info_h(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,intnal_flow_num varchar2(60) -- 内部流水号
    ,tran_dt date -- 交易日期
    ,tran_tm date -- 交易时间
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,back_end_chn_type_cd varchar2(30) -- 后端渠道类型代码
    ,mercht_id varchar2(250) -- 商户编号
    ,mercht_name varchar2(375) -- 商户名称
    ,chn_mercht_id varchar2(250) -- 渠道商户编号
    ,chn_sub_mercht_id varchar2(100) -- 渠道子商户编号
    ,chn_indent_flow_num varchar2(250) -- 渠道订单流水号
    ,chn_indent_tran_dt date -- 渠道订单交易日期
    ,pay_chn_fee_rat number(18,6) -- 支付渠道费率
    ,pay_flow_num varchar2(100) -- 支付流水号
    ,ova_flow_num varchar2(250) -- 全局流水号
    ,fee_rat_chn_cd varchar2(30) -- 费率渠道代码
    ,ext_indent_id varchar2(100) -- 外部订单编号
    ,indent_caption_name varchar2(750) -- 订单标题名称
    ,indent_descb varchar2(750) -- 订单描述
    ,agency_id varchar2(30) -- 代理商编号
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,indent_bal number(30,2) -- 订单余额
    ,init_indent_flow_num varchar2(100) -- 原订单流水号
    ,init_indent_tran_dt date -- 原订单交易日期
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,pay_sucs_dt date -- 付款成功日期
    ,pay_sucs_tm date -- 付款成功时间
    ,resp_code varchar2(45) -- 响应码
    ,resp_code_descb varchar2(3000) -- 响应码描述
    ,rtn_goods_status_cd varchar2(30) -- 退货状态代码
    ,on_acct_flg varchar2(10) -- 挂账标志
    ,indent_valid_tm varchar2(30) -- 订单有效时间
    ,pay_bank_card_id varchar2(30) -- 支付银行卡编号
    ,termn_type_cd varchar2(30) -- 终端类型代码
    ,recv_bill_brch_id varchar2(30) -- 收单分行编号
    ,ext_mercht_id varchar2(60) -- 外部商户编号
    ,pay_chn_cd varchar2(30) -- 支付渠道代码
    ,back_end_chn_indent_id varchar2(60) -- 后端渠道订单编号
    ,epc_g_room_flg varchar2(10) -- 网联机房标志
    ,pay_vouch_id varchar2(60) -- 付款凭证编号
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
grant select on ${iml_schema}.evt_mercht_indent_pay_info_h to ${icl_schema};
grant select on ${iml_schema}.evt_mercht_indent_pay_info_h to ${idl_schema};
grant select on ${iml_schema}.evt_mercht_indent_pay_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_mercht_indent_pay_info_h is '商户订单支付信息历史';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.intnal_flow_num is '内部流水号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.back_end_chn_type_cd is '后端渠道类型代码';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.mercht_name is '商户名称';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.chn_mercht_id is '渠道商户编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.chn_sub_mercht_id is '渠道子商户编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.chn_indent_flow_num is '渠道订单流水号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.chn_indent_tran_dt is '渠道订单交易日期';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.pay_chn_fee_rat is '支付渠道费率';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.pay_flow_num is '支付流水号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.fee_rat_chn_cd is '费率渠道代码';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.ext_indent_id is '外部订单编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.indent_caption_name is '订单标题名称';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.indent_descb is '订单描述';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.agency_id is '代理商编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.indent_bal is '订单余额';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.init_indent_flow_num is '原订单流水号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.init_indent_tran_dt is '原订单交易日期';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.pay_sucs_dt is '付款成功日期';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.pay_sucs_tm is '付款成功时间';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.resp_code is '响应码';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.resp_code_descb is '响应码描述';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.rtn_goods_status_cd is '退货状态代码';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.on_acct_flg is '挂账标志';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.indent_valid_tm is '订单有效时间';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.pay_bank_card_id is '支付银行卡编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.termn_type_cd is '终端类型代码';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.recv_bill_brch_id is '收单分行编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.ext_mercht_id is '外部商户编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.pay_chn_cd is '支付渠道代码';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.back_end_chn_indent_id is '后端渠道订单编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.epc_g_room_flg is '网联机房标志';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.pay_vouch_id is '付款凭证编号';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_mercht_indent_pay_info_h.etl_timestamp is 'ETL处理时间戳';
