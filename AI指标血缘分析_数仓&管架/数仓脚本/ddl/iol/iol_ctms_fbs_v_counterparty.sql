/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_v_counterparty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_v_counterparty
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_v_counterparty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_counterparty(
    counterparty_seq number -- 交易对手编号
    ,cus_number number(20,0) -- 机构编号
    ,label varchar2(96) -- 其他系统编号
    ,counterparty_cname varchar2(384) -- 中文名称
    ,counterparty_ename varchar2(384) -- 英文名称
    ,contact_name varchar2(90) -- 联系人
    ,telephone varchar2(30) -- 电话
    ,fax varchar2(30) -- 传真
    ,update_user number(5,0) -- 更新用户
    ,update_time date -- 更新时间
    ,is_issuer varchar2(2) -- 是否为发行者
    ,is_bank varchar2(2) -- 是否为银行
    ,is_guarantee varchar2(2) -- 是否为保证人
    ,is_custody varchar2(2) -- 是否为托管机构
    ,customer_type varchar2(30) -- 行业类别
    ,parent number -- 母公司
    ,rating_level nvarchar2(16) -- 內部信用評級
    ,ex_code varchar2(96) -- 联行号
    ,ex_account varchar2(96) -- 人行大额支付系统号
    ,swift_code varchar2(96) -- Swift 电文代号
    ,ref_issuer_id varchar2(60) -- Issuer, or guarantee 会有该字段
    ,cfets_member_id varchar2(60) -- 外汇编号或者第三方交易对手编号
    ,counterparty_short_cname varchar2(384) -- 交易对手方中文简称
    ,counterparty_short_ename varchar2(384) -- 交易对手方英文简称
    ,cfets_fx_member_id varchar2(75) -- 外汇编号
    ,cfets_member_attr varchar2(2) -- 外汇会员类型
    ,counterparty_fx_short_ename varchar2(384) -- 外汇交易对手方英文简称
    ,interbanktype varchar2(96) -- 交易对手同业类型
    ,overseas varchar2(96) -- 境内境外
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
grant select on ${iol_schema}.ctms_fbs_v_counterparty to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_v_counterparty to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_v_counterparty to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_v_counterparty to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_v_counterparty is '交易对手视图';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.counterparty_seq is '交易对手编号';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.cus_number is '机构编号';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.label is '其他系统编号';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.counterparty_cname is '中文名称';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.counterparty_ename is '英文名称';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.contact_name is '联系人';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.telephone is '电话';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.fax is '传真';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.update_user is '更新用户';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.update_time is '更新时间';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.is_issuer is '是否为发行者';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.is_bank is '是否为银行';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.is_guarantee is '是否为保证人';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.is_custody is '是否为托管机构';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.customer_type is '行业类别';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.parent is '母公司';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.rating_level is '內部信用評級';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.ex_code is '联行号';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.ex_account is '人行大额支付系统号';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.swift_code is 'Swift 电文代号';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.ref_issuer_id is 'Issuer, or guarantee 会有该字段';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.cfets_member_id is '外汇编号或者第三方交易对手编号';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.counterparty_short_cname is '交易对手方中文简称';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.counterparty_short_ename is '交易对手方英文简称';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.cfets_fx_member_id is '外汇编号';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.cfets_member_attr is '外汇会员类型';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.counterparty_fx_short_ename is '外汇交易对手方英文简称';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.interbanktype is '交易对手同业类型';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.overseas is '境内境外';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_fbs_v_counterparty.etl_timestamp is 'ETL处理时间戳';
