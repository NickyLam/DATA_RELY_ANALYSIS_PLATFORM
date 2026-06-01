/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_pvp_consignor_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_pvp_consignor_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_pvp_consignor_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_pvp_consignor_info(
    serialno varchar2(40) -- 申请业务流水号
    ,consignorname varchar2(120) -- 委托人名称
    ,capaccounttype varchar2(10) -- 本金归还入账账户支付工具类型
    ,taxaccountname varchar2(120) -- 印花税扣税账号名称
    ,nationaleconomysubclass varchar2(10) -- 国民经济部门子类
    ,contno varchar2(30) -- 借款合同号
    ,depaccountname varchar2(120) -- 委托人存款账户名称
    ,fundsprovided varchar2(1000) -- 资金来源
    ,cusname varchar2(200) -- 借款人名称
    ,capaccountname varchar2(120) -- 本金归还入账账户名称
    ,taxaccounttype varchar2(10) -- 印花税扣税账号支付工具类型
    ,consignorid varchar2(30) -- 委托人客户号
    ,depaccounttype varchar2(10) -- 委托人存款账户支付工具类型
    ,feeaccount varchar2(32) -- 手续费收取账号
    ,feeaccountname varchar2(120) -- 手续费收取账号名称
    ,entrustdepaccounttype varchar2(10) -- 委托存款账户支付工具类型
    ,intaccount varchar2(32) -- 利息归还入账账户
    ,intaccounttype varchar2(10) -- 利息归还入账账户支付工具类型
    ,entrustdepaccountbankname varchar2(200) -- 委托存款账户开户行行名称（行内的）
    ,entrustdeptypesub varchar2(10) -- 委托贷款细类
    ,migtflag varchar2(80) -- 
    ,nationaleconomycategory varchar2(10) -- 国民经济大类
    ,entrustdepaccountbank varchar2(20) -- 委托存款账户开户行行号（行内的）
    ,principalmarriage varchar2(10) -- 委托人婚姻状况
    ,taxaccount varchar2(32) -- 印花税扣税账号
    ,consignorcerttype varchar2(4) -- 委托人证件类型
    ,intaccountname varchar2(120) -- 利息归还入账账户名称
    ,billno varchar2(30) -- 借据号
    ,entrustdepdustrytype varchar2(10) -- 委托贷款投向
    ,cusid varchar2(30) -- 借款人客户号
    ,consignorcertno varchar2(32) -- 委托证人件号码
    ,consignortype varchar2(2) -- 委托人类型
    ,depaccount varchar2(32) -- 委托人存款账户
    ,feeaccounttype varchar2(10) -- 手续费收取账号支付工具类型
    ,capaccount varchar2(32) -- 本金归还入账账户
    ,entrustdepaccount varchar2(32) -- 委托存款账户
    ,entrustdepaccountname varchar2(120) -- 委托存款账户名称
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
grant select on ${iol_schema}.icms_pvp_consignor_info to ${iml_schema};
grant select on ${iol_schema}.icms_pvp_consignor_info to ${icl_schema};
grant select on ${iol_schema}.icms_pvp_consignor_info to ${idl_schema};
grant select on ${iol_schema}.icms_pvp_consignor_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_pvp_consignor_info is '委托人信息表(出账阶段)';
comment on column ${iol_schema}.icms_pvp_consignor_info.serialno is '申请业务流水号';
comment on column ${iol_schema}.icms_pvp_consignor_info.consignorname is '委托人名称';
comment on column ${iol_schema}.icms_pvp_consignor_info.capaccounttype is '本金归还入账账户支付工具类型';
comment on column ${iol_schema}.icms_pvp_consignor_info.taxaccountname is '印花税扣税账号名称';
comment on column ${iol_schema}.icms_pvp_consignor_info.nationaleconomysubclass is '国民经济部门子类';
comment on column ${iol_schema}.icms_pvp_consignor_info.contno is '借款合同号';
comment on column ${iol_schema}.icms_pvp_consignor_info.depaccountname is '委托人存款账户名称';
comment on column ${iol_schema}.icms_pvp_consignor_info.fundsprovided is '资金来源';
comment on column ${iol_schema}.icms_pvp_consignor_info.cusname is '借款人名称';
comment on column ${iol_schema}.icms_pvp_consignor_info.capaccountname is '本金归还入账账户名称';
comment on column ${iol_schema}.icms_pvp_consignor_info.taxaccounttype is '印花税扣税账号支付工具类型';
comment on column ${iol_schema}.icms_pvp_consignor_info.consignorid is '委托人客户号';
comment on column ${iol_schema}.icms_pvp_consignor_info.depaccounttype is '委托人存款账户支付工具类型';
comment on column ${iol_schema}.icms_pvp_consignor_info.feeaccount is '手续费收取账号';
comment on column ${iol_schema}.icms_pvp_consignor_info.feeaccountname is '手续费收取账号名称';
comment on column ${iol_schema}.icms_pvp_consignor_info.entrustdepaccounttype is '委托存款账户支付工具类型';
comment on column ${iol_schema}.icms_pvp_consignor_info.intaccount is '利息归还入账账户';
comment on column ${iol_schema}.icms_pvp_consignor_info.intaccounttype is '利息归还入账账户支付工具类型';
comment on column ${iol_schema}.icms_pvp_consignor_info.entrustdepaccountbankname is '委托存款账户开户行行名称（行内的）';
comment on column ${iol_schema}.icms_pvp_consignor_info.entrustdeptypesub is '委托贷款细类';
comment on column ${iol_schema}.icms_pvp_consignor_info.migtflag is '';
comment on column ${iol_schema}.icms_pvp_consignor_info.nationaleconomycategory is '国民经济大类';
comment on column ${iol_schema}.icms_pvp_consignor_info.entrustdepaccountbank is '委托存款账户开户行行号（行内的）';
comment on column ${iol_schema}.icms_pvp_consignor_info.principalmarriage is '委托人婚姻状况';
comment on column ${iol_schema}.icms_pvp_consignor_info.taxaccount is '印花税扣税账号';
comment on column ${iol_schema}.icms_pvp_consignor_info.consignorcerttype is '委托人证件类型';
comment on column ${iol_schema}.icms_pvp_consignor_info.intaccountname is '利息归还入账账户名称';
comment on column ${iol_schema}.icms_pvp_consignor_info.billno is '借据号';
comment on column ${iol_schema}.icms_pvp_consignor_info.entrustdepdustrytype is '委托贷款投向';
comment on column ${iol_schema}.icms_pvp_consignor_info.cusid is '借款人客户号';
comment on column ${iol_schema}.icms_pvp_consignor_info.consignorcertno is '委托证人件号码';
comment on column ${iol_schema}.icms_pvp_consignor_info.consignortype is '委托人类型';
comment on column ${iol_schema}.icms_pvp_consignor_info.depaccount is '委托人存款账户';
comment on column ${iol_schema}.icms_pvp_consignor_info.feeaccounttype is '手续费收取账号支付工具类型';
comment on column ${iol_schema}.icms_pvp_consignor_info.capaccount is '本金归还入账账户';
comment on column ${iol_schema}.icms_pvp_consignor_info.entrustdepaccount is '委托存款账户';
comment on column ${iol_schema}.icms_pvp_consignor_info.entrustdepaccountname is '委托存款账户名称';
comment on column ${iol_schema}.icms_pvp_consignor_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_pvp_consignor_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_pvp_consignor_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_pvp_consignor_info.etl_timestamp is 'ETL处理时间戳';
