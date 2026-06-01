/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_corp_cust_group_info_h
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
alter table ${idl_schema}.oass_pty_corp_cust_group_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_corp_cust_group_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_corp_cust_group_info_h (
etl_dt  --数据日期
,belong_group_id  --所属集团编号
,data_src_cd  --数据来源代码
,belong_group_name  --所属集团名称
,belong_group_orgnz_cd  --所属集团组织机构代码
,belong_group_loan_card_no  --所属集团贷款卡号
,belong_group_rgst_cty_rg_cd  --所属集团注册国家地区代码
,belong_group_site_cd  --所属集团所在地代码
,belong_group_rgst_addr  --所属集团注册地址
,group_core_mem_flg  --集团核心成员标志
,belong_group_dom_work_addr  --所属集团国内办公地址
,mem_type_cd  --成员类型代码
,parent_corp_flg  --母公司标志
,mem_status_cd  --成员状态代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.belong_group_id,chr(13),''),chr(10),'') as belong_group_id --所属集团编号
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd --数据来源代码
,replace(replace(t1.belong_group_name,chr(13),''),chr(10),'') as belong_group_name --所属集团名称
,replace(replace(t1.belong_group_orgnz_cd,chr(13),''),chr(10),'') as belong_group_orgnz_cd --所属集团组织机构代码
,replace(replace(t1.belong_group_loan_card_no,chr(13),''),chr(10),'') as belong_group_loan_card_no --所属集团贷款卡号
,replace(replace(t1.belong_group_rgst_cty_rg_cd,chr(13),''),chr(10),'') as belong_group_rgst_cty_rg_cd --所属集团注册国家地区代码
,replace(replace(t1.belong_group_site_cd,chr(13),''),chr(10),'') as belong_group_site_cd --所属集团所在地代码
,replace(replace(t1.belong_group_rgst_addr,chr(13),''),chr(10),'') as belong_group_rgst_addr --所属集团注册地址
,replace(replace(t1.group_core_mem_flg,chr(13),''),chr(10),'') as group_core_mem_flg --集团核心成员标志
,replace(replace(t1.belong_group_dom_work_addr,chr(13),''),chr(10),'') as belong_group_dom_work_addr --所属集团国内办公地址
,replace(replace(t1.mem_type_cd,chr(13),''),chr(10),'') as mem_type_cd --成员类型代码
,replace(replace(t1.parent_corp_flg,chr(13),''),chr(10),'') as parent_corp_flg --母公司标志
,replace(replace(t1.mem_status_cd,chr(13),''),chr(10),'') as mem_status_cd --成员状态代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_corp_cust_group_info_h t1    --对公客户集团信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_corp_cust_group_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
