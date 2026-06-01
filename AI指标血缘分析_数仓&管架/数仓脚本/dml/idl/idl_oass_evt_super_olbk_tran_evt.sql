/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_evt_super_olbk_tran_evt
CreateDate: 20230118
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_evt_super_olbk_tran_evt drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_evt_super_olbk_tran_evt add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_evt_super_olbk_tran_evt (
etl_dt  --数据日期
,evt_id  --事件编号
,lp_id  --法人编号
,evt_dt  --事件日期
,front_flow_num  --前置机流水号
,host_tran_code  --主机交易码
,front_tran_code  --前置交易码
,pbc_tran_code  --人行交易编码
,bank_int_bus_seq_num  --行内业务序号
,bus_seq_num  --业务序号
,num_site  --场次
,comm_fee  --手续费
,postage  --邮电费
,trdpty_org_comm_fee_amt  --第三方机构手续费金额
,stl_amt  --结算金额
,tran_amt  --交易金额
,curr_cd  --币种代码
,host_rest_cd  --主机结果代码
,pbc_bus_status_cd  --人行业务状态代码
,refuse_rs_cd  --拒绝原因代码
,pbc_bus_type_cd  --人行业务类型代码
,pbc_bus_kind_cd  --人行业务种类代码
,host_check_entry_status_cd  --与主机对账状态代码
,pbc_check_entry_status_cd  --与人行对账状态代码
,host_flow_num  --主机流水号
,sumos_id  --传票编号
,tran_brac_id  --交易网点编号
,operr_id  --操作员编号
,brac_print_flg  --网点打印标志
,temp_print_flg  --临时打印标志
,print_cnt  --打印次数
,subj_id  --科目编号
,fac_val_recd_dt  --票面记载日期
,present_wdraw_dt  --提出提回日期
,entry_dt  --记账日期
,send_bank_dt  --送银行日期
,pbc_proc_dt  --人行处理日期
,bank_int_sys_proc_tm  --行内系统受理时间
,bus_init_tm  --业务发起时间
,submit_prior_level  --提交优先级
,present_wdraw_flg  --提出提回标志
,realtm_onl_flg  --实时联机标志
,charge_flg  --收费标志
,debit_crdt_cd  --借贷代码
,recv_bank_no  --收款行行号
,recv_bank_name  --收款行行名称
,recver_acct_num  --收款人账号
,recver_name  --收款人姓名
,recver_acct_type  --收款人账户类型
,pay_bank_no  --付款行行号
,pay_bank_name  --付款行行名称
,payer_acct_num  --付款人账号
,payer_name  --付款人姓名
,payer_acct_type_cd  --付款人账户类型代码
,send_msg_bank_no  --发报行行号
,recv_msg_bank_no  --收报行行号
,tran_status_cd  --交易状态代码
,tran_status_rest_cd  --交易状态结果代码
,chn_cd  --渠道代码
,refuse_bus_org_bank_no  --拒绝业务机构行号
,pay_clear_bk_no  --付款清算行行号
,recvbl_clear_bk_no  --收款清算行行号
,payer_open_bank_no  --付款人开户行行号
,recver_open_bank_no  --收款人开户行行号
,payer_bank_belong_city_cd  --付款人开户行所属城市代码
,recver_bank_belong_city_cd  --收款人开户行所属城市代码
,web_tran_odd_no  --网上交易单号
,cert_way_cd  --认证方式代码
,cert_info  --认证信息
,pre_auth_id  --预授权编号
,mercht_id  --商户编号
,mercht_name  --商户名称
,coll_comm_fee_org_id  --收取手续费机构编号
,web_tran_tm  --网上交易时间
,open_acct_brac_id  --开户网点编号
,check_entry_dt  --对账日期
,check_entry_proc_flg  --对账处理标志
,tran_index_num  --交易索引号
,e_acct_cd  --电子账户代码
,e_acct_entry_req_flow_num  --电子账户记账请求流水号
,next_day_arrive_flg  --次日达标志
,supv_acct  --监管账户
,supv_acct_num  --监管账号
,supv_acct_num_acct_name  --监管账号户名称
,supv_acct_num_open_org_id  --监管账号开户机构编号
,acct_type_cd  --账户类型代码
,sign_type_cd  --签约类型代码
,refund_flg  --退款标志
,init_msg_idf_id  --原报文标识编号
,init_prtcpt_org_bank_no  --发起参与机构行号
,acct_ety_code  --会计分录编码
,acct_cate_cd  --账户类别代码
,resv_bd_flg  --预绑标志
,cust_id  --客户编号
,st_msg_check_ser_num  --短信验证序列号
,mobile_no  --手机号码
,cert_no  --证件号码
,super_olbk_entry_rela_seq_num  --超级网银记账流水关联序号
,lmt_order_no  --限额订单号
,bind_flg  --绑定标志
,ova_flow_num  --全局流水号
,esb_intfc_return_code  --esb接口返回码
,esb_intfc_return_info  --esb接口返回信息
,esb_intfc_tran_flow_num  --esb接口交易流水号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id --事件编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,t1.evt_dt as evt_dt --事件日期
,replace(replace(t1.front_flow_num,chr(13),''),chr(10),'') as front_flow_num --前置机流水号
,replace(replace(t1.host_tran_code,chr(13),''),chr(10),'') as host_tran_code --主机交易码
,replace(replace(t1.front_tran_code,chr(13),''),chr(10),'') as front_tran_code --前置交易码
,replace(replace(t1.pbc_tran_code,chr(13),''),chr(10),'') as pbc_tran_code --人行交易编码
,replace(replace(t1.bank_int_bus_seq_num,chr(13),''),chr(10),'') as bank_int_bus_seq_num --行内业务序号
,replace(replace(t1.bus_seq_num,chr(13),''),chr(10),'') as bus_seq_num --业务序号
,t1.num_site as num_site --场次
,t1.comm_fee as comm_fee --手续费
,t1.postage as postage --邮电费
,t1.trdpty_org_comm_fee_amt as trdpty_org_comm_fee_amt --第三方机构手续费金额
,t1.stl_amt as stl_amt --结算金额
,t1.tran_amt as tran_amt --交易金额
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.host_rest_cd,chr(13),''),chr(10),'') as host_rest_cd --主机结果代码
,replace(replace(t1.pbc_bus_status_cd,chr(13),''),chr(10),'') as pbc_bus_status_cd --人行业务状态代码
,replace(replace(t1.refuse_rs_cd,chr(13),''),chr(10),'') as refuse_rs_cd --拒绝原因代码
,replace(replace(t1.pbc_bus_type_cd,chr(13),''),chr(10),'') as pbc_bus_type_cd --人行业务类型代码
,replace(replace(t1.pbc_bus_kind_cd,chr(13),''),chr(10),'') as pbc_bus_kind_cd --人行业务种类代码
,replace(replace(t1.host_check_entry_status_cd,chr(13),''),chr(10),'') as host_check_entry_status_cd --与主机对账状态代码
,replace(replace(t1.pbc_check_entry_status_cd,chr(13),''),chr(10),'') as pbc_check_entry_status_cd --与人行对账状态代码
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num --主机流水号
,replace(replace(t1.sumos_id,chr(13),''),chr(10),'') as sumos_id --传票编号
,replace(replace(t1.tran_brac_id,chr(13),''),chr(10),'') as tran_brac_id --交易网点编号
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id --操作员编号
,replace(replace(t1.brac_print_flg,chr(13),''),chr(10),'') as brac_print_flg --网点打印标志
,replace(replace(t1.temp_print_flg,chr(13),''),chr(10),'') as temp_print_flg --临时打印标志
,t1.print_cnt as print_cnt --打印次数
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id --科目编号
,t1.fac_val_recd_dt as fac_val_recd_dt --票面记载日期
,t1.present_wdraw_dt as present_wdraw_dt --提出提回日期
,t1.entry_dt as entry_dt --记账日期
,t1.send_bank_dt as send_bank_dt --送银行日期
,t1.pbc_proc_dt as pbc_proc_dt --人行处理日期
,t1.bank_int_sys_proc_tm as bank_int_sys_proc_tm --行内系统受理时间
,t1.bus_init_tm as bus_init_tm --业务发起时间
,replace(replace(t1.submit_prior_level,chr(13),''),chr(10),'') as submit_prior_level --提交优先级
,replace(replace(t1.present_wdraw_flg,chr(13),''),chr(10),'') as present_wdraw_flg --提出提回标志
,replace(replace(t1.realtm_onl_flg,chr(13),''),chr(10),'') as realtm_onl_flg --实时联机标志
,replace(replace(t1.charge_flg,chr(13),''),chr(10),'') as charge_flg --收费标志
,replace(replace(t1.debit_crdt_cd,chr(13),''),chr(10),'') as debit_crdt_cd --借贷代码
,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no --收款行行号
,replace(replace(t1.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name --收款行行名称
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num --收款人账号
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name --收款人姓名
,replace(replace(t1.recver_acct_type,chr(13),''),chr(10),'') as recver_acct_type --收款人账户类型
,replace(replace(t1.pay_bank_no,chr(13),''),chr(10),'') as pay_bank_no --付款行行号
,replace(replace(t1.pay_bank_name,chr(13),''),chr(10),'') as pay_bank_name --付款行行名称
,replace(replace(t1.payer_acct_num,chr(13),''),chr(10),'') as payer_acct_num --付款人账号
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name --付款人姓名
,replace(replace(t1.payer_acct_type_cd,chr(13),''),chr(10),'') as payer_acct_type_cd --付款人账户类型代码
,replace(replace(t1.send_msg_bank_no,chr(13),''),chr(10),'') as send_msg_bank_no --发报行行号
,replace(replace(t1.recv_msg_bank_no,chr(13),''),chr(10),'') as recv_msg_bank_no --收报行行号
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd --交易状态代码
,replace(replace(t1.tran_status_rest_cd,chr(13),''),chr(10),'') as tran_status_rest_cd --交易状态结果代码
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd --渠道代码
,replace(replace(t1.refuse_bus_org_bank_no,chr(13),''),chr(10),'') as refuse_bus_org_bank_no --拒绝业务机构行号
,replace(replace(t1.pay_clear_bk_no,chr(13),''),chr(10),'') as pay_clear_bk_no --付款清算行行号
,replace(replace(t1.recvbl_clear_bk_no,chr(13),''),chr(10),'') as recvbl_clear_bk_no --收款清算行行号
,replace(replace(t1.payer_open_bank_no,chr(13),''),chr(10),'') as payer_open_bank_no --付款人开户行行号
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no --收款人开户行行号
,replace(replace(t1.payer_bank_belong_city_cd,chr(13),''),chr(10),'') as payer_bank_belong_city_cd --付款人开户行所属城市代码
,replace(replace(t1.recver_bank_belong_city_cd,chr(13),''),chr(10),'') as recver_bank_belong_city_cd --收款人开户行所属城市代码
,replace(replace(t1.web_tran_odd_no,chr(13),''),chr(10),'') as web_tran_odd_no --网上交易单号
,replace(replace(t1.cert_way_cd,chr(13),''),chr(10),'') as cert_way_cd --认证方式代码
,replace(replace(t1.cert_info,chr(13),''),chr(10),'') as cert_info --认证信息
,replace(replace(t1.pre_auth_id,chr(13),''),chr(10),'') as pre_auth_id --预授权编号
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id --商户编号
,replace(replace(t1.mercht_name,chr(13),''),chr(10),'') as mercht_name --商户名称
,replace(replace(t1.coll_comm_fee_org_id,chr(13),''),chr(10),'') as coll_comm_fee_org_id --收取手续费机构编号
,t1.web_tran_tm as web_tran_tm --网上交易时间
,replace(replace(t1.open_acct_brac_id,chr(13),''),chr(10),'') as open_acct_brac_id --开户网点编号
,t1.check_entry_dt as check_entry_dt --对账日期
,replace(replace(t1.check_entry_proc_flg,chr(13),''),chr(10),'') as check_entry_proc_flg --对账处理标志
,replace(replace(t1.tran_index_num,chr(13),''),chr(10),'') as tran_index_num --交易索引号
,replace(replace(t1.e_acct_cd,chr(13),''),chr(10),'') as e_acct_cd --电子账户代码
,replace(replace(t1.e_acct_entry_req_flow_num,chr(13),''),chr(10),'') as e_acct_entry_req_flow_num --电子账户记账请求流水号
,replace(replace(t1.next_day_arrive_flg,chr(13),''),chr(10),'') as next_day_arrive_flg --次日达标志
,replace(replace(t1.supv_acct,chr(13),''),chr(10),'') as supv_acct --监管账户
,replace(replace(t1.supv_acct_num,chr(13),''),chr(10),'') as supv_acct_num --监管账号
,replace(replace(t1.supv_acct_num_acct_name,chr(13),''),chr(10),'') as supv_acct_num_acct_name --监管账号户名称
,replace(replace(t1.supv_acct_num_open_org_id,chr(13),''),chr(10),'') as supv_acct_num_open_org_id --监管账号开户机构编号
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd --账户类型代码
,replace(replace(t1.sign_type_cd,chr(13),''),chr(10),'') as sign_type_cd --签约类型代码
,replace(replace(t1.refund_flg,chr(13),''),chr(10),'') as refund_flg --退款标志
,replace(replace(t1.init_msg_idf_id,chr(13),''),chr(10),'') as init_msg_idf_id --原报文标识编号
,replace(replace(t1.init_prtcpt_org_bank_no,chr(13),''),chr(10),'') as init_prtcpt_org_bank_no --发起参与机构行号
,replace(replace(t1.acct_ety_code,chr(13),''),chr(10),'') as acct_ety_code --会计分录编码
,replace(replace(t1.acct_cate_cd,chr(13),''),chr(10),'') as acct_cate_cd --账户类别代码
,replace(replace(t1.resv_bd_flg,chr(13),''),chr(10),'') as resv_bd_flg --预绑标志
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.st_msg_check_ser_num,chr(13),''),chr(10),'') as st_msg_check_ser_num --短信验证序列号
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no --手机号码
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no --证件号码
,replace(replace(t1.super_olbk_entry_rela_seq_num,chr(13),''),chr(10),'') as super_olbk_entry_rela_seq_num --超级网银记账流水关联序号
,replace(replace(t1.lmt_order_no,chr(13),''),chr(10),'') as lmt_order_no --限额订单号
,replace(replace(t1.bind_flg,chr(13),''),chr(10),'') as bind_flg --绑定标志
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num --全局流水号
,replace(replace(t1.esb_intfc_return_code,chr(13),''),chr(10),'') as esb_intfc_return_code --esb接口返回码
,replace(replace(t1.esb_intfc_return_info,chr(13),''),chr(10),'') as esb_intfc_return_info --esb接口返回信息
,replace(replace(t1.esb_intfc_tran_flow_num,chr(13),''),chr(10),'') as esb_intfc_tran_flow_num --esb接口交易流水号
from ${iml_schema}.evt_super_olbk_tran_evt t1    --超级网银交易事件
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_evt_super_olbk_tran_evt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
