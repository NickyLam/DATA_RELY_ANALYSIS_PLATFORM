/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_cnter_tran_flow_dtl
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_cnter_tran_flow_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,chn_flow_num  -- 渠道流水号
    ,ova_flow_num  -- 全局流水号
    ,tran_dt  -- 交易日期
    ,termn_tran_tm  -- 终端交易时间
    ,tran_cmplt_tm  -- 交易完成时间
    ,tran_id  -- 交易编号
    ,tran_name  -- 交易名称
    ,tran_org_id  -- 交易机构编号
    ,tran_teller_id  -- 交易柜员编号
    ,tran_teller_name  -- 交易柜员名称
    ,tran_status_cd  -- 交易状态代码
    ,auth_flow_num  -- 授权流水号
    ,auth_teller_id  -- 授权柜员编号
    ,cust_id  -- 客户编号
    ,acct_id_1  -- 账户编号1
    ,acct_name_1  -- 账户名称1
    ,card_no_1  -- 卡号1
    ,cust_type_cd_1  -- 客户类型代码1
    ,acct_id_2  -- 账户编号2
    ,acct_name_2  -- 账户名称2
    ,card_no_2  -- 卡号2
    ,cust_type_cd_2  -- 客户类型代码2
    ,tran_curr_cd  -- 交易币种代码
    ,amt  -- 金额
    ,debit_crdt_flg  -- 借贷标志
    ,cash_trans_flg  -- 现转标志
    ,cust_cert_type_cd  -- 客户证件类型代码
    ,cust_cert_no  -- 客户证件号码
    ,cust_netw_vrfction_rest_cd  -- 客户联网核查结果代码
    ,agent_name  -- 代理人姓名
    ,agent_cert_type_cd  -- 代理人证件类型代码
    ,agent_cert_no  -- 代理人证件号码
    ,agent_netw_vrfction_rest_cd  -- 代理人联网核查结果代码
    ,agent_phone  -- 代理人联系电话
    ,agent_reason  -- 代理理由
    ,back_end_sys_id  -- 后台系统编号
    ,back_end_sys_dt  -- 后台系统日期
    ,back_end_sys_flow_num  -- 后台系统流水号
    ,back_end_sys_tran_process_cd  -- 后台系统交易处理码
    ,back_end_sys_tran_return_code  -- 后台系统交易返回码
    ,back_end_sys_tran_return_info  -- 后台系统交易返回信息
    ,manual_bal_chk_status_cd  -- 手工勾对状态代码
    ,manual_bal_chk_tm  -- 手工勾对时间
    ,manual_bal_chk_teller_id  -- 手工勾对柜员编号
    ,remark  -- 备注
    ,usage  -- 用途
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.chn_flow_num,chr(13),''),chr(10),'')  -- 渠道流水号
    ,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'')  -- 全局流水号
    ,t1.tran_dt  -- 交易日期
    ,t1.termn_tran_tm  -- 终端交易时间
    ,t1.tran_cmplt_tm  -- 交易完成时间
    ,replace(replace(t1.tran_id,chr(13),''),chr(10),'')  -- 交易编号
    ,replace(replace(t1.tran_name,chr(13),''),chr(10),'')  -- 交易名称
    ,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'')  -- 交易机构编号
    ,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'')  -- 交易柜员编号
    ,replace(replace(t1.tran_teller_name,chr(13),''),chr(10),'')  -- 交易柜员名称
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易状态代码
    ,replace(replace(t1.auth_flow_num,chr(13),''),chr(10),'')  -- 授权流水号
    ,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'')  -- 授权柜员编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.acct_id_1,chr(13),''),chr(10),'')  -- 账户编号1
    ,replace(replace(t1.acct_name_1,chr(13),''),chr(10),'')  -- 账户名称1
    ,replace(replace(t1.card_no_1,chr(13),''),chr(10),'')  -- 卡号1
    ,replace(replace(t1.cust_type_cd_1,chr(13),''),chr(10),'')  -- 客户类型代码1
    ,replace(replace(t1.acct_id_2,chr(13),''),chr(10),'')  -- 账户编号2
    ,replace(replace(t1.acct_name_2,chr(13),''),chr(10),'')  -- 账户名称2
    ,replace(replace(t1.card_no_2,chr(13),''),chr(10),'')  -- 卡号2
    ,replace(replace(t1.cust_type_cd_2,chr(13),''),chr(10),'')  -- 客户类型代码2
    ,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'')  -- 交易币种代码
    ,t1.amt  -- 金额
    ,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'')  -- 借贷标志
    ,replace(replace(t1.cash_trans_flg,chr(13),''),chr(10),'')  -- 现转标志
    ,replace(replace(t1.cust_cert_type_cd,chr(13),''),chr(10),'')  -- 客户证件类型代码
    ,replace(replace(t1.cust_cert_no,chr(13),''),chr(10),'')  -- 客户证件号码
    ,replace(replace(t1.cust_netw_vrfction_rest_cd,chr(13),''),chr(10),'')  -- 客户联网核查结果代码
    ,replace(replace(t1.agent_name,chr(13),''),chr(10),'')  -- 代理人姓名
    ,replace(replace(t1.agent_cert_type_cd,chr(13),''),chr(10),'')  -- 代理人证件类型代码
    ,replace(replace(t1.agent_cert_no,chr(13),''),chr(10),'')  -- 代理人证件号码
    ,replace(replace(t1.agent_netw_vrfction_rest_cd,chr(13),''),chr(10),'')  -- 代理人联网核查结果代码
    ,replace(replace(t1.agent_phone,chr(13),''),chr(10),'')  -- 代理人联系电话
    ,replace(replace(t1.agent_reason,chr(13),''),chr(10),'')  -- 代理理由
    ,replace(replace(t1.back_end_sys_id,chr(13),''),chr(10),'')  -- 后台系统编号
    ,t1.back_end_sys_dt  -- 后台系统日期
    ,replace(replace(t1.back_end_sys_flow_num,chr(13),''),chr(10),'')  -- 后台系统流水号
    ,replace(replace(t1.back_end_sys_tran_process_cd,chr(13),''),chr(10),'')  -- 后台系统交易处理码
    ,replace(replace(t1.back_end_sys_tran_return_code,chr(13),''),chr(10),'')  -- 后台系统交易返回码
    ,replace(replace(t1.back_end_sys_tran_return_info,chr(13),''),chr(10),'')  -- 后台系统交易返回信息
    ,replace(replace(t1.manual_bal_chk_status_cd,chr(13),''),chr(10),'')  -- 手工勾对状态代码
    ,t1.manual_bal_chk_tm  -- 手工勾对时间
    ,replace(replace(t1.manual_bal_chk_teller_id,chr(13),''),chr(10),'')  -- 手工勾对柜员编号
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.usage,chr(13),''),chr(10),'')  -- 用途
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iml.v_evt_cnter_tran_flow_dtl t1    --柜面交易流水明细
where 1=1 ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_cnter_tran_flow_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);