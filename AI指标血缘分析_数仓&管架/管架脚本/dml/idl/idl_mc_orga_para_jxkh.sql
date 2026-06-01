--python $ETL_HOME/script/main.py yyyymmdd idl_mc_orga_para_jxkh 
set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

  merge into mc_orga_para_jxkh a
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
          ,a.super_org_id = b.admin_super_org_id
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
     when not matched then 
	 insert(org_no, org_name, super_org_id, org_level,etl_dt) 
     values(b.org_id
	      , b.org_abbr
		  , b.admin_super_org_id
		  ,(CASE
                   WHEN length(b.org_id) = 3 THEN
                    '分行'              
                   WHEN b.org_id in('800976','800892','800935') THEN '事业部'
                   WHEN b.org_id  in('800954',
                                  '800881',
                                  '800968',
                                  '800891',
                                  '800957',
                                  '800716',
                                  '800721',
                                  '800975') THEN
                    '条线管理部门'
					ELSE '支行团队'
               END)
		  ,b.etl_dt)
     where b.etl_dt = to_date('${batch_date}', 'yyyymmdd')
	       and b.org_status_cd not in ('1', '4') ;
COMMIT;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_orga_para_jxkh', degree => 8, cascade => true);
