/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a57tpaylist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a57tpaylist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a57tpaylist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a57tpaylist(
    sysid varchar2(9) -- 渠道标识
    ,orderno varchar2(48) -- 申购订单号
    ,reqtm varchar2(21) -- 支付时间
    ,memo varchar2(96) -- 附加信息
    ,dataid varchar2(30) -- 数据id
    ,hostseqno varchar2(18) -- 主机流水
    ,hostdt varchar2(12) -- 主机日期
    ,hostrspcd varchar2(15) -- 主机响应码
    ,hostrspmsg varchar2(383) -- 主机响应信息
    ,colflag varchar2(2) -- 对账标志
    ,coltm varchar2(21) -- 对账时间
    ,rspcd varchar2(15) -- 响应码
    ,rspmsg varchar2(383) -- 响应信息
    ,units varchar2(48) -- 确认份额
    ,rsptm varchar2(21) -- 响应时间
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
grant select on ${iol_schema}.mpcs_a57tpaylist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a57tpaylist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a57tpaylist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a57tpaylist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a57tpaylist is '';
comment on column ${iol_schema}.mpcs_a57tpaylist.sysid is '渠道标识';
comment on column ${iol_schema}.mpcs_a57tpaylist.orderno is '申购订单号';
comment on column ${iol_schema}.mpcs_a57tpaylist.reqtm is '支付时间';
comment on column ${iol_schema}.mpcs_a57tpaylist.memo is '附加信息';
comment on column ${iol_schema}.mpcs_a57tpaylist.dataid is '数据id';
comment on column ${iol_schema}.mpcs_a57tpaylist.hostseqno is '主机流水';
comment on column ${iol_schema}.mpcs_a57tpaylist.hostdt is '主机日期';
comment on column ${iol_schema}.mpcs_a57tpaylist.hostrspcd is '主机响应码';
comment on column ${iol_schema}.mpcs_a57tpaylist.hostrspmsg is '主机响应信息';
comment on column ${iol_schema}.mpcs_a57tpaylist.colflag is '对账标志';
comment on column ${iol_schema}.mpcs_a57tpaylist.coltm is '对账时间';
comment on column ${iol_schema}.mpcs_a57tpaylist.rspcd is '响应码';
comment on column ${iol_schema}.mpcs_a57tpaylist.rspmsg is '响应信息';
comment on column ${iol_schema}.mpcs_a57tpaylist.units is '确认份额';
comment on column ${iol_schema}.mpcs_a57tpaylist.rsptm is '响应时间';
comment on column ${iol_schema}.mpcs_a57tpaylist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a57tpaylist.etl_timestamp is 'ETL处理时间戳';
