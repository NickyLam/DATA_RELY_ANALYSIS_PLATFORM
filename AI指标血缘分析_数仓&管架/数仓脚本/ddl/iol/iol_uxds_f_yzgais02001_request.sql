/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_yzgais02001_request
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_yzgais02001_request
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_yzgais02001_request purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_yzgais02001_request(
    gendate varchar2(4000) -- 生成时间
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
    ,name varchar2(4000) -- 客户姓名
    ,certtype varchar2(4000) -- 证件类型
    ,certno varchar2(4000) -- 证件号码
    ,genmonth varchar2(4000) -- 生成月份
    ,msgid varchar2(4000) -- 报文编号
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
grant select on ${iol_schema}.uxds_f_yzgais02001_request to ${iml_schema};
grant select on ${iol_schema}.uxds_f_yzgais02001_request to ${icl_schema};
grant select on ${iol_schema}.uxds_f_yzgais02001_request to ${idl_schema};
grant select on ${iol_schema}.uxds_f_yzgais02001_request to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_yzgais02001_request is '粤账管-个人账户可疑及涉嫌违法检测查询-请求表';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.srv_scen_cd is '服务场景代码';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.src_init_sys_id is '源发起系统ID';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.srv_cllpty_sys_id is '服务调用方系统ID';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.srv_cllpty_trx_seq is '系统内流水号';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.srv_cllpty_trx_dt is '服务调用方交易日期';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.srv_cllpty_txn_tm is '服务调用方交易时间';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.srv_tgt_sys_id is '服务目标系统ID';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.txn_org_cd is '交易机构代码';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.chn_id is '源发起渠道编号';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.name is '客户姓名';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.certtype is '证件类型';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.certno is '证件号码';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.genmonth is '生成月份';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.msgid is '报文编号';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_yzgais02001_request.etl_timestamp is 'ETL处理时间戳';
