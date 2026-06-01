/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_evt_onl_bank_tran_flow
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
alter table ${idl_schema}.oass_evt_onl_bank_tran_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_evt_onl_bank_tran_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_evt_onl_bank_tran_flow (
etl_dt  --数据日期
,evt_id  --事件编号
,lp_id  --法人编号
,flow_num  --流水号
,tran_dt  --交易日期
,tran_tm  --交易时间
,tran_code  --交易码
,onl_bank_tran_status_cd  --网上银行交易状态代码
,tran_return_code  --交易返回码
,fail_rs  --失败原因
,tran_acct_num  --交易账号
,tran_amt  --交易金额
,curr_cd  --币种代码
,whole_unify_cust_id  --全行统一客户编号
,tran_chn_cd  --交易渠道代码
,chn_send_flow_num  --渠道发送流水号
,sorc_sys_flow_num  --源系统流水号
,core_tran_flow_num  --核心交易流水号
,comm_fee  --手续费
,visit_flow_num  --访问流水号
,core_tran_dt  --核心交易日期
,cust_ip_num  --客户ip号
,curr_server_host_name  --当前服务器主机名
,cust_termn_mac_addr  --客户终端mac地址
,cust_termn_oper_sys_edit_num  --客户终端操作系统版本号
,cust_termn_brow  --客户终端浏览器
,cust_termn_equip_model  --客户终端设备型号
,cust_termn_equip_id  --客户终端设备编号
,logon_session_id  --登陆session编号
,rela_flow_num  --关联流水号
,tran_jnl_info  --交易日志信息
,tran_type_code  --交易类型码
,cust_name  --客户名称
,save_cert_way_cd  --安全认证方式代码
,splt_flow_num  --拆笔流水号
,camp_job_no  --营销工号
,pbc_flow_num  --人行流水号
,user_seq_id  --用户顺序编号
,tran_order_no  --交易订单号
,chain_way_track_no  --链路跟踪号
,sys_flow_num  --系统流水号
,chn_id  --渠道编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id --事件编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num --流水号
,replace(replace(t1.tran_dt,chr(13),''),chr(10),'') as tran_dt --交易日期
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm --交易时间
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code --交易码
,replace(replace(t1.onl_bank_tran_status_cd,chr(13),''),chr(10),'') as onl_bank_tran_status_cd --网上银行交易状态代码
,replace(replace(t1.tran_return_code,chr(13),''),chr(10),'') as tran_return_code --交易返回码
,replace(replace(t1.fail_rs,chr(13),''),chr(10),'') as fail_rs --失败原因
,replace(replace(t1.tran_acct_num,chr(13),''),chr(10),'') as tran_acct_num --交易账号
,t1.tran_amt as tran_amt --交易金额
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.whole_unify_cust_id,chr(13),''),chr(10),'') as whole_unify_cust_id --全行统一客户编号
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd --交易渠道代码
,replace(replace(t1.chn_send_flow_num,chr(13),''),chr(10),'') as chn_send_flow_num --渠道发送流水号
,replace(replace(t1.sorc_sys_flow_num,chr(13),''),chr(10),'') as sorc_sys_flow_num --源系统流水号
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num --核心交易流水号
,t1.comm_fee as comm_fee --手续费
,replace(replace(t1.visit_flow_num,chr(13),''),chr(10),'') as visit_flow_num --访问流水号
,t1.core_tran_dt as core_tran_dt --核心交易日期
,replace(replace(t1.cust_ip_num,chr(13),''),chr(10),'') as cust_ip_num --客户ip号
,replace(replace(t1.curr_server_host_name,chr(13),''),chr(10),'') as curr_server_host_name --当前服务器主机名
,replace(replace(t1.cust_termn_mac_addr,chr(13),''),chr(10),'') as cust_termn_mac_addr --客户终端mac地址
,replace(replace(t1.cust_termn_oper_sys_edit_num,chr(13),''),chr(10),'') as cust_termn_oper_sys_edit_num --客户终端操作系统版本号
,replace(replace(t1.cust_termn_brow,chr(13),''),chr(10),'') as cust_termn_brow --客户终端浏览器
,replace(replace(t1.cust_termn_equip_model,chr(13),''),chr(10),'') as cust_termn_equip_model --客户终端设备型号
,replace(replace(t1.cust_termn_equip_id,chr(13),''),chr(10),'') as cust_termn_equip_id --客户终端设备编号
,replace(replace(t1.logon_session_id,chr(13),''),chr(10),'') as logon_session_id --登陆session编号
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num --关联流水号
,replace(replace(t1.tran_jnl_info,chr(13),''),chr(10),'') as tran_jnl_info --交易日志信息
,replace(replace(t1.tran_type_code,chr(13),''),chr(10),'') as tran_type_code --交易类型码
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.save_cert_way_cd,chr(13),''),chr(10),'') as save_cert_way_cd --安全认证方式代码
,replace(replace(t1.splt_flow_num,chr(13),''),chr(10),'') as splt_flow_num --拆笔流水号
,replace(replace(t1.camp_job_no,chr(13),''),chr(10),'') as camp_job_no --营销工号
,replace(replace(t1.pbc_flow_num,chr(13),''),chr(10),'') as pbc_flow_num --人行流水号
,replace(replace(t1.user_seq_id,chr(13),''),chr(10),'') as user_seq_id --用户顺序编号
,replace(replace(t1.tran_order_no,chr(13),''),chr(10),'') as tran_order_no --交易订单号
,replace(replace(t1.chain_way_track_no,chr(13),''),chr(10),'') as chain_way_track_no --链路跟踪号
,replace(replace(t1.sys_flow_num,chr(13),''),chr(10),'') as sys_flow_num --系统流水号
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id --渠道编号
from ${iml_schema}.evt_onl_bank_tran_flow t1    --网上银行交易流水
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_evt_onl_bank_tran_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
