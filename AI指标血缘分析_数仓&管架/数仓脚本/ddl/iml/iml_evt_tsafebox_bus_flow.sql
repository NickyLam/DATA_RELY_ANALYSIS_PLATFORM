/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_tsafebox_bus_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_tsafebox_bus_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_tsafebox_bus_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tsafebox_bus_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,midgrod_flow_num varchar2(100) -- 中台流水号
    ,tran_dt date -- 交易日期
    ,tran_code varchar2(100) -- 交易码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,safe_box_id varchar2(100) -- 保管箱编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(100) -- 证件号码
    ,pay_acct_id varchar2(100) -- 付款账户编号
    ,pay_sub_acct_num varchar2(60) -- 付款子账号
    ,payer_name varchar2(500) -- 付款人名称
    ,payer_prod_id varchar2(100) -- 付款方产品编号
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_sub_acct_num varchar2(60) -- 收款子账号
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,recver_prod_id varchar2(100) -- 收款方产品编号
    ,margin number(30,2) -- 押金
    ,curr_cd varchar2(30) -- 币种代码
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,vouch_id varchar2(100) -- 凭证编号
    ,vouch_invalid_dt date -- 凭证失效日期
    ,cap_src_cd varchar2(30) -- 资金来源代码
    ,unpacker_9elmnt varchar2(2000) -- 开箱人9要素
    ,unpacker_20elmnt varchar2(2000) -- 开箱人20要素
    ,unpacker_open_acct_vrfction_pass_flg varchar2(10) -- 开箱人开户核查通过标志
    ,unpacker_kyc_pass_flg varchar2(10) -- 开箱人KYC核查通过标志
    ,unpacker_anti_mon_lau_vrfction_pass_flg varchar2(10) -- 开箱人反洗钱核查通过标志
    ,unpacker_netw_vrfction_pass_flg varchar2(10) -- 开箱人联网核查通过标志
    ,co_sign_unpacker_9elmnt varchar2(2000) -- 联名开箱人9要素
    ,co_sign_unpacker_open_acct_vrfction_pass_flg varchar2(10) -- 联名开箱人开户核查通过标志
    ,co_sign_unpacker_kyc_pass_flg varchar2(10) -- 联名开箱人KYC核查通过标志
    ,co_sign_unpacker_anti_mon_lau_vrfction_pass_flg varchar2(10) -- 联名开箱人反洗钱核查通过标志
    ,co_sign_unpacker_netw_vrfction_pass_flg varchar2(10) -- 联名开箱人联网核查通过标志
    ,agent_4_elmnt varchar2(2000) -- 代理人4要素
    ,agent_open_acct_vrfction_pass_flg varchar2(10) -- 代理人开户核查通过标志
    ,agent_kyc_pass_flg varchar2(10) -- 代理人KYC核查通过标志
    ,agent_anti_mon_lau_vrfction_pass_flg varchar2(10) -- 代理人反洗钱核查通过标志
    ,agent_netw_vrfction_pass_flg varchar2(10) -- 代理人联网核查通过标志
    ,ova_flow_num varchar2(250) -- 全局流水号
    ,bus_flow_num varchar2(250) -- 业务流水号
    ,chn_id varchar2(100) -- 渠道编号
    ,org_id varchar2(100) -- 机构编号
    ,onacct_and_wrtoff_flow_num varchar2(250) -- 挂销流水号
    ,trdpty_tran_code varchar2(100) -- 第三方交易码
    ,core_flow_num varchar2(250) -- 核心流水号
    ,core_dt date -- 核心日期
    ,entry_sub_flow_num varchar2(250) -- 记账子流水号
    ,revs_flg varchar2(10) -- 冲正标志
    ,revs_ova_flow_num varchar2(250) -- 冲正全局流水号
    ,revs_cnt number(30) -- 冲正次数
    ,revs_fail_remark varchar2(1000) -- 冲正失败备注
    ,reply_cd varchar2(100) -- 应答码
    ,reply_info varchar2(1000) -- 应答信息
    ,final_update_dt date -- 最后更新日期
    ,rent_safebox_status_cd varchar2(30) -- 租箱状态代码
    ,rent_safebox_dt date -- 租箱日期
    ,rent_safebox_exp_dt date -- 租箱到期日期
    ,proc_teller_id varchar2(100) -- 处理柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
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
grant select on ${iml_schema}.evt_tsafebox_bus_flow to ${icl_schema};
grant select on ${iml_schema}.evt_tsafebox_bus_flow to ${idl_schema};
grant select on ${iml_schema}.evt_tsafebox_bus_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_tsafebox_bus_flow is '保险箱业务流水';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.safe_box_id is '保管箱编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.cert_no is '证件号码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.pay_acct_id is '付款账户编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.pay_sub_acct_num is '付款子账号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.payer_name is '付款人名称';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.payer_prod_id is '付款方产品编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.recvbl_sub_acct_num is '收款子账号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.recver_prod_id is '收款方产品编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.margin is '押金';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.vouch_id is '凭证编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.vouch_invalid_dt is '凭证失效日期';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.cap_src_cd is '资金来源代码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.unpacker_9elmnt is '开箱人9要素';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.unpacker_20elmnt is '开箱人20要素';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.unpacker_open_acct_vrfction_pass_flg is '开箱人开户核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.unpacker_kyc_pass_flg is '开箱人KYC核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.unpacker_anti_mon_lau_vrfction_pass_flg is '开箱人反洗钱核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.unpacker_netw_vrfction_pass_flg is '开箱人联网核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.co_sign_unpacker_9elmnt is '联名开箱人9要素';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.co_sign_unpacker_open_acct_vrfction_pass_flg is '联名开箱人开户核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.co_sign_unpacker_kyc_pass_flg is '联名开箱人KYC核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.co_sign_unpacker_anti_mon_lau_vrfction_pass_flg is '联名开箱人反洗钱核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.co_sign_unpacker_netw_vrfction_pass_flg is '联名开箱人联网核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.agent_4_elmnt is '代理人4要素';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.agent_open_acct_vrfction_pass_flg is '代理人开户核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.agent_kyc_pass_flg is '代理人KYC核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.agent_anti_mon_lau_vrfction_pass_flg is '代理人反洗钱核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.agent_netw_vrfction_pass_flg is '代理人联网核查通过标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.org_id is '机构编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.onacct_and_wrtoff_flow_num is '挂销流水号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.trdpty_tran_code is '第三方交易码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.core_dt is '核心日期';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.entry_sub_flow_num is '记账子流水号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.revs_flg is '冲正标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.revs_ova_flow_num is '冲正全局流水号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.revs_cnt is '冲正次数';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.revs_fail_remark is '冲正失败备注';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.reply_cd is '应答码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.reply_info is '应答信息';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.rent_safebox_status_cd is '租箱状态代码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.rent_safebox_dt is '租箱日期';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.rent_safebox_exp_dt is '租箱到期日期';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.proc_teller_id is '处理柜员编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.start_dt is '开始时间';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.end_dt is '结束时间';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.id_mark is '增删标志';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_tsafebox_bus_flow.etl_timestamp is 'ETL处理时间戳';
