/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_col_cont_info
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
alter table ${idl_schema}.oass_agt_col_cont_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_col_cont_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_col_cont_info (
etl_dt  --ETL处理日期
,cont_id  --合同编号
,cust_id  --客户编号
,rg_cd  --地区代码
,org_id  --机构编号
,enter_acct_org_id  --入账机构编号
,cust_mgr_id  --客户经理编号
,crdt_breed_id  --授信品种编号
,loan_dir_indus_cd  --贷款投向行业代码
,guar_curr_cd  --担保币种代码
,cont_amt  --合同金额
,cont_bal  --合同余额
,margin_ratio  --保证金比例
,margin_amt  --保证金余额
,effect_dt  --生效日期
,exp_dt  --到期日期
,guar_way_cd  --担保方式代码
,main_guar_way_cd  --主担保方式代码
,setup_dt  --建立日期
,chg_dt  --更改日期
,distrd_amt  --已发放金额
,level5_cls_cd  --五级分类代码
,off_bs_bal  --表外余额
,in_bs_bal  --表内余额
,over_int_amt  --欠息金额
,payoff_status_cd  --结清状态代码
,loan_rating_cd  --贷款评级代码
,reply_id  --批复编号
,strip_line_cd  --条线代码
,crdt_cont_id  --授信合同编号
,crdt_appl_id  --授信申请编号
,paper_cont_id  --纸质合同编号
,data_src_cd  --数据来源代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合同编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd --地区代码
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id --机构编号
,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id --入账机构编号
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.crdt_breed_id,chr(13),''),chr(10),'') as crdt_breed_id --授信品种编号
,replace(replace(t1.loan_dir_indus_cd,chr(13),''),chr(10),'') as loan_dir_indus_cd --贷款投向行业代码
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd --担保币种代码
,t1.cont_amt as cont_amt --合同金额
,t1.cont_bal as cont_bal --合同余额
,t1.margin_ratio as margin_ratio --保证金比例
,t1.margin_amt as margin_amt --保证金余额
,t1.effect_dt as effect_dt --生效日期
,t1.exp_dt as exp_dt --到期日期
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd --担保方式代码
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd --主担保方式代码
,t1.setup_dt as setup_dt --建立日期
,t1.chg_dt as chg_dt --更改日期
,t1.distrd_amt as distrd_amt --已发放金额
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd --五级分类代码
,t1.off_bs_bal as off_bs_bal --表外余额
,t1.in_bs_bal as in_bs_bal --表内余额
,t1.over_int_amt as over_int_amt --欠息金额
,replace(replace(t1.payoff_status_cd,chr(13),''),chr(10),'') as payoff_status_cd --结清状态代码
,replace(replace(t1.loan_rating_cd,chr(13),''),chr(10),'') as loan_rating_cd --贷款评级代码
,replace(replace(t1.reply_id,chr(13),''),chr(10),'') as reply_id --批复编号
,replace(replace(t1.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd --条线代码
,replace(replace(t1.crdt_cont_id,chr(13),''),chr(10),'') as crdt_cont_id --授信合同编号
,replace(replace(t1.crdt_appl_id,chr(13),''),chr(10),'') as crdt_appl_id --授信申请编号
,replace(replace(t1.paper_cont_id,chr(13),''),chr(10),'') as paper_cont_id --纸质合同编号
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd --数据来源代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_col_cont_info t1    --押品合同信息表
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_col_cont_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
