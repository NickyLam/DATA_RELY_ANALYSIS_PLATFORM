/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_bill_info
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
alter table ${idl_schema}.oass_agt_bill_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_bill_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_bill_info (
etl_dt  --ETL处理日期
,lp_id  --法人编号
,bill_num  --票据号码
,role_src_cd  --角色来源代码
,discnt_batch_id  --贴现批次编号
,pbc_tranbl_flg  --人行可转让标志
,hxb_acpt_flg  --我行承兑标志
,bill_med_cd  --票据介质代码
,bill_type_cd  --票据类型代码
,draw_dt  --出票日期
,fac_val_exp_dt  --票面到期日期
,drawer_cate_cd  --出票人类别代码
,drawer_orgnz_cd  --出票人组织机构代码
,drawer_name  --出票人名称
,drawer_acct_num  --出票人账号
,drawer_open_bank_num  --出票人开户行号
,accptor_open_bank_name  --承兑人开户行名称
,drawer_open_bank_name  --出票人开户行名称
,accptor_cate_cd  --承兑人类别代码
,accptor_name  --承兑人名称
,accptor_open_bank_num  --承兑人开户行号
,accptor_acct_num  --承兑人账号
,recver_name  --收款人名称
,recver_acct_num  --收款人账号
,recver_open_bank_num  --收款人开户行号
,recver_open_bank_name  --收款人开户行名称
,bill_amt  --贴现票据金额
,bill_belong_org_id  --票据所属机构编号
,bill_status_cd  --票据状态代码
,loss_flg  --挂失标志
,final_modif_operr_id  --最后修改操作员编号
,final_modif_tm  --最后修改时间
,receipt_flg  --小票标志
,redcst_flg  --再贴现标志
,h_data_flg  --历史数据标志
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,vouch_id  --凭证编号
,bill_id  --票据编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num --票据号码
,replace(replace(t1.role_src_cd,chr(13),''),chr(10),'') as role_src_cd --角色来源代码
,replace(replace(t1.discnt_batch_id,chr(13),''),chr(10),'') as discnt_batch_id --贴现批次编号
,replace(replace(t1.pbc_tranbl_flg,chr(13),''),chr(10),'') as pbc_tranbl_flg --人行可转让标志
,replace(replace(t1.hxb_acpt_flg,chr(13),''),chr(10),'') as hxb_acpt_flg --我行承兑标志
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd --票据介质代码
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd --票据类型代码
,t1.draw_dt as draw_dt --出票日期
,t1.fac_val_exp_dt as fac_val_exp_dt --票面到期日期
,replace(replace(t1.drawer_cate_cd,chr(13),''),chr(10),'') as drawer_cate_cd --出票人类别代码
,replace(replace(t1.drawer_orgnz_cd,chr(13),''),chr(10),'') as drawer_orgnz_cd --出票人组织机构代码
,replace(replace(t1.drawer_name,chr(13),''),chr(10),'') as drawer_name --出票人名称
,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'') as drawer_acct_num --出票人账号
,replace(replace(t1.drawer_open_bank_num,chr(13),''),chr(10),'') as drawer_open_bank_num --出票人开户行号
,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'') as accptor_open_bank_name --承兑人开户行名称
,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'') as drawer_open_bank_name --出票人开户行名称
,replace(replace(t1.accptor_cate_cd,chr(13),''),chr(10),'') as accptor_cate_cd --承兑人类别代码
,replace(replace(t1.accptor_name,chr(13),''),chr(10),'') as accptor_name --承兑人名称
,replace(replace(t1.accptor_open_bank_num,chr(13),''),chr(10),'') as accptor_open_bank_num --承兑人开户行号
,replace(replace(t1.accptor_acct_num,chr(13),''),chr(10),'') as accptor_acct_num --承兑人账号
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name --收款人名称
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num --收款人账号
,replace(replace(t1.recver_open_bank_num,chr(13),''),chr(10),'') as recver_open_bank_num --收款人开户行号
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name --收款人开户行名称
,t1.bill_amt as bill_amt --贴现票据金额
,replace(replace(t1.bill_belong_org_id,chr(13),''),chr(10),'') as bill_belong_org_id --票据所属机构编号
,replace(replace(t1.bill_status_cd,chr(13),''),chr(10),'') as bill_status_cd --票据状态代码
,replace(replace(t1.loss_flg,chr(13),''),chr(10),'') as loss_flg --挂失标志
,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'') as final_modif_operr_id --最后修改操作员编号
,t1.final_modif_tm as final_modif_tm --最后修改时间
,replace(replace(t1.receipt_flg,chr(13),''),chr(10),'') as receipt_flg --小票标志
,replace(replace(t1.redcst_flg,chr(13),''),chr(10),'') as redcst_flg --再贴现标志
,replace(replace(t1.h_data_flg,chr(13),''),chr(10),'') as h_data_flg --历史数据标志
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id --凭证编号
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id --票据编号
from ${iml_schema}.agt_bill_info t1    --票据信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_bill_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
