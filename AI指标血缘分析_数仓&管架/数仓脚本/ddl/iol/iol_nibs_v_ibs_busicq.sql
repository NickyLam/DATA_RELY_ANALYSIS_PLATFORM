/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_v_ibs_busicq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_v_ibs_busicq
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_v_ibs_busicq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_v_ibs_busicq(
    channeldate date -- 业务日期
    ,tx_teller_num varchar2(72) -- 办理业务柜员号
    ,tx_teller_name varchar2(1800) -- 柜员姓名
    ,tx_org_num varchar2(108) -- 机构号
    ,tx_org_name varchar2(1800) -- 机构名称
    ,auth_tel_num varchar2(72) -- 授权柜员号
    ,auth_tel_name varchar2(1800) -- 授权柜员姓名
    ,authbranchnum varchar2(90) -- 授权机构号
    ,authbranchname varchar2(288) -- 授权机构名称
    ,cust_num varchar2(144) -- 客户号
    ,queuegettime date -- 客户取号时间
    ,queuecalltime date -- 柜员叫号时间
    ,transtarttime date -- 开始办理业务时间
    ,tranendtime date -- 业务结束时间
    ,channeltrancode varchar2(288) -- 交易码
    ,menuname varchar2(1152) -- 交易名称
    ,authstarttime varchar2(288) -- 授权开始时间
    ,authendtime varchar2(288) -- 授权结束时间
    ,auth_mould varchar2(90) -- 授权模式
    ,tx_seq_num varchar2(297) -- 业务流水号
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
grant select on ${iol_schema}.nibs_v_ibs_busicq to ${iml_schema};
grant select on ${iol_schema}.nibs_v_ibs_busicq to ${icl_schema};
grant select on ${iol_schema}.nibs_v_ibs_busicq to ${idl_schema};
grant select on ${iol_schema}.nibs_v_ibs_busicq to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_v_ibs_busicq is '业务量明细报表';
comment on column ${iol_schema}.nibs_v_ibs_busicq.channeldate is '业务日期';
comment on column ${iol_schema}.nibs_v_ibs_busicq.tx_teller_num is '办理业务柜员号';
comment on column ${iol_schema}.nibs_v_ibs_busicq.tx_teller_name is '柜员姓名';
comment on column ${iol_schema}.nibs_v_ibs_busicq.tx_org_num is '机构号';
comment on column ${iol_schema}.nibs_v_ibs_busicq.tx_org_name is '机构名称';
comment on column ${iol_schema}.nibs_v_ibs_busicq.auth_tel_num is '授权柜员号';
comment on column ${iol_schema}.nibs_v_ibs_busicq.auth_tel_name is '授权柜员姓名';
comment on column ${iol_schema}.nibs_v_ibs_busicq.authbranchnum is '授权机构号';
comment on column ${iol_schema}.nibs_v_ibs_busicq.authbranchname is '授权机构名称';
comment on column ${iol_schema}.nibs_v_ibs_busicq.cust_num is '客户号';
comment on column ${iol_schema}.nibs_v_ibs_busicq.queuegettime is '客户取号时间';
comment on column ${iol_schema}.nibs_v_ibs_busicq.queuecalltime is '柜员叫号时间';
comment on column ${iol_schema}.nibs_v_ibs_busicq.transtarttime is '开始办理业务时间';
comment on column ${iol_schema}.nibs_v_ibs_busicq.tranendtime is '业务结束时间';
comment on column ${iol_schema}.nibs_v_ibs_busicq.channeltrancode is '交易码';
comment on column ${iol_schema}.nibs_v_ibs_busicq.menuname is '交易名称';
comment on column ${iol_schema}.nibs_v_ibs_busicq.authstarttime is '授权开始时间';
comment on column ${iol_schema}.nibs_v_ibs_busicq.authendtime is '授权结束时间';
comment on column ${iol_schema}.nibs_v_ibs_busicq.auth_mould is '授权模式';
comment on column ${iol_schema}.nibs_v_ibs_busicq.tx_seq_num is '业务流水号';
comment on column ${iol_schema}.nibs_v_ibs_busicq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_v_ibs_busicq.etl_timestamp is 'ETL处理时间戳';
