/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_under_asset_top_ten_ret1
CreateDate: 20250310
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
                       FROM ibms_ttrd_under_asset_top_ten_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('ibms_ttrd_under_asset_top_ten');

  if v_var <> 0 then
    execute immediate 'alter table ibms_ttrd_under_asset_top_ten drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table ibms_ttrd_under_asset_top_ten add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.ibms_ttrd_under_asset_top_ten (
    id -- 主键
    ,i_code -- 产品代码
    ,a_type -- 资产大类
    ,m_type -- 市场类型
    ,asset_code -- 资产代码
    ,asset_name -- 资产名称
    ,asset_type -- 资产类型
    ,asset_net_per -- 占资产净值比例（%）
    ,map_weight -- 映射权重
    ,g4b_field_no -- G4B栏位号
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    id as id -- 主键
    ,i_code as i_code -- 产品代码
    ,a_type as a_type -- 资产大类
    ,m_type as m_type -- 市场类型
    ,asset_code as asset_code -- 资产代码
    ,asset_name as asset_name -- 资产名称
    ,asset_type as asset_type -- 资产类型
    ,asset_net_per as asset_net_per -- 占资产净值比例（%）
    ,map_weight as map_weight -- 映射权重
    ,' ' as g4b_field_no -- G4B栏位号
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_under_asset_top_ten_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

