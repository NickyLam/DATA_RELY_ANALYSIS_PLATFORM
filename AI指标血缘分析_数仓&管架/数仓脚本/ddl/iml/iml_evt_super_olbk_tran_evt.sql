/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_super_olbk_tran_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_super_olbk_tran_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_super_olbk_tran_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_super_olbk_tran_evt(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,evt_dt date -- 事件日期
    ,front_flow_num varchar2(60) -- 前置机流水号
    ,host_tran_code varchar2(45) -- 主机交易码
    ,front_tran_code varchar2(45) -- 前置交易码
    ,pbc_tran_code varchar2(45) -- 人行交易编码
    ,bank_int_bus_seq_num varchar2(60) -- 行内业务序号
    ,bus_seq_num varchar2(60) -- 业务序号
    ,num_site number(10) -- 场次
    ,comm_fee number(30,8) -- 手续费
    ,postage number(30,8) -- 邮电费
    ,trdpty_org_comm_fee_amt number(30,8) -- 第三方机构手续费金额
    ,stl_amt number(30,2) -- 转贴现金额
    ,tran_amt number(30,2) -- 交易金额
    ,curr_cd varchar2(10) -- 币种代码
    ,host_rest_cd varchar2(100) -- 主机结果代码
    ,pbc_bus_status_cd varchar2(10) -- 人行业务状态代码
    ,refuse_rs_cd varchar2(10) -- 拒绝原因代码
    ,pbc_bus_type_cd varchar2(10) -- 人行业务类型代码
    ,pbc_bus_kind_cd varchar2(10) -- 人行业务种类代码
    ,host_check_entry_status_cd varchar2(10) -- 与主机对账状态代码
    ,pbc_check_entry_status_cd varchar2(10) -- 与人行对账状态代码
    ,host_flow_num varchar2(60) -- 主机流水号
    ,sumos_id varchar2(60) -- 传票编号
    ,tran_brac_id varchar2(60) -- 交易网点编号
    ,operr_id varchar2(60) -- 操作员编号
    ,brac_print_flg varchar2(10) -- 网点打印标志
    ,temp_print_flg varchar2(10) -- 临时打印标志
    ,print_cnt number(10) -- 打印次数
    ,subj_id varchar2(60) -- 科目编号
    ,fac_val_recd_dt date -- 票面记载日期
    ,present_wdraw_dt date -- 提出提回日期
    ,entry_dt date -- 记账日期
    ,send_bank_dt date -- 送银行日期
    ,pbc_proc_dt date -- 人行处理日期
    ,bank_int_sys_proc_tm timestamp -- 行内系统受理时间
    ,bus_init_tm timestamp -- 业务发起时间
    ,submit_prior_level varchar2(30) -- 提交优先级
    ,present_wdraw_flg varchar2(10) -- 提出提回标志
    ,realtm_onl_flg varchar2(10) -- 实时联机标志
    ,charge_flg varchar2(10) -- 收费标志
    ,debit_crdt_cd varchar2(10) -- 借贷代码
    ,recv_bank_no varchar2(60) -- 收款行行号
    ,recv_bank_name varchar2(150) -- 收款行行名称
    ,recver_acct_num varchar2(60) -- 收款人账号
    ,recver_name varchar2(375) -- 收款人姓名
    ,recver_acct_type varchar2(90) -- 收款人账户类型
    ,pay_bank_no varchar2(60) -- 付款行行号
    ,pay_bank_name varchar2(150) -- 付款行行名称
    ,payer_acct_num varchar2(60) -- 付款人账号
    ,payer_name varchar2(375) -- 付款人姓名
    ,payer_acct_type_cd varchar2(10) -- 付款人账户类型代码
    ,send_msg_bank_no varchar2(60) -- 发报行行号
    ,recv_msg_bank_no varchar2(60) -- 收报行行号
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,tran_status_rest_cd varchar2(10) -- 交易状态结果代码
    ,chn_cd varchar2(10) -- 渠道代码
    ,refuse_bus_org_bank_no varchar2(60) -- 拒绝业务机构行号
    ,pay_clear_bk_no varchar2(60) -- 付款清算行行号
    ,recvbl_clear_bk_no varchar2(60) -- 收款清算行行号
    ,payer_open_bank_no varchar2(60) -- 付款人开户行行号
    ,recver_open_bank_no varchar2(60) -- 收款人开户行行号
    ,payer_bank_belong_city_cd varchar2(10) -- 付款人开户行所属城市代码
    ,recver_bank_belong_city_cd varchar2(10) -- 收款人开户行所属城市代码
    ,web_tran_odd_no varchar2(60) -- 网上交易单号
    ,cert_way_cd varchar2(10) -- 认证方式代码
    ,cert_info varchar2(375) -- 认证信息
    ,pre_auth_id varchar2(60) -- 预授权编号
    ,mercht_id varchar2(500) -- 商户编号
    ,mercht_name varchar2(375) -- 商户名称
    ,coll_comm_fee_org_id varchar2(60) -- 收取手续费机构编号
    ,web_tran_tm timestamp -- 网上交易时间
    ,open_acct_brac_id varchar2(60) -- 开户网点编号
    ,check_entry_dt date -- 对账日期
    ,check_entry_proc_flg varchar2(10) -- 对账处理标志
    ,tran_index_num varchar2(60) -- 交易索引号
    ,e_acct_cd varchar2(10) -- 电子账户代码
    ,e_acct_entry_req_flow_num varchar2(100) -- 电子账户记账请求流水号
    ,next_day_arrive_flg varchar2(10) -- 次日达标志
    ,supv_acct varchar2(90) -- 监管账户
    ,supv_acct_num varchar2(60) -- 监管账号
    ,supv_acct_num_acct_name varchar2(375) -- 监管账号户名称
    ,supv_acct_num_open_org_id varchar2(60) -- 监管账号开户机构编号
    ,acct_type_cd varchar2(20) -- 账户类型代码
    ,sign_type_cd varchar2(10) -- 签约类型代码
    ,refund_flg varchar2(10) -- 退款标志
    ,init_msg_idf_id varchar2(60) -- 原报文标识编号
    ,init_prtcpt_org_bank_no varchar2(60) -- 发起参与机构行号
    ,acct_ety_code varchar2(45) -- 会计分录编码
    ,acct_cate_cd varchar2(20) -- 账户类别代码
    ,resv_bd_flg varchar2(10) -- 预绑标志
    ,cust_id varchar2(60) -- 交易客户编号
    ,st_msg_check_ser_num varchar2(60) -- 短信验证序列号
    ,mobile_no varchar2(60) -- 手机号码
    ,cert_no varchar2(30) -- 证件号码
    ,super_olbk_entry_rela_seq_num varchar2(60) -- 超级网银记账流水关联序号
    ,lmt_order_no varchar2(60) -- 限额订单号
    ,bind_flg varchar2(10) -- 绑定标志
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,esb_intfc_return_code varchar2(45) -- ESB接口返回码
    ,esb_intfc_return_info varchar2(3000) -- ESB接口返回信息
    ,esb_intfc_tran_flow_num varchar2(60) -- ESB接口交易流水号
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
grant select on ${iml_schema}.evt_super_olbk_tran_evt to ${icl_schema};
grant select on ${iml_schema}.evt_super_olbk_tran_evt to ${idl_schema};
grant select on ${iml_schema}.evt_super_olbk_tran_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_super_olbk_tran_evt is '超级网银交易事件';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.evt_dt is '事件日期';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.front_flow_num is '前置机流水号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.host_tran_code is '主机交易码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.front_tran_code is '前置交易码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.pbc_tran_code is '人行交易编码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.bank_int_bus_seq_num is '行内业务序号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.bus_seq_num is '业务序号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.num_site is '场次';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.comm_fee is '手续费';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.postage is '邮电费';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.trdpty_org_comm_fee_amt is '第三方机构手续费金额';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.stl_amt is '转贴现金额';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.host_rest_cd is '主机结果代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.pbc_bus_status_cd is '人行业务状态代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.refuse_rs_cd is '拒绝原因代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.pbc_bus_type_cd is '人行业务类型代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.pbc_bus_kind_cd is '人行业务种类代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.host_check_entry_status_cd is '与主机对账状态代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.pbc_check_entry_status_cd is '与人行对账状态代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.sumos_id is '传票编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.tran_brac_id is '交易网点编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.operr_id is '操作员编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.brac_print_flg is '网点打印标志';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.temp_print_flg is '临时打印标志';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.print_cnt is '打印次数';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.subj_id is '科目编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.fac_val_recd_dt is '票面记载日期';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.present_wdraw_dt is '提出提回日期';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.entry_dt is '记账日期';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.send_bank_dt is '送银行日期';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.pbc_proc_dt is '人行处理日期';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.bank_int_sys_proc_tm is '行内系统受理时间';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.bus_init_tm is '业务发起时间';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.submit_prior_level is '提交优先级';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.present_wdraw_flg is '提出提回标志';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.realtm_onl_flg is '实时联机标志';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.charge_flg is '收费标志';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.debit_crdt_cd is '借贷代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.recv_bank_no is '收款行行号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.recv_bank_name is '收款行行名称';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.recver_acct_num is '收款人账号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.recver_name is '收款人姓名';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.recver_acct_type is '收款人账户类型';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.pay_bank_no is '付款行行号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.pay_bank_name is '付款行行名称';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.payer_acct_num is '付款人账号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.payer_name is '付款人姓名';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.payer_acct_type_cd is '付款人账户类型代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.send_msg_bank_no is '发报行行号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.recv_msg_bank_no is '收报行行号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.tran_status_rest_cd is '交易状态结果代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.chn_cd is '渠道代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.refuse_bus_org_bank_no is '拒绝业务机构行号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.pay_clear_bk_no is '付款清算行行号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.recvbl_clear_bk_no is '收款清算行行号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.payer_open_bank_no is '付款人开户行行号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.recver_open_bank_no is '收款人开户行行号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.payer_bank_belong_city_cd is '付款人开户行所属城市代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.recver_bank_belong_city_cd is '收款人开户行所属城市代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.web_tran_odd_no is '网上交易单号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.cert_way_cd is '认证方式代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.cert_info is '认证信息';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.pre_auth_id is '预授权编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.mercht_name is '商户名称';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.coll_comm_fee_org_id is '收取手续费机构编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.web_tran_tm is '网上交易时间';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.open_acct_brac_id is '开户网点编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.check_entry_dt is '对账日期';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.check_entry_proc_flg is '对账处理标志';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.tran_index_num is '交易索引号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.e_acct_cd is '电子账户代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.e_acct_entry_req_flow_num is '电子账户记账请求流水号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.next_day_arrive_flg is '次日达标志';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.supv_acct is '监管账户';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.supv_acct_num is '监管账号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.supv_acct_num_acct_name is '监管账号户名称';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.supv_acct_num_open_org_id is '监管账号开户机构编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.sign_type_cd is '签约类型代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.refund_flg is '退款标志';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.init_msg_idf_id is '原报文标识编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.init_prtcpt_org_bank_no is '发起参与机构行号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.acct_ety_code is '会计分录编码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.acct_cate_cd is '账户类别代码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.resv_bd_flg is '预绑标志';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.st_msg_check_ser_num is '短信验证序列号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.mobile_no is '手机号码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.cert_no is '证件号码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.super_olbk_entry_rela_seq_num is '超级网银记账流水关联序号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.lmt_order_no is '限额订单号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.bind_flg is '绑定标志';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.esb_intfc_return_code is 'ESB接口返回码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.esb_intfc_return_info is 'ESB接口返回信息';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.esb_intfc_tran_flow_num is 'ESB接口交易流水号';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_super_olbk_tran_evt.etl_timestamp is 'ETL处理时间戳';
