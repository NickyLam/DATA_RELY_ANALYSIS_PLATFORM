/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_hx_credit_record
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
create table ${iol_schema}.ibms_ttrd_hx_credit_record_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_hx_credit_record
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_hx_credit_record_op purge;
drop table ${iol_schema}.ibms_ttrd_hx_credit_record_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_hx_credit_record_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_hx_credit_record where 0=1;

create table ${iol_schema}.ibms_ttrd_hx_credit_record_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_hx_credit_record where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_hx_credit_record_cl(
            id -- 序列,取S_TTRD_HX_CREDIT_COMMON
            ,ord_id -- 占信审批单号
            ,intordid -- 占信交易单号
            ,i_code -- 占信金融工具代码
            ,a_type -- 占信金融工具资产类型
            ,m_type -- 占信金融工具市场类型
            ,secu_accid -- 占信内部证券账户
            ,secu_actgtype -- 占信账户会计分类
            ,credit_secu_type -- 占信账户类别,Bank-银行账簿,Trade-交易账簿
            ,party_id -- 授信方
            ,party_name -- 授信方名称
            ,reply_code -- 额度合同编号
            ,occupy_amount -- 占信额度
            ,remain_amount -- 占信释放剩余额度
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_hx_credit_record_op(
            id -- 序列,取S_TTRD_HX_CREDIT_COMMON
            ,ord_id -- 占信审批单号
            ,intordid -- 占信交易单号
            ,i_code -- 占信金融工具代码
            ,a_type -- 占信金融工具资产类型
            ,m_type -- 占信金融工具市场类型
            ,secu_accid -- 占信内部证券账户
            ,secu_actgtype -- 占信账户会计分类
            ,credit_secu_type -- 占信账户类别,Bank-银行账簿,Trade-交易账簿
            ,party_id -- 授信方
            ,party_name -- 授信方名称
            ,reply_code -- 额度合同编号
            ,occupy_amount -- 占信额度
            ,remain_amount -- 占信释放剩余额度
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 序列,取S_TTRD_HX_CREDIT_COMMON
    ,nvl(n.ord_id, o.ord_id) as ord_id -- 占信审批单号
    ,nvl(n.intordid, o.intordid) as intordid -- 占信交易单号
    ,nvl(n.i_code, o.i_code) as i_code -- 占信金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 占信金融工具资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 占信金融工具市场类型
    ,nvl(n.secu_accid, o.secu_accid) as secu_accid -- 占信内部证券账户
    ,nvl(n.secu_actgtype, o.secu_actgtype) as secu_actgtype -- 占信账户会计分类
    ,nvl(n.credit_secu_type, o.credit_secu_type) as credit_secu_type -- 占信账户类别,Bank-银行账簿,Trade-交易账簿
    ,nvl(n.party_id, o.party_id) as party_id -- 授信方
    ,nvl(n.party_name, o.party_name) as party_name -- 授信方名称
    ,nvl(n.reply_code, o.reply_code) as reply_code -- 额度合同编号
    ,nvl(n.occupy_amount, o.occupy_amount) as occupy_amount -- 占信额度
    ,nvl(n.remain_amount, o.remain_amount) as remain_amount -- 占信释放剩余额度
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_hx_credit_record_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_hx_credit_record where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.ord_id <> n.ord_id
        or o.intordid <> n.intordid
        or o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.secu_accid <> n.secu_accid
        or o.secu_actgtype <> n.secu_actgtype
        or o.credit_secu_type <> n.credit_secu_type
        or o.party_id <> n.party_id
        or o.party_name <> n.party_name
        or o.reply_code <> n.reply_code
        or o.occupy_amount <> n.occupy_amount
        or o.remain_amount <> n.remain_amount
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_hx_credit_record_cl(
            id -- 序列,取S_TTRD_HX_CREDIT_COMMON
            ,ord_id -- 占信审批单号
            ,intordid -- 占信交易单号
            ,i_code -- 占信金融工具代码
            ,a_type -- 占信金融工具资产类型
            ,m_type -- 占信金融工具市场类型
            ,secu_accid -- 占信内部证券账户
            ,secu_actgtype -- 占信账户会计分类
            ,credit_secu_type -- 占信账户类别,Bank-银行账簿,Trade-交易账簿
            ,party_id -- 授信方
            ,party_name -- 授信方名称
            ,reply_code -- 额度合同编号
            ,occupy_amount -- 占信额度
            ,remain_amount -- 占信释放剩余额度
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_hx_credit_record_op(
            id -- 序列,取S_TTRD_HX_CREDIT_COMMON
            ,ord_id -- 占信审批单号
            ,intordid -- 占信交易单号
            ,i_code -- 占信金融工具代码
            ,a_type -- 占信金融工具资产类型
            ,m_type -- 占信金融工具市场类型
            ,secu_accid -- 占信内部证券账户
            ,secu_actgtype -- 占信账户会计分类
            ,credit_secu_type -- 占信账户类别,Bank-银行账簿,Trade-交易账簿
            ,party_id -- 授信方
            ,party_name -- 授信方名称
            ,reply_code -- 额度合同编号
            ,occupy_amount -- 占信额度
            ,remain_amount -- 占信释放剩余额度
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 序列,取S_TTRD_HX_CREDIT_COMMON
    ,o.ord_id -- 占信审批单号
    ,o.intordid -- 占信交易单号
    ,o.i_code -- 占信金融工具代码
    ,o.a_type -- 占信金融工具资产类型
    ,o.m_type -- 占信金融工具市场类型
    ,o.secu_accid -- 占信内部证券账户
    ,o.secu_actgtype -- 占信账户会计分类
    ,o.credit_secu_type -- 占信账户类别,Bank-银行账簿,Trade-交易账簿
    ,o.party_id -- 授信方
    ,o.party_name -- 授信方名称
    ,o.reply_code -- 额度合同编号
    ,o.occupy_amount -- 占信额度
    ,o.remain_amount -- 占信释放剩余额度
    ,o.update_time -- 更新时间
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
from ${iol_schema}.ibms_ttrd_hx_credit_record_bk o
    left join ${iol_schema}.ibms_ttrd_hx_credit_record_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_hx_credit_record_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_hx_credit_record;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_hx_credit_record') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_hx_credit_record drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_hx_credit_record add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_hx_credit_record exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_hx_credit_record_cl;
alter table ${iol_schema}.ibms_ttrd_hx_credit_record exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_hx_credit_record_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_hx_credit_record to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_hx_credit_record_op purge;
drop table ${iol_schema}.ibms_ttrd_hx_credit_record_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_hx_credit_record_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_hx_credit_record',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
