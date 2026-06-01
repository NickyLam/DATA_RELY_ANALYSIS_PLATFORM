/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdws_a_chnl_process_index_statis
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;
truncate table bdws_a_chnl_process_index_statis;

declare
     v_flag   number(10) :=0;
          
begin
	for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt 
	             from user_tab_partitions 
	            where table_name = upper('bdws_a_chnl_process_index_statis_bak_${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('bdws_a_chnl_process_index_statis')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table bdws_a_chnl_process_index_statis drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table bdws_a_chnl_process_index_statis add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.bdws_a_chnl_process_index_statis(
    etl_dt_ora -- 数据日期
    ,execut_org_id -- 管户/共管机构编号
    ,execut_org_name -- 管户/共管机构名称
    ,execut_type -- 管户类型
    ,execut_clerk_id -- 管户/共管人员工号
    ,execut_clerk_name -- 管户/共管人名称
    ,cust_id -- 客户号
    ,open_acct_dt -- 开户时间
    ,monthly_act_examine -- 是否满足月活考核口径
    ,mobile_bank_open -- 是否开通手机银行
    ,mobile_bank_login_m -- 当月是否登录手机银行
    ,fin_risk_sign -- 是否签约理财风评
    ,bind_card_examine -- 是否符合绑卡考核口径
    ,wct_bank_bind -- 是否绑定微信银行
    ,quick_pay_bind -- 是否绑定快捷支付
    ,cust_acct_nature -- 客户账户性质
    ,new_open_y -- 是否当年内新开户
    ,if_message_sign -- 是否同意接收营销短信
    ,aum_m_avg_bal -- 客户aum月日均
    ,aum_acct_bal -- 客户aum余额
    ,first_aum -- 开户当日的余额
    ,three_aum -- 开户后3天余额
    ,seven_aum -- 开户后7天余额
    ,fifteen_aum -- 开户后15天余额
    ,thirty_aum -- 开户后30天余额
    ,if_day -- 是否开户满30天
    ,is_payroll_cust -- 是否代发客户
    ,open_acct_chn_cd -- 开户渠道
    ,is_hav_prod -- 是否持有产品
    ,aum_sum -- 持有产品总余额（不含活期）
    ,all_label -- 持有产品类型（大类，存款不包含活期）
    ,if_bill -- 是否收单
    ,bind_remv_flg -- 是否添加企业微信
    ,new_open_m -- 是否当月内新开户
    ,open_acct_teller_name -- 开户柜员名称
    ,if_new_open_t0_amt -- 是否T0入金
    ,load_date -- 分区字段
    ,kqhf -- 客群划分
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    etl_dt_ora -- 数据日期
    ,execut_org_id -- 管户/共管机构编号
    ,execut_org_name -- 管户/共管机构名称
    ,execut_type -- 管户类型
    ,execut_clerk_id -- 管户/共管人员工号
    ,execut_clerk_name -- 管户/共管人名称
    ,cust_id -- 客户号
    ,open_acct_dt -- 开户时间
    ,monthly_act_examine -- 是否满足月活考核口径
    ,mobile_bank_open -- 是否开通手机银行
    ,mobile_bank_login_m -- 当月是否登录手机银行
    ,fin_risk_sign -- 是否签约理财风评
    ,bind_card_examine -- 是否符合绑卡考核口径
    ,wct_bank_bind -- 是否绑定微信银行
    ,quick_pay_bind -- 是否绑定快捷支付
    ,cust_acct_nature -- 客户账户性质
    ,new_open_y -- 是否当年内新开户
    ,if_message_sign -- 是否同意接收营销短信
    ,aum_m_avg_bal -- 客户aum月日均
    ,aum_acct_bal -- 客户aum余额
    ,first_aum -- 开户当日的余额
    ,three_aum -- 开户后3天余额
    ,seven_aum -- 开户后7天余额
    ,fifteen_aum -- 开户后15天余额
    ,thirty_aum -- 开户后30天余额
    ,if_day -- 是否开户满30天
    ,is_payroll_cust -- 是否代发客户
    ,open_acct_chn_cd -- 开户渠道
    ,is_hav_prod -- 是否持有产品
    ,aum_sum -- 持有产品总余额（不含活期）
    ,all_label -- 持有产品类型（大类，存款不包含活期）
    ,if_bill -- 是否收单
    ,bind_remv_flg -- 是否添加企业微信
    ,new_open_m -- 是否当月内新开户
    ,open_acct_teller_name -- 开户柜员名称
    ,if_new_open_t0_amt -- 是否T0入金
    ,load_date -- 分区字段
    ,' ' as kqhf -- 客群划分
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
from bdws_a_chnl_process_index_statis_bak_${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/