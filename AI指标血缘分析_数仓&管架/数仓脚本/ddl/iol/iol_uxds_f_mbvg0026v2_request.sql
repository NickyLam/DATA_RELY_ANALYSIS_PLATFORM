/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_mbvg0026v2_request
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_mbvg0026v2_request
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_mbvg0026v2_request purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_mbvg0026v2_request(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,srv_scen_cd varchar2(4000) -- 服务场景代码
    ,src_init_sys_id varchar2(4000) -- 源发起系统ID
    ,srv_cllpty_sys_id varchar2(4000) -- 服务调用方系统ID
    ,srv_cllpty_trx_seq varchar2(4000) -- 系统内流水号
    ,srv_cllpty_trx_dt varchar2(4000) -- 服务调用方交易日期
    ,srv_cllpty_txn_tm varchar2(4000) -- 服务调用方交易时间
    ,srv_tgt_sys_id varchar2(4000) -- 服务目标系统ID
    ,txn_org_cd varchar2(4000) -- 交易机构代码
    ,chn_id varchar2(4000) -- 源发起渠道编号
    ,msgid varchar2(4000) -- 报文编号
    ,mobile varchar2(4000) -- 手机号码
    ,empowerno varchar2(4000) -- 授权记录号
    ,genmonth varchar2(4000) -- 生成月份
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
grant select on ${iol_schema}.uxds_f_mbvg0026v2_request to ${iml_schema};
grant select on ${iol_schema}.uxds_f_mbvg0026v2_request to ${icl_schema};
grant select on ${iol_schema}.uxds_f_mbvg0026v2_request to ${idl_schema};
grant select on ${iol_schema}.uxds_f_mbvg0026v2_request to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_mbvg0026v2_request is '百行征信-手机在网时长2.0-请求表';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.srv_scen_cd is '服务场景代码';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.src_init_sys_id is '源发起系统ID';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.srv_cllpty_sys_id is '服务调用方系统ID';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.srv_cllpty_trx_seq is '系统内流水号';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.srv_cllpty_trx_dt is '服务调用方交易日期';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.srv_cllpty_txn_tm is '服务调用方交易时间';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.srv_tgt_sys_id is '服务目标系统ID';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.txn_org_cd is '交易机构代码';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.chn_id is '源发起渠道编号';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.msgid is '报文编号';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.mobile is '手机号码';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.empowerno is '授权记录号';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.genmonth is '生成月份';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_mbvg0026v2_request.etl_timestamp is 'ETL处理时间戳';
