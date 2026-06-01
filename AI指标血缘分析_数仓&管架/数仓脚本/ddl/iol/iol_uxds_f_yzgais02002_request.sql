/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_yzgais02002_request
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_yzgais02002_request
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_yzgais02002_request purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_yzgais02002_request(
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
    ,deponame varchar2(4000) -- 企业名称
    ,uniscid varchar2(4000) -- 统一社会信用
    ,address varchar2(4000) -- 地址
    ,legalname varchar2(4000) -- 法人姓名
    ,legalldtype varchar2(4000) -- 法人证件类型
    ,legalldno varchar2(4000) -- 法人证件号
    ,legalcontel varchar2(4000) -- 法人手机号
    ,handlpernameother varchar2(4000) -- 经办人姓名
    ,handlidtypeother varchar2(4000) -- 经办人证件类型
    ,andlidnoother varchar2(4000) -- 经办人证件号
    ,handlcontelother varchar2(4000) -- 经办人手机号
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
grant select on ${iol_schema}.uxds_f_yzgais02002_request to ${iml_schema};
grant select on ${iol_schema}.uxds_f_yzgais02002_request to ${icl_schema};
grant select on ${iol_schema}.uxds_f_yzgais02002_request to ${idl_schema};
grant select on ${iol_schema}.uxds_f_yzgais02002_request to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_yzgais02002_request is '粤账管-11项实时检测查询-请求表';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.srv_scen_cd is '服务场景代码';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.src_init_sys_id is '源发起系统ID';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.srv_cllpty_sys_id is '服务调用方系统ID';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.srv_cllpty_trx_seq is '系统内流水号';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.srv_cllpty_trx_dt is '服务调用方交易日期';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.srv_cllpty_txn_tm is '服务调用方交易时间';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.srv_tgt_sys_id is '服务目标系统ID';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.txn_org_cd is '交易机构代码';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.chn_id is '源发起渠道编号';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.deponame is '企业名称';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.uniscid is '统一社会信用';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.address is '地址';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.legalname is '法人姓名';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.legalldtype is '法人证件类型';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.legalldno is '法人证件号';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.legalcontel is '法人手机号';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.handlpernameother is '经办人姓名';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.handlidtypeother is '经办人证件类型';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.andlidnoother is '经办人证件号';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.handlcontelother is '经办人手机号';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.genmonth is '生成月份';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.msgid is '报文编号';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_yzgais02002_request.etl_timestamp is 'ETL处理时间戳';
