/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_tranflow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_tranflow
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_tranflow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_tranflow(
    ctl_flowno varchar2(32) -- 流水号
    ,ctl_ecifno varchar2(32) -- 全行统一客户号
    ,ctl_userno varchar2(32) -- 用户顺序号
    ,ctl_transcode varchar2(64) -- 交易码
    ,ctl_payeracc varchar2(40) -- 付款账号
    ,ctl_payeracname varchar2(512) -- 付款账号名称
    ,ctl_payerdeptid varchar2(20) -- 付款账号开户行
    ,ctl_currency varchar2(3) -- 币种
    ,ctl_crflag varchar2(1) -- 钞汇标志：C：钞；R：汇；X：不适用
    ,ctl_rcvciftype varchar2(1) -- 收款人类型：1：企业；2：个人
    ,ctl_rcvacc varchar2(40) -- 收款账号
    ,ctl_rcvaccname varchar2(512) -- 收款人户名
    ,ctl_savercvflag varchar2(1) -- 保存收款人：1：是；2：否
    ,ctl_notifyrcvflag varchar2(1) -- 通知收款人：1：是；2：否
    ,ctl_rcvmobile varchar2(16) -- 收款人号码
    ,ctl_rcvbankid varchar2(32) -- 收款人银行号
    ,ctl_provincecode varchar2(16) -- 省
    ,ctl_citycode varchar2(16) -- 市
    ,ctl_uniondeptid varchar2(20) -- 联行号
    ,ctl_uniondeptname varchar2(255) -- 联行名
    ,ctl_amount number(15,2) -- 金额
    ,ctl_fee number(15,2) -- 手续费
    ,ctl_groundflag varchar2(1) -- 落地标志
    ,ctl_notecode varchar2(60) -- 通知码
    ,ctl_remark varchar2(512) -- 附言：ET和EU，按核心的枚举值送
    ,ctl_priority varchar2(1) -- 加急标志
    ,ctl_productcode varchar2(40) -- 产品代码（理财交易填写）
    ,ctl_productname varchar2(128) -- 产品名称（理财交易填写）
    ,ctl_cancelflow varchar2(40) -- 被撤单流水号（理财交易填写）
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbps_cpr_tranflow to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_tranflow to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_tranflow to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_tranflow to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_tranflow is '转账交易流水表';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_flowno is '流水号';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_ecifno is '全行统一客户号';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_userno is '用户顺序号';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_transcode is '交易码';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_payeracc is '付款账号';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_payeracname is '付款账号名称';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_payerdeptid is '付款账号开户行';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_currency is '币种';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_crflag is '钞汇标志：C：钞；R：汇；X：不适用';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_rcvciftype is '收款人类型：1：企业；2：个人';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_rcvacc is '收款账号';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_rcvaccname is '收款人户名';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_savercvflag is '保存收款人：1：是；2：否';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_notifyrcvflag is '通知收款人：1：是；2：否';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_rcvmobile is '收款人号码';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_rcvbankid is '收款人银行号';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_provincecode is '省';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_citycode is '市';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_uniondeptid is '联行号';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_uniondeptname is '联行名';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_amount is '金额';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_fee is '手续费';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_groundflag is '落地标志';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_notecode is '通知码';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_remark is '附言：ET和EU，按核心的枚举值送';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_priority is '加急标志';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_productcode is '产品代码（理财交易填写）';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_productname is '产品名称（理财交易填写）';
comment on column ${iol_schema}.tbps_cpr_tranflow.ctl_cancelflow is '被撤单流水号（理财交易填写）';
comment on column ${iol_schema}.tbps_cpr_tranflow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tbps_cpr_tranflow.etl_timestamp is 'ETL处理时间戳';
