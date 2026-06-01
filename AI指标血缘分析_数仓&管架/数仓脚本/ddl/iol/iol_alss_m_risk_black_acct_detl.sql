/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_m_risk_black_acct_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_m_risk_black_acct_detl
whenever sqlerror continue none;
drop table ${iol_schema}.alss_m_risk_black_acct_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_m_risk_black_acct_detl(
    etl_dt_ora date -- 数据日期
    ,legal_dt date -- 涉案日期
    ,data_typ varchar2(100) -- 数据类型
    ,legal_acct varchar2(100) -- 涉案账号
    ,iden_typ varchar2(100) -- 证件类型
    ,cert_num varchar2(100) -- 证件号码
    ,pty_id varchar2(100) -- 客户号
    ,ceph_num varchar2(100) -- 手机号码
    ,tel_num varchar2(100) -- 电话号码
    ,wthr_snd_short_lett varchar2(100) -- 是否发送短信
    ,blkl_typ varchar2(100) -- 涉案类型（黑名单类型）
    ,legal_comm varchar2(255) -- 涉案说明
    ,deal_flg varchar2(100) -- 处理标志
    ,dat_src varchar2(100) -- 数据源
    ,starti varchar2(255) -- 
    ,endti varchar2(255) -- 
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
grant select on ${iol_schema}.alss_m_risk_black_acct_detl to ${iml_schema};
grant select on ${iol_schema}.alss_m_risk_black_acct_detl to ${icl_schema};
grant select on ${iol_schema}.alss_m_risk_black_acct_detl to ${idl_schema};
grant select on ${iol_schema}.alss_m_risk_black_acct_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_m_risk_black_acct_detl is '诈骗风险交易名单';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.legal_dt is '涉案日期';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.data_typ is '数据类型';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.legal_acct is '涉案账号';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.iden_typ is '证件类型';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.cert_num is '证件号码';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.pty_id is '客户号';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.ceph_num is '手机号码';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.tel_num is '电话号码';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.wthr_snd_short_lett is '是否发送短信';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.blkl_typ is '涉案类型（黑名单类型）';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.legal_comm is '涉案说明';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.deal_flg is '处理标志';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.dat_src is '数据源';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.starti is '';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.endti is '';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_m_risk_black_acct_detl.etl_timestamp is 'ETL处理时间戳';
