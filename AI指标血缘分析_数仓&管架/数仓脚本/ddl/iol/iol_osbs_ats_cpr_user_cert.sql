/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_ats_cpr_user_cert
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_ats_cpr_user_cert
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_ats_cpr_user_cert purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ats_cpr_user_cert(
    cuc_certdn varchar2(256) -- 证书DN
    ,cuc_ecifno varchar2(32) -- 企业顺序号
    ,cuc_userno varchar2(32) -- 企业用户顺序号
    ,cuc_serialno varchar2(64) -- 证书序列号
    ,cuc_certrefno varchar2(64) -- 证书参考号
    ,cuc_certauthcode varchar2(64) -- 证书授权号
    ,cuc_issuerdn varchar2(64) -- 证书发行商DN
    ,cuc_applydate varchar2(14) -- 证书申请日期
    ,cuc_usbkeysn varchar2(64) -- USBKEY序号
    ,cuc_usbkeyflag varchar2(1) -- 是否使用USBKEY
    ,cuc_certstate varchar2(1) -- 证书状态
    ,cuc_closedate varchar2(14) -- 证书销户日期
    ,cuc_toolopendate varchar2(14) -- 工具开通日期
    ,cuc_toolclosedate varchar2(14) -- 工具关闭日期
    ,cuc_vendorid varchar2(1) -- 厂商号(0飞天)
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.osbs_ats_cpr_user_cert to ${iml_schema};
grant select on ${iol_schema}.osbs_ats_cpr_user_cert to ${icl_schema};
grant select on ${iol_schema}.osbs_ats_cpr_user_cert to ${idl_schema};
grant select on ${iol_schema}.osbs_ats_cpr_user_cert to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_ats_cpr_user_cert is '企业用户表';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_certdn is '证书DN';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_ecifno is '企业顺序号';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_userno is '企业用户顺序号';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_serialno is '证书序列号';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_certrefno is '证书参考号';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_certauthcode is '证书授权号';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_issuerdn is '证书发行商DN';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_applydate is '证书申请日期';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_usbkeysn is 'USBKEY序号';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_usbkeyflag is '是否使用USBKEY';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_certstate is '证书状态';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_closedate is '证书销户日期';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_toolopendate is '工具开通日期';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_toolclosedate is '工具关闭日期';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.cuc_vendorid is '厂商号(0飞天)';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_ats_cpr_user_cert.etl_timestamp is 'ETL处理时间戳';
