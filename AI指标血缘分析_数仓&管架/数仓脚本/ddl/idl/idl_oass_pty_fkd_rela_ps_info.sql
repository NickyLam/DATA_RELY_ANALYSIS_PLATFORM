/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_fkd_rela_ps_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_fkd_rela_ps_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_fkd_rela_ps_info(
etl_dt date --数据日期
,bus_flow_num varchar2(60) --业务流水号
,rela_ps_type_cd varchar2(30) --关联人类型代码
,rela_ps_name varchar2(100) --关联人姓名
,rela_ps_mobile_no varchar2(60) --关联人手机号码
,rela_ps_cert_type_cd varchar2(10) --关联人证件类型代码
,rela_ps_cert_no varchar2(60) --关联人证件号码
,and_main_brwer_rela_cd varchar2(10) --与主借款人关系代码
,rela_ps_resdnt_addr_city_cd varchar2(10) --关联人居住地址城市代码
,rela_ps_resdnt_addr varchar2(500) --关联人居住地址
,rela_ps_marriage_situ_cd varchar2(10) --关联人婚姻状况代码
,rela_ps_spouse_name varchar2(100) --关联人配偶姓名
,rela_ps_spouse_mobile_no varchar2(60) --关联人配偶手机号码
,rela_ps_spouse_cert_type_cd varchar2(10) --关联人配偶证件类型代码
,rela_ps_spouse_cert_no varchar2(60) --关联人配偶证件号码
,rela_ps_cert_exp_dt date --关联人证件到期日
,cust_id varchar2(60) --客户编号
,rev_fraud_rest varchar2(10) --反欺诈结果
,crdtc_rest varchar2(10) --征信结果
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,fkd_rela_ps_list_id varchar2(60) --房快贷关联人列表编号
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
grant select on ${idl_schema}.oass_pty_fkd_rela_ps_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_fkd_rela_ps_info is '房快贷关联人信息';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.bus_flow_num is '业务流水号';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_type_cd is '关联人类型代码';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_name is '关联人姓名';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_mobile_no is '关联人手机号码';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_cert_type_cd is '关联人证件类型代码';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_cert_no is '关联人证件号码';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.and_main_brwer_rela_cd is '与主借款人关系代码';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_resdnt_addr_city_cd is '关联人居住地址城市代码';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_resdnt_addr is '关联人居住地址';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_marriage_situ_cd is '关联人婚姻状况代码';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_spouse_name is '关联人配偶姓名';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_spouse_mobile_no is '关联人配偶手机号码';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_spouse_cert_type_cd is '关联人配偶证件类型代码';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_spouse_cert_no is '关联人配偶证件号码';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rela_ps_cert_exp_dt is '关联人证件到期日';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.cust_id is '客户编号';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.rev_fraud_rest is '反欺诈结果';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.crdtc_rest is '征信结果';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.fkd_rela_ps_list_id is '房快贷关联人列表编号';
comment on column ${idl_schema}.oass_pty_fkd_rela_ps_info.lp_id is '法人编号';

