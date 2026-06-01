/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_s_qry_req_inf
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cqss_s_qry_req_inf_ex purge;
alter table ${iol_schema}.cqss_s_qry_req_inf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.cqss_s_qry_req_inf;

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_s_qry_req_inf_ex nologging
compress
as
select * from ${iol_schema}.cqss_s_qry_req_inf where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_s_qry_req_inf_ex(
    qry_req_id -- 
    ,biz_elmt_val -- 
    ,ent_idt_tp -- 
    ,ent_idt_no -- 
    ,ent_nm -- 
    ,ind_idt_tp -- 
    ,ind_idt_no -- 
    ,ind_nm -- 
    ,pbc_qry_rscd -- 
    ,qry_stgy -- 
    ,qry_user_id -- 
    ,qry_user_nm -- 
    ,user_office_id -- 
    ,user_office_nm -- 
    ,qry_office_id -- 
    ,qry_office_nm -- 
    ,app_user_id -- 
    ,app_user_nm -- 
    ,app_office_id -- 
    ,app_office_nm -- 
    ,pbc_org_cd -- 
    ,pbc_usr -- 
    ,qry_req_tm -- 
    ,qry_res_tm -- 
    ,failed_qry_tm -- 
    ,qry_rslt_cd -- 
    ,qry_rslt_desc -- 
    ,result_type -- 
    ,result_desc -- 
    ,msgidno -- 
    ,qry_st -- 
    ,src_sys_cd -- 
    ,dt_src_tp -- 
    ,ori_rsp_msg -- 
    ,score -- 
    ,position -- 
    ,score_time -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    qry_req_id -- 
    ,biz_elmt_val -- 
    ,ent_idt_tp -- 
    ,ent_idt_no -- 
    ,ent_nm -- 
    ,ind_idt_tp -- 
    ,ind_idt_no -- 
    ,ind_nm -- 
    ,pbc_qry_rscd -- 
    ,qry_stgy -- 
    ,qry_user_id -- 
    ,qry_user_nm -- 
    ,user_office_id -- 
    ,user_office_nm -- 
    ,qry_office_id -- 
    ,qry_office_nm -- 
    ,app_user_id -- 
    ,app_user_nm -- 
    ,app_office_id -- 
    ,app_office_nm -- 
    ,pbc_org_cd -- 
    ,pbc_usr -- 
    ,qry_req_tm -- 
    ,qry_res_tm -- 
    ,failed_qry_tm -- 
    ,qry_rslt_cd -- 
    ,qry_rslt_desc -- 
    ,result_type -- 
    ,result_desc -- 
    ,msgidno -- 
    ,qry_st -- 
    ,src_sys_cd -- 
    ,dt_src_tp -- 
    ,ori_rsp_msg -- 
    ,score -- 
    ,position -- 
    ,score_time -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_s_qry_req_inf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_s_qry_req_inf exchange partition p_${batch_date} with table ${iol_schema}.cqss_s_qry_req_inf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_s_qry_req_inf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_s_qry_req_inf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_s_qry_req_inf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);