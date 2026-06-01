/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_indv_cust
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_indv_cust purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_indv_cust(
etl_dt date --ETL处理日期
,sorc_sys_cd varchar2(10) --源系统代码
,gender_cd varchar2(10) --性别代码
,birth_dt date --出生日期
,nationty_cd varchar2(10) --民族代码
,nati_place varchar2(500) --籍贯
,politic_status_cd varchar2(30) --政治面貌代码
,marriage_situ_cd varchar2(10) --婚姻状况代码
,emply_flg varchar2(10) --行员标志
,age number(10,0) --年龄
,resdnt_flg varchar2(10) --居民标志
,nation_cd varchar2(10) --国籍代码
,dist_cd varchar2(10) --行政区划代码
,hxb_shard_flg varchar2(10) --我行股东标志
,owner_type_cd varchar2(30) --业主类型代码
,ctysd_rpr_flg varchar2(10) --农村户口标志
,hxb_rela_party_flg varchar2(10) --我行关联方标志
,hxb_trast_inter_bus_flg varchar2(10) --在我行办理过中间业务标志
,hxb_payoff_sal_acct_flg varchar2(10) --我行代发工资户标志
,hxb_reg_cust_flg varchar2(10) --我行定期客户标志
,hxb_finc_cust_flg varchar2(10) --我行理财客户标志
,hxb_vip_cust_idf varchar2(10) --我行VIP客户标识
,spouse_child_img_flg varchar2(10) --配偶及子女移民标志
,enjoy_cty_prefr_policy_flg varchar2(10) --享受国家优惠政策标志
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,open_acct_teller_id varchar2(100) --开户柜员编号
,open_acct_org_id varchar2(100) --开户机构编号
,open_acct_dt date --开户日期
,grad_sch varchar2(1000) --毕业学校
,grad_year date --毕业年份
,e_mail varchar2(500) --电子邮箱
,cust_id varchar2(60) --客户编号
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
grant select on ${idl_schema}.oass_pty_indv_cust to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_indv_cust is '个人客户';
comment on column ${idl_schema}.oass_pty_indv_cust.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_pty_indv_cust.sorc_sys_cd is '源系统代码';
comment on column ${idl_schema}.oass_pty_indv_cust.gender_cd is '性别代码';
comment on column ${idl_schema}.oass_pty_indv_cust.birth_dt is '出生日期';
comment on column ${idl_schema}.oass_pty_indv_cust.nationty_cd is '民族代码';
comment on column ${idl_schema}.oass_pty_indv_cust.nati_place is '籍贯';
comment on column ${idl_schema}.oass_pty_indv_cust.politic_status_cd is '政治面貌代码';
comment on column ${idl_schema}.oass_pty_indv_cust.marriage_situ_cd is '婚姻状况代码';
comment on column ${idl_schema}.oass_pty_indv_cust.emply_flg is '行员标志';
comment on column ${idl_schema}.oass_pty_indv_cust.age is '年龄';
comment on column ${idl_schema}.oass_pty_indv_cust.resdnt_flg is '居民标志';
comment on column ${idl_schema}.oass_pty_indv_cust.nation_cd is '国籍代码';
comment on column ${idl_schema}.oass_pty_indv_cust.dist_cd is '行政区划代码';
comment on column ${idl_schema}.oass_pty_indv_cust.hxb_shard_flg is '我行股东标志';
comment on column ${idl_schema}.oass_pty_indv_cust.owner_type_cd is '业主类型代码';
comment on column ${idl_schema}.oass_pty_indv_cust.ctysd_rpr_flg is '农村户口标志';
comment on column ${idl_schema}.oass_pty_indv_cust.hxb_rela_party_flg is '我行关联方标志';
comment on column ${idl_schema}.oass_pty_indv_cust.hxb_trast_inter_bus_flg is '在我行办理过中间业务标志';
comment on column ${idl_schema}.oass_pty_indv_cust.hxb_payoff_sal_acct_flg is '我行代发工资户标志';
comment on column ${idl_schema}.oass_pty_indv_cust.hxb_reg_cust_flg is '我行定期客户标志';
comment on column ${idl_schema}.oass_pty_indv_cust.hxb_finc_cust_flg is '我行理财客户标志';
comment on column ${idl_schema}.oass_pty_indv_cust.hxb_vip_cust_idf is '我行VIP客户标识';
comment on column ${idl_schema}.oass_pty_indv_cust.spouse_child_img_flg is '配偶及子女移民标志';
comment on column ${idl_schema}.oass_pty_indv_cust.enjoy_cty_prefr_policy_flg is '享受国家优惠政策标志';
comment on column ${idl_schema}.oass_pty_indv_cust.create_dt is '创建日期';
comment on column ${idl_schema}.oass_pty_indv_cust.update_dt is '更新日期';
comment on column ${idl_schema}.oass_pty_indv_cust.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_indv_cust.open_acct_teller_id is '开户柜员编号';
comment on column ${idl_schema}.oass_pty_indv_cust.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.oass_pty_indv_cust.open_acct_dt is '开户日期';
comment on column ${idl_schema}.oass_pty_indv_cust.grad_sch is '毕业学校';
comment on column ${idl_schema}.oass_pty_indv_cust.grad_year is '毕业年份';
comment on column ${idl_schema}.oass_pty_indv_cust.e_mail is '电子邮箱';
comment on column ${idl_schema}.oass_pty_indv_cust.cust_id is '客户编号';
comment on column ${idl_schema}.oass_pty_indv_cust.lp_id is '法人编号';

