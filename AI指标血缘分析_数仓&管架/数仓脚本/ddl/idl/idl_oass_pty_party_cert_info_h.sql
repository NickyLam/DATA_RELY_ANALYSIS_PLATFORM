/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_party_cert_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_party_cert_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_party_cert_info_h(
etl_dt date --数据日期
,sorc_sys_cd varchar2(10) --源系统代码
,cert_type_cd varchar2(10) --证件类型代码
,cert_num varchar2(60) --证件号码
,cert_addr varchar2(500) --证件地址
,issue_cert_org varchar2(500) --发证机关
,issue_cert_org_cty_cd varchar2(10) --证件签发国家代码
,cert_effect_dt date --证件生效日期
,cert_invalid_dt date --证件失效日期
,licen_issue_autho_dist_cd varchar2(30) --发证机关地区代码
,crdt_cd_cert_id varchar2(60) --信用代码证编号
,cert_valid_flg varchar2(10) --证件有效标志
,cert_status_cd varchar2(10) --证件状态代码
,main_cert_no_flg varchar2(10) --主证件号标志
,netw_vrfction_flg varchar2(30) --联网核查标志
,netw_vrfction_rest_cd varchar2(30) --联网核查结果代码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,party_id varchar2(60) --当事人编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_pty_party_cert_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_party_cert_info_h is '当事人证件信息历史';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.sorc_sys_cd is '源系统代码';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.cert_num is '证件号码';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.cert_addr is '证件地址';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.issue_cert_org is '发证机关';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.issue_cert_org_cty_cd is '证件签发国家代码';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.cert_effect_dt is '证件生效日期';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.cert_invalid_dt is '证件失效日期';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.licen_issue_autho_dist_cd is '发证机关地区代码';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.crdt_cd_cert_id is '信用代码证编号';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.cert_valid_flg is '证件有效标志';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.cert_status_cd is '证件状态代码';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.main_cert_no_flg is '主证件号标志';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.netw_vrfction_flg is '联网核查标志';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.netw_vrfction_rest_cd is '联网核查结果代码';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_party_cert_info_h.lp_id is '法人编号';

