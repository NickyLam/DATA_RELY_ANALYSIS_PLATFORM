/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cd_card_arch
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM ncbs_cd_card_arch_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_cd_card_arch');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_cd_card_arch drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_cd_card_arch add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_cd_card_arch(
            acct_seq_no -- 账户子账号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,app_flag -- 附属卡标志
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_close_reason -- 销卡原因
            ,card_cvn -- 卡片cvn信息
            ,card_medium_type -- 卡介质类型
            ,card_pb_union_flag -- 卡折合一标志
            ,card_status -- 卡状态
            ,change_card_num -- 换卡次数
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,failure_times -- 累积失败次数
            ,is_corp_settle_card -- 单位结算卡标志
            ,query_pwd -- 查询密码
            ,sign_flag -- 是否记名卡
            ,tread_pwd -- 交易密码
            ,card_close_date -- 销卡日期
            ,issue_date -- 发行日期
            ,last_change_time -- 上次修改时间
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,apply_user_id -- 申请柜员
            ,close_user_id -- 关闭柜员
            ,issue_user_id -- 发卡柜员
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,card_cvn_mac -- 卡CVN信息密文MAC值|卡CVN信息密文MAC值
            ,valid_thru_date_mac -- 卡有效期截止日期密文MAC值|卡有效期截止日期密文MAC值
            ,valid_thru_date_pwd -- 卡有效期截止日期密文|卡有效期截止日期密文
            ,card_cvn2_mac -- 卡CVN信息密文MAC值（存储等效二磁信息，包含D的）
            ,card_cvn2 -- 卡片CVN信息（存储的等效二磁信息，包含D的）
            ,card_cvv2 -- 
            ,card_cvv2_mac -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            acct_seq_no -- 账户子账号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,app_flag -- 附属卡标志
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_close_reason -- 销卡原因
            ,card_cvn -- 卡片cvn信息
            ,card_medium_type -- 卡介质类型
            ,card_pb_union_flag -- 卡折合一标志
            ,card_status -- 卡状态
            ,change_card_num -- 换卡次数
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,failure_times -- 累积失败次数
            ,is_corp_settle_card -- 单位结算卡标志
            ,query_pwd -- 查询密码
            ,sign_flag -- 是否记名卡
            ,tread_pwd -- 交易密码
            ,card_close_date -- 销卡日期
            ,issue_date -- 发行日期
            ,last_change_time -- 上次修改时间
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,apply_user_id -- 申请柜员
            ,close_user_id -- 关闭柜员
            ,issue_user_id -- 发卡柜员
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,card_cvn_mac -- 卡CVN信息密文MAC值|卡CVN信息密文MAC值
            ,valid_thru_date_mac -- 卡有效期截止日期密文MAC值|卡有效期截止日期密文MAC值
            ,valid_thru_date_pwd -- 卡有效期截止日期密文|卡有效期截止日期密文
            ,card_cvn2_mac -- 卡CVN信息密文MAC值（存储等效二磁信息，包含D的）
            ,' ' as card_cvn2 -- 卡片CVN信息（存储的等效二磁信息，包含D的）
            ,' ' as card_cvv2 -- 
            ,' ' as card_cvv2_mac -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cd_card_arch_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
