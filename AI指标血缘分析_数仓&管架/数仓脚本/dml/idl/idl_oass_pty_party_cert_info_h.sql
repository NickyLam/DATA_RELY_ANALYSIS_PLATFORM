/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_party_cert_info_h
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_pty_party_cert_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_party_cert_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_party_cert_info_h (
etl_dt  --数据日期
,sorc_sys_cd  --源系统代码
,cert_type_cd  --证件类型代码
,cert_num  --证件号码
,cert_addr  --证件地址
,issue_cert_org  --发证机关
,issue_cert_org_cty_cd  --证件签发国家代码
,cert_effect_dt  --证件生效日期
,cert_invalid_dt  --证件失效日期
,licen_issue_autho_dist_cd  --发证机关地区代码
,crdt_cd_cert_id  --信用代码证编号
,cert_valid_flg  --证件有效标志
,cert_status_cd  --证件状态代码
,main_cert_no_flg  --主证件号标志
,netw_vrfction_flg  --联网核查标志
,netw_vrfction_rest_cd  --联网核查结果代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd --源系统代码
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd --证件类型代码
,replace(replace(t1.cert_num,chr(13),''),chr(10),'') as cert_num --证件号码
,replace(replace(t1.cert_addr,chr(13),''),chr(10),'') as cert_addr --证件地址
,replace(replace(t1.issue_cert_org,chr(13),''),chr(10),'') as issue_cert_org --发证机关
,replace(replace(t1.issue_cert_org_cty_cd,chr(13),''),chr(10),'') as issue_cert_org_cty_cd --证件签发国家代码
,t1.cert_effect_dt as cert_effect_dt --证件生效日期
,t1.cert_invalid_dt as cert_invalid_dt --证件失效日期
,replace(replace(t1.licen_issue_autho_dist_cd,chr(13),''),chr(10),'') as licen_issue_autho_dist_cd --发证机关地区代码
,replace(replace(t1.crdt_cd_cert_id,chr(13),''),chr(10),'') as crdt_cd_cert_id --信用代码证编号
,replace(replace(t1.cert_valid_flg,chr(13),''),chr(10),'') as cert_valid_flg --证件有效标志
,replace(replace(t1.cert_status_cd,chr(13),''),chr(10),'') as cert_status_cd --证件状态代码
,replace(replace(t1.main_cert_no_flg,chr(13),''),chr(10),'') as main_cert_no_flg --主证件号标志
,replace(replace(t1.netw_vrfction_flg,chr(13),''),chr(10),'') as netw_vrfction_flg --联网核查标志
,replace(replace(t1.netw_vrfction_rest_cd,chr(13),''),chr(10),'') as netw_vrfction_rest_cd --联网核查结果代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_party_cert_info_h t1    --当事人证件信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_party_cert_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
