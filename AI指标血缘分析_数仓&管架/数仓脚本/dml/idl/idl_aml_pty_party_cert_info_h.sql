/*
Purpose:    反洗钱应用层-当事人证件信息历史
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_pty_party_cert_info_h
Createdate: 20191025
Logs:

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_pty_party_cert_info_h drop partition p_${last_date};
alter table ${idl_schema}.aml_pty_party_cert_info_h drop partition p_${batch_date};

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.aml_pty_party_cert_info_h add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${idl_schema}.aml_pty_party_cert_info_h_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_pty_party_cert_info_h_ex
nologging
compress ${option_switch} for query high
as
select * from ${idl_schema}.aml_pty_party_cert_info_h where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_pty_party_cert_info_h_ex(
     party_id                          --当事人编号     
     ,lp_id                            --法人编号      
     ,sorc_sys_cd                      --源系统代码     
     ,cert_type_cd                     --证件类型代码    
     ,start_dt                         --开始日期      
     ,cert_num                         --证件号码      
     ,cert_addr                        --证件地址      
     ,issue_cert_org                   --发证机关      
     ,issue_cert_org_cty_cd            --发证机关国家代码  
     ,cert_effect_dt                   --证件生效日期    
     ,cert_invalid_dt                  --证件失效日期    
     ,licen_issue_autho_dist_cd        --发证机关行政区划代码
     ,crdt_cd_cert_id                  --信用代码证编号   
     ,cert_valid_flg                   --证件有效标志    
     ,cert_status_cd                   --证件状态代码    
     ,main_cert_no_flg                 --主证件号标志    
     ,end_dt                           --结束日期      
     ,id_mark                          --删除标识      
     ,src_table_name                   --源表名称      
     ,job_cd                           --任务代码      
     ,etl_timestamp                    --数据处理时间 
    ,etl_dt                 --ETL数据日期  
)
select
     party_id                          --当事人编号     
     ,lp_id                            --法人编号      
     ,sorc_sys_cd                      --源系统代码     
     ,cert_type_cd                     --证件类型代码    
     ,start_dt                         --开始日期      
     ,cert_num                         --证件号码      
     ,cert_addr                        --证件地址      
     ,issue_cert_org                   --发证机关      
     ,issue_cert_org_cty_cd            --发证机关国家代码  
     ,cert_effect_dt                   --证件生效日期    
     ,cert_invalid_dt                  --证件失效日期    
     ,licen_issue_autho_dist_cd        --发证机关行政区划代码
     ,crdt_cd_cert_id                  --信用代码证编号   
     ,cert_valid_flg                   --证件有效标志    
     ,cert_status_cd                   --证件状态代码    
     ,main_cert_no_flg                 --主证件号标志    
     ,end_dt                           --结束日期      
     ,id_mark                          --删除标识      
     ,src_table_name                   --源表名称      
     ,job_cd                           --任务代码      
     ,etl_timestamp                    --数据处理时间  
    ,to_date('${batch_date}','yyyymmdd') as etl_dt     --ETL数据日期      
from ${iml_schema}.pty_party_cert_info_h  --当事人证件信息历史
where start_dt<= to_date('${batch_date}','yyyymmdd')
and end_dt> to_date('${batch_date}','yyyymmdd')
union all
select
     party_id                          --当事人编号     
     ,lp_id                            --法人编号      
     ,sorc_sys_cd                      --源系统代码     
     ,cert_type_cd                     --证件类型代码    
     ,start_dt                         --开始日期      
     ,cert_num                         --证件号码      
     ,cert_addr                        --证件地址      
     ,issue_cert_org                   --发证机关      
     ,issue_cert_org_cty_cd            --发证机关国家代码  
     ,cert_effect_dt                   --证件生效日期    
     ,cert_invalid_dt                  --证件失效日期    
     ,licen_issue_autho_dist_cd        --发证机关行政区划代码
     ,crdt_cd_cert_id                  --信用代码证编号   
     ,cert_valid_flg                   --证件有效标志    
     ,cert_status_cd                   --证件状态代码    
     ,main_cert_no_flg                 --主证件号标志    
     ,end_dt                           --结束日期      
     ,id_mark                          --删除标识      
     ,src_table_name                   --源表名称      
     ,job_cd                           --任务代码      
     ,etl_timestamp                    --数据处理时间  
    ,to_date('${batch_date}','yyyymmdd') as etl_dt     --ETL数据日期      
from ${iml_schema}.pty_party_cert_info_h_ecif1_static_data t1 --静态数据
where 1 = 1
and not exists (select 1 from ${iml_schema}.pty_party_cert_info_h b 
                        where t1.party_id=b.party_id 
                          and t1.sorc_sys_cd=b.sorc_sys_cd 
                          and t1.cert_type_cd=b.cert_type_cd
                          and b.start_dt<= to_date('${batch_date}','yyyymmdd')
                          and b.end_dt> to_date('${batch_date}','yyyymmdd')
                )
;
commit;

-- 2.3 exchage ex table and target table
alter table ${idl_schema}.aml_pty_party_cert_info_h exchange partition p_${batch_date} with table ${idl_schema}.aml_pty_party_cert_info_h_ex;

-- 3.1 drop ex table
drop table ${idl_schema}.aml_pty_party_cert_info_h_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_pty_party_cert_info_h', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);