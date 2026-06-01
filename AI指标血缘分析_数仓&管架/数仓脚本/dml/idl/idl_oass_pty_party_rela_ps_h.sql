/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_party_rela_ps_h
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
alter table ${idl_schema}.oass_pty_party_rela_ps_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_party_rela_ps_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_party_rela_ps_h (
etl_dt  --数据日期
,sorc_sys_cd  --源系统代码
,rela_ps_rela_type_cd  --关联人关系类型代码
,rela_ps_join_work_tm  --关联人参加工作时间
,rela_ps_corp_phone  --关联人单位联系电话
,rela_ps_tel_num  --关联人电话号码
,rela_ps_corp_name  --关联人单位名称
,rela_ps_name  --关联人名称
,rela_ps_mobile_no  --关联人手机号码
,rela_ps_gender_cd  --关联人性别代码
,rela_ps_mon_inco  --关联人月收入
,rela_ps_cert_no  --关联人证件号码
,rela_ps_cert_type_cd  --关联人证件类型代码
,rela_ps_title_cd  --关联人职称代码
,rela_ps_post_cd  --关联人职务代码
,rela_ps_career_cd  --关联人职业代码
,cty_rg_cd  --国家和地区代码
,rela_ps_zip_cd  --关联人邮政编码
,seq_num  --序号
,spouse_is_have_work  --配偶是否有工作
,rela_ps_phys_addr  --关联人物理地址
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd --源系统代码
,replace(replace(t1.rela_ps_rela_type_cd,chr(13),''),chr(10),'') as rela_ps_rela_type_cd --关联人关系类型代码
,t1.rela_ps_join_work_tm as rela_ps_join_work_tm --关联人参加工作时间
,replace(replace(t1.rela_ps_corp_phone,chr(13),''),chr(10),'') as rela_ps_corp_phone --关联人单位联系电话
,replace(replace(t1.rela_ps_tel_num,chr(13),''),chr(10),'') as rela_ps_tel_num --关联人电话号码
,replace(replace(t1.rela_ps_corp_name,chr(13),''),chr(10),'') as rela_ps_corp_name --关联人单位名称
,replace(replace(t1.rela_ps_name,chr(13),''),chr(10),'') as rela_ps_name --关联人名称
,replace(replace(t1.rela_ps_mobile_no,chr(13),''),chr(10),'') as rela_ps_mobile_no --关联人手机号码
,replace(replace(t1.rela_ps_gender_cd,chr(13),''),chr(10),'') as rela_ps_gender_cd --关联人性别代码
,t1.rela_ps_mon_inco as rela_ps_mon_inco --关联人月收入
,replace(replace(t1.rela_ps_cert_no,chr(13),''),chr(10),'') as rela_ps_cert_no --关联人证件号码
,replace(replace(t1.rela_ps_cert_type_cd,chr(13),''),chr(10),'') as rela_ps_cert_type_cd --关联人证件类型代码
,replace(replace(t1.rela_ps_title_cd,chr(13),''),chr(10),'') as rela_ps_title_cd --关联人职称代码
,replace(replace(t1.rela_ps_post_cd,chr(13),''),chr(10),'') as rela_ps_post_cd --关联人职务代码
,replace(replace(t1.rela_ps_career_cd,chr(13),''),chr(10),'') as rela_ps_career_cd --关联人职业代码
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd --国家和地区代码
,replace(replace(t1.rela_ps_zip_cd,chr(13),''),chr(10),'') as rela_ps_zip_cd --关联人邮政编码
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num --序号
,replace(replace(t1.spouse_is_have_work,chr(13),''),chr(10),'') as spouse_is_have_work --配偶是否有工作
,replace(replace(t1.rela_ps_phys_addr,chr(13),''),chr(10),'') as rela_ps_phys_addr --关联人物理地址
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_party_rela_ps_h t1    --当事人关联人历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_party_rela_ps_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
