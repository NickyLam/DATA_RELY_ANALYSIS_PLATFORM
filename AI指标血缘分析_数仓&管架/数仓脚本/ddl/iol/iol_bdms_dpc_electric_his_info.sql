/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_dpc_electric_his_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_dpc_electric_his_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_dpc_electric_his_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_dpc_electric_his_info(
    id varchar2(60) -- ID
    ,top_branch_no varchar2(30) -- 总行机构号
    ,branch_no varchar2(30) -- 机构号
    ,draft_id varchar2(60) -- 票据ID
    ,draft_number varchar2(45) -- 票据号码
    ,busi_type varchar2(5) -- 业务类型
    ,busi_name varchar2(30) -- 业务名称
    ,req_name varchar2(300) -- 请求方名称
    ,req_cmon_id varchar2(15) -- 请求方组织机构代码
    ,rcv_name varchar2(300) -- 接收方名称
    ,rcv_cmon_id varchar2(15) -- 接收方组织机构代码
    ,sign_date varchar2(12) -- 签收日期
    ,endrsmt_mk varchar2(6) -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,rpd_open_date varchar2(12) -- 赎回开放日
    ,rpd_end_date varchar2(12) -- 赎回截止日
    ,ucondl_consgnmt_mrk varchar2(6) -- 到期无条件支付委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,ucondl_prms_mrk varchar2(15) -- 到期无条件支付承诺： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,acceptor_role varchar2(6) -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,acceptor_name varchar2(300) -- 承兑人名称
    ,acceptor_acct varchar2(48) -- 承兑人账号
    ,acceptor_bank_no varchar2(18) -- 承兑人开户行号
    ,acceptor_cmon_id varchar2(15) -- 承兑人组织机构代码
    ,acceptor_txn_ctrct_nb varchar2(45) -- 承兑人交易合同编号
    ,acceptor_cdt_ratgs varchar2(6) -- 承兑人信用等级
    ,acceptor_cdt_ratg_agcy varchar2(270) -- 承兑人评级机构
    ,acceptor_cdt_ratg_due_date varchar2(12) -- 承兑人评级到期日
    ,last_upd_time varchar2(21) -- 最后操作时间
    ,guarantee_address varchar2(270) -- 保证人地址
    ,misc varchar2(1500) -- 备注域
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
grant select on ${iol_schema}.bdms_dpc_electric_his_info to ${iml_schema};
grant select on ${iol_schema}.bdms_dpc_electric_his_info to ${icl_schema};
grant select on ${iol_schema}.bdms_dpc_electric_his_info to ${idl_schema};
grant select on ${iol_schema}.bdms_dpc_electric_his_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_dpc_electric_his_info is '贴现通电子票据背书历史信息表';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.id is 'ID';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.branch_no is '机构号';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.busi_type is '业务类型';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.busi_name is '业务名称';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.req_name is '请求方名称';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.req_cmon_id is '请求方组织机构代码';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.rcv_name is '接收方名称';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.rcv_cmon_id is '接收方组织机构代码';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.sign_date is '签收日期';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.endrsmt_mk is '不得转让标记： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.rpd_open_date is '赎回开放日';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.rpd_end_date is '赎回截止日';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.ucondl_consgnmt_mrk is '到期无条件支付委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.ucondl_prms_mrk is '到期无条件支付承诺： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.acceptor_role is '承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.acceptor_name is '承兑人名称';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.acceptor_acct is '承兑人账号';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.acceptor_bank_no is '承兑人开户行号';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.acceptor_cmon_id is '承兑人组织机构代码';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.acceptor_txn_ctrct_nb is '承兑人交易合同编号';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.acceptor_cdt_ratgs is '承兑人信用等级';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.acceptor_cdt_ratg_agcy is '承兑人评级机构';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.acceptor_cdt_ratg_due_date is '承兑人评级到期日';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.last_upd_time is '最后操作时间';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.guarantee_address is '保证人地址';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.misc is '备注域';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_dpc_electric_his_info.etl_timestamp is 'ETL处理时间戳';
