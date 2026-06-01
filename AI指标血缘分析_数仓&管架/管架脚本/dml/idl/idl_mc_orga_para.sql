--python $ETL_HOME/script/main.py yyyymmdd idl_mc_orga_para 
set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

  merge into mc_orga_para a
  using ${idl_schema}.mtl_cmm_intnal_org_info b
  on (a.org_no = b.org_id)
  when matched then
    update
       set a.org_name =
           (case
             when b.org_status_cd = '4' then
              b.org_abbr || '(已撤销)'
             else
              b.org_abbr
           end) -- 机构名称
          ,a.super_org_id = (CASE
                   WHEN length(b.org_id) = 3 THEN
                    '000000'              --分行级别，默认上级机构号为000000
                   ELSE
                    substr(org_id
                          ,1
                          ,3)             --支行级别，默认上级机构号为支行机构号前3位，即分行号
               END)
           -- 跑数时间,已停用的机构不再更新日期
          ,a.etl_dt =
           (case
             when b.org_status_cd = '4' then
              a.etl_dt
             else
              b.etl_dt
           end)
     where b.etl_dt = to_date('${batch_date}', 'yyyymmdd')
           and b.org_id <> '800' --排除总行
           and b.org_id <> '000000' --排除全行
     when not matched then insert(org_no, org_name, super_org_id, etl_dt) 
     values(b.org_id, b.org_abbr,(CASE
                   WHEN length(b.org_id) = 3 THEN
                    '000000'              --分行级别，默认上级机构号为000000
                   ELSE
                    substr(org_id
                          ,1
                          ,3)             --支行级别，默认上级机构号为支行机构号前3位，即分行号
               END),b.etl_dt)
     where b.etl_dt = to_date('${batch_date}', 'yyyymmdd')
           and b.org_type_cd in ('10', '11', '12') --总分支行
           and b.org_lev_cd in ('02', '03', '01') --分行支行 总行不需更新     
           and b.org_status_cd = '2' --已启用
           and b.bus_status_cd = '2' --正常营业
           and b.org_id not like '89%' -- 排除事业部
           and ((length(b.org_id) = 6 and substr(b.org_id, 6, 1) = 1 and b.accti_org_flg = '1') --支行
           or (b.admin_super_org_id = '000000')) -- 分行
         ;
COMMIT;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_orga_para', degree => 8, cascade => true);