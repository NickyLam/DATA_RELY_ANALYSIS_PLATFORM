/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fzss_mod_fzs_main_acct_info
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
create table ${iol_schema}.fzss_mod_fzs_main_acct_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fzss_mod_fzs_main_acct_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_main_acct_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_main_acct_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_main_acct_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fzss_mod_fzs_main_acct_info where 0=1;

create table ${iol_schema}.fzss_mod_fzs_main_acct_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fzss_mod_fzs_main_acct_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fzss_mod_fzs_main_acct_info_cl(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,ref_acct_type -- 关联账号类型 [枚举: 1-一般户,2-存单开户账户,3-存单利息账户,4-绑定提现账户]
            ,ref_seq -- 关联序号 可用于排序
            ,base_acct_no -- 账号
            ,base_acct_name -- 户名 监管账户的正式名称（官方注释：资金监管账户名）
            ,bank_flag -- 行内外标志 [枚举: 1-行内,2-行外]
            ,cnaps_branch_id -- 联行号
            ,open_bank_no -- 开户机构号
            ,is_need_downhost -- 是否需要下载核心流水 [枚举: 0-否,1-是]
            ,downhost_dealstatus -- 流水下载状态 [枚举: 0-处理中,1-空闲]
            ,downhost_date -- 流水最后下载日期
            ,downhost_pagenum -- 流水最后下载页码 从0开始算
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fzss_mod_fzs_main_acct_info_op(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,ref_acct_type -- 关联账号类型 [枚举: 1-一般户,2-存单开户账户,3-存单利息账户,4-绑定提现账户]
            ,ref_seq -- 关联序号 可用于排序
            ,base_acct_no -- 账号
            ,base_acct_name -- 户名 监管账户的正式名称（官方注释：资金监管账户名）
            ,bank_flag -- 行内外标志 [枚举: 1-行内,2-行外]
            ,cnaps_branch_id -- 联行号
            ,open_bank_no -- 开户机构号
            ,is_need_downhost -- 是否需要下载核心流水 [枚举: 0-否,1-是]
            ,downhost_dealstatus -- 流水下载状态 [枚举: 0-处理中,1-空闲]
            ,downhost_date -- 流水最后下载日期
            ,downhost_pagenum -- 流水最后下载页码 从0开始算
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.corp_id, o.corp_id) as corp_id -- 平台商户号
    ,nvl(n.mybank, o.mybank) as mybank -- 法人标识代码
    ,nvl(n.zone_no, o.zone_no) as zone_no -- 分行号
    ,nvl(n.ref_acct_type, o.ref_acct_type) as ref_acct_type -- 关联账号类型 [枚举: 1-一般户,2-存单开户账户,3-存单利息账户,4-绑定提现账户]
    ,nvl(n.ref_seq, o.ref_seq) as ref_seq -- 关联序号 可用于排序
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 账号
    ,nvl(n.base_acct_name, o.base_acct_name) as base_acct_name -- 户名 监管账户的正式名称（官方注释：资金监管账户名）
    ,nvl(n.bank_flag, o.bank_flag) as bank_flag -- 行内外标志 [枚举: 1-行内,2-行外]
    ,nvl(n.cnaps_branch_id, o.cnaps_branch_id) as cnaps_branch_id -- 联行号
    ,nvl(n.open_bank_no, o.open_bank_no) as open_bank_no -- 开户机构号
    ,nvl(n.is_need_downhost, o.is_need_downhost) as is_need_downhost -- 是否需要下载核心流水 [枚举: 0-否,1-是]
    ,nvl(n.downhost_dealstatus, o.downhost_dealstatus) as downhost_dealstatus -- 流水下载状态 [枚举: 0-处理中,1-空闲]
    ,nvl(n.downhost_date, o.downhost_date) as downhost_date -- 流水最后下载日期
    ,nvl(n.downhost_pagenum, o.downhost_pagenum) as downhost_pagenum -- 流水最后下载页码 从0开始算
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 更新时间戳
    ,case when
            n.corp_id is null
            and n.ref_acct_type is null
            and n.ref_seq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.corp_id is null
            and n.ref_acct_type is null
            and n.ref_seq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.corp_id is null
            and n.ref_acct_type is null
            and n.ref_seq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fzss_mod_fzs_main_acct_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fzss_mod_fzs_main_acct_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.corp_id = n.corp_id
            and o.ref_acct_type = n.ref_acct_type
            and o.ref_seq = n.ref_seq
where (
        o.corp_id is null
        and o.ref_acct_type is null
        and o.ref_seq is null
    )
    or (
        n.corp_id is null
        and n.ref_acct_type is null
        and n.ref_seq is null
    )
    or (
        o.mybank <> n.mybank
        or o.zone_no <> n.zone_no
        or o.base_acct_no <> n.base_acct_no
        or o.base_acct_name <> n.base_acct_name
        or o.bank_flag <> n.bank_flag
        or o.cnaps_branch_id <> n.cnaps_branch_id
        or o.open_bank_no <> n.open_bank_no
        or o.is_need_downhost <> n.is_need_downhost
        or o.downhost_dealstatus <> n.downhost_dealstatus
        or o.downhost_date <> n.downhost_date
        or o.downhost_pagenum <> n.downhost_pagenum
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fzss_mod_fzs_main_acct_info_cl(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,ref_acct_type -- 关联账号类型 [枚举: 1-一般户,2-存单开户账户,3-存单利息账户,4-绑定提现账户]
            ,ref_seq -- 关联序号 可用于排序
            ,base_acct_no -- 账号
            ,base_acct_name -- 户名 监管账户的正式名称（官方注释：资金监管账户名）
            ,bank_flag -- 行内外标志 [枚举: 1-行内,2-行外]
            ,cnaps_branch_id -- 联行号
            ,open_bank_no -- 开户机构号
            ,is_need_downhost -- 是否需要下载核心流水 [枚举: 0-否,1-是]
            ,downhost_dealstatus -- 流水下载状态 [枚举: 0-处理中,1-空闲]
            ,downhost_date -- 流水最后下载日期
            ,downhost_pagenum -- 流水最后下载页码 从0开始算
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fzss_mod_fzs_main_acct_info_op(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,ref_acct_type -- 关联账号类型 [枚举: 1-一般户,2-存单开户账户,3-存单利息账户,4-绑定提现账户]
            ,ref_seq -- 关联序号 可用于排序
            ,base_acct_no -- 账号
            ,base_acct_name -- 户名 监管账户的正式名称（官方注释：资金监管账户名）
            ,bank_flag -- 行内外标志 [枚举: 1-行内,2-行外]
            ,cnaps_branch_id -- 联行号
            ,open_bank_no -- 开户机构号
            ,is_need_downhost -- 是否需要下载核心流水 [枚举: 0-否,1-是]
            ,downhost_dealstatus -- 流水下载状态 [枚举: 0-处理中,1-空闲]
            ,downhost_date -- 流水最后下载日期
            ,downhost_pagenum -- 流水最后下载页码 从0开始算
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.corp_id -- 平台商户号
    ,o.mybank -- 法人标识代码
    ,o.zone_no -- 分行号
    ,o.ref_acct_type -- 关联账号类型 [枚举: 1-一般户,2-存单开户账户,3-存单利息账户,4-绑定提现账户]
    ,o.ref_seq -- 关联序号 可用于排序
    ,o.base_acct_no -- 账号
    ,o.base_acct_name -- 户名 监管账户的正式名称（官方注释：资金监管账户名）
    ,o.bank_flag -- 行内外标志 [枚举: 1-行内,2-行外]
    ,o.cnaps_branch_id -- 联行号
    ,o.open_bank_no -- 开户机构号
    ,o.is_need_downhost -- 是否需要下载核心流水 [枚举: 0-否,1-是]
    ,o.downhost_dealstatus -- 流水下载状态 [枚举: 0-处理中,1-空闲]
    ,o.downhost_date -- 流水最后下载日期
    ,o.downhost_pagenum -- 流水最后下载页码 从0开始算
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.fzss_mod_fzs_main_acct_info_bk o
    left join ${iol_schema}.fzss_mod_fzs_main_acct_info_op n
        on
            o.corp_id = n.corp_id
            and o.ref_acct_type = n.ref_acct_type
            and o.ref_seq = n.ref_seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fzss_mod_fzs_main_acct_info_cl d
        on
            o.corp_id = d.corp_id
            and o.ref_acct_type = d.ref_acct_type
            and o.ref_seq = d.ref_seq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fzss_mod_fzs_main_acct_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fzss_mod_fzs_main_acct_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fzss_mod_fzs_main_acct_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fzss_mod_fzs_main_acct_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fzss_mod_fzs_main_acct_info exchange partition p_${batch_date} with table ${iol_schema}.fzss_mod_fzs_main_acct_info_cl;
alter table ${iol_schema}.fzss_mod_fzs_main_acct_info exchange partition p_20991231 with table ${iol_schema}.fzss_mod_fzs_main_acct_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fzss_mod_fzs_main_acct_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_main_acct_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_main_acct_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fzss_mod_fzs_main_acct_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fzss_mod_fzs_main_acct_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
