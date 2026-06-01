set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;
delete from mc_wind_org_para a
where trim(third_code) not in ('avg','all')
;
commit ;
whenever sqlerror exit sql.sqlcode; 

insert into mc_wind_org_para
(
     first_code    -- 一级分类代码
    ,first_name    -- 一级分类名称
    ,second_code   -- 二级分类代码
    ,second_name   -- 二级分类名称
    ,third_code    -- 三级分类代码
    ,third_name    -- 三级分类名称
    ,source_sys    -- 数据来源
    ,remark        -- 备注
    ,update_dt     -- 更新时间
)
select 
    substr(a.industriescode,1,6)||'0000'   as first_code    -- 一级分类代码
    ,case when  substr(a.industriescode,1,6) = '081601' then '银行'  
          else '非银行金融机构'
     end                                   as first_name    -- 一级分类名称
    ,substr(a.industriescode,1,8)||'00'    as second_code   -- 二级分类代码
    ,b.industriesname                      as second_name   -- 二级分类名称
    ,substr(a.industriescode,1,10)         as third_code    -- 三级分类代码
    ,case when substr(a.industriescode,1,10) = '0816010000' then '银行' 
          when substr(a.industriescode,1,10) = '0816020000' then '非银行金融机构'
          else a.industriesname
     end                                   as third_name    -- 三级分类名称
    ,'wind'                                as source_sys    -- 数据来源
    ,''                                    as remark        -- 备注
    ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                         
                                           as update_dt     -- 更新时间
from mtl_wind_ashareindustriescode a
left join mtl_wind_ashareindustriescode b
on substr(a.industriescode,1,8)||'00' = substr(b.industriescode,1,10)
 and a.etl_dt = b.etl_dt
where substr(a.industriescode,1,6) in ('081601','081602')
  and a.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit ;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_wind_org_para', degree => 8, cascade => true);