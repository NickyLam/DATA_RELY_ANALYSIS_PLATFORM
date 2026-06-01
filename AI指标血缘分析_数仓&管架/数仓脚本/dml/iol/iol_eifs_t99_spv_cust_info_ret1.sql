/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t99_spv_cust_info_ret1
CreateDate: 20250206
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
                       FROM eifs_t99_spv_cust_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('eifs_t99_spv_cust_info');

  if v_var <> 0 then
    execute immediate 'alter table eifs_t99_spv_cust_info drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table eifs_t99_spv_cust_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.eifs_t99_spv_cust_info (
    cust_num -- spv客户号
    ,org_cust_num -- 主机构客户号
    ,cust_name -- spv名称
    ,spv_ytpe -- spv类型
    ,prod_stat_cd -- 资管产品统计编码
    ,spv_cd -- spv代码
    ,create_te -- 创建柜员
    ,create_org -- 创建机构号
    ,init_system_id -- 创建渠道
    ,init_created_ts -- 源系统创建时间
    ,created_ts -- 进入ecif的时间
    ,updated_ts -- 在ecif中失效的时间
    ,last_updated_te -- 最新更新柜员
    ,last_updated_org -- 最新更新机构号
    ,last_system_id -- 最新更新渠道
    ,last_updated_ts -- 最新更新时间
    ,is_cash_magm -- 是否现金管理类理财
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    cust_num as cust_num -- spv客户号
    ,org_cust_num as org_cust_num -- 主机构客户号
    ,cust_name as cust_name -- spv名称
    ,spv_ytpe as spv_ytpe -- spv类型
    ,prod_stat_cd as prod_stat_cd -- 资管产品统计编码
    ,spv_cd as spv_cd -- spv代码
    ,create_te as create_te -- 创建柜员
    ,create_org as create_org -- 创建机构号
    ,init_system_id as init_system_id -- 创建渠道
    ,init_created_ts as init_created_ts -- 源系统创建时间
    ,created_ts as created_ts -- 进入ecif的时间
    ,updated_ts as updated_ts -- 在ecif中失效的时间
    ,last_updated_te as last_updated_te -- 最新更新柜员
    ,last_updated_org as last_updated_org -- 最新更新机构号
    ,last_system_id as last_system_id -- 最新更新渠道
    ,last_updated_ts as last_updated_ts -- 最新更新时间
    ,' ' as is_cash_magm -- 是否现金管理类理财
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t99_spv_cust_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

