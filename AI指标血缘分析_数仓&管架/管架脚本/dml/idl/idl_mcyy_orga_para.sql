--python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_orga_para 
set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

    MERGE INTO mcyy_orga_para a
    USING ${idl_schema}.mtl_cmm_intnal_org_info b
    ON (a.org_no = b.org_id)
    WHEN MATCHED THEN
        UPDATE
        SET    a.org_name       = (case when b.org_status_cd='4'  then b.org_abbr||'(已撤销)' else b.org_abbr end) -- 机构名称
              ,a.org_abbr       = (case when b.org_status_cd='4'  then b.org_name||'(已撤销)' else b.org_name end)  -- 机构简称(名称)
              ,a.super_org_no  =
               (CASE
                   WHEN length(b.org_id) = 3 THEN
                    '000000'              --分行级别，默认上级机构号为000000
                   ELSE
                    substr(org_id
                          ,1
                          ,3)             --支行级别，默认上级机构号为支行机构号前3位，即分行号
               END) -- 上级机构号
              ,a.super_org_name = REPLACE(b.brch_name
                                         ,'广东华兴银行股份有限公司'
                                         ,'')  -- 上级机构名称
             -- 跑数时间,已停用的机构不再更新日期
             ,a.etl_dt      = (case when b.org_status_cd='4' then a.etl_dt else b.etl_dt end )  
             ,a.org_status_cd  = b.org_status_cd --机构启用标识
             ,a.org_level =b.org_type_cd -- 机构类型代码 10	总行 11	分行 12	支行 -	未知

        WHERE  b.etl_dt = to_date('${batch_date}'
                                 ,'yyyymmdd')
        AND  b.org_id <> '800' --排除总行
        AND    b.org_id <> '000000' --排除全行
         WHEN NOT MATCHED THEN 
         INSERT(org_belong, org_no, org_name, super_org_no, super_org_name, accts_org_ind, org_status_cd, org_level, org_level_cd, enty_org_flg, org_abbr, etl_dt)
        
        VALUES((CASE
            WHEN b.admin_super_org_id = '000000' THEN
             substr(b.org_id
                   ,1
                   ,3)
            ELSE
             b.admin_super_org_id
        END), b.org_id, b.org_abbr,(CASE
            WHEN length(b.org_id) = 3 THEN
             '000000'
            ELSE
             substr(b.org_id
                   ,1
                   ,3)
        END), REPLACE(b.brch_name, '广东华兴银行股份有限公司', ''), NULL, b.org_status_cd, b.org_type_cd, b.org_lev_cd, b.enty_org_flg, b.org_name, b.etl_dt)
        WHERE  b.etl_dt = to_date('${batch_date}'
                                 ,'yyyymmdd')
        AND    b.org_type_cd IN ('10'
                                ,'11'
                                ,'12') --总分支行
        AND    b.org_lev_cd IN ('02'
                               ,'03'
                               ,'01') --分行支行 总行不需更新     
        AND    b.org_status_cd = '2' --已启用
        AND    b.bus_status_cd = '2' --正常营业
        AND    b.org_id NOT LIKE '89%' -- 排除事业部
        AND    ((length(b.org_id) = 6 and substr(b.org_id,6,1)=1 and b.accti_org_flg = '1' ) --支行
        or    (b.admin_super_org_id = '000000') )-- 分行
        ;
COMMIT;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mcyy_orga_para', degree => 8, cascade => true);
