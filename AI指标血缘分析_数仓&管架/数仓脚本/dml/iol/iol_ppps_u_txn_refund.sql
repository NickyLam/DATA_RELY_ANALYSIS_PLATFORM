/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_u_txn_refund
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_u_txn_refund_ex purge;
alter table ${iol_schema}.ppps_u_txn_refund add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
-- 2.2.1 get new data into table
set serveroutput on
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''ppps_u_txn_refund'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.ppps_u_txn_refund truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.ppps_u_txn_refund add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.ppps_u_txn_refund_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_u_txn_refund where 0=1;

insert /*+ append */ into ${iol_schema}.ppps_u_txn_refund(
    sys_id -- 系统流水
    ,sys_date -- 系统日期
    ,trx_id -- 退款流水号
    ,trx_dt_tm -- 交易日期时间
    ,settlmt_dt -- 清算日期
    ,trxtyp -- 交易类型编码
    ,trx_curry -- 退款币种
    ,trx_amt -- 交易金额
    ,trx_amt_d -- 退款金额
    ,acct_in_tp -- 账户输入方式
    ,trx_trm_tp -- 交易终端类型
    ,trx_trm_no -- 交易终端编码
    ,r_p_flg -- 收／付标识
    ,pyee_acct_issr_id -- 收款方账户所属机构标识
    ,pyee_acct_id -- 收款方账户编号
    ,pyee_acct_tp -- 收款方账户类型
    ,pyee_issr_id -- 发送机构标识
    ,pyer_acct_issr_id -- 付款方账户所属机构标识
    ,resfd_acct_issr_id -- 备付金银行机构标识
    ,instg_acct_id -- 备付金银行账号
    ,instg_acct_nm -- 备付金银行账户名称
    ,channel_issr_id -- 渠道方机构标识
    ,sgn_no -- 签约协议号
    ,mrchnt_no -- 商户编号
    ,mrchnt_tp_id -- 商户类别
    ,mrchnt_pltfrm_nm -- 商户名称
    ,sub_mrchnt_no -- 二级商户编码
    ,sub_mrchnt_tp_id -- 二级商户类别
    ,sub_mrchnt_pltfrm_nm -- 二级商户名称
    ,ori_trx_id -- 原交易流水号
    ,ori_trx_amt -- 原交易金额
    ,ori_trx_amt_d -- 原订单金额
    ,ori_ordr_id -- 原订单号
    ,ori_trx_dt_tm -- 原交易日期时间
    ,product_tp -- 0
    ,product_ass_information -- 原产品辅助信息
    ,device_mode -- 设备型号
    ,device_language -- 设备语言:代码遵从iso639-3标准
    ,source_i_p -- ip地址
    ,m_a_c -- mac地址
    ,dev_id -- 设备号
    ,extensive_device_location -- gps位置:经纬度
    ,device_number -- sim卡号码,存储11位手机号码,存在2个通讯设备号码,则用逗号隔开
    ,device_s_i_m_number -- 设备sim卡数量
    ,account_i_d_hash -- 账户id
    ,risk_score -- 风险评分:0-1000分
    ,risk_reason_code -- 原因码
    ,mchnt_usr_rgstr_tm -- 收单端用户注册日期,14位时间字符yyyymmddhhmmss
    ,mchnt_usr_rgstr_email -- 收单端注册账户邮箱地址
    ,rcv_province -- 收货省,注意需转换为银联清算地区代码
    ,rcv_city -- 收货市,注意需转换为银联清算地区代码
    ,goods_class -- 商品类型:虚拟(1),非虚拟(2),不确定(0)
    ,pyer_acct_id -- 退款方账户编号
    ,pyer_acct_tp -- 退款方账户类型
    ,pyee_nm -- 收款方账户名称
    ,trx_status -- 交易状态
    ,sys_rtn_cd -- 系统返回码
    ,sys_rtn_desc -- 系统返回说明
    ,host_id -- 核心流水
    ,host_date -- 核心日期
    ,host_status -- 核心状态
    ,create_time -- 创建日期时间
    ,update_time -- 修改日期时间
    ,sys_type -- 系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心
    ,adjust_flag -- 调账标识   0-未调账 1-已调账
    ,liqu_flag -- 清算标识 0-未清算 1-已清算
    ,transfer_flag -- 转移标识 0-未转移 1-已转移
    ,quick_chk -- 银联状态
    ,host_check -- 核心对账状态
    ,chk_status -- 对账状态
    ,trans_type -- refund
    ,rs_flag -- 来往账标识 1-往账 2-来账
    ,branch_no -- 收款方所属分支机构号
    ,city_no -- 收款方所属分行号
    ,branch_nm -- 收款方所属分支机构名称
    ,settlmt_inf -- 清算信息：xxyy,xx为文件序号，yy为场次号（即批次号）
    ,batch_id -- 银联无卡交易：场次号（即批次号）
    ,txn_no -- 平台交易流水号
    ,txn_date -- 平台交易日期
    ,txn_time -- 平台交易时间
    ,teller_no -- 柜员号
    ,open_org_id -- 开户机构编号
    ,tran_seq_no -- 外联平台流水
    ,global_seq_no -- 外联全局平台流水
    ,mrchnt_border_in -- 商户境内外标识
    ,mrchnt_cntry_cd -- 商户国家和地区代码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sys_id -- 系统流水
    ,sys_date -- 系统日期
    ,trx_id -- 退款流水号
    ,trx_dt_tm -- 交易日期时间
    ,settlmt_dt -- 清算日期
    ,trxtyp -- 交易类型编码
    ,trx_curry -- 退款币种
    ,trx_amt -- 交易金额
    ,trx_amt_d -- 退款金额
    ,acct_in_tp -- 账户输入方式
    ,trx_trm_tp -- 交易终端类型
    ,trx_trm_no -- 交易终端编码
    ,r_p_flg -- 收／付标识
    ,pyee_acct_issr_id -- 收款方账户所属机构标识
    ,pyee_acct_id -- 收款方账户编号
    ,pyee_acct_tp -- 收款方账户类型
    ,pyee_issr_id -- 发送机构标识
    ,pyer_acct_issr_id -- 付款方账户所属机构标识
    ,resfd_acct_issr_id -- 备付金银行机构标识
    ,instg_acct_id -- 备付金银行账号
    ,instg_acct_nm -- 备付金银行账户名称
    ,channel_issr_id -- 渠道方机构标识
    ,sgn_no -- 签约协议号
    ,mrchnt_no -- 商户编号
    ,mrchnt_tp_id -- 商户类别
    ,mrchnt_pltfrm_nm -- 商户名称
    ,sub_mrchnt_no -- 二级商户编码
    ,sub_mrchnt_tp_id -- 二级商户类别
    ,sub_mrchnt_pltfrm_nm -- 二级商户名称
    ,ori_trx_id -- 原交易流水号
    ,ori_trx_amt -- 原交易金额
    ,ori_trx_amt_d -- 原订单金额
    ,ori_ordr_id -- 原订单号
    ,ori_trx_dt_tm -- 原交易日期时间
    ,product_tp -- 0
    ,product_ass_information -- 原产品辅助信息
    ,device_mode -- 设备型号
    ,device_language -- 设备语言:代码遵从iso639-3标准
    ,source_i_p -- ip地址
    ,m_a_c -- mac地址
    ,dev_id -- 设备号
    ,extensive_device_location -- gps位置:经纬度
    ,device_number -- sim卡号码,存储11位手机号码,存在2个通讯设备号码,则用逗号隔开
    ,device_s_i_m_number -- 设备sim卡数量
    ,account_i_d_hash -- 账户id
    ,risk_score -- 风险评分:0-1000分
    ,risk_reason_code -- 原因码
    ,mchnt_usr_rgstr_tm -- 收单端用户注册日期,14位时间字符yyyymmddhhmmss
    ,mchnt_usr_rgstr_email -- 收单端注册账户邮箱地址
    ,rcv_province -- 收货省,注意需转换为银联清算地区代码
    ,rcv_city -- 收货市,注意需转换为银联清算地区代码
    ,goods_class -- 商品类型:虚拟(1),非虚拟(2),不确定(0)
    ,pyer_acct_id -- 退款方账户编号
    ,pyer_acct_tp -- 退款方账户类型
    ,pyee_nm -- 收款方账户名称
    ,trx_status -- 交易状态
    ,sys_rtn_cd -- 系统返回码
    ,sys_rtn_desc -- 系统返回说明
    ,host_id -- 核心流水
    ,host_date -- 核心日期
    ,host_status -- 核心状态
    ,create_time -- 创建日期时间
    ,update_time -- 修改日期时间
    ,sys_type -- 系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心
    ,adjust_flag -- 调账标识   0-未调账 1-已调账
    ,liqu_flag -- 清算标识 0-未清算 1-已清算
    ,transfer_flag -- 转移标识 0-未转移 1-已转移
    ,quick_chk -- 银联状态
    ,host_check -- 核心对账状态
    ,chk_status -- 对账状态
    ,trans_type -- refund
    ,rs_flag -- 来往账标识 1-往账 2-来账
    ,branch_no -- 收款方所属分支机构号
    ,city_no -- 收款方所属分行号
    ,branch_nm -- 收款方所属分支机构名称
    ,settlmt_inf -- 清算信息：xxyy,xx为文件序号，yy为场次号（即批次号）
    ,batch_id -- 银联无卡交易：场次号（即批次号）
    ,txn_no -- 平台交易流水号
    ,txn_date -- 平台交易日期
    ,txn_time -- 平台交易时间
    ,teller_no -- 柜员号
    ,open_org_id -- 开户机构编号
    ,tran_seq_no -- 外联平台流水
    ,global_seq_no -- 外联全局平台流水
    ,mrchnt_border_in -- 商户境内外标识
    ,mrchnt_cntry_cd -- 商户国家和地区代码
    ,to_date(sys_date,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ppps_u_txn_refund
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_u_txn_refund to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ppps_u_txn_refund_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_u_txn_refund',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);