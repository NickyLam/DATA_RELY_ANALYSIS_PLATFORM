/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbinsurerinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbinsurerinfo
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbinsurerinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsurerinfo(
    ta_code varchar2(14) -- 
    ,insure_bank_no varchar2(14) -- 
    ,ta_name varchar2(90) -- 
    ,ta_short_name varchar2(30) -- 
    ,ta_busin_name varchar2(15) -- 
    ,ta_type varchar2(3) -- 
    ,ta_limit_flag varchar2(2) -- 
    ,charge_flag varchar2(2) -- 
    ,begin_date number(22) -- 
    ,end_date number(22) -- 
    ,master_internal varchar2(18) -- 
    ,master_branch varchar2(24) -- 
    ,insurer_acc varchar2(48) -- 
    ,in_busin_no varchar2(30) -- 
    ,out_busin_no varchar2(30) -- 
    ,ip_address varchar2(30) -- 
    ,port varchar2(15) -- 
    ,wait_time number(22) -- 
    ,file_ip varchar2(30) -- 
    ,file_port varchar2(15) -- 
    ,file_wait_time number(22) -- 
    ,link_name varchar2(30) -- 
    ,link_tel varchar2(30) -- 
    ,signin_flag varchar2(2) -- 
    ,signin_date number(22) -- 
    ,m_pkg_key varchar2(192) -- 
    ,m_pwd_key varchar2(192) -- 
    ,m_mac_key varchar2(192) -- 
    ,pkg_key varchar2(192) -- 
    ,pwd_key varchar2(192) -- 
    ,mac_key varchar2(192) -- 
    ,control_flag varchar2(375) -- 
    ,open_time number(22) -- 
    ,close_time number(22) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbinsurerinfo to ${iml_schema};
grant select on ${iol_schema}.ifms_tbinsurerinfo to ${icl_schema};
grant select on ${iol_schema}.ifms_tbinsurerinfo to ${idl_schema};
grant select on ${iol_schema}.ifms_tbinsurerinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbinsurerinfo is '保险公司信息表';
comment on column ${iol_schema}.ifms_tbinsurerinfo.ta_code is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.insure_bank_no is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.ta_name is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.ta_short_name is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.ta_busin_name is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.ta_type is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.ta_limit_flag is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.charge_flag is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.begin_date is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.end_date is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.master_internal is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.master_branch is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.insurer_acc is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.in_busin_no is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.out_busin_no is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.ip_address is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.port is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.wait_time is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.file_ip is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.file_port is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.file_wait_time is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.link_name is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.link_tel is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.signin_flag is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.signin_date is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.m_pkg_key is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.m_pwd_key is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.m_mac_key is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.pkg_key is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.pwd_key is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.mac_key is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.control_flag is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.open_time is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.close_time is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.reserve1 is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.reserve2 is '';
comment on column ${iol_schema}.ifms_tbinsurerinfo.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbinsurerinfo.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbinsurerinfo.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbinsurerinfo.etl_timestamp is 'ETL处理时间戳';
