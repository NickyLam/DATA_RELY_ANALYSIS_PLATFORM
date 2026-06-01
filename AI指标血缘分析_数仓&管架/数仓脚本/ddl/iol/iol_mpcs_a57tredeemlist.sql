/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a57tredeemlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a57tredeemlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a57tredeemlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a57tredeemlist(
    sysid varchar2(9) -- 渠道标识
    ,srcseqno varchar2(48) -- 请求流水
    ,acctno varchar2(48) -- 结算账号
    ,fudcd varchar2(12) -- 基金代码
    ,units varchar2(48) -- 赎回份额，单位为0.01 份
    ,redeemtype varchar2(2) -- 1 为普通赎回 0 为d+0 赎回（增值转出专用）
    ,reqtm varchar2(21) -- 申请时间
    ,memo varchar2(96) -- 附加信息
    ,dataid varchar2(30) -- 数据id
    ,hostseqno varchar2(18) -- 主机流水
    ,hostdt varchar2(12) -- 主机日期
    ,hostrspcd varchar2(15) -- 主机响应码
    ,hostrspmsg varchar2(383) -- 主机响应信息
    ,colflag varchar2(2) -- 对账标志 0正常 1挂账成功 2挂账失败
    ,coltm varchar2(21) -- 对账时间
    ,rspcd varchar2(15) -- 响应码
    ,rspmsg varchar2(383) -- 响应信息
    ,hangflag varchar2(2) -- 挂账标志
    ,fudorderno varchar2(48) -- 赎回订单号(基金公司生成)
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
grant select on ${iol_schema}.mpcs_a57tredeemlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a57tredeemlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a57tredeemlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a57tredeemlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a57tredeemlist is '';
comment on column ${iol_schema}.mpcs_a57tredeemlist.sysid is '渠道标识';
comment on column ${iol_schema}.mpcs_a57tredeemlist.srcseqno is '请求流水';
comment on column ${iol_schema}.mpcs_a57tredeemlist.acctno is '结算账号';
comment on column ${iol_schema}.mpcs_a57tredeemlist.fudcd is '基金代码';
comment on column ${iol_schema}.mpcs_a57tredeemlist.units is '赎回份额，单位为0.01 份';
comment on column ${iol_schema}.mpcs_a57tredeemlist.redeemtype is '1 为普通赎回 0 为d+0 赎回（增值转出专用）';
comment on column ${iol_schema}.mpcs_a57tredeemlist.reqtm is '申请时间';
comment on column ${iol_schema}.mpcs_a57tredeemlist.memo is '附加信息';
comment on column ${iol_schema}.mpcs_a57tredeemlist.dataid is '数据id';
comment on column ${iol_schema}.mpcs_a57tredeemlist.hostseqno is '主机流水';
comment on column ${iol_schema}.mpcs_a57tredeemlist.hostdt is '主机日期';
comment on column ${iol_schema}.mpcs_a57tredeemlist.hostrspcd is '主机响应码';
comment on column ${iol_schema}.mpcs_a57tredeemlist.hostrspmsg is '主机响应信息';
comment on column ${iol_schema}.mpcs_a57tredeemlist.colflag is '对账标志 0正常 1挂账成功 2挂账失败';
comment on column ${iol_schema}.mpcs_a57tredeemlist.coltm is '对账时间';
comment on column ${iol_schema}.mpcs_a57tredeemlist.rspcd is '响应码';
comment on column ${iol_schema}.mpcs_a57tredeemlist.rspmsg is '响应信息';
comment on column ${iol_schema}.mpcs_a57tredeemlist.hangflag is '挂账标志';
comment on column ${iol_schema}.mpcs_a57tredeemlist.fudorderno is '赎回订单号(基金公司生成)';
comment on column ${iol_schema}.mpcs_a57tredeemlist.rsptm is '响应时间';
comment on column ${iol_schema}.mpcs_a57tredeemlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a57tredeemlist.etl_timestamp is 'ETL处理时间戳';
