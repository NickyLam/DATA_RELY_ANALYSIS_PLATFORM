/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_bill_discnt_dtl
CreateDate: 20221108
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_agt_bill_discnt_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_bill_discnt_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_bill_discnt_dtl (
etl_dt  --ETL处理日期
,agt_id  --协议编号
,lp_id  --法人编号
,buy_dtl_id  --买入明细编号
,buy_way_cd  --买入方式代码
,batch_id  --批次编号
,discnt_type_cd  --贴现类型代码
,bill_id  --票据编号
,city_wide_flg  --同城标志
,rher_name  --前手名称
,int_accr_exp_dt  --计息到期日期
,defer_days  --顺延天数
,int_accr_days  --计息天数
,not_ngbl_flg  --不得转让标志
,int_amt  --利息金额
,onl_clear_flg  --线上清算标志
,buyer_pay_int  --买方付息利息
,actl_amt  --贴现金额
,discnt_appl_enter_acct_num  --贴现申请入账账号
,discnt_appl_enter_acct_bk_no  --贴现申请入账行行号
,dscnt_props_cate_cd  --贴出人类别代码
,dscnt_props_name  --贴出人名称
,dscnt_props_orgnz_cd  --贴出人组织机构代码
,dscnt_props_acct_num  --贴出人账号
,dscnt_props_udtake_bk_no  --贴出人承接行行号
,tran_cont_id  --交易合同编号
,entry_dt  --记账日期
,entry_status_cd  --记账状态代码
,recv_dt  --签收日期
,buy_dtl_status_cd  --买入明细状态代码
,final_modif_tm  --最后修改时间
,modif_teller_id  --修改柜员编号
,bill_sub_intrv_id  --票据子区间编号
,quick_discnt_status_cd  --秒贴状态代码
,quick_discnt_flg  --秒贴标志
,bill_src_cd  --票据来源代码
,crdt_out_acct_flow_num  --信贷出账流水号
,h_data_flg  --历史数据标志
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.buy_dtl_id,chr(13),''),chr(10),'') as buy_dtl_id --买入明细编号
,replace(replace(t1.buy_way_cd,chr(13),''),chr(10),'') as buy_way_cd --买入方式代码
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id --批次编号
,replace(replace(t1.discnt_type_cd,chr(13),''),chr(10),'') as discnt_type_cd --贴现类型代码
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id --票据编号
,replace(replace(t1.city_wide_flg,chr(13),''),chr(10),'') as city_wide_flg --同城标志
,replace(replace(t1.rher_name,chr(13),''),chr(10),'') as rher_name --前手名称
,t1.int_accr_exp_dt as int_accr_exp_dt --计息到期日期
,t1.defer_days as defer_days --顺延天数
,t1.int_accr_days as int_accr_days --计息天数
,replace(replace(t1.not_ngbl_flg,chr(13),''),chr(10),'') as not_ngbl_flg --不得转让标志
,t1.int_amt as int_amt --利息金额
,replace(replace(t1.onl_clear_flg,chr(13),''),chr(10),'') as onl_clear_flg --线上清算标志
,t1.buyer_pay_int as buyer_pay_int --买方付息利息
,t1.actl_amt as actl_amt --贴现金额
,replace(replace(t1.discnt_appl_enter_acct_num,chr(13),''),chr(10),'') as discnt_appl_enter_acct_num --贴现申请入账账号
,replace(replace(t1.discnt_appl_enter_acct_bk_no,chr(13),''),chr(10),'') as discnt_appl_enter_acct_bk_no --贴现申请入账行行号
,replace(replace(t1.dscnt_props_cate_cd,chr(13),''),chr(10),'') as dscnt_props_cate_cd --贴出人类别代码
,replace(replace(t1.dscnt_props_name,chr(13),''),chr(10),'') as dscnt_props_name --贴出人名称
,replace(replace(t1.dscnt_props_orgnz_cd,chr(13),''),chr(10),'') as dscnt_props_orgnz_cd --贴出人组织机构代码
,replace(replace(t1.dscnt_props_acct_num,chr(13),''),chr(10),'') as dscnt_props_acct_num --贴出人账号
,replace(replace(t1.dscnt_props_udtake_bk_no,chr(13),''),chr(10),'') as dscnt_props_udtake_bk_no --贴出人承接行行号
,replace(replace(t1.tran_cont_id,chr(13),''),chr(10),'') as tran_cont_id --交易合同编号
,t1.entry_dt as entry_dt --记账日期
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd --记账状态代码
,t1.recv_dt as recv_dt --签收日期
,replace(replace(t1.buy_dtl_status_cd,chr(13),''),chr(10),'') as buy_dtl_status_cd --买入明细状态代码
,t1.final_modif_tm as final_modif_tm --最后修改时间
,replace(replace(t1.modif_teller_id,chr(13),''),chr(10),'') as modif_teller_id --修改柜员编号
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id --票据子区间编号
,replace(replace(t1.quick_discnt_status_cd,chr(13),''),chr(10),'') as quick_discnt_status_cd --秒贴状态代码
,replace(replace(t1.quick_discnt_flg,chr(13),''),chr(10),'') as quick_discnt_flg --秒贴标志
,replace(replace(t1.bill_src_cd,chr(13),''),chr(10),'') as bill_src_cd --票据来源代码
,replace(replace(t1.crdt_out_acct_flow_num,chr(13),''),chr(10),'') as crdt_out_acct_flow_num --信贷出账流水号
,replace(replace(t1.h_data_flg,chr(13),''),chr(10),'') as h_data_flg --历史数据标志
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
from ${iml_schema}.agt_bill_discnt_dtl t1    --票据贴现明细
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_bill_discnt_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
