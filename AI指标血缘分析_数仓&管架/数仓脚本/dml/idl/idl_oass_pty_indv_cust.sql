/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_indv_cust
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
alter table ${idl_schema}.oass_pty_indv_cust drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_indv_cust add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_indv_cust (
etl_dt  --ETL处理日期
,sorc_sys_cd  --源系统代码
,gender_cd  --性别代码
,birth_dt  --出生日期
,nationty_cd  --民族代码
,nati_place  --籍贯
,politic_status_cd  --政治面貌代码
,marriage_situ_cd  --婚姻状况代码
,emply_flg  --行员标志
,age  --年龄
,resdnt_flg  --居民标志
,nation_cd  --国籍代码
,dist_cd  --行政区划代码
,hxb_shard_flg  --我行股东标志
,owner_type_cd  --业主类型代码
,ctysd_rpr_flg  --农村户口标志
,hxb_rela_party_flg  --我行关联方标志
,hxb_trast_inter_bus_flg  --在我行办理过中间业务标志
,hxb_payoff_sal_acct_flg  --我行代发工资户标志
,hxb_reg_cust_flg  --我行定期客户标志
,hxb_finc_cust_flg  --我行理财客户标志
,hxb_vip_cust_idf  --我行VIP客户标识
,spouse_child_img_flg  --配偶及子女移民标志
,enjoy_cty_prefr_policy_flg  --享受国家优惠政策标志
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,open_acct_teller_id  --开户柜员编号
,open_acct_org_id  --开户机构编号
,open_acct_dt  --开户日期
,grad_sch  --毕业学校
,grad_year  --毕业年份
,e_mail  --电子邮箱
,cust_id  --客户编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd --源系统代码
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd --性别代码
,t1.birth_dt as birth_dt --出生日期
,replace(replace(t1.nationty_cd,chr(13),''),chr(10),'') as nationty_cd --民族代码
,replace(replace(t1.nati_place,chr(13),''),chr(10),'') as nati_place --籍贯
,replace(replace(t1.politic_status_cd,chr(13),''),chr(10),'') as politic_status_cd --政治面貌代码
,replace(replace(t1.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd --婚姻状况代码
,replace(replace(t1.emply_flg,chr(13),''),chr(10),'') as emply_flg --行员标志
,t1.age as age --年龄
,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg --居民标志
,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd --国籍代码
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd --行政区划代码
,replace(replace(t1.hxb_shard_flg,chr(13),''),chr(10),'') as hxb_shard_flg --我行股东标志
,replace(replace(t1.owner_type_cd,chr(13),''),chr(10),'') as owner_type_cd --业主类型代码
,replace(replace(t1.ctysd_rpr_flg,chr(13),''),chr(10),'') as ctysd_rpr_flg --农村户口标志
,replace(replace(t1.hxb_rela_party_flg,chr(13),''),chr(10),'') as hxb_rela_party_flg --我行关联方标志
,replace(replace(t1.hxb_trast_inter_bus_flg,chr(13),''),chr(10),'') as hxb_trast_inter_bus_flg --在我行办理过中间业务标志
,replace(replace(t1.hxb_payoff_sal_acct_flg,chr(13),''),chr(10),'') as hxb_payoff_sal_acct_flg --我行代发工资户标志
,replace(replace(t1.hxb_reg_cust_flg,chr(13),''),chr(10),'') as hxb_reg_cust_flg --我行定期客户标志
,replace(replace(t1.hxb_finc_cust_flg,chr(13),''),chr(10),'') as hxb_finc_cust_flg --我行理财客户标志
,replace(replace(t1.hxb_vip_cust_idf,chr(13),''),chr(10),'') as hxb_vip_cust_idf --我行VIP客户标识
,replace(replace(t1.spouse_child_img_flg,chr(13),''),chr(10),'') as spouse_child_img_flg --配偶及子女移民标志
,replace(replace(t1.enjoy_cty_prefr_policy_flg,chr(13),''),chr(10),'') as enjoy_cty_prefr_policy_flg --享受国家优惠政策标志
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id --开户柜员编号
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id --开户机构编号
,t1.open_acct_dt as open_acct_dt --开户日期
,replace(replace(t1.grad_sch,chr(13),''),chr(10),'') as grad_sch --毕业学校
,t1.grad_year as grad_year --毕业年份
,replace(replace(t1.e_mail,chr(13),''),chr(10),'') as e_mail --电子邮箱
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_indv_cust t1    --个人客户
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_indv_cust',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
