/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_dep_acct_lmt_info_h
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
alter table ${idl_schema}.oass_agt_dep_acct_lmt_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_dep_acct_lmt_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_dep_acct_lmt_info_h (
etl_dt  --数据日期
,acct_id  --账户编号
,tran_lmt_type_cd  --交易限制类型代码
,lmt_id  --限制编号
,tran_dt  --交易日期
,tran_tm  --交易时间
,ova_flow_num  --全局流水号
,cust_id  --客户编号
,effect_dt  --生效日期
,dep_tenor  --存款期限
,tenor_type_cd  --期限类型代码
,invalid_dt  --失效日期
,acct_check_dt  --账户复核日期
,can_deduct_amt  --可扣划金额
,acct_lmt_amt  --账户限制金额
,wait_to_froz_seq_num  --轮候冻结序号
,tran_org_id  --交易机构编号
,vouch_type_cd  --凭证类型代码
,cust_name  --客户名称
,stl_flow_id  --结算流水编号
,tran_ref_no  --交易参考号
,tran_cd  --交易码
,stop_amt  --截止金额
,aldy_paid_amt  --已还金额
,begin_amt  --起始金额
,pay_amt  --支付金额
,tran_amt  --交易金额
,acct_aldy_check_flg  --账户已复核标志
,interp_flg  --中断标志
,enforc_ps_1_cert_a_type_cd  --执法人1证件A类型代码
,enforc_ps_1_cert_b_type_cd  --执法人1证件B类型代码
,enforc_ps_2_cert_a_type_cd  --执法人2证件A类型代码
,enforc_ps_2_cert_b_type_cd  --执法人2证件B类型代码
,matn_way_cd  --维护方式代码
,cntpty_acct_prod_id  --交易对手账户产品编号
,cntpty_acct_id  --交易对手账户编号
,cntpty_acct_name  --交易对手账户名称
,cntpty_cust_acct_num  --交易对手客户账号
,cntpty_curr_cd  --交易对手币种代码
,cntpty_open_acct_org_id  --交易对手开户机构编号
,mtg_acct_id  --抵押账户编号
,mtg_cust_acct_num  --抵押客户账号
,mtg_acct_curr_cd  --抵押账户币种代码
,mtg_acct_type_cd  --抵押账户类型代码
,auth_org_name  --有权机关名称
,deduct_law_doc_num  --扣划法律文书号码
,termnt_check_id  --终止支票编号
,full_amt_froz_flg  --全额冻结标志
,asit_exec_item  --协助执行事项
,ct_froz_flg  --续冻标志
,enforc_ps_1_cert_a_no  --执法人1证件A号码
,enforc_ps_1_cert_b_no  --执法人1证件B号码
,enforc_ps_2_cert_a_no  --执法人2证件A号码
,enforc_ps_2_cert_b_no  --执法人2证件B号码
,tran_memo_descb  --交易摘要描述
,tot_pay_cnt  --总支付笔数
,aldy_pay_cnt  --已支付笔数
,unfrz_org_name  --解冻机关名称
,unfrz_org_law_doc_num  --解冻机关法律文书号码
,froz_org_name  --冻结机关名称
,froz_org_law_doc_num  --冻结机关法律文书号码
,lmt_acct_range_cd  --限制账户范围代码
,froz_lev  --冻结级别
,acct_lmt_status_cd  --账户限制状态代码
,src_module_type_cd  --源模块类型代码
,begin_check_id  --起始支票编号
,sub_lmt_cate_cd  --子限制类别代码
,pm_flg  --抵质押标志
,check_teller_id  --复核柜员编号
,auth_teller_id  --授权柜员编号
,tran_teller_id  --交易柜员编号
,enforc_ps_1_name  --执法人1名称
,enforc_ps_2_name  --执法人2名称
,operr_1_cert_a_no  --经办人1证件A号码
,operr_1_cert_b_no  --经办人1证件B号码
,operr_1_name  --经办人1名称
,operr_2_cert_a_no  --经办人2证件A号码
,operr_2_cert_b_no  --经办人2证件B号码
,operr_2_cert_a_type_cd  --经办人2证件A类型代码
,operr_2_cert_b_type_cd  --经办人2证件B类型代码
,operr_2_name  --经办人2名称
,operr_1_cert_a_type_cd  --经办人1证件A类型代码
,operr_1_cert_b_type_cd  --经办人1证件B类型代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
,replace(replace(t1.tran_lmt_type_cd,chr(13),''),chr(10),'') as tran_lmt_type_cd --交易限制类型代码
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id --限制编号
,t1.tran_dt as tran_dt --交易日期
,t1.tran_tm as tran_tm --交易时间
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num --全局流水号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,t1.effect_dt as effect_dt --生效日期
,t1.dep_tenor as dep_tenor --存款期限
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd --期限类型代码
,t1.invalid_dt as invalid_dt --失效日期
,t1.acct_check_dt as acct_check_dt --账户复核日期
,t1.can_deduct_amt as can_deduct_amt --可扣划金额
,t1.acct_lmt_amt as acct_lmt_amt --账户限制金额
,replace(replace(t1.wait_to_froz_seq_num,chr(13),''),chr(10),'') as wait_to_froz_seq_num --轮候冻结序号
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id --交易机构编号
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd --凭证类型代码
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.stl_flow_id,chr(13),''),chr(10),'') as stl_flow_id --结算流水编号
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no --交易参考号
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd --交易码
,t1.stop_amt as stop_amt --截止金额
,t1.aldy_paid_amt as aldy_paid_amt --已还金额
,t1.begin_amt as begin_amt --起始金额
,t1.pay_amt as pay_amt --支付金额
,t1.tran_amt as tran_amt --交易金额
,replace(replace(t1.acct_aldy_check_flg,chr(13),''),chr(10),'') as acct_aldy_check_flg --账户已复核标志
,replace(replace(t1.interp_flg,chr(13),''),chr(10),'') as interp_flg --中断标志
,replace(replace(t1.enforc_ps_1_cert_a_type_cd,chr(13),''),chr(10),'') as enforc_ps_1_cert_a_type_cd --执法人1证件A类型代码
,replace(replace(t1.enforc_ps_1_cert_b_type_cd,chr(13),''),chr(10),'') as enforc_ps_1_cert_b_type_cd --执法人1证件B类型代码
,replace(replace(t1.enforc_ps_2_cert_a_type_cd,chr(13),''),chr(10),'') as enforc_ps_2_cert_a_type_cd --执法人2证件A类型代码
,replace(replace(t1.enforc_ps_2_cert_b_type_cd,chr(13),''),chr(10),'') as enforc_ps_2_cert_b_type_cd --执法人2证件B类型代码
,replace(replace(t1.matn_way_cd,chr(13),''),chr(10),'') as matn_way_cd --维护方式代码
,replace(replace(t1.cntpty_acct_prod_id,chr(13),''),chr(10),'') as cntpty_acct_prod_id --交易对手账户产品编号
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id --交易对手账户编号
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name --交易对手账户名称
,replace(replace(t1.cntpty_cust_acct_num,chr(13),''),chr(10),'') as cntpty_cust_acct_num --交易对手客户账号
,replace(replace(t1.cntpty_curr_cd,chr(13),''),chr(10),'') as cntpty_curr_cd --交易对手币种代码
,replace(replace(t1.cntpty_open_acct_org_id,chr(13),''),chr(10),'') as cntpty_open_acct_org_id --交易对手开户机构编号
,replace(replace(t1.mtg_acct_id,chr(13),''),chr(10),'') as mtg_acct_id --抵押账户编号
,replace(replace(t1.mtg_cust_acct_num,chr(13),''),chr(10),'') as mtg_cust_acct_num --抵押客户账号
,replace(replace(t1.mtg_acct_curr_cd,chr(13),''),chr(10),'') as mtg_acct_curr_cd --抵押账户币种代码
,replace(replace(t1.mtg_acct_type_cd,chr(13),''),chr(10),'') as mtg_acct_type_cd --抵押账户类型代码
,replace(replace(t1.auth_org_name,chr(13),''),chr(10),'') as auth_org_name --有权机关名称
,replace(replace(t1.deduct_law_doc_num,chr(13),''),chr(10),'') as deduct_law_doc_num --扣划法律文书号码
,replace(replace(t1.termnt_check_id,chr(13),''),chr(10),'') as termnt_check_id --终止支票编号
,replace(replace(t1.full_amt_froz_flg,chr(13),''),chr(10),'') as full_amt_froz_flg --全额冻结标志
,replace(replace(t1.asit_exec_item,chr(13),''),chr(10),'') as asit_exec_item --协助执行事项
,replace(replace(t1.ct_froz_flg,chr(13),''),chr(10),'') as ct_froz_flg --续冻标志
,replace(replace(t1.enforc_ps_1_cert_a_no,chr(13),''),chr(10),'') as enforc_ps_1_cert_a_no --执法人1证件A号码
,replace(replace(t1.enforc_ps_1_cert_b_no,chr(13),''),chr(10),'') as enforc_ps_1_cert_b_no --执法人1证件B号码
,replace(replace(t1.enforc_ps_2_cert_a_no,chr(13),''),chr(10),'') as enforc_ps_2_cert_a_no --执法人2证件A号码
,replace(replace(t1.enforc_ps_2_cert_b_no,chr(13),''),chr(10),'') as enforc_ps_2_cert_b_no --执法人2证件B号码
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb --交易摘要描述
,t1.tot_pay_cnt as tot_pay_cnt --总支付笔数
,t1.aldy_pay_cnt as aldy_pay_cnt --已支付笔数
,replace(replace(t1.unfrz_org_name,chr(13),''),chr(10),'') as unfrz_org_name --解冻机关名称
,replace(replace(t1.unfrz_org_law_doc_num,chr(13),''),chr(10),'') as unfrz_org_law_doc_num --解冻机关法律文书号码
,replace(replace(t1.froz_org_name,chr(13),''),chr(10),'') as froz_org_name --冻结机关名称
,replace(replace(t1.froz_org_law_doc_num,chr(13),''),chr(10),'') as froz_org_law_doc_num --冻结机关法律文书号码
,replace(replace(t1.lmt_acct_range_cd,chr(13),''),chr(10),'') as lmt_acct_range_cd --限制账户范围代码
,replace(replace(t1.froz_lev,chr(13),''),chr(10),'') as froz_lev --冻结级别
,replace(replace(t1.acct_lmt_status_cd,chr(13),''),chr(10),'') as acct_lmt_status_cd --账户限制状态代码
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd --源模块类型代码
,replace(replace(t1.begin_check_id,chr(13),''),chr(10),'') as begin_check_id --起始支票编号
,replace(replace(t1.sub_lmt_cate_cd,chr(13),''),chr(10),'') as sub_lmt_cate_cd --子限制类别代码
,replace(replace(t1.pm_flg,chr(13),''),chr(10),'') as pm_flg --抵质押标志
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id --复核柜员编号
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id --授权柜员编号
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id --交易柜员编号
,replace(replace(t1.enforc_ps_1_name,chr(13),''),chr(10),'') as enforc_ps_1_name --执法人1名称
,replace(replace(t1.enforc_ps_2_name,chr(13),''),chr(10),'') as enforc_ps_2_name --执法人2名称
,replace(replace(t1.operr_1_cert_a_no,chr(13),''),chr(10),'') as operr_1_cert_a_no --经办人1证件A号码
,replace(replace(t1.operr_1_cert_b_no,chr(13),''),chr(10),'') as operr_1_cert_b_no --经办人1证件B号码
,replace(replace(t1.operr_1_name,chr(13),''),chr(10),'') as operr_1_name --经办人1名称
,replace(replace(t1.operr_2_cert_a_no,chr(13),''),chr(10),'') as operr_2_cert_a_no --经办人2证件A号码
,replace(replace(t1.operr_2_cert_b_no,chr(13),''),chr(10),'') as operr_2_cert_b_no --经办人2证件B号码
,replace(replace(t1.operr_2_cert_a_type_cd,chr(13),''),chr(10),'') as operr_2_cert_a_type_cd --经办人2证件A类型代码
,replace(replace(t1.operr_2_cert_b_type_cd,chr(13),''),chr(10),'') as operr_2_cert_b_type_cd --经办人2证件B类型代码
,replace(replace(t1.operr_2_name,chr(13),''),chr(10),'') as operr_2_name --经办人2名称
,replace(replace(t1.operr_1_cert_a_type_cd,chr(13),''),chr(10),'') as operr_1_cert_a_type_cd --经办人1证件A类型代码
,replace(replace(t1.operr_1_cert_b_type_cd,chr(13),''),chr(10),'') as operr_1_cert_b_type_cd --经办人1证件B类型代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_dep_acct_lmt_info_h t1    --存款账户限制信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_dep_acct_lmt_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
