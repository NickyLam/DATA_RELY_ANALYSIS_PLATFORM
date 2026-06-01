/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_intstl_addr_rela_h_isbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_intstl_addr_rela_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_intstl_addr_rela_h partition for ('isbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_tm purge;
drop table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_op purge;
drop table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    rela_id -- 关联编号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,addr_desc -- 地址描述
    ,main_addr_flg -- 主地址标志
    ,addr_id -- 地址编号
    ,bic_code -- BIC码
    ,addr_status_cd -- 地址状态代码
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_intstl_addr_rela_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_intstl_addr_rela_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_intstl_addr_rela_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_pta-1
insert into ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_tm(
    rela_id -- 关联编号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,addr_desc -- 地址描述
    ,main_addr_flg -- 主地址标志
    ,addr_id -- 地址编号
    ,bic_code -- BIC码
    ,addr_status_cd -- 地址状态代码
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.INR -- 关联编号
    ,'9999' -- 法人编号
    ,P1.PTYINR -- 当事人编号
    ,P1.NAM -- 地址描述
    ,P1.PRI -- 主地址标志
    ,P1.OBJINR -- 地址编号
    ,P1.BIC -- BIC码
    ,P1.ADRSTA -- 地址状态代码
    ,P1.BRANCHINR -- 所属机构编号
    ,P1.BCHKEYINR -- 交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_pta' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_pta p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_cl(
            rela_id -- 关联编号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,addr_desc -- 地址描述
    ,main_addr_flg -- 主地址标志
    ,addr_id -- 地址编号
    ,bic_code -- BIC码
    ,addr_status_cd -- 地址状态代码
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_op(
            rela_id -- 关联编号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,addr_desc -- 地址描述
    ,main_addr_flg -- 主地址标志
    ,addr_id -- 地址编号
    ,bic_code -- BIC码
    ,addr_status_cd -- 地址状态代码
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rela_id, o.rela_id) as rela_id -- 关联编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.addr_desc, o.addr_desc) as addr_desc -- 地址描述
    ,nvl(n.main_addr_flg, o.main_addr_flg) as main_addr_flg -- 主地址标志
    ,nvl(n.addr_id, o.addr_id) as addr_id -- 地址编号
    ,nvl(n.bic_code, o.bic_code) as bic_code -- BIC码
    ,nvl(n.addr_status_cd, o.addr_status_cd) as addr_status_cd -- 地址状态代码
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,case when
            n.rela_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rela_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rela_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_tm n
    full join (select * from ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.rela_id = n.rela_id
            and o.lp_id = n.lp_id
where (
        o.rela_id is null
        and o.lp_id is null
    )
    or (
        n.rela_id is null
        and n.lp_id is null
    )
    or (
        o.party_id <> n.party_id
        or o.addr_desc <> n.addr_desc
        or o.main_addr_flg <> n.main_addr_flg
        or o.addr_id <> n.addr_id
        or o.bic_code <> n.bic_code
        or o.addr_status_cd <> n.addr_status_cd
        or o.belong_org_id <> n.belong_org_id
        or o.tran_org_id <> n.tran_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_cl(
            rela_id -- 关联编号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,addr_desc -- 地址描述
    ,main_addr_flg -- 主地址标志
    ,addr_id -- 地址编号
    ,bic_code -- BIC码
    ,addr_status_cd -- 地址状态代码
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_op(
            rela_id -- 关联编号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,addr_desc -- 地址描述
    ,main_addr_flg -- 主地址标志
    ,addr_id -- 地址编号
    ,bic_code -- BIC码
    ,addr_status_cd -- 地址状态代码
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rela_id -- 关联编号
    ,o.lp_id -- 法人编号
    ,o.party_id -- 当事人编号
    ,o.addr_desc -- 地址描述
    ,o.main_addr_flg -- 主地址标志
    ,o.addr_id -- 地址编号
    ,o.bic_code -- BIC码
    ,o.addr_status_cd -- 地址状态代码
    ,o.belong_org_id -- 所属机构编号
    ,o.tran_org_id -- 交易机构编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_bk o
    left join ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_op n
        on
            o.rela_id = n.rela_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_cl d
        on
            o.rela_id = d.rela_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_intstl_addr_rela_h;
alter table ${iml_schema}.pty_intstl_addr_rela_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.pty_intstl_addr_rela_h exchange subpartition p_isbsf1_19000101 with table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_cl;
alter table ${iml_schema}.pty_intstl_addr_rela_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_intstl_addr_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_tm purge;
drop table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_op purge;
drop table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_intstl_addr_rela_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_intstl_addr_rela_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
