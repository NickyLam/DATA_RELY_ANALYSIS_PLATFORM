/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a57tfudsign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a57tfudsign
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a57tfudsign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a57tfudsign(
    sysid varchar2(9) -- 渠道标识
    ,srcseqno varchar2(48) -- 请求流水
    ,custname varchar2(48) -- 客户名称
    ,idtype varchar2(3) -- 证件类型
    ,idno varchar2(48) -- 身份识别码
    ,idcd varchar2(15) -- 
    ,custno varchar2(48) -- 客户号
    ,acctno varchar2(48) -- 结算账号
    ,reqtm varchar2(21) -- 申请时间
    ,mobile varchar2(48) -- 手机号
    ,tel varchar2(48) -- 固定电话
    ,addr varchar2(383) -- 地址
    ,zip varchar2(9) -- 邮编
    ,email varchar2(96) -- 邮箱
    ,memo varchar2(384) -- 附加信息
    ,fudcustno varchar2(96) -- 基金账号
    ,fudacctno varchar2(96) -- 基金交易账号
    ,rspcd varchar2(15) -- 响应码
    ,rspmsg varchar2(383) -- 响应信息
    ,status varchar2(2) -- 开户结果
    ,rsptm varchar2(21) -- 响应时间
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
grant select on ${iol_schema}.mpcs_a57tfudsign to ${iml_schema};
grant select on ${iol_schema}.mpcs_a57tfudsign to ${icl_schema};
grant select on ${iol_schema}.mpcs_a57tfudsign to ${idl_schema};
grant select on ${iol_schema}.mpcs_a57tfudsign to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a57tfudsign is '';
comment on column ${iol_schema}.mpcs_a57tfudsign.sysid is '渠道标识';
comment on column ${iol_schema}.mpcs_a57tfudsign.srcseqno is '请求流水';
comment on column ${iol_schema}.mpcs_a57tfudsign.custname is '客户名称';
comment on column ${iol_schema}.mpcs_a57tfudsign.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a57tfudsign.idno is '身份识别码';
comment on column ${iol_schema}.mpcs_a57tfudsign.idcd is '';
comment on column ${iol_schema}.mpcs_a57tfudsign.custno is '客户号';
comment on column ${iol_schema}.mpcs_a57tfudsign.acctno is '结算账号';
comment on column ${iol_schema}.mpcs_a57tfudsign.reqtm is '申请时间';
comment on column ${iol_schema}.mpcs_a57tfudsign.mobile is '手机号';
comment on column ${iol_schema}.mpcs_a57tfudsign.tel is '固定电话';
comment on column ${iol_schema}.mpcs_a57tfudsign.addr is '地址';
comment on column ${iol_schema}.mpcs_a57tfudsign.zip is '邮编';
comment on column ${iol_schema}.mpcs_a57tfudsign.email is '邮箱';
comment on column ${iol_schema}.mpcs_a57tfudsign.memo is '附加信息';
comment on column ${iol_schema}.mpcs_a57tfudsign.fudcustno is '基金账号';
comment on column ${iol_schema}.mpcs_a57tfudsign.fudacctno is '基金交易账号';
comment on column ${iol_schema}.mpcs_a57tfudsign.rspcd is '响应码';
comment on column ${iol_schema}.mpcs_a57tfudsign.rspmsg is '响应信息';
comment on column ${iol_schema}.mpcs_a57tfudsign.status is '开户结果';
comment on column ${iol_schema}.mpcs_a57tfudsign.rsptm is '响应时间';
comment on column ${iol_schema}.mpcs_a57tfudsign.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a57tfudsign.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a57tfudsign.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a57tfudsign.etl_timestamp is 'ETL处理时间戳';
