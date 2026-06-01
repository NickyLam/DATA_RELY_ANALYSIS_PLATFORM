/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_hlw_loan_product_partner_info_ret1
CreateDate: 20250611
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;

declare
  v_flag   number(10) :=0;

begin
  for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt
               from user_tab_partitions
                   where table_name = upper('icms_hlw_loan_product_partner_info_bak${batch_date}')
                       and partition_name <> 'P_19000101'
                       --and substr(partition_name,3) = '${batch_date}'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('icms_hlw_loan_product_partner_info')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table icms_hlw_loan_product_partner_info drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table icms_hlw_loan_product_partner_info add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_hlw_loan_product_partner_info (
    serialno -- 流水号
    ,objectno -- HLW_LOAN_PRODUCT_INFO流水号
    ,partnername -- 合作方名称
    ,channelno -- 渠道性质
    ,certid -- 合作方统一社会信用代码
    ,investmentprop -- 出资比例
    ,startdate -- 启用时间
    ,enddate -- 停用时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno as serialno -- 流水号
    ,objectno as objectno -- HLW_LOAN_PRODUCT_INFO流水号
    ,partnername as partnername -- 合作方名称
    ,channelno as channelno -- 渠道性质
    ,certid as certid -- 合作方统一社会信用代码
    ,investmentprop as investmentprop -- 出资比例
    ,to_date('00010101','yyyymmdd') as startdate -- 启用时间
    ,to_date('00010101','yyyymmdd') as enddate -- 停用时间
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_hlw_loan_product_partner_info_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

