/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_tef_tran_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_tef_tran_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_tef_tran_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tef_tran_evt(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,front_flow_num varchar2(60) -- 前置流水号
    ,front_dt date -- 前置日期
    ,front_tm varchar2(10) -- 前置时间
    ,host_flow_num varchar2(100) -- 主机流水号
    ,host_dt date -- 主机日期
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,teller_id varchar2(60) -- 柜员编号
    ,org_id varchar2(60) -- 机构编号
    ,auth_teller_id varchar2(60) -- 授权柜员编号
    ,auth_teller_dept_id varchar2(60) -- 授权柜员部门编号
    ,pass_id varchar2(60) -- 通道编号
    ,batch_dt date -- 批次日期
    ,batch_flow_num varchar2(60) -- 批次流水号
    ,pay_report_info_seq_num varchar2(60) -- 支付报单号信息序号
    ,init_tran_pay_odd_no varchar2(60) -- 原交易支付单号
    ,tran_subdv_type_cd varchar2(10) -- 交易细分类型代码
    ,bus_kind_cd varchar2(10) -- 业务种类代码
    ,entr_dt date -- 委托日期
    ,vouch_submit_num varchar2(60) -- 凭证提交号
    ,msg_id varchar2(60) -- 报文编号
    ,pkg_seq_num varchar2(60) -- 包序号
    ,pkg_dt date -- 包日期
    ,ec_flg varchar2(10) -- 钞汇标志
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,comm_fee_way number(30,8) -- 手续费方式
    ,comm_fee number(30,8) -- 手续费
    ,postage number(30,8) -- 邮电费
    ,todos number(30,8) -- 工本费
    ,vouch_type_cd varchar2(10) -- 凭证类型代码
    ,entr_vouch_id varchar2(60) -- 委托凭证编号
    ,intior_sys_num varchar2(60) -- 发起方系统号
    ,intior_rg_cd varchar2(10) -- 发起方地区代码
    ,origi_bank_no varchar2(60) -- 发起行行号
    ,pay_bank_no varchar2(60) -- 付款行行号
    ,payer_open_bank_no varchar2(60) -- 付款人开户行行号
    ,payer_acct_num varchar2(60) -- 付款人账号
    ,payer_name varchar2(150) -- 付款人名称
    ,payer_addr varchar2(150) -- 付款人地址
    ,recver_rg_cd varchar2(10) -- 收款方地区代码
    ,recv_bank_no varchar2(60) -- 收款行行号
    ,recver_open_bank_no varchar2(60) -- 收款人开户行行号
    ,recver_acct_num varchar2(60) -- 收款人账号
    ,recver_name varchar2(150) -- 收款人名称
    ,recver_addr varchar2(150) -- 收款人地址
    ,center_proc_num varchar2(60) -- 中心受理号
    ,clear_dt date -- 清算日期
    ,clear_num_site number(10) -- 清算场次
    ,init_origi_bank_no varchar2(60) -- 原发起行行号
    ,init_tran_subdv_type_cd varchar2(10) -- 原交易细分类型代码
    ,init_entr_dt date -- 原委托日期
    ,init_vouch_submit_num varchar2(60) -- 原凭证提交号
    ,init_host_flow_num varchar2(100) -- 原主机流水号
    ,init_host_dt date -- 原主机日期
    ,secd_magn_track_data varchar2(375) -- 第二磁道数据
    ,trd_magn_track_data varchar2(375) -- 第三磁道数据
    ,cash_tran_flg varchar2(10) -- 现金转账标志
    ,corp_priv_flg varchar2(10) -- 对公对私标志
    ,resp_bk_bus_proc_id varchar2(60) -- 回应行业务处理编号
    ,resp_bk_tran_proc_tm timestamp -- 回应行交易受理时间
    ,cont_id varchar2(60) -- 合同编号
    ,connet_id varchar2(60) -- 连接编号
    ,nostro_flg varchar2(10) -- 往来账标志
    ,status_cd varchar2(10) -- 状态代码
    ,err_code varchar2(45) -- 错误编码
    ,err_info varchar2(150) -- 错误信息
    ,recv_bank_name varchar2(150) -- 接收行行名称
    ,card_psbook_flg varchar2(10) -- 卡折标志
    ,pay_bank_name varchar2(150) -- 付款行行名称
    ,print_cnt number(10) -- 打印次数
    ,check_entry_dt date -- 对账日期
    ,cert_type_cd varchar2(10) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,intnal_acct_flg varchar2(10) -- 内部账标志
    ,actl_acct_num varchar2(60) -- 实际账号
    ,actl_deduct_acct_name varchar2(150) -- 实际扣账户名称
    ,tran_dt date -- 交易日期
    ,mode_pay_cd varchar2(10) -- 支付方式代码
    ,minor_tot_amt number(30,2) -- 次总金额
    ,midgrod_tran_code varchar2(45) -- 中台交易码
    ,recv_bank_num varchar2(60) -- 接收行行号
    ,err_return_code varchar2(45) -- 错误返回编码
    ,e_acct_cd varchar2(10) -- 电子账户代码
    ,happ_od_flg varchar2(10) -- 发生透支标志
    ,od_amt number(30,2) -- 透支金额
    ,chn_cd varchar2(10) -- 渠道代码
    ,next_day_arrive_idf number(10) -- 次日达标识
    ,auto_refund_flg varchar2(10) -- 自动退汇标志
    ,auto_refund_cnt number(10) -- 自动退汇次数
    ,auto_refund_info varchar2(375) -- 自动退汇信息
    ,vtual_acct_bind_acct varchar2(90) -- 虚户绑定账户
    ,vtual_acct_bind_acct_name varchar2(375) -- 虚户绑定账户名称
    ,acct_type_cd varchar2(20) -- 账户类型代码
    ,vtual_open_acct_org_id varchar2(60) -- 虚户绑定账户开户机构编号
    ,lmt_order_no varchar2(60) -- 限额订单号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,bus_flow_num varchar2(100) -- 业务流水号
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
grant select on ${iml_schema}.evt_tef_tran_evt to ${icl_schema};
grant select on ${iml_schema}.evt_tef_tran_evt to ${idl_schema};
grant select on ${iml_schema}.evt_tef_tran_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_tef_tran_evt is '省金服交易事件';
comment on column ${iml_schema}.evt_tef_tran_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_tef_tran_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_tef_tran_evt.front_flow_num is '前置流水号';
comment on column ${iml_schema}.evt_tef_tran_evt.front_dt is '前置日期';
comment on column ${iml_schema}.evt_tef_tran_evt.front_tm is '前置时间';
comment on column ${iml_schema}.evt_tef_tran_evt.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_tef_tran_evt.host_dt is '主机日期';
comment on column ${iml_schema}.evt_tef_tran_evt.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.evt_tef_tran_evt.teller_id is '柜员编号';
comment on column ${iml_schema}.evt_tef_tran_evt.org_id is '机构编号';
comment on column ${iml_schema}.evt_tef_tran_evt.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_tef_tran_evt.auth_teller_dept_id is '授权柜员部门编号';
comment on column ${iml_schema}.evt_tef_tran_evt.pass_id is '通道编号';
comment on column ${iml_schema}.evt_tef_tran_evt.batch_dt is '批次日期';
comment on column ${iml_schema}.evt_tef_tran_evt.batch_flow_num is '批次流水号';
comment on column ${iml_schema}.evt_tef_tran_evt.pay_report_info_seq_num is '支付报单号信息序号';
comment on column ${iml_schema}.evt_tef_tran_evt.init_tran_pay_odd_no is '原交易支付单号';
comment on column ${iml_schema}.evt_tef_tran_evt.tran_subdv_type_cd is '交易细分类型代码';
comment on column ${iml_schema}.evt_tef_tran_evt.bus_kind_cd is '业务种类代码';
comment on column ${iml_schema}.evt_tef_tran_evt.entr_dt is '委托日期';
comment on column ${iml_schema}.evt_tef_tran_evt.vouch_submit_num is '凭证提交号';
comment on column ${iml_schema}.evt_tef_tran_evt.msg_id is '报文编号';
comment on column ${iml_schema}.evt_tef_tran_evt.pkg_seq_num is '包序号';
comment on column ${iml_schema}.evt_tef_tran_evt.pkg_dt is '包日期';
comment on column ${iml_schema}.evt_tef_tran_evt.ec_flg is '钞汇标志';
comment on column ${iml_schema}.evt_tef_tran_evt.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_tef_tran_evt.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_tef_tran_evt.comm_fee_way is '手续费方式';
comment on column ${iml_schema}.evt_tef_tran_evt.comm_fee is '手续费';
comment on column ${iml_schema}.evt_tef_tran_evt.postage is '邮电费';
comment on column ${iml_schema}.evt_tef_tran_evt.todos is '工本费';
comment on column ${iml_schema}.evt_tef_tran_evt.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.evt_tef_tran_evt.entr_vouch_id is '委托凭证编号';
comment on column ${iml_schema}.evt_tef_tran_evt.intior_sys_num is '发起方系统号';
comment on column ${iml_schema}.evt_tef_tran_evt.intior_rg_cd is '发起方地区代码';
comment on column ${iml_schema}.evt_tef_tran_evt.origi_bank_no is '发起行行号';
comment on column ${iml_schema}.evt_tef_tran_evt.pay_bank_no is '付款行行号';
comment on column ${iml_schema}.evt_tef_tran_evt.payer_open_bank_no is '付款人开户行行号';
comment on column ${iml_schema}.evt_tef_tran_evt.payer_acct_num is '付款人账号';
comment on column ${iml_schema}.evt_tef_tran_evt.payer_name is '付款人名称';
comment on column ${iml_schema}.evt_tef_tran_evt.payer_addr is '付款人地址';
comment on column ${iml_schema}.evt_tef_tran_evt.recver_rg_cd is '收款方地区代码';
comment on column ${iml_schema}.evt_tef_tran_evt.recv_bank_no is '收款行行号';
comment on column ${iml_schema}.evt_tef_tran_evt.recver_open_bank_no is '收款人开户行行号';
comment on column ${iml_schema}.evt_tef_tran_evt.recver_acct_num is '收款人账号';
comment on column ${iml_schema}.evt_tef_tran_evt.recver_name is '收款人名称';
comment on column ${iml_schema}.evt_tef_tran_evt.recver_addr is '收款人地址';
comment on column ${iml_schema}.evt_tef_tran_evt.center_proc_num is '中心受理号';
comment on column ${iml_schema}.evt_tef_tran_evt.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_tef_tran_evt.clear_num_site is '清算场次';
comment on column ${iml_schema}.evt_tef_tran_evt.init_origi_bank_no is '原发起行行号';
comment on column ${iml_schema}.evt_tef_tran_evt.init_tran_subdv_type_cd is '原交易细分类型代码';
comment on column ${iml_schema}.evt_tef_tran_evt.init_entr_dt is '原委托日期';
comment on column ${iml_schema}.evt_tef_tran_evt.init_vouch_submit_num is '原凭证提交号';
comment on column ${iml_schema}.evt_tef_tran_evt.init_host_flow_num is '原主机流水号';
comment on column ${iml_schema}.evt_tef_tran_evt.init_host_dt is '原主机日期';
comment on column ${iml_schema}.evt_tef_tran_evt.secd_magn_track_data is '第二磁道数据';
comment on column ${iml_schema}.evt_tef_tran_evt.trd_magn_track_data is '第三磁道数据';
comment on column ${iml_schema}.evt_tef_tran_evt.cash_tran_flg is '现金转账标志';
comment on column ${iml_schema}.evt_tef_tran_evt.corp_priv_flg is '对公对私标志';
comment on column ${iml_schema}.evt_tef_tran_evt.resp_bk_bus_proc_id is '回应行业务处理编号';
comment on column ${iml_schema}.evt_tef_tran_evt.resp_bk_tran_proc_tm is '回应行交易受理时间';
comment on column ${iml_schema}.evt_tef_tran_evt.cont_id is '合同编号';
comment on column ${iml_schema}.evt_tef_tran_evt.connet_id is '连接编号';
comment on column ${iml_schema}.evt_tef_tran_evt.nostro_flg is '往来账标志';
comment on column ${iml_schema}.evt_tef_tran_evt.status_cd is '状态代码';
comment on column ${iml_schema}.evt_tef_tran_evt.err_code is '错误编码';
comment on column ${iml_schema}.evt_tef_tran_evt.err_info is '错误信息';
comment on column ${iml_schema}.evt_tef_tran_evt.recv_bank_name is '接收行行名称';
comment on column ${iml_schema}.evt_tef_tran_evt.card_psbook_flg is '卡折标志';
comment on column ${iml_schema}.evt_tef_tran_evt.pay_bank_name is '付款行行名称';
comment on column ${iml_schema}.evt_tef_tran_evt.print_cnt is '打印次数';
comment on column ${iml_schema}.evt_tef_tran_evt.check_entry_dt is '对账日期';
comment on column ${iml_schema}.evt_tef_tran_evt.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_tef_tran_evt.cert_no is '证件号码';
comment on column ${iml_schema}.evt_tef_tran_evt.intnal_acct_flg is '内部账标志';
comment on column ${iml_schema}.evt_tef_tran_evt.actl_acct_num is '实际账号';
comment on column ${iml_schema}.evt_tef_tran_evt.actl_deduct_acct_name is '实际扣账户名称';
comment on column ${iml_schema}.evt_tef_tran_evt.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_tef_tran_evt.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.evt_tef_tran_evt.minor_tot_amt is '次总金额';
comment on column ${iml_schema}.evt_tef_tran_evt.midgrod_tran_code is '中台交易码';
comment on column ${iml_schema}.evt_tef_tran_evt.recv_bank_num is '接收行行号';
comment on column ${iml_schema}.evt_tef_tran_evt.err_return_code is '错误返回编码';
comment on column ${iml_schema}.evt_tef_tran_evt.e_acct_cd is '电子账户代码';
comment on column ${iml_schema}.evt_tef_tran_evt.happ_od_flg is '发生透支标志';
comment on column ${iml_schema}.evt_tef_tran_evt.od_amt is '透支金额';
comment on column ${iml_schema}.evt_tef_tran_evt.chn_cd is '渠道代码';
comment on column ${iml_schema}.evt_tef_tran_evt.next_day_arrive_idf is '次日达标识';
comment on column ${iml_schema}.evt_tef_tran_evt.auto_refund_flg is '自动退汇标志';
comment on column ${iml_schema}.evt_tef_tran_evt.auto_refund_cnt is '自动退汇次数';
comment on column ${iml_schema}.evt_tef_tran_evt.auto_refund_info is '自动退汇信息';
comment on column ${iml_schema}.evt_tef_tran_evt.vtual_acct_bind_acct is '虚户绑定账户';
comment on column ${iml_schema}.evt_tef_tran_evt.vtual_acct_bind_acct_name is '虚户绑定账户名称';
comment on column ${iml_schema}.evt_tef_tran_evt.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.evt_tef_tran_evt.vtual_open_acct_org_id is '虚户绑定账户开户机构编号';
comment on column ${iml_schema}.evt_tef_tran_evt.lmt_order_no is '限额订单号';
comment on column ${iml_schema}.evt_tef_tran_evt.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_tef_tran_evt.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_tef_tran_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_tef_tran_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_tef_tran_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_tef_tran_evt.etl_timestamp is 'ETL处理时间戳';
