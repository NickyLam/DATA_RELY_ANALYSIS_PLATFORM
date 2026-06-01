/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_contract_info_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_contract_info_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_contract_info_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_contract_info_tb(
    id varchar2(36) -- 主键id
    ,tx_branch_id varchar2(9) -- 交易机构
    ,teller varchar2(12) -- 柜员号
    ,tr_date date -- 交易日期
    ,biz_code varchar2(20) -- 交易码
    ,contract_tr_date date -- 签约主机交易日期
    ,contract_flw_code varchar2(33) -- 文件的签约平台流水号为表里的签约主机交易流水号
    ,contract_tx_code varchar2(20) -- 签约交易码
    ,chanel_flow_no varchar2(33) -- 渠道流水号
    ,contractno varchar2(10) -- 业务类型
    ,contract_flag varchar2(1) -- 签约标志（0-成功，1-失败）
    ,contract_ret_code varchar2(20) -- 签约返回值
    ,contract_ret_mess varchar2(4000) -- 签约信息
    ,check_flag varchar2(1) -- 对账标志(1.邮寄2.面对面3.网银)
    ,task_id varchar2(33) -- 任务号
    ,contract_msg varchar2(4000) -- 签约信息(用来重发)
    ,contract_type varchar2(4) -- 签约类型(个人：1000-个人网银、1001-短信通、1002-基金、1003-理财、1004-非柜面非同名限额签约、1005-个人扣款协议、1006-三方存管签约、1007-储蓄定投、1008-灵活盈、1009-云闪付；对公：2000-短信通、2001-非柜面非同名限额签约、2002-网银/手机银行、2003-银企对账)
    ,trans_status varchar2(1) -- 处理状态(1-已重发成功 2-放弃 0-待重发)
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.scps_bp_contract_info_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_contract_info_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_contract_info_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_contract_info_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_contract_info_tb is '签约表';
comment on column ${iol_schema}.scps_bp_contract_info_tb.id is '主键id';
comment on column ${iol_schema}.scps_bp_contract_info_tb.tx_branch_id is '交易机构';
comment on column ${iol_schema}.scps_bp_contract_info_tb.teller is '柜员号';
comment on column ${iol_schema}.scps_bp_contract_info_tb.tr_date is '交易日期';
comment on column ${iol_schema}.scps_bp_contract_info_tb.biz_code is '交易码';
comment on column ${iol_schema}.scps_bp_contract_info_tb.contract_tr_date is '签约主机交易日期';
comment on column ${iol_schema}.scps_bp_contract_info_tb.contract_flw_code is '文件的签约平台流水号为表里的签约主机交易流水号';
comment on column ${iol_schema}.scps_bp_contract_info_tb.contract_tx_code is '签约交易码';
comment on column ${iol_schema}.scps_bp_contract_info_tb.chanel_flow_no is '渠道流水号';
comment on column ${iol_schema}.scps_bp_contract_info_tb.contractno is '业务类型';
comment on column ${iol_schema}.scps_bp_contract_info_tb.contract_flag is '签约标志（0-成功，1-失败）';
comment on column ${iol_schema}.scps_bp_contract_info_tb.contract_ret_code is '签约返回值';
comment on column ${iol_schema}.scps_bp_contract_info_tb.contract_ret_mess is '签约信息';
comment on column ${iol_schema}.scps_bp_contract_info_tb.check_flag is '对账标志(1.邮寄2.面对面3.网银)';
comment on column ${iol_schema}.scps_bp_contract_info_tb.task_id is '任务号';
comment on column ${iol_schema}.scps_bp_contract_info_tb.contract_msg is '签约信息(用来重发)';
comment on column ${iol_schema}.scps_bp_contract_info_tb.contract_type is '签约类型(个人：1000-个人网银、1001-短信通、1002-基金、1003-理财、1004-非柜面非同名限额签约、1005-个人扣款协议、1006-三方存管签约、1007-储蓄定投、1008-灵活盈、1009-云闪付；对公：2000-短信通、2001-非柜面非同名限额签约、2002-网银/手机银行、2003-银企对账)';
comment on column ${iol_schema}.scps_bp_contract_info_tb.trans_status is '处理状态(1-已重发成功 2-放弃 0-待重发)';
comment on column ${iol_schema}.scps_bp_contract_info_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_contract_info_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_contract_info_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_contract_info_tb.etl_timestamp is 'ETL处理时间戳';
