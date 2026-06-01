set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

MERGE INTO mtl_rdl_idx_indx_data a
USING (SELECT * FROM mtl_fdl_idx_index_data WHERE index_measure = '001' AND substr(index_no,1,2) = 'RM') b
ON (a.indx_no = b.index_no AND a.org_no = b.org_no AND a.curr_cd = b.curr_cd AND a.etl_dt = b.etl_dt and a.indx_dimen_cd ='ALL'  )
WHEN MATCHED THEN
    UPDATE
    SET    a.indx_val      = b.index_val
           ,a.etl_timestamp = b.etl_timestamp
    WHERE  b.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'mm') - 1
WHEN NOT MATCHED THEN
    INSERT
        (indx_no
        ,org_no
        ,curr_cd
        ,indx_dimen_no
        ,indx_dimen_cd
        ,stat_ped_cd
        ,indx_val
        ,comp_ear_year_val
        ,comp_same_term_val
        ,comp_last_mon_val
        ,comp_last_qua_val
        ,etl_dt
        ,etl_timestamp
        ,biz_strip_line_cd
        ,index_measure)
    VALUES
        (b.index_no
        ,b.org_no
        ,b.curr_cd
        ,'IND001'
        ,'ALL'
        ,b.BATCH_FREQ
        ,coalesce(b.index_val,0)
        ,0
        ,0
        ,0
        ,0
        ,trunc(to_date('${batch_date}','yyyymmdd'),'mm') - 1 
        ,b.etl_timestamp
        ,''
        ,b.index_measure) 
        WHERE b.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'mm') - 1 
        AND b.index_no = 'RM0200128'
        AND b.index_measure = '001';
COMMIT;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mtl_rdl_idx_indx_data', degree => 8, cascade => true);