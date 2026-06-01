/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_scss_unp_atm_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_scss_unp_atm_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_scss_unp_atm_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_scss_unp_atm_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,sys_dt date -- 系统日期
    ,sys_flow_num varchar2(100) -- 系统流水号
    ,req_flow_num varchar2(100) -- 请求流水号
    ,aldy_revo_flg varchar2(10) -- 已撤销标志
    ,revo_flow_num varchar2(100) -- 撤销流水号
    ,revo_front_flow_num varchar2(100) -- 撤销前置流水号
    ,chn_id varchar2(100) -- 渠道编号
    ,src_chn_id varchar2(100) -- 源渠道编号
    ,chn_dt date -- 渠道日期
    ,check_entry_code varchar2(60) -- 对账编码
    ,mercht_type_cd varchar2(30) -- 商户类型代码
    ,mercht_id varchar2(100) -- 商户编号
    ,mercht_name varchar2(500) -- 商户名称
    ,unionpay_org_id varchar2(100) -- 银联机构编号
    ,unionpay_rg_code varchar2(100) -- 银联地区码
    ,agent_org_id varchar2(100) -- 代理机构编号
    ,tran_code varchar2(100) -- 交易码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,return_code varchar2(100) -- 返回码
    ,return_descb varchar2(500) -- 返回描述
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,init_intfc_code varchar2(100) -- 原接口码
    ,tran_sub_module_code varchar2(100) -- 交易子模块码
    ,tran_acct_id varchar2(100) -- 交易账户编号
    ,tran_acct_name varchar2(500) -- 交易账户名称
    ,tran_acct_type_cd varchar2(30) -- 交易账户类型代码
    ,card_iss_org_id varchar2(100) -- 发卡机构编号
    ,card_level_cd varchar2(30) -- 卡片等级代码
    ,stl_card_flg varchar2(10) -- 单位结算卡标志
    ,corp_stl_card_lp_name varchar2(500) -- 单位结算卡法人姓名
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,mobile_no varchar2(60) -- 手机号码
    ,tran_out_acct_id varchar2(100) -- 转出账户编号
    ,tran_out_acct_name varchar2(500) -- 转出账户名称
    ,tran_out_acct_org_id varchar2(100) -- 转出账户机构编号
    ,tran_in_acct_id varchar2(100) -- 转入账户编号
    ,tran_in_acct_name varchar2(500) -- 转入账户名称
    ,tran_in_acct_org_id varchar2(100) -- 转入账户机构编号
    ,dr_acct_id1 varchar2(100) -- 借方账户编号一
    ,dr_acct_name1 varchar2(500) -- 借方账户名称一
    ,cr_acct_id1 varchar2(100) -- 贷方账户编号一
    ,cr_acct_name1 varchar2(500) -- 贷方账户名称一
    ,tran_amt1 number(30,2) -- 交易金额一
    ,dr_acct_id2 varchar2(100) -- 借方账户编号二
    ,dr_acct_name2 varchar2(500) -- 借方账户名称二
    ,cr_acct_id2 varchar2(100) -- 贷方账户编号二
    ,cr_acct_name2 varchar2(500) -- 贷方账户名称二
    ,tran_amt2 number(30,2) -- 交易金额二
    ,dr_acct_id3 varchar2(100) -- 借方账户编号三
    ,dr_acct_name3 varchar2(500) -- 借方账户名称三
    ,cr_acct_id3 varchar2(100) -- 贷方账户编号三
    ,cr_acct_name3 varchar2(500) -- 贷方账户名称三
    ,tran_amt3 number(30,2) -- 交易金额三
    ,dr_acct_id4 varchar2(100) -- 借方账户编号四
    ,dr_acct_name4 varchar2(500) -- 借方账户名称四
    ,cr_acct_id4 varchar2(100) -- 贷方账户编号四
    ,cr_acct_name4 varchar2(500) -- 贷方账户名称四
    ,tran_amt4 number(30,2) -- 交易金额四
    ,comm_fee_dr_acct_id varchar2(100) -- 手续费借方账户编号
    ,comm_fee_dr_acct_name varchar2(500) -- 手续费借方账户名称
    ,comm_fee_cr_acct_id varchar2(100) -- 手续费贷方账户编号
    ,comm_fee_cr_acct_name varchar2(500) -- 手续费贷方账户名称
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,remark1 varchar2(500) -- 手续费备注信息
    ,actl_bal number(30,2) -- 实际余额
    ,acct_bal number(30,2) -- 账户余额
    ,remark2 varchar2(500) -- 闲钱宝备注信息
    ,serv_src_init_sys_id varchar2(100) -- 服务源发起系统编号
    ,serv_target_sys_id varchar2(100) -- 服务目标系统编号
    ,serv_msg_id varchar2(100) -- 服务消息编号
    ,serv_caller_sys_id varchar2(100) -- 服务调用方系统编号
    ,serv_ova_flow_num varchar2(100) -- 服务全局流水号
    ,serv_caller_tran_flow_num varchar2(500) -- 服务调用方交易流水号
    ,serv_caller_tran_dt date -- 服务调用方交易日期
    ,serv_name varchar2(500) -- 服务名称
    ,serv_tran_code varchar2(100) -- 服务交易码
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,core_dt date -- 核心日期
    ,core_return_code varchar2(100) -- 核心返回码
    ,core_return_info varchar2(500) -- 核心返回信息
    ,froz_dt date -- 冻结日期
    ,froz_flow varchar2(100) -- 冻结流水
    ,init_serv_caller_tran_flow_num varchar2(100) -- 原服务调用方交易流水号
    ,init_serv_caller_tran_dt date -- 原服务调用方交易日期
    ,init_upp_tran_flow_num varchar2(100) -- 原UPP交易流水号
    ,init_upp_tran_dt date -- 原UPP交易日期
    ,init_froz_dt date -- 原冻结日期
    ,init_froz_flow_num varchar2(100) -- 原冻结流水号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_belong_org_id varchar2(100) -- 客户所属机构编号
    ,auth_flow_num varchar2(100) -- 授权流水号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,tran_serv_process_cd varchar2(100) -- 交易服务处理码
    ,acctnt_dt date -- 会计日期
    ,insto_dt date -- 入库日期
    ,final_update_dt date -- 最后更新日期
    ,remark varchar2(500) -- 备注
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
grant select on ${iml_schema}.evt_scss_unp_atm_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_scss_unp_atm_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_scss_unp_atm_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_scss_unp_atm_tran_flow is '自助渠道银联和ATM交易流水';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.sys_dt is '系统日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.sys_flow_num is '系统流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.req_flow_num is '请求流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.aldy_revo_flg is '已撤销标志';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.revo_flow_num is '撤销流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.revo_front_flow_num is '撤销前置流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.src_chn_id is '源渠道编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.chn_dt is '渠道日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.check_entry_code is '对账编码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.mercht_type_cd is '商户类型代码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.mercht_name is '商户名称';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.unionpay_org_id is '银联机构编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.unionpay_rg_code is '银联地区码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.agent_org_id is '代理机构编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.return_code is '返回码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.return_descb is '返回描述';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.init_intfc_code is '原接口码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_sub_module_code is '交易子模块码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_acct_id is '交易账户编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_acct_name is '交易账户名称';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_acct_type_cd is '交易账户类型代码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.card_iss_org_id is '发卡机构编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.card_level_cd is '卡片等级代码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.stl_card_flg is '单位结算卡标志';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.corp_stl_card_lp_name is '单位结算卡法人姓名';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cert_no is '证件号码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.mobile_no is '手机号码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_out_acct_id is '转出账户编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_out_acct_name is '转出账户名称';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_out_acct_org_id is '转出账户机构编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_in_acct_id is '转入账户编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_in_acct_name is '转入账户名称';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_in_acct_org_id is '转入账户机构编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.dr_acct_id1 is '借方账户编号一';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.dr_acct_name1 is '借方账户名称一';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cr_acct_id1 is '贷方账户编号一';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cr_acct_name1 is '贷方账户名称一';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_amt1 is '交易金额一';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.dr_acct_id2 is '借方账户编号二';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.dr_acct_name2 is '借方账户名称二';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cr_acct_id2 is '贷方账户编号二';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cr_acct_name2 is '贷方账户名称二';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_amt2 is '交易金额二';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.dr_acct_id3 is '借方账户编号三';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.dr_acct_name3 is '借方账户名称三';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cr_acct_id3 is '贷方账户编号三';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cr_acct_name3 is '贷方账户名称三';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_amt3 is '交易金额三';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.dr_acct_id4 is '借方账户编号四';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.dr_acct_name4 is '借方账户名称四';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cr_acct_id4 is '贷方账户编号四';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cr_acct_name4 is '贷方账户名称四';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_amt4 is '交易金额四';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.comm_fee_dr_acct_id is '手续费借方账户编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.comm_fee_dr_acct_name is '手续费借方账户名称';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.comm_fee_cr_acct_id is '手续费贷方账户编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.comm_fee_cr_acct_name is '手续费贷方账户名称';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.remark1 is '手续费备注信息';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.actl_bal is '实际余额';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.acct_bal is '账户余额';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.remark2 is '闲钱宝备注信息';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.serv_src_init_sys_id is '服务源发起系统编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.serv_target_sys_id is '服务目标系统编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.serv_msg_id is '服务消息编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.serv_caller_sys_id is '服务调用方系统编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.serv_ova_flow_num is '服务全局流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.serv_caller_tran_flow_num is '服务调用方交易流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.serv_caller_tran_dt is '服务调用方交易日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.serv_name is '服务名称';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.serv_tran_code is '服务交易码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.core_dt is '核心日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.core_return_code is '核心返回码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.core_return_info is '核心返回信息';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.froz_dt is '冻结日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.froz_flow is '冻结流水';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.init_serv_caller_tran_flow_num is '原服务调用方交易流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.init_serv_caller_tran_dt is '原服务调用方交易日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.init_upp_tran_flow_num is '原UPP交易流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.init_upp_tran_dt is '原UPP交易日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.init_froz_dt is '原冻结日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.init_froz_flow_num is '原冻结流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.cust_belong_org_id is '客户所属机构编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.auth_flow_num is '授权流水号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.tran_serv_process_cd is '交易服务处理码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.acctnt_dt is '会计日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.insto_dt is '入库日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.remark is '备注';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_scss_unp_atm_tran_flow.etl_timestamp is 'ETL处理时间戳';
