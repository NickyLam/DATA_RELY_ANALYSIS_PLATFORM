/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_retain_card_table
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
                       FROM atms_retain_card_table_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('atms_retain_card_table');
  
  if v_var <> 0 then 
    execute immediate 'alter table atms_retain_card_table drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table atms_retain_card_table add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;
    
insert /*+ append */ into ${iol_schema}.atms_retain_card_table(
            logic_id -- 编号
            ,dev_no -- 设备号
            ,retain_date -- 吞卡日期
            ,retain_time -- 吞卡时间
            ,account -- 卡号
            ,reason -- 原因
            ,period -- 会计周期号
            ,card_stuck_org -- 吞卡机构
            ,card_handle_org -- 处理机构
            ,auto_flag -- 自动录入标志
            ,check_op -- 登记人
            ,check_date -- 登记日期
            ,check_time -- 登记时间
            ,op_no -- 处理人
            ,op_date -- 处理日期
            ,op_time -- 处理时间
            ,op_address -- 处理地点
            ,account_name -- 客户姓名
            ,account_id -- 客户证件号
            ,account_phome -- 客户电话
            ,cert_type -- 证件类型
            ,status -- 吞卡状态
            ,account_phone -- 客户电话
            ,type_flag -- 新吞类型（0——吞卡，1——吞钞）
            ,card_retain_type -- 吞卡类型，1-已吞卡到回收箱；2-已吞卡到退卡器；3-吞卡被取走（读卡器）；4-吞卡被取走（退卡器）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            logic_id -- 编号
            ,dev_no -- 设备号
            ,retain_date -- 吞卡日期
            ,retain_time -- 吞卡时间
            ,account -- 卡号
            ,reason -- 原因
            ,period -- 会计周期号
            ,card_stuck_org -- 吞卡机构
            ,card_handle_org -- 处理机构
            ,auto_flag -- 自动录入标志
            ,check_op -- 登记人
            ,check_date -- 登记日期
            ,check_time -- 登记时间
            ,op_no -- 处理人
            ,op_date -- 处理日期
            ,op_time -- 处理时间
            ,op_address -- 处理地点
            ,account_name -- 客户姓名
            ,account_id -- 客户证件号
            ,account_phome -- 客户电话
            ,cert_type -- 证件类型
            ,status -- 吞卡状态
            ,' ' as account_phone -- 客户电话
            ,' ' as type_flag -- 新吞类型（0——吞卡，1——吞钞）
            ,' ' as card_retain_type -- 吞卡类型，1-已吞卡到回收箱；2-已吞卡到退卡器；3-吞卡被取走（读卡器）；4-吞卡被取走（退卡器）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.atms_retain_card_table_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
