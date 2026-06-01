/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tcs_tbclientext
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
create table ${iol_schema}.nfss_tcs_tbclientext_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tcs_tbclientext;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tcs_tbclientext_op purge;
drop table ${iol_schema}.nfss_tcs_tbclientext_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbclientext_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tcs_tbclientext where 0=1;

create table ${iol_schema}.nfss_tcs_tbclientext_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tcs_tbclientext where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tcs_tbclientext_cl(
            in_client_no -- 
            ,adrtype -- 
            ,adrsta -- 
            ,adrcty -- 
            ,adrsec -- 
            ,adrdet -- 
            ,telint -- 
            ,telzon -- 
            ,telnum -- 
            ,telext -- 
            ,mobint -- 
            ,gzdw -- 
            ,hy -- 
            ,xqah -- 
            ,hyzt -- 
            ,jrzc -- 
            ,zzsyq -- 
            ,jtgj -- 
            ,jtkhlx -- 
            ,khsqjb -- 
            ,sqjbxgsj -- 
            ,zyyw -- 
            ,nzsr -- 
            ,zzlx -- 
            ,ygrs -- 
            ,zhxgyh -- 
            ,zhxgsj -- 
            ,reserve1 -- 
            ,investor_type -- 
            ,fold_in_client_no -- 
            ,fold_id_type -- 
            ,fold_id_code -- 
            ,modify_flag -- 
            ,fdaily_upd_date -- 
            ,other_id_type_name -- 
            ,fold_client_name -- 
            ,old_other_id_type_name -- 
            ,host_id_type -- 
            ,old_host_id_type -- 
            ,spv_branch -- 
            ,other_branch -- 
            ,spv_account -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tcs_tbclientext_op(
            in_client_no -- 
            ,adrtype -- 
            ,adrsta -- 
            ,adrcty -- 
            ,adrsec -- 
            ,adrdet -- 
            ,telint -- 
            ,telzon -- 
            ,telnum -- 
            ,telext -- 
            ,mobint -- 
            ,gzdw -- 
            ,hy -- 
            ,xqah -- 
            ,hyzt -- 
            ,jrzc -- 
            ,zzsyq -- 
            ,jtgj -- 
            ,jtkhlx -- 
            ,khsqjb -- 
            ,sqjbxgsj -- 
            ,zyyw -- 
            ,nzsr -- 
            ,zzlx -- 
            ,ygrs -- 
            ,zhxgyh -- 
            ,zhxgsj -- 
            ,reserve1 -- 
            ,investor_type -- 
            ,fold_in_client_no -- 
            ,fold_id_type -- 
            ,fold_id_code -- 
            ,modify_flag -- 
            ,fdaily_upd_date -- 
            ,other_id_type_name -- 
            ,fold_client_name -- 
            ,old_other_id_type_name -- 
            ,host_id_type -- 
            ,old_host_id_type -- 
            ,spv_branch -- 
            ,other_branch -- 
            ,spv_account -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.adrtype, o.adrtype) as adrtype -- 
    ,nvl(n.adrsta, o.adrsta) as adrsta -- 
    ,nvl(n.adrcty, o.adrcty) as adrcty -- 
    ,nvl(n.adrsec, o.adrsec) as adrsec -- 
    ,nvl(n.adrdet, o.adrdet) as adrdet -- 
    ,nvl(n.telint, o.telint) as telint -- 
    ,nvl(n.telzon, o.telzon) as telzon -- 
    ,nvl(n.telnum, o.telnum) as telnum -- 
    ,nvl(n.telext, o.telext) as telext -- 
    ,nvl(n.mobint, o.mobint) as mobint -- 
    ,nvl(n.gzdw, o.gzdw) as gzdw -- 
    ,nvl(n.hy, o.hy) as hy -- 
    ,nvl(n.xqah, o.xqah) as xqah -- 
    ,nvl(n.hyzt, o.hyzt) as hyzt -- 
    ,nvl(n.jrzc, o.jrzc) as jrzc -- 
    ,nvl(n.zzsyq, o.zzsyq) as zzsyq -- 
    ,nvl(n.jtgj, o.jtgj) as jtgj -- 
    ,nvl(n.jtkhlx, o.jtkhlx) as jtkhlx -- 
    ,nvl(n.khsqjb, o.khsqjb) as khsqjb -- 
    ,nvl(n.sqjbxgsj, o.sqjbxgsj) as sqjbxgsj -- 
    ,nvl(n.zyyw, o.zyyw) as zyyw -- 
    ,nvl(n.nzsr, o.nzsr) as nzsr -- 
    ,nvl(n.zzlx, o.zzlx) as zzlx -- 
    ,nvl(n.ygrs, o.ygrs) as ygrs -- 
    ,nvl(n.zhxgyh, o.zhxgyh) as zhxgyh -- 
    ,nvl(n.zhxgsj, o.zhxgsj) as zhxgsj -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.investor_type, o.investor_type) as investor_type -- 
    ,nvl(n.fold_in_client_no, o.fold_in_client_no) as fold_in_client_no -- 
    ,nvl(n.fold_id_type, o.fold_id_type) as fold_id_type -- 
    ,nvl(n.fold_id_code, o.fold_id_code) as fold_id_code -- 
    ,nvl(n.modify_flag, o.modify_flag) as modify_flag -- 
    ,nvl(n.fdaily_upd_date, o.fdaily_upd_date) as fdaily_upd_date -- 
    ,nvl(n.other_id_type_name, o.other_id_type_name) as other_id_type_name -- 
    ,nvl(n.fold_client_name, o.fold_client_name) as fold_client_name -- 
    ,nvl(n.old_other_id_type_name, o.old_other_id_type_name) as old_other_id_type_name -- 
    ,nvl(n.host_id_type, o.host_id_type) as host_id_type -- 
    ,nvl(n.old_host_id_type, o.old_host_id_type) as old_host_id_type -- 
    ,nvl(n.spv_branch, o.spv_branch) as spv_branch -- 
    ,nvl(n.other_branch, o.other_branch) as other_branch -- 
    ,nvl(n.spv_account, o.spv_account) as spv_account -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 
    ,case when
            n.in_client_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.in_client_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.in_client_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tcs_tbclientext_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tcs_tbclientext where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.in_client_no = n.in_client_no
where (
        o.in_client_no is null
    )
    or (
        n.in_client_no is null
    )
    or (
        o.adrtype <> n.adrtype
        or o.adrsta <> n.adrsta
        or o.adrcty <> n.adrcty
        or o.adrsec <> n.adrsec
        or o.adrdet <> n.adrdet
        or o.telint <> n.telint
        or o.telzon <> n.telzon
        or o.telnum <> n.telnum
        or o.telext <> n.telext
        or o.mobint <> n.mobint
        or o.gzdw <> n.gzdw
        or o.hy <> n.hy
        or o.xqah <> n.xqah
        or o.hyzt <> n.hyzt
        or o.jrzc <> n.jrzc
        or o.zzsyq <> n.zzsyq
        or o.jtgj <> n.jtgj
        or o.jtkhlx <> n.jtkhlx
        or o.khsqjb <> n.khsqjb
        or o.sqjbxgsj <> n.sqjbxgsj
        or o.zyyw <> n.zyyw
        or o.nzsr <> n.nzsr
        or o.zzlx <> n.zzlx
        or o.ygrs <> n.ygrs
        or o.zhxgyh <> n.zhxgyh
        or o.zhxgsj <> n.zhxgsj
        or o.reserve1 <> n.reserve1
        or o.investor_type <> n.investor_type
        or o.fold_in_client_no <> n.fold_in_client_no
        or o.fold_id_type <> n.fold_id_type
        or o.fold_id_code <> n.fold_id_code
        or o.modify_flag <> n.modify_flag
        or o.fdaily_upd_date <> n.fdaily_upd_date
        or o.other_id_type_name <> n.other_id_type_name
        or o.fold_client_name <> n.fold_client_name
        or o.old_other_id_type_name <> n.old_other_id_type_name
        or o.host_id_type <> n.host_id_type
        or o.old_host_id_type <> n.old_host_id_type
        or o.spv_branch <> n.spv_branch
        or o.other_branch <> n.other_branch
        or o.spv_account <> n.spv_account
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tcs_tbclientext_cl(
            in_client_no -- 
            ,adrtype -- 
            ,adrsta -- 
            ,adrcty -- 
            ,adrsec -- 
            ,adrdet -- 
            ,telint -- 
            ,telzon -- 
            ,telnum -- 
            ,telext -- 
            ,mobint -- 
            ,gzdw -- 
            ,hy -- 
            ,xqah -- 
            ,hyzt -- 
            ,jrzc -- 
            ,zzsyq -- 
            ,jtgj -- 
            ,jtkhlx -- 
            ,khsqjb -- 
            ,sqjbxgsj -- 
            ,zyyw -- 
            ,nzsr -- 
            ,zzlx -- 
            ,ygrs -- 
            ,zhxgyh -- 
            ,zhxgsj -- 
            ,reserve1 -- 
            ,investor_type -- 
            ,fold_in_client_no -- 
            ,fold_id_type -- 
            ,fold_id_code -- 
            ,modify_flag -- 
            ,fdaily_upd_date -- 
            ,other_id_type_name -- 
            ,fold_client_name -- 
            ,old_other_id_type_name -- 
            ,host_id_type -- 
            ,old_host_id_type -- 
            ,spv_branch -- 
            ,other_branch -- 
            ,spv_account -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tcs_tbclientext_op(
            in_client_no -- 
            ,adrtype -- 
            ,adrsta -- 
            ,adrcty -- 
            ,adrsec -- 
            ,adrdet -- 
            ,telint -- 
            ,telzon -- 
            ,telnum -- 
            ,telext -- 
            ,mobint -- 
            ,gzdw -- 
            ,hy -- 
            ,xqah -- 
            ,hyzt -- 
            ,jrzc -- 
            ,zzsyq -- 
            ,jtgj -- 
            ,jtkhlx -- 
            ,khsqjb -- 
            ,sqjbxgsj -- 
            ,zyyw -- 
            ,nzsr -- 
            ,zzlx -- 
            ,ygrs -- 
            ,zhxgyh -- 
            ,zhxgsj -- 
            ,reserve1 -- 
            ,investor_type -- 
            ,fold_in_client_no -- 
            ,fold_id_type -- 
            ,fold_id_code -- 
            ,modify_flag -- 
            ,fdaily_upd_date -- 
            ,other_id_type_name -- 
            ,fold_client_name -- 
            ,old_other_id_type_name -- 
            ,host_id_type -- 
            ,old_host_id_type -- 
            ,spv_branch -- 
            ,other_branch -- 
            ,spv_account -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.in_client_no -- 
    ,o.adrtype -- 
    ,o.adrsta -- 
    ,o.adrcty -- 
    ,o.adrsec -- 
    ,o.adrdet -- 
    ,o.telint -- 
    ,o.telzon -- 
    ,o.telnum -- 
    ,o.telext -- 
    ,o.mobint -- 
    ,o.gzdw -- 
    ,o.hy -- 
    ,o.xqah -- 
    ,o.hyzt -- 
    ,o.jrzc -- 
    ,o.zzsyq -- 
    ,o.jtgj -- 
    ,o.jtkhlx -- 
    ,o.khsqjb -- 
    ,o.sqjbxgsj -- 
    ,o.zyyw -- 
    ,o.nzsr -- 
    ,o.zzlx -- 
    ,o.ygrs -- 
    ,o.zhxgyh -- 
    ,o.zhxgsj -- 
    ,o.reserve1 -- 
    ,o.investor_type -- 
    ,o.fold_in_client_no -- 
    ,o.fold_id_type -- 
    ,o.fold_id_code -- 
    ,o.modify_flag -- 
    ,o.fdaily_upd_date -- 
    ,o.other_id_type_name -- 
    ,o.fold_client_name -- 
    ,o.old_other_id_type_name -- 
    ,o.host_id_type -- 
    ,o.old_host_id_type -- 
    ,o.spv_branch -- 
    ,o.other_branch -- 
    ,o.spv_account -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.reserve4 -- 
    ,o.reserve5 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tcs_tbclientext_bk o
    left join ${iol_schema}.nfss_tcs_tbclientext_op n
        on
            o.in_client_no = n.in_client_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tcs_tbclientext_cl d
        on
            o.in_client_no = d.in_client_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tcs_tbclientext;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tcs_tbclientext exchange partition p_19000101 with table ${iol_schema}.nfss_tcs_tbclientext_cl;
alter table ${iol_schema}.nfss_tcs_tbclientext exchange partition p_20991231 with table ${iol_schema}.nfss_tcs_tbclientext_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tcs_tbclientext to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tcs_tbclientext_op purge;
drop table ${iol_schema}.nfss_tcs_tbclientext_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tcs_tbclientext_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tcs_tbclientext',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
