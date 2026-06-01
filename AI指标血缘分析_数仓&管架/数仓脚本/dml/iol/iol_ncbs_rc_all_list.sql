/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rc_all_list
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
create table ${iol_schema}.ncbs_rc_all_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rc_all_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rc_all_list_op purge;
drop table ${iol_schema}.ncbs_rc_all_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rc_all_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rc_all_list where 0=1;

create table ${iol_schema}.ncbs_rc_all_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rc_all_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rc_all_list_cl(
            acct_name -- 账户名称
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,document_type -- 客户证件类型
            ,user_id -- 交易柜员编号
            ,list_type -- 名单类型代码
            ,company -- 法人
            ,data_type -- 数据类型
            ,data_value -- 数据值
            ,list_category -- 名单种类代码
            ,narrative -- 摘要
            ,our_bank_flag -- 黑名单客户标志
            ,source_type -- 渠道编号
            ,effect_date -- 产品生效日期
            ,maturity_date -- 到期日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,input_branch -- 录入机构
            ,list_org -- 名单发送/审核机构
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rc_all_list_op(
            acct_name -- 账户名称
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,document_type -- 客户证件类型
            ,user_id -- 交易柜员编号
            ,list_type -- 名单类型代码
            ,company -- 法人
            ,data_type -- 数据类型
            ,data_value -- 数据值
            ,list_category -- 名单种类代码
            ,narrative -- 摘要
            ,our_bank_flag -- 黑名单客户标志
            ,source_type -- 渠道编号
            ,effect_date -- 产品生效日期
            ,maturity_date -- 到期日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,input_branch -- 录入机构
            ,list_org -- 名单发送/审核机构
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.list_type, o.list_type) as list_type -- 名单类型代码
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.data_type, o.data_type) as data_type -- 数据类型
    ,nvl(n.data_value, o.data_value) as data_value -- 数据值
    ,nvl(n.list_category, o.list_category) as list_category -- 名单种类代码
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.our_bank_flag, o.our_bank_flag) as our_bank_flag -- 黑名单客户标志
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.iss_country, o.iss_country) as iss_country -- 发证国家
    ,nvl(n.input_branch, o.input_branch) as input_branch -- 录入机构
    ,nvl(n.list_org, o.list_org) as list_org -- 名单发送/审核机构
    ,nvl(n.remark1, o.remark1) as remark1 -- 备注1
    ,nvl(n.remark2, o.remark2) as remark2 -- 备注2
    ,nvl(n.remark3, o.remark3) as remark3 -- 备注3
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.acct_name is null
            and n.list_type is null
            and n.data_type is null
            and n.data_value is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acct_name is null
            and n.list_type is null
            and n.data_type is null
            and n.data_value is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acct_name is null
            and n.list_type is null
            and n.data_type is null
            and n.data_value is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rc_all_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rc_all_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acct_name = n.acct_name
            and o.list_type = n.list_type
            and o.data_type = n.data_type
            and o.data_value = n.data_value
where (
        o.acct_name is null
        and o.list_type is null
        and o.data_type is null
        and o.data_value is null
    )
    or (
        n.acct_name is null
        and n.list_type is null
        and n.data_type is null
        and n.data_value is null
    )
    or (
        o.client_name <> n.client_name
        or o.client_no <> n.client_no
        or o.document_type <> n.document_type
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.list_category <> n.list_category
        or o.narrative <> n.narrative
        or o.our_bank_flag <> n.our_bank_flag
        or o.source_type <> n.source_type
        or o.effect_date <> n.effect_date
        or o.maturity_date <> n.maturity_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.iss_country <> n.iss_country
        or o.input_branch <> n.input_branch
        or o.list_org <> n.list_org
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.remark3 <> n.remark3
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rc_all_list_cl(
            acct_name -- 账户名称
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,document_type -- 客户证件类型
            ,user_id -- 交易柜员编号
            ,list_type -- 名单类型代码
            ,company -- 法人
            ,data_type -- 数据类型
            ,data_value -- 数据值
            ,list_category -- 名单种类代码
            ,narrative -- 摘要
            ,our_bank_flag -- 黑名单客户标志
            ,source_type -- 渠道编号
            ,effect_date -- 产品生效日期
            ,maturity_date -- 到期日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,input_branch -- 录入机构
            ,list_org -- 名单发送/审核机构
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rc_all_list_op(
            acct_name -- 账户名称
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,document_type -- 客户证件类型
            ,user_id -- 交易柜员编号
            ,list_type -- 名单类型代码
            ,company -- 法人
            ,data_type -- 数据类型
            ,data_value -- 数据值
            ,list_category -- 名单种类代码
            ,narrative -- 摘要
            ,our_bank_flag -- 黑名单客户标志
            ,source_type -- 渠道编号
            ,effect_date -- 产品生效日期
            ,maturity_date -- 到期日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,input_branch -- 录入机构
            ,list_org -- 名单发送/审核机构
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.client_name -- 客户名称
    ,o.client_no -- 客户编号
    ,o.document_type -- 客户证件类型
    ,o.user_id -- 交易柜员编号
    ,o.list_type -- 名单类型代码
    ,o.company -- 法人
    ,o.data_type -- 数据类型
    ,o.data_value -- 数据值
    ,o.list_category -- 名单种类代码
    ,o.narrative -- 摘要
    ,o.our_bank_flag -- 黑名单客户标志
    ,o.source_type -- 渠道编号
    ,o.effect_date -- 产品生效日期
    ,o.maturity_date -- 到期日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.iss_country -- 发证国家
    ,o.input_branch -- 录入机构
    ,o.list_org -- 名单发送/审核机构
    ,o.remark1 -- 备注1
    ,o.remark2 -- 备注2
    ,o.remark3 -- 备注3
    ,o.tran_branch -- 核心交易机构编号
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
from ${iol_schema}.ncbs_rc_all_list_bk o
    left join ${iol_schema}.ncbs_rc_all_list_op n
        on
            o.acct_name = n.acct_name
            and o.list_type = n.list_type
            and o.data_type = n.data_type
            and o.data_value = n.data_value
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rc_all_list_cl d
        on
            o.acct_name = d.acct_name
            and o.list_type = d.list_type
            and o.data_type = d.data_type
            and o.data_value = d.data_value
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rc_all_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rc_all_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rc_all_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rc_all_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rc_all_list exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rc_all_list_cl;
alter table ${iol_schema}.ncbs_rc_all_list exchange partition p_20991231 with table ${iol_schema}.ncbs_rc_all_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rc_all_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rc_all_list_op purge;
drop table ${iol_schema}.ncbs_rc_all_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rc_all_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rc_all_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
