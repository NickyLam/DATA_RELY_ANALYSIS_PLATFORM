/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_swt_settle_path
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ctms_fbs_v_swt_settle_path_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_fbs_v_swt_settle_path;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_swt_settle_path_op purge;
drop table ${iol_schema}.ctms_fbs_v_swt_settle_path_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_swt_settle_path_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_swt_settle_path where 0=1;

create table ${iol_schema}.ctms_fbs_v_swt_settle_path_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_swt_settle_path where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_swt_settle_path_cl(
            infr_srno -- 
            ,cus_number -- 
            ,cus_branch_number -- 
            ,settle_path_name -- 
            ,mem_code_srno -- 
            ,crncy_accnt_code_desc -- 
            ,default_path_indc -- 
            ,settle_type_indc -- 
            ,prdct_srno -- 
            ,account_bank_type -- 
            ,account_bank_bic -- 
            ,account_bank_desc -- 
            ,account_bank_accnt -- 
            ,benifit_bank_type -- 
            ,benifit_bank_bic -- 
            ,benifit_bank_desc -- 
            ,benifit_bank_accnt -- 
            ,mid_bank_type -- 
            ,mid_bank_bic -- 
            ,mid_bank_desc -- 
            ,mid_bank_accnt -- 
            ,agency_bank_type -- 
            ,agency_bank_bic -- 
            ,agency_bank_desc -- 
            ,agency_bank_accnt -- 
            ,order_bank_type -- 
            ,order_bank_bic -- 
            ,order_bank_desc -- 
            ,order_bank_account -- 
            ,crtd_user_id -- 
            ,crtd_date -- 
            ,updtd_user_id -- 
            ,updtd_date -- 
            ,system_name -- 
            ,account_bank_cname -- 
            ,mid_bank_cname -- 
            ,agency_bank_cname -- 
            ,benifit_bank_cname -- 
            ,order_bank_cname -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_swt_settle_path_op(
            infr_srno -- 
            ,cus_number -- 
            ,cus_branch_number -- 
            ,settle_path_name -- 
            ,mem_code_srno -- 
            ,crncy_accnt_code_desc -- 
            ,default_path_indc -- 
            ,settle_type_indc -- 
            ,prdct_srno -- 
            ,account_bank_type -- 
            ,account_bank_bic -- 
            ,account_bank_desc -- 
            ,account_bank_accnt -- 
            ,benifit_bank_type -- 
            ,benifit_bank_bic -- 
            ,benifit_bank_desc -- 
            ,benifit_bank_accnt -- 
            ,mid_bank_type -- 
            ,mid_bank_bic -- 
            ,mid_bank_desc -- 
            ,mid_bank_accnt -- 
            ,agency_bank_type -- 
            ,agency_bank_bic -- 
            ,agency_bank_desc -- 
            ,agency_bank_accnt -- 
            ,order_bank_type -- 
            ,order_bank_bic -- 
            ,order_bank_desc -- 
            ,order_bank_account -- 
            ,crtd_user_id -- 
            ,crtd_date -- 
            ,updtd_user_id -- 
            ,updtd_date -- 
            ,system_name -- 
            ,account_bank_cname -- 
            ,mid_bank_cname -- 
            ,agency_bank_cname -- 
            ,benifit_bank_cname -- 
            ,order_bank_cname -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.infr_srno, o.infr_srno) as infr_srno -- 
    ,nvl(n.cus_number, o.cus_number) as cus_number -- 
    ,nvl(n.cus_branch_number, o.cus_branch_number) as cus_branch_number -- 
    ,nvl(n.settle_path_name, o.settle_path_name) as settle_path_name -- 
    ,nvl(n.mem_code_srno, o.mem_code_srno) as mem_code_srno -- 
    ,nvl(n.crncy_accnt_code_desc, o.crncy_accnt_code_desc) as crncy_accnt_code_desc -- 
    ,nvl(n.default_path_indc, o.default_path_indc) as default_path_indc -- 
    ,nvl(n.settle_type_indc, o.settle_type_indc) as settle_type_indc -- 
    ,nvl(n.prdct_srno, o.prdct_srno) as prdct_srno -- 
    ,nvl(n.account_bank_type, o.account_bank_type) as account_bank_type -- 
    ,nvl(n.account_bank_bic, o.account_bank_bic) as account_bank_bic -- 
    ,nvl(n.account_bank_desc, o.account_bank_desc) as account_bank_desc -- 
    ,nvl(n.account_bank_accnt, o.account_bank_accnt) as account_bank_accnt -- 
    ,nvl(n.benifit_bank_type, o.benifit_bank_type) as benifit_bank_type -- 
    ,nvl(n.benifit_bank_bic, o.benifit_bank_bic) as benifit_bank_bic -- 
    ,nvl(n.benifit_bank_desc, o.benifit_bank_desc) as benifit_bank_desc -- 
    ,nvl(n.benifit_bank_accnt, o.benifit_bank_accnt) as benifit_bank_accnt -- 
    ,nvl(n.mid_bank_type, o.mid_bank_type) as mid_bank_type -- 
    ,nvl(n.mid_bank_bic, o.mid_bank_bic) as mid_bank_bic -- 
    ,nvl(n.mid_bank_desc, o.mid_bank_desc) as mid_bank_desc -- 
    ,nvl(n.mid_bank_accnt, o.mid_bank_accnt) as mid_bank_accnt -- 
    ,nvl(n.agency_bank_type, o.agency_bank_type) as agency_bank_type -- 
    ,nvl(n.agency_bank_bic, o.agency_bank_bic) as agency_bank_bic -- 
    ,nvl(n.agency_bank_desc, o.agency_bank_desc) as agency_bank_desc -- 
    ,nvl(n.agency_bank_accnt, o.agency_bank_accnt) as agency_bank_accnt -- 
    ,nvl(n.order_bank_type, o.order_bank_type) as order_bank_type -- 
    ,nvl(n.order_bank_bic, o.order_bank_bic) as order_bank_bic -- 
    ,nvl(n.order_bank_desc, o.order_bank_desc) as order_bank_desc -- 
    ,nvl(n.order_bank_account, o.order_bank_account) as order_bank_account -- 
    ,nvl(n.crtd_user_id, o.crtd_user_id) as crtd_user_id -- 
    ,nvl(n.crtd_date, o.crtd_date) as crtd_date -- 
    ,nvl(n.updtd_user_id, o.updtd_user_id) as updtd_user_id -- 
    ,nvl(n.updtd_date, o.updtd_date) as updtd_date -- 
    ,nvl(n.system_name, o.system_name) as system_name -- 
    ,nvl(n.account_bank_cname, o.account_bank_cname) as account_bank_cname -- 
    ,nvl(n.mid_bank_cname, o.mid_bank_cname) as mid_bank_cname -- 
    ,nvl(n.agency_bank_cname, o.agency_bank_cname) as agency_bank_cname -- 
    ,nvl(n.benifit_bank_cname, o.benifit_bank_cname) as benifit_bank_cname -- 
    ,nvl(n.order_bank_cname, o.order_bank_cname) as order_bank_cname -- 
    ,case when
            n.infr_srno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.infr_srno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.infr_srno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_fbs_v_swt_settle_path_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_fbs_v_swt_settle_path where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.infr_srno = n.infr_srno
where (
        o.infr_srno is null
    )
    or (
        n.infr_srno is null
    )
    or (
        o.cus_number <> n.cus_number
        or o.cus_branch_number <> n.cus_branch_number
        or o.settle_path_name <> n.settle_path_name
        or o.mem_code_srno <> n.mem_code_srno
        or o.crncy_accnt_code_desc <> n.crncy_accnt_code_desc
        or o.default_path_indc <> n.default_path_indc
        or o.settle_type_indc <> n.settle_type_indc
        or o.prdct_srno <> n.prdct_srno
        or o.account_bank_type <> n.account_bank_type
        or o.account_bank_bic <> n.account_bank_bic
        or o.account_bank_desc <> n.account_bank_desc
        or o.account_bank_accnt <> n.account_bank_accnt
        or o.benifit_bank_type <> n.benifit_bank_type
        or o.benifit_bank_bic <> n.benifit_bank_bic
        or o.benifit_bank_desc <> n.benifit_bank_desc
        or o.benifit_bank_accnt <> n.benifit_bank_accnt
        or o.mid_bank_type <> n.mid_bank_type
        or o.mid_bank_bic <> n.mid_bank_bic
        or o.mid_bank_desc <> n.mid_bank_desc
        or o.mid_bank_accnt <> n.mid_bank_accnt
        or o.agency_bank_type <> n.agency_bank_type
        or o.agency_bank_bic <> n.agency_bank_bic
        or o.agency_bank_desc <> n.agency_bank_desc
        or o.agency_bank_accnt <> n.agency_bank_accnt
        or o.order_bank_type <> n.order_bank_type
        or o.order_bank_bic <> n.order_bank_bic
        or o.order_bank_desc <> n.order_bank_desc
        or o.order_bank_account <> n.order_bank_account
        or o.crtd_user_id <> n.crtd_user_id
        or o.crtd_date <> n.crtd_date
        or o.updtd_user_id <> n.updtd_user_id
        or o.updtd_date <> n.updtd_date
        or o.system_name <> n.system_name
        or o.account_bank_cname <> n.account_bank_cname
        or o.mid_bank_cname <> n.mid_bank_cname
        or o.agency_bank_cname <> n.agency_bank_cname
        or o.benifit_bank_cname <> n.benifit_bank_cname
        or o.order_bank_cname <> n.order_bank_cname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_swt_settle_path_cl(
            infr_srno -- 
            ,cus_number -- 
            ,cus_branch_number -- 
            ,settle_path_name -- 
            ,mem_code_srno -- 
            ,crncy_accnt_code_desc -- 
            ,default_path_indc -- 
            ,settle_type_indc -- 
            ,prdct_srno -- 
            ,account_bank_type -- 
            ,account_bank_bic -- 
            ,account_bank_desc -- 
            ,account_bank_accnt -- 
            ,benifit_bank_type -- 
            ,benifit_bank_bic -- 
            ,benifit_bank_desc -- 
            ,benifit_bank_accnt -- 
            ,mid_bank_type -- 
            ,mid_bank_bic -- 
            ,mid_bank_desc -- 
            ,mid_bank_accnt -- 
            ,agency_bank_type -- 
            ,agency_bank_bic -- 
            ,agency_bank_desc -- 
            ,agency_bank_accnt -- 
            ,order_bank_type -- 
            ,order_bank_bic -- 
            ,order_bank_desc -- 
            ,order_bank_account -- 
            ,crtd_user_id -- 
            ,crtd_date -- 
            ,updtd_user_id -- 
            ,updtd_date -- 
            ,system_name -- 
            ,account_bank_cname -- 
            ,mid_bank_cname -- 
            ,agency_bank_cname -- 
            ,benifit_bank_cname -- 
            ,order_bank_cname -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_swt_settle_path_op(
            infr_srno -- 
            ,cus_number -- 
            ,cus_branch_number -- 
            ,settle_path_name -- 
            ,mem_code_srno -- 
            ,crncy_accnt_code_desc -- 
            ,default_path_indc -- 
            ,settle_type_indc -- 
            ,prdct_srno -- 
            ,account_bank_type -- 
            ,account_bank_bic -- 
            ,account_bank_desc -- 
            ,account_bank_accnt -- 
            ,benifit_bank_type -- 
            ,benifit_bank_bic -- 
            ,benifit_bank_desc -- 
            ,benifit_bank_accnt -- 
            ,mid_bank_type -- 
            ,mid_bank_bic -- 
            ,mid_bank_desc -- 
            ,mid_bank_accnt -- 
            ,agency_bank_type -- 
            ,agency_bank_bic -- 
            ,agency_bank_desc -- 
            ,agency_bank_accnt -- 
            ,order_bank_type -- 
            ,order_bank_bic -- 
            ,order_bank_desc -- 
            ,order_bank_account -- 
            ,crtd_user_id -- 
            ,crtd_date -- 
            ,updtd_user_id -- 
            ,updtd_date -- 
            ,system_name -- 
            ,account_bank_cname -- 
            ,mid_bank_cname -- 
            ,agency_bank_cname -- 
            ,benifit_bank_cname -- 
            ,order_bank_cname -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.infr_srno -- 
    ,o.cus_number -- 
    ,o.cus_branch_number -- 
    ,o.settle_path_name -- 
    ,o.mem_code_srno -- 
    ,o.crncy_accnt_code_desc -- 
    ,o.default_path_indc -- 
    ,o.settle_type_indc -- 
    ,o.prdct_srno -- 
    ,o.account_bank_type -- 
    ,o.account_bank_bic -- 
    ,o.account_bank_desc -- 
    ,o.account_bank_accnt -- 
    ,o.benifit_bank_type -- 
    ,o.benifit_bank_bic -- 
    ,o.benifit_bank_desc -- 
    ,o.benifit_bank_accnt -- 
    ,o.mid_bank_type -- 
    ,o.mid_bank_bic -- 
    ,o.mid_bank_desc -- 
    ,o.mid_bank_accnt -- 
    ,o.agency_bank_type -- 
    ,o.agency_bank_bic -- 
    ,o.agency_bank_desc -- 
    ,o.agency_bank_accnt -- 
    ,o.order_bank_type -- 
    ,o.order_bank_bic -- 
    ,o.order_bank_desc -- 
    ,o.order_bank_account -- 
    ,o.crtd_user_id -- 
    ,o.crtd_date -- 
    ,o.updtd_user_id -- 
    ,o.updtd_date -- 
    ,o.system_name -- 
    ,o.account_bank_cname -- 
    ,o.mid_bank_cname -- 
    ,o.agency_bank_cname -- 
    ,o.benifit_bank_cname -- 
    ,o.order_bank_cname -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_fbs_v_swt_settle_path_bk o
    left join ${iol_schema}.ctms_fbs_v_swt_settle_path_op n
        on
            o.infr_srno = n.infr_srno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_fbs_v_swt_settle_path_cl d
        on
            o.infr_srno = d.infr_srno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_fbs_v_swt_settle_path;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_fbs_v_swt_settle_path exchange partition p_19000101 with table ${iol_schema}.ctms_fbs_v_swt_settle_path_cl;
alter table ${iol_schema}.ctms_fbs_v_swt_settle_path exchange partition p_20991231 with table ${iol_schema}.ctms_fbs_v_swt_settle_path_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_v_swt_settle_path to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_swt_settle_path_op purge;
drop table ${iol_schema}.ctms_fbs_v_swt_settle_path_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_fbs_v_swt_settle_path_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_v_swt_settle_path',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
