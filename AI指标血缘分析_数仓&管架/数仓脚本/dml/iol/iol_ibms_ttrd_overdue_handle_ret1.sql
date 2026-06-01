/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_overdue_handle
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
                       FROM ibms_ttrd_overdue_handle_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ibms_ttrd_overdue_handle');
  
  if v_var <> 0 then 
    execute immediate 'alter table ibms_ttrd_overdue_handle drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ibms_ttrd_overdue_handle add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ibms_ttrd_overdue_handle(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,i_name -- 金融工具名称
            ,is_ai_overdue -- 利息是否逾期：1是0否
            ,amount_ai_overdue -- 利息逾期金额
            ,beg_date_ai_overdue -- 利息逾期开始日
            ,is_cp_overdue -- 本金是否逾期：1是0否
            ,amount_cp_overdue -- 本金逾期金额
            ,beg_date_cp_overdue -- 本金逾期开始日
            ,transfer_table_type -- 1:转表内,2:转表外,0:默认值,未进行过转表操作
            ,statu -- 状态 1:待复核,2:已生效
            ,check_name -- 提交人/修改人
            ,check_time -- 提交时间/修改时间
            ,review_user -- 复核人
            ,review_time -- 复核时间
            ,change_date -- 变更日期
            ,is_si -- 是次级标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,i_name -- 金融工具名称
            ,is_ai_overdue -- 利息是否逾期：1是0否
            ,amount_ai_overdue -- 利息逾期金额
            ,beg_date_ai_overdue -- 利息逾期开始日
            ,is_cp_overdue -- 本金是否逾期：1是0否
            ,amount_cp_overdue -- 本金逾期金额
            ,beg_date_cp_overdue -- 本金逾期开始日
            ,transfer_table_type -- 1:转表内,2:转表外,0:默认值,未进行过转表操作
            ,statu -- 状态 1:待复核,2:已生效
            ,check_name -- 提交人/修改人
            ,check_time -- 提交时间/修改时间
            ,review_user -- 复核人
            ,review_time -- 复核时间
            ,change_date -- 变更日期
            ,' ' as is_si -- 是次级标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ibms_ttrd_overdue_handle_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
