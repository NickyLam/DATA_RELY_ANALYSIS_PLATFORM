/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_fkd_rela_ps_info
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
alter table ${idl_schema}.oass_pty_fkd_rela_ps_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_fkd_rela_ps_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_fkd_rela_ps_info (
etl_dt  --数据日期
,bus_flow_num  --业务流水号
,rela_ps_type_cd  --关联人类型代码
,rela_ps_name  --关联人姓名
,rela_ps_mobile_no  --关联人手机号码
,rela_ps_cert_type_cd  --关联人证件类型代码
,rela_ps_cert_no  --关联人证件号码
,and_main_brwer_rela_cd  --与主借款人关系代码
,rela_ps_resdnt_addr_city_cd  --关联人居住地址城市代码
,rela_ps_resdnt_addr  --关联人居住地址
,rela_ps_marriage_situ_cd  --关联人婚姻状况代码
,rela_ps_spouse_name  --关联人配偶姓名
,rela_ps_spouse_mobile_no  --关联人配偶手机号码
,rela_ps_spouse_cert_type_cd  --关联人配偶证件类型代码
,rela_ps_spouse_cert_no  --关联人配偶证件号码
,rela_ps_cert_exp_dt  --关联人证件到期日
,cust_id  --客户编号
,rev_fraud_rest  --反欺诈结果
,crdtc_rest  --征信结果
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,fkd_rela_ps_list_id  --房快贷关联人列表编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num --业务流水号
,replace(replace(t1.rela_ps_type_cd,chr(13),''),chr(10),'') as rela_ps_type_cd --关联人类型代码
,replace(replace(t1.rela_ps_name,chr(13),''),chr(10),'') as rela_ps_name --关联人姓名
,replace(replace(t1.rela_ps_mobile_no,chr(13),''),chr(10),'') as rela_ps_mobile_no --关联人手机号码
,replace(replace(t1.rela_ps_cert_type_cd,chr(13),''),chr(10),'') as rela_ps_cert_type_cd --关联人证件类型代码
,replace(replace(t1.rela_ps_cert_no,chr(13),''),chr(10),'') as rela_ps_cert_no --关联人证件号码
,replace(replace(t1.and_main_brwer_rela_cd,chr(13),''),chr(10),'') as and_main_brwer_rela_cd --与主借款人关系代码
,replace(replace(t1.rela_ps_resdnt_addr_city_cd,chr(13),''),chr(10),'') as rela_ps_resdnt_addr_city_cd --关联人居住地址城市代码
,replace(replace(t1.rela_ps_resdnt_addr,chr(13),''),chr(10),'') as rela_ps_resdnt_addr --关联人居住地址
,replace(replace(t1.rela_ps_marriage_situ_cd,chr(13),''),chr(10),'') as rela_ps_marriage_situ_cd --关联人婚姻状况代码
,replace(replace(t1.rela_ps_spouse_name,chr(13),''),chr(10),'') as rela_ps_spouse_name --关联人配偶姓名
,replace(replace(t1.rela_ps_spouse_mobile_no,chr(13),''),chr(10),'') as rela_ps_spouse_mobile_no --关联人配偶手机号码
,replace(replace(t1.rela_ps_spouse_cert_type_cd,chr(13),''),chr(10),'') as rela_ps_spouse_cert_type_cd --关联人配偶证件类型代码
,replace(replace(t1.rela_ps_spouse_cert_no,chr(13),''),chr(10),'') as rela_ps_spouse_cert_no --关联人配偶证件号码
,t1.rela_ps_cert_exp_dt as rela_ps_cert_exp_dt --关联人证件到期日
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.rev_fraud_rest,chr(13),''),chr(10),'') as rev_fraud_rest --反欺诈结果
,replace(replace(t1.crdtc_rest,chr(13),''),chr(10),'') as crdtc_rest --征信结果
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.fkd_rela_ps_list_id,chr(13),''),chr(10),'') as fkd_rela_ps_list_id --房快贷关联人列表编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_fkd_rela_ps_info t1    --房快贷关联人信息
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_fkd_rela_ps_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
