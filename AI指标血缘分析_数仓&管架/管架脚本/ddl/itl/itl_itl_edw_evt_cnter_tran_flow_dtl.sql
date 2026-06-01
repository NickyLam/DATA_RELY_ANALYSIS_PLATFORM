/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_evt_cnter_tran_flow_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,chn_flow_num varchar2(60) -- 渠道流水号
    ,ova_flow_num varchar2(60) -- 全局流水号
    ,tran_dt date -- 交易日期
    ,termn_tran_tm timestamp -- 终端交易时间
    ,tran_cmplt_tm timestamp -- 交易完成时间
    ,tran_id varchar2(100) -- 交易编号
    ,tran_name varchar2(500) -- 交易名称
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_teller_name varchar2(500) -- 交易柜员名称
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,auth_flow_num varchar2(60) -- 授权流水号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_id_1 varchar2(100) -- 账户编号1
    ,acct_name_1 varchar2(500) -- 账户名称1
    ,card_no_1 varchar2(100) -- 卡号1
    ,cust_type_cd_1 varchar2(30) -- 客户类型代码1
    ,acct_id_2 varchar2(100) -- 账户编号2
    ,acct_name_2 varchar2(500) -- 账户名称2
    ,card_no_2 varchar2(100) -- 卡号2
    ,cust_type_cd_2 varchar2(30) -- 客户类型代码2
    ,tran_curr_cd varchar2(30) -- 交易币种代码
    ,amt number(30,8) -- 金额
    ,debit_crdt_flg varchar2(30) -- 借贷标志
    ,cash_trans_flg varchar2(30) -- 现转标志
    ,cust_cert_type_cd varchar2(30) -- 客户证件类型代码
    ,cust_cert_no varchar2(100) -- 客户证件号码
    ,cust_netw_vrfction_rest_cd varchar2(30) -- 客户联网核查结果代码
    ,agent_name varchar2(500) -- 代理人姓名
    ,agent_cert_type_cd varchar2(30) -- 代理人证件类型代码
    ,agent_cert_no varchar2(100) -- 代理人证件号码
    ,agent_netw_vrfction_rest_cd varchar2(30) -- 代理人联网核查结果代码
    ,agent_phone varchar2(60) -- 代理人联系电话
    ,agent_reason varchar2(500) -- 代理理由
    ,back_end_sys_id varchar2(100) -- 后台系统编号
    ,back_end_sys_dt date -- 后台系统日期
    ,back_end_sys_flow_num varchar2(60) -- 后台系统流水号
    ,back_end_sys_tran_process_cd varchar2(60) -- 后台系统交易处理码
    ,back_end_sys_tran_return_code varchar2(60) -- 后台系统交易返回码
    ,back_end_sys_tran_return_info varchar2(1000) -- 后台系统交易返回信息
    ,manual_bal_chk_status_cd varchar2(30) -- 手工勾对状态代码
    ,manual_bal_chk_tm timestamp -- 手工勾对时间
    ,manual_bal_chk_teller_id varchar2(100) -- 手工勾对柜员编号
    ,remark varchar2(500) -- 备注
    ,usage varchar2(500) -- 用途
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
grant select on ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl to ${icl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl is '柜面交易流水明细';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.evt_id is '事件编号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.chn_flow_num is '渠道流水号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.ova_flow_num is '全局流水号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.tran_dt is '交易日期';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.termn_tran_tm is '终端交易时间';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.tran_cmplt_tm is '交易完成时间';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.tran_id is '交易编号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.tran_name is '交易名称';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.tran_org_id is '交易机构编号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.tran_teller_id is '交易柜员编号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.tran_teller_name is '交易柜员名称';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.tran_status_cd is '交易状态代码';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.auth_flow_num is '授权流水号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.auth_teller_id is '授权柜员编号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.cust_id is '客户编号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.acct_id_1 is '账户编号1';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.acct_name_1 is '账户名称1';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.card_no_1 is '卡号1';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.cust_type_cd_1 is '客户类型代码1';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.acct_id_2 is '账户编号2';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.acct_name_2 is '账户名称2';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.card_no_2 is '卡号2';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.cust_type_cd_2 is '客户类型代码2';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.tran_curr_cd is '交易币种代码';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.amt is '金额';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.debit_crdt_flg is '借贷标志';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.cash_trans_flg is '现转标志';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.cust_cert_type_cd is '客户证件类型代码';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.cust_cert_no is '客户证件号码';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.cust_netw_vrfction_rest_cd is '客户联网核查结果代码';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.agent_name is '代理人姓名';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.agent_cert_type_cd is '代理人证件类型代码';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.agent_cert_no is '代理人证件号码';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.agent_netw_vrfction_rest_cd is '代理人联网核查结果代码';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.agent_phone is '代理人联系电话';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.agent_reason is '代理理由';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.back_end_sys_id is '后台系统编号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.back_end_sys_dt is '后台系统日期';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.back_end_sys_flow_num is '后台系统流水号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.back_end_sys_tran_process_cd is '后台系统交易处理码';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.back_end_sys_tran_return_code is '后台系统交易返回码';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.back_end_sys_tran_return_info is '后台系统交易返回信息';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.manual_bal_chk_status_cd is '手工勾对状态代码';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.manual_bal_chk_tm is '手工勾对时间';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.manual_bal_chk_teller_id is '手工勾对柜员编号';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.remark is '备注';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.usage is '用途';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl.etl_timestamp is 'ETL处理时间戳';
