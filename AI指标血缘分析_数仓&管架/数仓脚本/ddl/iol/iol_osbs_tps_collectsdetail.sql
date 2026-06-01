/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_tps_collectsdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_tps_collectsdetail
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_tps_collectsdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_collectsdetail(
    tcd_collectdelno varchar2(32) -- 计划编号
    ,tcd_transcode varchar2(64) -- 交易编码
    ,tcd_protocolidqry varchar2(60) -- 跨行查询协议
    ,tcd_protocolidpay varchar2(60) -- 跨行支付协议
    ,tcd_payeracno varchar2(40) -- 转出账号
    ,tcd_payeracname varchar2(128) -- 转出账户名称
    ,tcd_payerbankname varchar2(128) -- 转出银行名称
    ,tcd_payerbankactype varchar2(4) -- 转出账号账户类别
    ,tcd_payerbankid varchar2(16) -- 转出账户开户行
    ,tcd_payercurrency varchar2(3) -- 转出币种
    ,tcd_payeeacno varchar2(40) -- 转入账号
    ,tcd_modelflag varchar2(1) -- 归集模式
    ,tcd_amount number(15,2) -- 转出金额
    ,tcd_remark varchar2(128) -- 附言
    ,tcd_fee number(15,2) -- 费用
    ,tcd_validatemsg varchar2(256) -- 验证信息
    ,tcd_notecode varchar2(64) -- 付款用途
    ,tcd_submittime varchar2(14) -- 提交时间
    ,tcd_singleamtlimit number(15,2) -- 单笔限额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.osbs_tps_collectsdetail to ${iml_schema};
grant select on ${iol_schema}.osbs_tps_collectsdetail to ${icl_schema};
grant select on ${iol_schema}.osbs_tps_collectsdetail to ${idl_schema};
grant select on ${iol_schema}.osbs_tps_collectsdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_tps_collectsdetail is '个人资金自动归集交易具体信息表';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_collectdelno is '计划编号';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_transcode is '交易编码';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_protocolidqry is '跨行查询协议';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_protocolidpay is '跨行支付协议';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_payeracno is '转出账号';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_payeracname is '转出账户名称';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_payerbankname is '转出银行名称';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_payerbankactype is '转出账号账户类别';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_payerbankid is '转出账户开户行';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_payercurrency is '转出币种';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_payeeacno is '转入账号';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_modelflag is '归集模式';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_amount is '转出金额';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_remark is '附言';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_fee is '费用';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_validatemsg is '验证信息';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_notecode is '付款用途';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_submittime is '提交时间';
comment on column ${iol_schema}.osbs_tps_collectsdetail.tcd_singleamtlimit is '单笔限额';
comment on column ${iol_schema}.osbs_tps_collectsdetail.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_tps_collectsdetail.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_tps_collectsdetail.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_tps_collectsdetail.etl_timestamp is 'ETL处理时间戳';
