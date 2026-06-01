/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_lmt_seg_h
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
alter table ${idl_schema}.oass_agt_loan_lmt_seg_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_lmt_seg_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_lmt_seg_h (
etl_dt  --数据日期
,obj_type_name  --对象类型名称
,obj_id  --对象编号
,up_level_seg_lmt_id  --上层切分额度编号
,seg_obj_type_cd  --切分对象类型代码
,seg_obj_id  --切分对象编号
,circl_flg  --循环标志
,curr_cd  --币种代码
,nmal_amt  --名义金额
,open_amt  --敞口金额
,used_nmal_amt  --已用名义金额
,used_open_amt  --已用敞口金额
,aval_nmal_amt  --可用名义金额
,aval_open_amt  --可用敞口金额
,higt_sig_amt  --最高单笔金额
,lowt_margin_ratio  --最低保证金比例
,lowt_int_rat  --最低利率
,other_request_descb  --其他要求描述
,status_cd  --状态代码
,rgst_teller_id  --登记柜员编号
,rgst_org_id  --登记机构编号
,rgst_dt  --登记日期
,guar_type_cd  --担保类型代码
,exlus_lmt_flg  --专属额度标志
,chn_id  --渠道编号
,init_obj_type_name  --原对象类型名称
,init_obj_id  --原对象编号
,lmt_belong_cust_id  --额度所属客户编号
,comn_risk_open_lmt  --一般风险敞口限额
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,seg_lmt_id  --切分额度编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.obj_type_name,chr(13),''),chr(10),'') as obj_type_name --对象类型名称
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id --对象编号
,replace(replace(t1.up_level_seg_lmt_id,chr(13),''),chr(10),'') as up_level_seg_lmt_id --上层切分额度编号
,replace(replace(t1.seg_obj_type_cd,chr(13),''),chr(10),'') as seg_obj_type_cd --切分对象类型代码
,replace(replace(t1.seg_obj_id,chr(13),''),chr(10),'') as seg_obj_id --切分对象编号
,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg --循环标志
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.nmal_amt as nmal_amt --名义金额
,t1.open_amt as open_amt --敞口金额
,t1.used_nmal_amt as used_nmal_amt --已用名义金额
,t1.used_open_amt as used_open_amt --已用敞口金额
,t1.aval_nmal_amt as aval_nmal_amt --可用名义金额
,t1.aval_open_amt as aval_open_amt --可用敞口金额
,t1.higt_sig_amt as higt_sig_amt --最高单笔金额
,t1.lowt_margin_ratio as lowt_margin_ratio --最低保证金比例
,t1.lowt_int_rat as lowt_int_rat --最低利率
,replace(replace(t1.other_request_descb,chr(13),''),chr(10),'') as other_request_descb --其他要求描述
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd --状态代码
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id --登记柜员编号
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,t1.rgst_dt as rgst_dt --登记日期
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd --担保类型代码
,replace(replace(t1.exlus_lmt_flg,chr(13),''),chr(10),'') as exlus_lmt_flg --专属额度标志
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id --渠道编号
,replace(replace(t1.init_obj_type_name,chr(13),''),chr(10),'') as init_obj_type_name --原对象类型名称
,replace(replace(t1.init_obj_id,chr(13),''),chr(10),'') as init_obj_id --原对象编号
,replace(replace(t1.lmt_belong_cust_id,chr(13),''),chr(10),'') as lmt_belong_cust_id --额度所属客户编号
,t1.comn_risk_open_lmt as comn_risk_open_lmt --一般风险敞口限额
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.seg_lmt_id,chr(13),''),chr(10),'') as seg_lmt_id --切分额度编号
from ${iml_schema}.agt_loan_lmt_seg_h t1    --贷款额度切分历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_lmt_seg_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
