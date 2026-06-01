/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_bill_bus_stl_info
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
alter table ${idl_schema}.oass_agt_bill_bus_stl_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_bill_bus_stl_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_bill_bus_stl_info (
etl_dt  --数据日期
,mem_org_cd  --会员机构代码
,stl_req_id  --结算请求编号
,stl_tm  --结算时间
,bus_type_cd  --业务类型代码
,stl_way_cd  --结算方式代码
,stl_bus_type_cd  --结算业务类型代码
,clear_type_cd  --清算类型代码
,bag_dir_cd  --成交方向代码
,stl_amt  --转贴现金额
,int_paybl  --应付利息
,bill_cnt  --票据张数
,ctr_nt_id  --成交单编号
,lg_pay_sys_msg_ind_no  --大额支付系统报文标识号
,bill_num  --票据号码
,recver_org_cd  --收款方机构代码
,recver_trust_acct_num  --收款方托管账号
,recver_trust_acct_name  --收款方托管账户名称
,recver_cap_acct_num  --收款方资金账号
,recver_cap_acct_name  --收款方资金账户名称
,payer_org_cd  --付款方机构代码
,payer_trust_acct_num  --付款方托管账号
,payer_trust_acct_name  --付款方托管账户名称
,payer_cap_acct_num  --付款方资金账号
,payer_cap_acct_name  --付款方资金账户名称
,stl_status_cd  --结算状态代码
,stl_rest_code  --结算结果编码
,stl_fail_rs  --结算失败原因
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,bill_sub_intrv_id  --
,bus_stl_id  --业务结算编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.mem_org_cd,chr(13),''),chr(10),'') as mem_org_cd --会员机构代码
,replace(replace(t1.stl_req_id,chr(13),''),chr(10),'') as stl_req_id --结算请求编号
,t1.stl_tm as stl_tm --结算时间
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd --业务类型代码
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd --结算方式代码
,replace(replace(t1.stl_bus_type_cd,chr(13),''),chr(10),'') as stl_bus_type_cd --结算业务类型代码
,replace(replace(t1.clear_type_cd,chr(13),''),chr(10),'') as clear_type_cd --清算类型代码
,replace(replace(t1.bag_dir_cd,chr(13),''),chr(10),'') as bag_dir_cd --成交方向代码
,t1.stl_amt as stl_amt --转贴现金额
,t1.int_paybl as int_paybl --应付利息
,t1.bill_cnt as bill_cnt --票据张数
,replace(replace(t1.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id --成交单编号
,replace(replace(t1.lg_pay_sys_msg_ind_no,chr(13),''),chr(10),'') as lg_pay_sys_msg_ind_no --大额支付系统报文标识号
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num --票据号码
,replace(replace(t1.recver_org_cd,chr(13),''),chr(10),'') as recver_org_cd --收款方机构代码
,replace(replace(t1.recver_trust_acct_num,chr(13),''),chr(10),'') as recver_trust_acct_num --收款方托管账号
,replace(replace(t1.recver_trust_acct_name,chr(13),''),chr(10),'') as recver_trust_acct_name --收款方托管账户名称
,replace(replace(t1.recver_cap_acct_num,chr(13),''),chr(10),'') as recver_cap_acct_num --收款方资金账号
,replace(replace(t1.recver_cap_acct_name,chr(13),''),chr(10),'') as recver_cap_acct_name --收款方资金账户名称
,replace(replace(t1.payer_org_cd,chr(13),''),chr(10),'') as payer_org_cd --付款方机构代码
,replace(replace(t1.payer_trust_acct_num,chr(13),''),chr(10),'') as payer_trust_acct_num --付款方托管账号
,replace(replace(t1.payer_trust_acct_name,chr(13),''),chr(10),'') as payer_trust_acct_name --付款方托管账户名称
,replace(replace(t1.payer_cap_acct_num,chr(13),''),chr(10),'') as payer_cap_acct_num --付款方资金账号
,replace(replace(t1.payer_cap_acct_name,chr(13),''),chr(10),'') as payer_cap_acct_name --付款方资金账户名称
,replace(replace(t1.stl_status_cd,chr(13),''),chr(10),'') as stl_status_cd --结算状态代码
,replace(replace(t1.stl_rest_code,chr(13),''),chr(10),'') as stl_rest_code --结算结果编码
,replace(replace(t1.stl_fail_rs,chr(13),''),chr(10),'') as stl_fail_rs --结算失败原因
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id --
,replace(replace(t1.bus_stl_id,chr(13),''),chr(10),'') as bus_stl_id --业务结算编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_bill_bus_stl_info t1    --票据业务结算信息
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_bill_bus_stl_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
