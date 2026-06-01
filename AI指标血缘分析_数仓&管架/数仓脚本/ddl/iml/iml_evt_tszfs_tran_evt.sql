/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_tszfs_tran_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_tszfs_tran_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_tszfs_tran_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tszfs_tran_evt(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,midgrod_flow_num varchar2(60) -- 中台流水号
    ,tran_dt date -- 交易日期
    ,bank_int_bus_seq_num varchar2(60) -- 行内业务序号
    ,msg_type_id varchar2(60) -- 报文类型编号
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,bus_id varchar2(60) -- 业务编号
    ,pay_tran_seq_num varchar2(60) -- 支付交易序号
    ,dtl_entr_dt date -- 明细委托日期
    ,csner_id varchar2(60) -- 委托方编号
    ,belong_batch_bus_seq_num varchar2(60) -- 所属批量包业务序号
    ,pkg_seq_num varchar2(60) -- 包序号
    ,host_tran_code varchar2(45) -- 主机交易码
    ,midgrod_tran_code varchar2(45) -- 中台交易码
    ,host_dt date -- 主机日期
    ,host_flow_num varchar2(250) -- 主机流水号
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,pay_bank_no varchar2(60) -- 付款行行号
    ,pay_bank_name varchar2(375) -- 付款行行名称
    ,recv_bank_no varchar2(60) -- 收款行行号
    ,recv_bank_name varchar2(375) -- 收款行行名称
    ,payer_open_bank_no varchar2(60) -- 付款人开户行行号
    ,payer_open_bank_name varchar2(375) -- 付款人开户行名称
    ,payer_acct_num varchar2(60) -- 付款人账号
    ,payer_name varchar2(375) -- 付款人名称
    ,payer_addr varchar2(375) -- 付款人地址
    ,recver_open_bank_no varchar2(60) -- 收款人开户行行号
    ,recver_open_bank_name varchar2(375) -- 收款人开户行名称
    ,recver_acct_num varchar2(60) -- 收款人账号
    ,recver_name varchar2(375) -- 收款人名称
    ,recver_addr varchar2(375) -- 收款人地址
    ,init_bus_type_cd varchar2(10) -- 原业务类型代码
    ,init_entr_dt date -- 原委托日期
    ,init_pay_tran_seq_num varchar2(60) -- 原支付交易序号
    ,init_csner_id varchar2(60) -- 原委托方编号
    ,init_belong_bus_seq_num varchar2(60) -- 原所属包业务序号
    ,offs_bal_num_site number(10) -- 轧差场次
    ,offs_bal_dt date -- 轧差日期
    ,proc_status_cd varchar2(10) -- 处理状态代码
    ,rest_cd varchar2(10) -- 处理结果代码
    ,nostro_flg varchar2(10) -- 往来账标志
    ,debit_crdt_cd varchar2(10) -- 借贷代码
    ,proc_org_id varchar2(60) -- 处理机构编号
    ,input_teller_id varchar2(60) -- 录入柜员编号
    ,check_teller_id varchar2(60) -- 复核柜员编号
    ,auth_teller_id varchar2(60) -- 授权柜员编号
    ,input_check_teller_dept_id varchar2(60) -- 录入复核柜员部门编号
    ,auth_teller_dept_id varchar2(60) -- 授权柜员部门编号
    ,refund_rs_cd varchar2(20) -- 退汇原因代码
    ,sys_type_cd varchar2(10) -- 系统类型代码
    ,node_type_cd varchar2(10) -- 节点类型代码
    ,refund_rest_cd varchar2(10) -- 退汇结果代码
    ,center_return_status_cd varchar2(10) -- 中心返回状态代码
    ,center_return_proc_code varchar2(45) -- 中心返回处理编码
    ,center_return_process_cd_comnt varchar2(375) -- 中心返回处理码处理说明
    ,bank_return_proc_code varchar2(45) -- 银行返回处理编码
    ,bank_return_process_cd_comnt varchar2(375) -- 银行返回处理码处理说明
    ,reg_bus_batch_no varchar2(60) -- 定期业务批次号
    ,clear_dt date -- 清算日期
    ,err_code varchar2(45) -- 错误编码
    ,err_info varchar2(750) -- 错误信息
    ,prior_level varchar2(30) -- 优先级别
    ,check_entry_status_cd varchar2(10) -- 对账状态代码
    ,print_cnt number(10) -- 打印次数
    ,nostro_tm timestamp -- 往来账时间
    ,charge_flg varchar2(10) -- 收费标志
    ,bank_int_out_line_flg varchar2(10) -- 行内行外标志
    ,matn_enter_acct_acct_num varchar2(60) -- 维护入账账号
    ,reg_main_name varchar2(375) -- 挂账或维护入账姓名
    ,matn_enter_acct_dt date -- 维护入账日期
    ,matn_enter_acct_teller_id varchar2(60) -- 维护入账柜员编号
    ,matn_enter_acct_dept_id varchar2(60) -- 维护入账部门编号
    ,mpr_host_flow_num varchar2(250) -- 维护入账冲账主机流水号
    ,mpr_host_dt date -- 维护入账冲账主机日期
    ,mpr_teller_id varchar2(60) -- 维护入账冲账柜员编号
    ,agent_flg varchar2(10) -- 代理标志
    ,vouch_type_cd varchar2(10) -- 凭证类型代码
    ,entr_vouch_dt date -- 委托凭证日期
    ,entr_vouch_id varchar2(60) -- 委托凭证编号
    ,cert_kind_cd varchar2(10) -- 证件种类代码
    ,cert_no varchar2(60) -- 证件号码
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,send_tran_flow_num varchar2(60) -- 发送交易流水号
    ,mode_pay_cd varchar2(10) -- 支付方式代码
    ,exch_bus_cors_tran_chn_cd varchar2(10) -- 汇兑业务对应交易渠道代码
    ,comm_fee number(30,8) -- 手续费
    ,remit_tran_fee number(30,8) -- 汇划费
    ,todos number(30,8) -- 工本费
    ,comm_fee_tot number(30,8) -- 手续费总额
    ,recnt_modif_tm timestamp -- 最近修改时间
    ,rec_status_cd varchar2(10) -- 记录状态代码
    ,prod_cd varchar2(10) -- 产品代码
    ,intnal_acct_flg varchar2(10) -- 内部账标志
    ,actl_deduct_acct_num varchar2(60) -- 实际扣账账号
    ,actl_deduct_acct_name varchar2(150) -- 实际扣账户名称
    ,ground_proc_status_cd varchar2(10) -- 落地处理状态代码
    ,verify_proc_status_cd varchar2(10) -- 查证处理状态代码
    ,rgst_addit_data_name varchar2(150) -- 登记附加数据表名称
    ,on_acct_rs_cd varchar2(10) -- 挂账原因代码
    ,modif_teller_id varchar2(60) -- 修改柜员编号
    ,rg_cd varchar2(10) -- 地区代码
    ,acct_info_check_flg varchar2(10) -- 账户信息检查标志
    ,cash_tran_flg varchar2(10) -- 现金转账标志
    ,realtm_crdt_enter_acct_flg varchar2(10) -- 实时贷记实时入账标志
    ,ec_flg varchar2(10) -- 钞汇标志
    ,reg_debit_crdt_agt_id varchar2(60) -- 定期借贷记协议编号
    ,reissue_flg varchar2(10) -- 补发标志
    ,bill_flg varchar2(10) -- 票据标志
    ,bill_type_cd varchar2(10) -- 票据类型代码
    ,bill_num varchar2(60) -- 票据号码
    ,chn_dt date -- 渠道日期
    ,chn_flow_num varchar2(60) -- 渠道流水号
    ,init_bus_seq_num varchar2(60) -- 原业务包序号
    ,corp_cd varchar2(20) -- 企业单位代码
    ,fee_item_cd varchar2(10) -- 费项代码
    ,fee_item_name varchar2(150) -- 费项名称
    ,bus_amt number(30,2) -- 业务金额
    ,pay_bank_withhold_comm_fee number(30,8) -- 需付款行代扣手续费
    ,strk_bal_rs varchar2(750) -- 冲账原因
    ,happ_od_flg varchar2(10) -- 发生透支标志
    ,od_amt number(30,2) -- 透支金额
    ,delay_duran_cd varchar2(10) -- 延时时长代码
    ,auto_refund_flg varchar2(10) -- 自动退汇标志
    ,auto_refund_cnt number(10) -- 自动退汇次数
    ,vtual_acct_bind_acct varchar2(90) -- 虚户绑定账户
    ,vtual_acct_bind_acct_name varchar2(375) -- 虚户绑定账户名称
    ,indv_corp_flg varchar2(10) -- 个人企业标志
    ,upp_return_order_no varchar2(60) -- UPP返回订单号
    ,actl_recver_num_type_cd varchar2(100) -- 实际收款人账号类型代码
    ,acct_type_cd varchar2(20) -- 账户类型代码
    ,vtual_open_acct_org_id varchar2(60) -- 虚户绑定账户开户机构编号
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,acct_cate_cd varchar2(20) -- 账户类别代码
    ,follow_up_oper_flg varchar2(10) -- 后续操作标志
    ,cust_id varchar2(60) -- 交易客户编号
    ,agt_id varchar2(60) -- 协议编号
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
grant select on ${iml_schema}.evt_tszfs_tran_evt to ${icl_schema};
grant select on ${iml_schema}.evt_tszfs_tran_evt to ${idl_schema};
grant select on ${iml_schema}.evt_tszfs_tran_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_tszfs_tran_evt is '深同城交易事件';
comment on column ${iml_schema}.evt_tszfs_tran_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_tszfs_tran_evt.bank_int_bus_seq_num is '行内业务序号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.msg_type_id is '报文类型编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.bus_id is '业务编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.pay_tran_seq_num is '支付交易序号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.dtl_entr_dt is '明细委托日期';
comment on column ${iml_schema}.evt_tszfs_tran_evt.csner_id is '委托方编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.belong_batch_bus_seq_num is '所属批量包业务序号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.pkg_seq_num is '包序号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.host_tran_code is '主机交易码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.midgrod_tran_code is '中台交易码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.host_dt is '主机日期';
comment on column ${iml_schema}.evt_tszfs_tran_evt.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_tszfs_tran_evt.pay_bank_no is '付款行行号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.pay_bank_name is '付款行行名称';
comment on column ${iml_schema}.evt_tszfs_tran_evt.recv_bank_no is '收款行行号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.recv_bank_name is '收款行行名称';
comment on column ${iml_schema}.evt_tszfs_tran_evt.payer_open_bank_no is '付款人开户行行号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.payer_open_bank_name is '付款人开户行名称';
comment on column ${iml_schema}.evt_tszfs_tran_evt.payer_acct_num is '付款人账号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.payer_name is '付款人名称';
comment on column ${iml_schema}.evt_tszfs_tran_evt.payer_addr is '付款人地址';
comment on column ${iml_schema}.evt_tszfs_tran_evt.recver_open_bank_no is '收款人开户行行号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.recver_open_bank_name is '收款人开户行名称';
comment on column ${iml_schema}.evt_tszfs_tran_evt.recver_acct_num is '收款人账号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.recver_name is '收款人名称';
comment on column ${iml_schema}.evt_tszfs_tran_evt.recver_addr is '收款人地址';
comment on column ${iml_schema}.evt_tszfs_tran_evt.init_bus_type_cd is '原业务类型代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.init_entr_dt is '原委托日期';
comment on column ${iml_schema}.evt_tszfs_tran_evt.init_pay_tran_seq_num is '原支付交易序号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.init_csner_id is '原委托方编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.init_belong_bus_seq_num is '原所属包业务序号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.offs_bal_num_site is '轧差场次';
comment on column ${iml_schema}.evt_tszfs_tran_evt.offs_bal_dt is '轧差日期';
comment on column ${iml_schema}.evt_tszfs_tran_evt.proc_status_cd is '处理状态代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.rest_cd is '处理结果代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.nostro_flg is '往来账标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.debit_crdt_cd is '借贷代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.proc_org_id is '处理机构编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.input_teller_id is '录入柜员编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.input_check_teller_dept_id is '录入复核柜员部门编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.auth_teller_dept_id is '授权柜员部门编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.refund_rs_cd is '退汇原因代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.sys_type_cd is '系统类型代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.node_type_cd is '节点类型代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.refund_rest_cd is '退汇结果代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.center_return_status_cd is '中心返回状态代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.center_return_proc_code is '中心返回处理编码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.center_return_process_cd_comnt is '中心返回处理码处理说明';
comment on column ${iml_schema}.evt_tszfs_tran_evt.bank_return_proc_code is '银行返回处理编码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.bank_return_process_cd_comnt is '银行返回处理码处理说明';
comment on column ${iml_schema}.evt_tszfs_tran_evt.reg_bus_batch_no is '定期业务批次号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_tszfs_tran_evt.err_code is '错误编码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.err_info is '错误信息';
comment on column ${iml_schema}.evt_tszfs_tran_evt.prior_level is '优先级别';
comment on column ${iml_schema}.evt_tszfs_tran_evt.check_entry_status_cd is '对账状态代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.print_cnt is '打印次数';
comment on column ${iml_schema}.evt_tszfs_tran_evt.nostro_tm is '往来账时间';
comment on column ${iml_schema}.evt_tszfs_tran_evt.charge_flg is '收费标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.bank_int_out_line_flg is '行内行外标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.matn_enter_acct_acct_num is '维护入账账号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.reg_main_name is '挂账或维护入账姓名';
comment on column ${iml_schema}.evt_tszfs_tran_evt.matn_enter_acct_dt is '维护入账日期';
comment on column ${iml_schema}.evt_tszfs_tran_evt.matn_enter_acct_teller_id is '维护入账柜员编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.matn_enter_acct_dept_id is '维护入账部门编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.mpr_host_flow_num is '维护入账冲账主机流水号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.mpr_host_dt is '维护入账冲账主机日期';
comment on column ${iml_schema}.evt_tszfs_tran_evt.mpr_teller_id is '维护入账冲账柜员编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.agent_flg is '代理标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.entr_vouch_dt is '委托凭证日期';
comment on column ${iml_schema}.evt_tszfs_tran_evt.entr_vouch_id is '委托凭证编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.cert_kind_cd is '证件种类代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.cert_no is '证件号码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.send_tran_flow_num is '发送交易流水号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.exch_bus_cors_tran_chn_cd is '汇兑业务对应交易渠道代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.comm_fee is '手续费';
comment on column ${iml_schema}.evt_tszfs_tran_evt.remit_tran_fee is '汇划费';
comment on column ${iml_schema}.evt_tszfs_tran_evt.todos is '工本费';
comment on column ${iml_schema}.evt_tszfs_tran_evt.comm_fee_tot is '手续费总额';
comment on column ${iml_schema}.evt_tszfs_tran_evt.recnt_modif_tm is '最近修改时间';
comment on column ${iml_schema}.evt_tszfs_tran_evt.rec_status_cd is '记录状态代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.prod_cd is '产品代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.intnal_acct_flg is '内部账标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.actl_deduct_acct_num is '实际扣账账号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.actl_deduct_acct_name is '实际扣账户名称';
comment on column ${iml_schema}.evt_tszfs_tran_evt.ground_proc_status_cd is '落地处理状态代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.verify_proc_status_cd is '查证处理状态代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.rgst_addit_data_name is '登记附加数据表名称';
comment on column ${iml_schema}.evt_tszfs_tran_evt.on_acct_rs_cd is '挂账原因代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.modif_teller_id is '修改柜员编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.rg_cd is '地区代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.acct_info_check_flg is '账户信息检查标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.cash_tran_flg is '现金转账标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.realtm_crdt_enter_acct_flg is '实时贷记实时入账标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.ec_flg is '钞汇标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.reg_debit_crdt_agt_id is '定期借贷记协议编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.reissue_flg is '补发标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.bill_flg is '票据标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.bill_num is '票据号码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.chn_dt is '渠道日期';
comment on column ${iml_schema}.evt_tszfs_tran_evt.chn_flow_num is '渠道流水号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.init_bus_seq_num is '原业务包序号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.corp_cd is '企业单位代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.fee_item_cd is '费项代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.fee_item_name is '费项名称';
comment on column ${iml_schema}.evt_tszfs_tran_evt.bus_amt is '业务金额';
comment on column ${iml_schema}.evt_tszfs_tran_evt.pay_bank_withhold_comm_fee is '需付款行代扣手续费';
comment on column ${iml_schema}.evt_tszfs_tran_evt.strk_bal_rs is '冲账原因';
comment on column ${iml_schema}.evt_tszfs_tran_evt.happ_od_flg is '发生透支标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.od_amt is '透支金额';
comment on column ${iml_schema}.evt_tszfs_tran_evt.delay_duran_cd is '延时时长代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.auto_refund_flg is '自动退汇标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.auto_refund_cnt is '自动退汇次数';
comment on column ${iml_schema}.evt_tszfs_tran_evt.vtual_acct_bind_acct is '虚户绑定账户';
comment on column ${iml_schema}.evt_tszfs_tran_evt.vtual_acct_bind_acct_name is '虚户绑定账户名称';
comment on column ${iml_schema}.evt_tszfs_tran_evt.indv_corp_flg is '个人企业标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.upp_return_order_no is 'UPP返回订单号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.actl_recver_num_type_cd is '实际收款人账号类型代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.vtual_open_acct_org_id is '虚户绑定账户开户机构编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.acct_cate_cd is '账户类别代码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.follow_up_oper_flg is '后续操作标志';
comment on column ${iml_schema}.evt_tszfs_tran_evt.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.agt_id is '协议编号';
comment on column ${iml_schema}.evt_tszfs_tran_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_tszfs_tran_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_tszfs_tran_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_tszfs_tran_evt.etl_timestamp is 'ETL处理时间戳';
