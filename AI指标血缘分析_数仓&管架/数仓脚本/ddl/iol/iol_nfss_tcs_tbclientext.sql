/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tcs_tbclientext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tcs_tbclientext
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tcs_tbclientext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbclientext(
    in_client_no varchar2(30) -- 
    ,adrtype varchar2(2) -- 
    ,adrsta varchar2(15) -- 
    ,adrcty varchar2(15) -- 
    ,adrsec varchar2(15) -- 
    ,adrdet varchar2(375) -- 
    ,telint varchar2(9) -- 
    ,telzon varchar2(6) -- 
    ,telnum varchar2(15) -- 
    ,telext varchar2(9) -- 
    ,mobint varchar2(9) -- 
    ,gzdw varchar2(90) -- 
    ,hy varchar2(6) -- 
    ,xqah varchar2(30) -- 
    ,hyzt varchar2(2) -- 
    ,jrzc varchar2(15) -- 
    ,zzsyq varchar2(2) -- 
    ,jtgj varchar2(2) -- 
    ,jtkhlx varchar2(2) -- 
    ,khsqjb varchar2(2) -- 
    ,sqjbxgsj varchar2(30) -- 
    ,zyyw varchar2(27) -- 
    ,nzsr number(18,2) -- 
    ,zzlx varchar2(3) -- 
    ,ygrs varchar2(2) -- 
    ,zhxgyh varchar2(15) -- 
    ,zhxgsj varchar2(30) -- 
    ,reserve1 varchar2(375) -- 
    ,investor_type varchar2(2) -- 
    ,fold_in_client_no varchar2(30) -- 
    ,fold_id_type varchar2(2) -- 
    ,fold_id_code varchar2(45) -- 
    ,modify_flag varchar2(2) -- 
    ,fdaily_upd_date number(22,0) -- 
    ,other_id_type_name varchar2(90) -- 
    ,fold_client_name varchar2(375) -- 
    ,old_other_id_type_name varchar2(90) -- 
    ,host_id_type varchar2(3) -- 
    ,old_host_id_type varchar2(3) -- 
    ,spv_branch varchar2(9) -- 
    ,other_branch varchar2(90) -- 
    ,spv_account varchar2(150) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
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
grant select on ${iol_schema}.nfss_tcs_tbclientext to ${iml_schema};
grant select on ${iol_schema}.nfss_tcs_tbclientext to ${icl_schema};
grant select on ${iol_schema}.nfss_tcs_tbclientext to ${idl_schema};
grant select on ${iol_schema}.nfss_tcs_tbclientext to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tcs_tbclientext is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.in_client_no is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.adrtype is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.adrsta is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.adrcty is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.adrsec is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.adrdet is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.telint is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.telzon is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.telnum is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.telext is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.mobint is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.gzdw is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.hy is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.xqah is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.hyzt is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.jrzc is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.zzsyq is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.jtgj is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.jtkhlx is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.khsqjb is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.sqjbxgsj is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.zyyw is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.nzsr is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.zzlx is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.ygrs is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.zhxgyh is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.zhxgsj is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.reserve1 is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.investor_type is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.fold_in_client_no is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.fold_id_type is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.fold_id_code is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.modify_flag is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.fdaily_upd_date is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.other_id_type_name is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.fold_client_name is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.old_other_id_type_name is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.host_id_type is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.old_host_id_type is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.spv_branch is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.other_branch is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.spv_account is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.reserve2 is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.reserve3 is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.reserve4 is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.reserve5 is '';
comment on column ${iol_schema}.nfss_tcs_tbclientext.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tcs_tbclientext.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tcs_tbclientext.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tcs_tbclientext.etl_timestamp is 'ETL处理时间戳';
