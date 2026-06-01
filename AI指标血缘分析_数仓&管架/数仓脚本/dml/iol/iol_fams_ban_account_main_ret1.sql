/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ban_account_main
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
                       FROM fams_ban_account_main_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('fams_ban_account_main');
  
  if v_var <> 0 then 
    execute immediate 'alter table fams_ban_account_main drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table fams_ban_account_main add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.fams_ban_account_main(
            vouch_num -- 凭证编号
            ,bus_vouchnum -- 凭证编号
            ,bookset_id -- 账套代码
            ,trade_id -- 交易编号
            ,book_date -- 日期
            ,com_table_id -- 合并场景代码
            ,vouch_remark -- 凭证说明
            ,offset_flag -- 冲正标识
            ,vouch_year -- 年份
            ,vouch_month -- 月份
            ,num -- 编号位数
            ,book_type -- 凭证类型
            ,handle_user -- 经办人
            ,approve_user -- 复核人
            ,approve_status -- 审批状态
            ,send_user -- 发送人
            ,send_status -- 发送状态
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,vouch_type -- 账务类型
            ,customer_name -- 客户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            vouch_num -- 凭证编号
            ,bus_vouchnum -- 凭证编号
            ,bookset_id -- 账套代码
            ,trade_id -- 交易编号
            ,book_date -- 日期
            ,com_table_id -- 合并场景代码
            ,vouch_remark -- 凭证说明
            ,offset_flag -- 冲正标识
            ,vouch_year -- 年份
            ,vouch_month -- 月份
            ,num -- 编号位数
            ,book_type -- 凭证类型
            ,handle_user -- 经办人
            ,approve_user -- 复核人
            ,approve_status -- 审批状态
            ,send_user -- 发送人
            ,send_status -- 发送状态
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,vouch_type -- 账务类型
            ,' ' as customer_name -- 客户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from fams_ban_account_main_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
