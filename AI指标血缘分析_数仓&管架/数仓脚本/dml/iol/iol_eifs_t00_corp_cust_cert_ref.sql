/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t00_corp_cust_cert_ref
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
create table ${iol_schema}.eifs_t00_corp_cust_cert_ref_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t00_corp_cust_cert_ref
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t00_corp_cust_cert_ref_op purge;
drop table ${iol_schema}.eifs_t00_corp_cust_cert_ref_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t00_corp_cust_cert_ref_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t00_corp_cust_cert_ref where 0=1;

create table ${iol_schema}.eifs_t00_corp_cust_cert_ref_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t00_corp_cust_cert_ref where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t00_corp_cust_cert_ref_cl(
            cert_index_seq -- 证件序列号
            ,party_id -- 参与人id
            ,cert_type_cd -- 证件类型
            ,cert_num -- 证件号码
            ,cust_name -- 客户名称
            ,cert_effect_dt -- 证件生效日期
            ,cert_valid -- 证件有效期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_rgst_addr -- 证件注册地址
            ,is_main_cert -- 是否主证件
            ,cert_issue_province -- 发证机关所属省
            ,cert_issue_zone_cd -- 发证机关地区代码
            ,cert_issue_org_name -- 证件签发机关名称
            ,annual_insp_ind -- 年检标志
            ,recnt_year_check_dt -- 最近一次年检日期
            ,is_net_check -- 是否联网核查
            ,network_verif -- 联网核查结果
            ,check_date -- 核查日期
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,cert_issue_zone_name -- 发证机关地区中文名称
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t00_corp_cust_cert_ref_op(
            cert_index_seq -- 证件序列号
            ,party_id -- 参与人id
            ,cert_type_cd -- 证件类型
            ,cert_num -- 证件号码
            ,cust_name -- 客户名称
            ,cert_effect_dt -- 证件生效日期
            ,cert_valid -- 证件有效期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_rgst_addr -- 证件注册地址
            ,is_main_cert -- 是否主证件
            ,cert_issue_province -- 发证机关所属省
            ,cert_issue_zone_cd -- 发证机关地区代码
            ,cert_issue_org_name -- 证件签发机关名称
            ,annual_insp_ind -- 年检标志
            ,recnt_year_check_dt -- 最近一次年检日期
            ,is_net_check -- 是否联网核查
            ,network_verif -- 联网核查结果
            ,check_date -- 核查日期
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,cert_issue_zone_name -- 发证机关地区中文名称
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cert_index_seq, o.cert_index_seq) as cert_index_seq -- 证件序列号
    ,nvl(n.party_id, o.party_id) as party_id -- 参与人id
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型
    ,nvl(n.cert_num, o.cert_num) as cert_num -- 证件号码
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_effect_dt, o.cert_effect_dt) as cert_effect_dt -- 证件生效日期
    ,nvl(n.cert_valid, o.cert_valid) as cert_valid -- 证件有效期
    ,nvl(n.cert_invalid_dt, o.cert_invalid_dt) as cert_invalid_dt -- 证件失效日期
    ,nvl(n.cert_rgst_addr, o.cert_rgst_addr) as cert_rgst_addr -- 证件注册地址
    ,nvl(n.is_main_cert, o.is_main_cert) as is_main_cert -- 是否主证件
    ,nvl(n.cert_issue_province, o.cert_issue_province) as cert_issue_province -- 发证机关所属省
    ,nvl(n.cert_issue_zone_cd, o.cert_issue_zone_cd) as cert_issue_zone_cd -- 发证机关地区代码
    ,nvl(n.cert_issue_org_name, o.cert_issue_org_name) as cert_issue_org_name -- 证件签发机关名称
    ,nvl(n.annual_insp_ind, o.annual_insp_ind) as annual_insp_ind -- 年检标志
    ,nvl(n.recnt_year_check_dt, o.recnt_year_check_dt) as recnt_year_check_dt -- 最近一次年检日期
    ,nvl(n.is_net_check, o.is_net_check) as is_net_check -- 是否联网核查
    ,nvl(n.network_verif, o.network_verif) as network_verif -- 联网核查结果
    ,nvl(n.check_date, o.check_date) as check_date -- 核查日期
    ,nvl(n.create_te, o.create_te) as create_te -- 创建柜员
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ecif的时间
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ecif中失效的时间
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间
    ,nvl(n.cert_issue_zone_name, o.cert_issue_zone_name) as cert_issue_zone_name -- 发证机关地区中文名称
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,case when
            n.cert_index_seq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cert_index_seq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cert_index_seq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t00_corp_cust_cert_ref_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t00_corp_cust_cert_ref where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cert_index_seq = n.cert_index_seq
where (
        o.cert_index_seq is null
    )
    or (
        n.cert_index_seq is null
    )
    or (
        o.party_id <> n.party_id
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_num <> n.cert_num
        or o.cust_name <> n.cust_name
        or o.cert_effect_dt <> n.cert_effect_dt
        or o.cert_valid <> n.cert_valid
        or o.cert_invalid_dt <> n.cert_invalid_dt
        or o.cert_rgst_addr <> n.cert_rgst_addr
        or o.is_main_cert <> n.is_main_cert
        or o.cert_issue_province <> n.cert_issue_province
        or o.cert_issue_zone_cd <> n.cert_issue_zone_cd
        or o.cert_issue_org_name <> n.cert_issue_org_name
        or o.annual_insp_ind <> n.annual_insp_ind
        or o.recnt_year_check_dt <> n.recnt_year_check_dt
        or o.is_net_check <> n.is_net_check
        or o.network_verif <> n.network_verif
        or o.check_date <> n.check_date
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.updated_ts <> n.updated_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.cert_issue_zone_name <> n.cert_issue_zone_name
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t00_corp_cust_cert_ref_cl(
            cert_index_seq -- 证件序列号
            ,party_id -- 参与人id
            ,cert_type_cd -- 证件类型
            ,cert_num -- 证件号码
            ,cust_name -- 客户名称
            ,cert_effect_dt -- 证件生效日期
            ,cert_valid -- 证件有效期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_rgst_addr -- 证件注册地址
            ,is_main_cert -- 是否主证件
            ,cert_issue_province -- 发证机关所属省
            ,cert_issue_zone_cd -- 发证机关地区代码
            ,cert_issue_org_name -- 证件签发机关名称
            ,annual_insp_ind -- 年检标志
            ,recnt_year_check_dt -- 最近一次年检日期
            ,is_net_check -- 是否联网核查
            ,network_verif -- 联网核查结果
            ,check_date -- 核查日期
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,cert_issue_zone_name -- 发证机关地区中文名称
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t00_corp_cust_cert_ref_op(
            cert_index_seq -- 证件序列号
            ,party_id -- 参与人id
            ,cert_type_cd -- 证件类型
            ,cert_num -- 证件号码
            ,cust_name -- 客户名称
            ,cert_effect_dt -- 证件生效日期
            ,cert_valid -- 证件有效期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_rgst_addr -- 证件注册地址
            ,is_main_cert -- 是否主证件
            ,cert_issue_province -- 发证机关所属省
            ,cert_issue_zone_cd -- 发证机关地区代码
            ,cert_issue_org_name -- 证件签发机关名称
            ,annual_insp_ind -- 年检标志
            ,recnt_year_check_dt -- 最近一次年检日期
            ,is_net_check -- 是否联网核查
            ,network_verif -- 联网核查结果
            ,check_date -- 核查日期
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,cert_issue_zone_name -- 发证机关地区中文名称
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cert_index_seq -- 证件序列号
    ,o.party_id -- 参与人id
    ,o.cert_type_cd -- 证件类型
    ,o.cert_num -- 证件号码
    ,o.cust_name -- 客户名称
    ,o.cert_effect_dt -- 证件生效日期
    ,o.cert_valid -- 证件有效期
    ,o.cert_invalid_dt -- 证件失效日期
    ,o.cert_rgst_addr -- 证件注册地址
    ,o.is_main_cert -- 是否主证件
    ,o.cert_issue_province -- 发证机关所属省
    ,o.cert_issue_zone_cd -- 发证机关地区代码
    ,o.cert_issue_org_name -- 证件签发机关名称
    ,o.annual_insp_ind -- 年检标志
    ,o.recnt_year_check_dt -- 最近一次年检日期
    ,o.is_net_check -- 是否联网核查
    ,o.network_verif -- 联网核查结果
    ,o.check_date -- 核查日期
    ,o.create_te -- 创建柜员
    ,o.create_org -- 创建机构号
    ,o.init_system_id -- 创建渠道
    ,o.init_created_ts -- 源系统创建时间
    ,o.created_ts -- 进入ecif的时间
    ,o.updated_ts -- 在ecif中失效的时间
    ,o.last_updated_te -- 最新更新柜员
    ,o.last_updated_org -- 最新更新机构号
    ,o.last_system_id -- 最新更新渠道
    ,o.last_updated_ts -- 最新更新时间
    ,o.cert_issue_zone_name -- 发证机关地区中文名称
    ,o.src_sys_num -- 来源系统编号
    ,o.last_updated_src_sys_num -- 最新更新源系统编号
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
from ${iol_schema}.eifs_t00_corp_cust_cert_ref_bk o
    left join ${iol_schema}.eifs_t00_corp_cust_cert_ref_op n
        on
            o.cert_index_seq = n.cert_index_seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t00_corp_cust_cert_ref_cl d
        on
            o.cert_index_seq = d.cert_index_seq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t00_corp_cust_cert_ref;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t00_corp_cust_cert_ref') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t00_corp_cust_cert_ref drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t00_corp_cust_cert_ref add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t00_corp_cust_cert_ref exchange partition p_${batch_date} with table ${iol_schema}.eifs_t00_corp_cust_cert_ref_cl;
alter table ${iol_schema}.eifs_t00_corp_cust_cert_ref exchange partition p_20991231 with table ${iol_schema}.eifs_t00_corp_cust_cert_ref_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t00_corp_cust_cert_ref to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t00_corp_cust_cert_ref_op purge;
drop table ${iol_schema}.eifs_t00_corp_cust_cert_ref_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t00_corp_cust_cert_ref_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t00_corp_cust_cert_ref',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
