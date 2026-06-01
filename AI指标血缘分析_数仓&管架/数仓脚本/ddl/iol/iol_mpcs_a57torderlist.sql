/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a57torderlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a57torderlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a57torderlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a57torderlist(
    sysid varchar2(9) -- 渠道标识
    ,srcseqno varchar2(48) -- 请求流水
    ,acctno varchar2(48) -- 结算账号
    ,fudcd varchar2(12) -- 基金代码
    ,ordertype varchar2(2) -- 订单类型 1：申购 2：认购 3：定投 4：余额增值转入
    ,trnamt varchar2(27) -- 交易金额，单位为分
    ,ccy varchar2(3) -- 币种，目前只支持人民币
    ,chargetype varchar2(2) -- 手续费类型 0：申购费前端收费 1：申购费后端收费 2：无申购费，按保有量收费
    ,reqtm varchar2(21) -- 申请时间
    ,memo varchar2(96) -- 附加信息
    ,rspcd varchar2(15) -- 响应码
    ,rspmsg varchar2(383) -- 响应信息
    ,orderno varchar2(48) -- 申购订单号
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
grant select on ${iol_schema}.mpcs_a57torderlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a57torderlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a57torderlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a57torderlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a57torderlist is '';
comment on column ${iol_schema}.mpcs_a57torderlist.sysid is '渠道标识';
comment on column ${iol_schema}.mpcs_a57torderlist.srcseqno is '请求流水';
comment on column ${iol_schema}.mpcs_a57torderlist.acctno is '结算账号';
comment on column ${iol_schema}.mpcs_a57torderlist.fudcd is '基金代码';
comment on column ${iol_schema}.mpcs_a57torderlist.ordertype is '订单类型 1：申购 2：认购 3：定投 4：余额增值转入';
comment on column ${iol_schema}.mpcs_a57torderlist.trnamt is '交易金额，单位为分';
comment on column ${iol_schema}.mpcs_a57torderlist.ccy is '币种，目前只支持人民币';
comment on column ${iol_schema}.mpcs_a57torderlist.chargetype is '手续费类型 0：申购费前端收费 1：申购费后端收费 2：无申购费，按保有量收费';
comment on column ${iol_schema}.mpcs_a57torderlist.reqtm is '申请时间';
comment on column ${iol_schema}.mpcs_a57torderlist.memo is '附加信息';
comment on column ${iol_schema}.mpcs_a57torderlist.rspcd is '响应码';
comment on column ${iol_schema}.mpcs_a57torderlist.rspmsg is '响应信息';
comment on column ${iol_schema}.mpcs_a57torderlist.orderno is '申购订单号';
comment on column ${iol_schema}.mpcs_a57torderlist.rsptm is '响应时间';
comment on column ${iol_schema}.mpcs_a57torderlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a57torderlist.etl_timestamp is 'ETL处理时间戳';
