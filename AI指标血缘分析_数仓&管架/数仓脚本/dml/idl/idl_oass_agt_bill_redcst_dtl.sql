/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_bill_redcst_dtl
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
alter table ${idl_schema}.oass_agt_bill_redcst_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_bill_redcst_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_bill_redcst_dtl (
etl_dt  --ETL处理日期
,redcst_dtl_id  --再贴现明细编号
,batch_id  --批次编号
,bill_id  --票据编号
,fac_val_amt  --票面金额
,bill_exp_dt  --票据到期日期
,actl_exp_dt  --实际到期日期
,surp_tenor  --剩余期限
,int_paybl  --应付利息
,stl_amt  --转贴现金额
,exp_stl_amt  --到期结算金额
,lmt_ocup_status_cd  --额度占用状态代码
,proc_status_cd  --处理状态代码
,entry_status_cd  --记账状态代码
,valid_flg  --有效标志
,discount_bill_flg  --转贴现票据标志
,remote_bill_flg  --异地票据标志
,policy_std_flg  --政策标准标志
,refuse_flg  --拒绝标志
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,init_bill_amt  --
,bill_num  --
,bf_split_intrv_id  --
,bill_intrv_std_amt  --
,bill_sub_intrv_id  --
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.redcst_dtl_id,chr(13),''),chr(10),'') as redcst_dtl_id --再贴现明细编号
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id --批次编号
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id --票据编号
,t1.fac_val_amt as fac_val_amt --票面金额
,t1.bill_exp_dt as bill_exp_dt --票据到期日期
,t1.actl_exp_dt as actl_exp_dt --实际到期日期
,t1.surp_tenor as surp_tenor --剩余期限
,t1.int_paybl as int_paybl --应付利息
,t1.stl_amt as stl_amt --转贴现金额
,t1.exp_stl_amt as exp_stl_amt --到期结算金额
,replace(replace(t1.lmt_ocup_status_cd,chr(13),''),chr(10),'') as lmt_ocup_status_cd --额度占用状态代码
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd --处理状态代码
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd --记账状态代码
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg --有效标志
,replace(replace(t1.discount_bill_flg,chr(13),''),chr(10),'') as discount_bill_flg --转贴现票据标志
,replace(replace(t1.remote_bill_flg,chr(13),''),chr(10),'') as remote_bill_flg --异地票据标志
,replace(replace(t1.policy_std_flg,chr(13),''),chr(10),'') as policy_std_flg --政策标准标志
,replace(replace(t1.refuse_flg,chr(13),''),chr(10),'') as refuse_flg --拒绝标志
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,t1.init_bill_amt as init_bill_amt --
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num --
,replace(replace(t1.bf_split_intrv_id,chr(13),''),chr(10),'') as bf_split_intrv_id --
,t1.bill_intrv_std_amt as bill_intrv_std_amt --
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id --
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_bill_redcst_dtl t1    --票据再贴现明细
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_bill_redcst_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
