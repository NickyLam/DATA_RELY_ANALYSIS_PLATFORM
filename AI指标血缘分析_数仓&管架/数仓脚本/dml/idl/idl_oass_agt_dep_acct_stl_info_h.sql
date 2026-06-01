/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_dep_acct_stl_info_h
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
alter table ${idl_schema}.oass_agt_dep_acct_stl_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_dep_acct_stl_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_dep_acct_stl_info_h (
etl_dt  --数据日期
,stl_id  --结算编号
,lp_id  --法人编号
,lmt_id  --限制编号
,evt_cate_id  --事件类别编号
,tran_ref_no  --交易参考号
,stl_acct_cls_cd  --结算账户分类代码
,stl_method_cd  --结算方法代码
,tran_cd  --交易码
,acpt_pay_idf_cd  --收付标识代码
,amt_type_cd  --金额类型代码
,stl_cust_id  --结算客户编号
,out_line_flg  --行外标志
,hxb_stl_flg  --我行结算标志
,recv_bank_no  --收款行行号
,recv_bank_name  --收款行名称
,stl_bk_bank_no  --结算行行号
,stl_acct_id  --结算账户编号
,stl_cust_acct_num  --结算客户账号
,stl_acct_prod_id  --结算账户产品编号
,stl_acct_curr_cd  --结算账户币种代码
,stl_acct_sub_acct_num  --结算账户子账号
,stl_acct_name  --结算账户名称
,stl_acct_bind_mobile_no  --结算账户绑定手机号码
,stl_org_id  --结算机构编号
,auto_lock_flg  --自动锁定标志
,entr_pay_id  --受托支付编号
,stl_wt  --结算权重
,stl_curr_cd  --结算币种代码
,stl_amt  --结算金额
,stl_exch_rat  --结算汇率
,entred_ps_acct_froz_way_cd  --受托人账户冻结方式代码
,sel_sup_flg  --自营标志
,prior_level  --优先等级
,prft_cut_ratio  --分润比例
,exch_way_cd  --汇兑方式代码
,cust_id  --客户编号
,tran_teller_id  --交易柜员编号
,final_modif_dt  --最后修改日期
,final_modif_teller_id  --最后修改柜员编号
,tran_tm  --交易时间
,open_acct_bank_fin_inst_id  --开户银行金融机构编号
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,acct_id  --账户编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.stl_id,chr(13),''),chr(10),'') as stl_id --结算编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id --限制编号
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id --事件类别编号
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no --交易参考号
,replace(replace(t1.stl_acct_cls_cd,chr(13),''),chr(10),'') as stl_acct_cls_cd --结算账户分类代码
,replace(replace(t1.stl_method_cd,chr(13),''),chr(10),'') as stl_method_cd --结算方法代码
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd --交易码
,replace(replace(t1.acpt_pay_idf_cd,chr(13),''),chr(10),'') as acpt_pay_idf_cd --收付标识代码
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd --金额类型代码
,replace(replace(t1.stl_cust_id,chr(13),''),chr(10),'') as stl_cust_id --结算客户编号
,replace(replace(t1.out_line_flg,chr(13),''),chr(10),'') as out_line_flg --行外标志
,replace(replace(t1.hxb_stl_flg,chr(13),''),chr(10),'') as hxb_stl_flg --我行结算标志
,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no --收款行行号
,replace(replace(t1.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name --收款行名称
,replace(replace(t1.stl_bk_bank_no,chr(13),''),chr(10),'') as stl_bk_bank_no --结算行行号
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id --结算账户编号
,replace(replace(t1.stl_cust_acct_num,chr(13),''),chr(10),'') as stl_cust_acct_num --结算客户账号
,replace(replace(t1.stl_acct_prod_id,chr(13),''),chr(10),'') as stl_acct_prod_id --结算账户产品编号
,replace(replace(t1.stl_acct_curr_cd,chr(13),''),chr(10),'') as stl_acct_curr_cd --结算账户币种代码
,replace(replace(t1.stl_acct_sub_acct_num,chr(13),''),chr(10),'') as stl_acct_sub_acct_num --结算账户子账号
,replace(replace(t1.stl_acct_name,chr(13),''),chr(10),'') as stl_acct_name --结算账户名称
,replace(replace(t1.stl_acct_bind_mobile_no,chr(13),''),chr(10),'') as stl_acct_bind_mobile_no --结算账户绑定手机号码
,replace(replace(t1.stl_org_id,chr(13),''),chr(10),'') as stl_org_id --结算机构编号
,replace(replace(t1.auto_lock_flg,chr(13),''),chr(10),'') as auto_lock_flg --自动锁定标志
,replace(replace(t1.entr_pay_id,chr(13),''),chr(10),'') as entr_pay_id --受托支付编号
,t1.stl_wt as stl_wt --结算权重
,replace(replace(t1.stl_curr_cd,chr(13),''),chr(10),'') as stl_curr_cd --结算币种代码
,t1.stl_amt as stl_amt --结算金额
,t1.stl_exch_rat as stl_exch_rat --结算汇率
,replace(replace(t1.entred_ps_acct_froz_way_cd,chr(13),''),chr(10),'') as entred_ps_acct_froz_way_cd --受托人账户冻结方式代码
,replace(replace(t1.sel_sup_flg,chr(13),''),chr(10),'') as sel_sup_flg --自营标志
,replace(replace(t1.prior_level,chr(13),''),chr(10),'') as prior_level --优先等级
,t1.prft_cut_ratio as prft_cut_ratio --分润比例
,replace(replace(t1.exch_way_cd,chr(13),''),chr(10),'') as exch_way_cd --汇兑方式代码
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id --交易柜员编号
,t1.final_modif_dt as final_modif_dt --最后修改日期
,replace(replace(t1.final_modif_teller_id,chr(13),''),chr(10),'') as final_modif_teller_id --最后修改柜员编号
,t1.tran_tm as tran_tm --交易时间
,replace(replace(t1.open_acct_bank_fin_inst_id,chr(13),''),chr(10),'') as open_acct_bank_fin_inst_id --开户银行金融机构编号
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
from ${iml_schema}.agt_dep_acct_stl_info_h t1    --存款账户结算信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_dep_acct_stl_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
