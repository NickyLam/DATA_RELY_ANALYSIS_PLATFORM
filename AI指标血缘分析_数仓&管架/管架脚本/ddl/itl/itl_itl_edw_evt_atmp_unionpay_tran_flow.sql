/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_evt_atmp_unionpay_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,send_org_id varchar2(100) -- 发送机构编号
    ,sys_follow_id varchar2(100) -- 系统跟踪编号
    ,tran_tm varchar2(30) -- 交易时间
    ,tran_cd varchar2(30) -- 交易代码
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,proc_org_id varchar2(100) -- 受理机构编号
    ,tran_dt date -- 交易日期
    ,teller_id varchar2(100) -- 柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,chn_cd varchar2(30) -- 渠道代码
    ,msg_type_cd varchar2(30) -- 报文类型代码
    ,main_acct_id varchar2(100) -- 主账户编号
    ,proc_cd varchar2(30) -- 处理代码
    ,intnal_proc_cd varchar2(30) -- 内部处理代码
    ,tran_amt number(30,8) -- 交易金额
    ,onl_acct_bal number(30,8) -- 联机账户余额
    ,acct_td_aval_bal number(30,8) -- 账户当日可用余额
    ,atm_draw_td_aval_bal number(30,8) -- ATM取款当日可用余额
    ,tran_fee varchar2(30) -- 交易费用
    ,proc_org_site_tm varchar2(30) -- 受理机构所在地时间
    ,proc_org_site_dt varchar2(30) -- 受理机构所在地日期
    ,clear_dt varchar2(30) -- 清算日期
    ,mercht_type_cd varchar2(30) -- 商户类型代码
    ,tran_serv_input_way_cd varchar2(30) -- 交易服务点输入方式代码
    ,tran_serv_cond_cd varchar2(30) -- 交易服务点条件代码
    ,retriv_ref_id varchar2(100) -- 检索参考编号
    ,apprv_tran_auth_id varchar2(100) -- 批准交易授权编号
    ,return_code varchar2(30) -- 返回码
    ,proc_termn_id varchar2(100) -- 受理终端编号
    ,proc_mercht_id varchar2(100) -- 受理商户编号
    ,proc_mercht_name varchar2(100) -- 受理商户名称
    ,addit_resp_descb varchar2(100) -- 附加响应描述
    ,addit_priv varchar2(1000) -- 附加私有域
    ,curr_cd varchar2(30) -- 币种代码
    ,resv_region varchar2(250) -- 保留域
    ,recv_org_id varchar2(100) -- 接收机构编号
    ,cups_resv_num varchar2(250) -- CUPS保留号
    ,init_proc_org_id varchar2(100) -- 原受理机构编号
    ,init_send_org_id varchar2(100) -- 原发送机构编号
    ,init_sys_follow_id varchar2(100) -- 原系统跟踪编号
    ,init_tran_tm timestamp -- 原交易时间
    ,unionpay_exch_rat varchar2(250) -- 银联汇率
    ,expns_acct_id varchar2(100) -- 支出账户编号
    ,depot_acct_id varchar2(100) -- 存入账户编号
    ,atmc_tran_flow_num varchar2(100) -- ATMC交易流水号
    ,msg_head_info varchar2(250) -- 报文头信息
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,err_cd varchar2(30) -- 错误码
    ,err_info varchar2(250) -- 错误信息
    ,termn_type_cd varchar2(30) -- 终端类型代码
    ,init_way_cd varchar2(30) -- 发起方式代码
    ,mercht_cty_rg_cd varchar2(30) -- 商户国家地区代码
    ,deduct_amt number(30,8) -- 扣款金额
    ,deduct_exch_rat number(30,8) -- 扣款汇率
    ,clear_amt number(30,8) -- 清算金额
    ,send_org_actl_id varchar2(100) -- 发送机构实际编号
    ,cross_bor_flg varchar2(10) -- 跨境标志
    ,card_ser_num varchar2(100) -- 卡序列号
    ,access_ic_data_region varchar2(1000) -- 接入IC卡数据域
    ,send_ic_data_region varchar2(1000) -- 发出IC卡数据域
    ,intnal_tran_cd varchar2(30) -- 内部交易代码
    ,fcurr_tran_amt number(30,8) -- 外币交易金额
    ,bank_acct_type_cd varchar2(30) -- 银行账户类型代码
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,comm_fee number(30,8) -- 手续费
    ,card_type_cd varchar2(30) -- 卡类型代码
    ,card_tran_type_cd varchar2(30) -- 卡交易类型代码
    ,qr_code_pay_scene_cd varchar2(30) -- 二维码付款场景代码
    ,cross_bank_flg varchar2(10) -- 跨行标志
    ,degr_flg varchar2(10) -- 降级标志
    ,beps_unpasew_flg varchar2(10) -- 小额免密标志
    ,subclass_return_code varchar2(30) -- 细类返回码
    ,memo_cd varchar2(30) -- 摘要代码
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,init_tran_flow_num varchar2(100) -- 原交易流水号
    ,upp_enter_status_cd varchar2(30) -- UPP入账状态代码
    ,entry_flow_num varchar2(100) -- 记账流水号
    ,entry_dt date -- 记账日期
    ,delay_deduct_tran_flow_num varchar2(100) -- 延时扣款交易流水号
    ,delay_deduct_tran_dt date -- 延时扣款交易日期
    ,unionpay_delay_tran_return_cd varchar2(30) -- 银联延时转账返回代码
    ,delay_tran_return_cd varchar2(30) -- 延时转账返回代码
    ,termn_equip_id varchar2(100) -- 终端设备编号
    ,termn_ip_addr varchar2(100) -- 终端IP地址
    ,termn_sim_num varchar2(100) -- 终端SIM号码
    ,termn_gps_position varchar2(100) -- 终端GPS位置
    ,rsrv_mobile_no varchar2(60) -- 预留手机号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,midgrod_tran_dt timestamp -- 中台交易日期
    ,acct_dt date -- 账务日期
    ,init_tran_cd varchar2(30) -- 原交易代码
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow is 'ATMP银联前置交易流水';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.evt_id is '事件编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.send_org_id is '发送机构编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.sys_follow_id is '系统跟踪编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.tran_tm is '交易时间';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.tran_cd is '交易代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.tran_type_cd is '交易类型代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.proc_org_id is '受理机构编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.tran_dt is '交易日期';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.teller_id is '柜员编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.tran_org_id is '交易机构编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.chn_cd is '渠道代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.msg_type_cd is '报文类型代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.main_acct_id is '主账户编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.proc_cd is '处理代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.intnal_proc_cd is '内部处理代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.tran_amt is '交易金额';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.onl_acct_bal is '联机账户余额';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.acct_td_aval_bal is '账户当日可用余额';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.atm_draw_td_aval_bal is 'ATM取款当日可用余额';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.tran_fee is '交易费用';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.proc_org_site_tm is '受理机构所在地时间';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.proc_org_site_dt is '受理机构所在地日期';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.clear_dt is '清算日期';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.mercht_type_cd is '商户类型代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.tran_serv_input_way_cd is '交易服务点输入方式代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.tran_serv_cond_cd is '交易服务点条件代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.retriv_ref_id is '检索参考编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.apprv_tran_auth_id is '批准交易授权编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.return_code is '返回码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.proc_termn_id is '受理终端编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.proc_mercht_id is '受理商户编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.proc_mercht_name is '受理商户名称';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.addit_resp_descb is '附加响应描述';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.addit_priv is '附加私有域';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.curr_cd is '币种代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.resv_region is '保留域';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.recv_org_id is '接收机构编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.cups_resv_num is 'CUPS保留号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.init_proc_org_id is '原受理机构编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.init_send_org_id is '原发送机构编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.init_sys_follow_id is '原系统跟踪编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.init_tran_tm is '原交易时间';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.unionpay_exch_rat is '银联汇率';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.expns_acct_id is '支出账户编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.depot_acct_id is '存入账户编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.atmc_tran_flow_num is 'ATMC交易流水号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.msg_head_info is '报文头信息';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.err_cd is '错误码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.err_info is '错误信息';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.termn_type_cd is '终端类型代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.init_way_cd is '发起方式代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.mercht_cty_rg_cd is '商户国家地区代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.deduct_amt is '扣款金额';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.deduct_exch_rat is '扣款汇率';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.clear_amt is '清算金额';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.send_org_actl_id is '发送机构实际编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.cross_bor_flg is '跨境标志';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.card_ser_num is '卡序列号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.access_ic_data_region is '接入IC卡数据域';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.send_ic_data_region is '发出IC卡数据域';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.intnal_tran_cd is '内部交易代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.fcurr_tran_amt is '外币交易金额';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.bank_acct_type_cd is '银行账户类型代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.open_acct_org_id is '开户机构编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.comm_fee is '手续费';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.card_type_cd is '卡类型代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.card_tran_type_cd is '卡交易类型代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.qr_code_pay_scene_cd is '二维码付款场景代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.cross_bank_flg is '跨行标志';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.degr_flg is '降级标志';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.beps_unpasew_flg is '小额免密标志';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.subclass_return_code is '细类返回码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.memo_cd is '摘要代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.ova_flow_num is '全局流水号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.tran_flow_num is '交易流水号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.init_tran_flow_num is '原交易流水号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.upp_enter_status_cd is 'UPP入账状态代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.entry_flow_num is '记账流水号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.entry_dt is '记账日期';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.delay_deduct_tran_flow_num is '延时扣款交易流水号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.delay_deduct_tran_dt is '延时扣款交易日期';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.unionpay_delay_tran_return_cd is '银联延时转账返回代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.delay_tran_return_cd is '延时转账返回代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.termn_equip_id is '终端设备编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.termn_ip_addr is '终端IP地址';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.termn_sim_num is '终端SIM号码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.termn_gps_position is '终端GPS位置';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.rsrv_mobile_no is '预留手机号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.cust_id is '客户编号';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.cust_name is '客户名称';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.midgrod_tran_dt is '中台交易日期';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.acct_dt is '账务日期';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.init_tran_cd is '原交易代码';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow.etl_timestamp is 'ETL处理时间戳';