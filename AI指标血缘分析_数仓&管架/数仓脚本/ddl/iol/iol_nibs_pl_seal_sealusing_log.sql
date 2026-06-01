/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_pl_seal_sealusing_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_pl_seal_sealusing_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_pl_seal_sealusing_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_pl_seal_sealusing_log(
    origin varchar2(2) -- 申请来源
    ,remark3 varchar2(128) -- 备用3
    ,sealdata varchar2(4000) -- 印章数据
    ,scenecode varchar2(20) -- 场景码
    ,sealtype varchar2(2) -- 印章类型（01-电子印章;02-实物印章）
    ,sealmodelid varchar2(20) -- 电子印模id
    ,oprteller varchar2(8) -- 操作柜员编号
    ,oprbranch varchar2(12) -- 操作机构编号
    ,serialno varchar2(50) -- 交易流水号/打印流水号
    ,oprtime date -- 操作时间
    ,oprdate date -- 操作日期
    ,chanelcode varchar2(6) -- 交易渠道编号
    ,verificationcode varchar2(12) -- 业务验证码12位
    ,remark2 varchar2(64) -- 备用2
    ,remark1 varchar2(32) -- 备用1
    ,amount number(20,2) -- 金额
    ,accname varchar2(200) -- 户名
    ,account varchar2(2000) -- 账户编号
    ,tradename varchar2(100) -- 交易名称
    ,tradecode varchar2(20) -- 交易码
    ,brnoname varchar2(200) -- 机构名称
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
grant select on ${iol_schema}.nibs_pl_seal_sealusing_log to ${iml_schema};
grant select on ${iol_schema}.nibs_pl_seal_sealusing_log to ${icl_schema};
grant select on ${iol_schema}.nibs_pl_seal_sealusing_log to ${idl_schema};
grant select on ${iol_schema}.nibs_pl_seal_sealusing_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_pl_seal_sealusing_log is '用印流水表';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.origin is '申请来源';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.remark3 is '备用3';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.sealdata is '印章数据';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.scenecode is '场景码';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.sealtype is '印章类型（01-电子印章;02-实物印章）';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.sealmodelid is '电子印模id';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.oprteller is '操作柜员编号';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.oprbranch is '操作机构编号';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.serialno is '交易流水号/打印流水号';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.oprtime is '操作时间';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.oprdate is '操作日期';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.chanelcode is '交易渠道编号';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.verificationcode is '业务验证码12位';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.remark2 is '备用2';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.remark1 is '备用1';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.amount is '金额';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.accname is '户名';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.account is '账户编号';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.tradename is '交易名称';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.tradecode is '交易码';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.brnoname is '机构名称';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_pl_seal_sealusing_log.etl_timestamp is 'ETL处理时间戳';
