/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_tszfs_corp_info_para_mpcsf1
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
alter table ${iml_schema}.ref_tszfs_corp_info_para add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tszfs_corp_info_para partition for ('mpcsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_tm purge;
drop table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_op purge;
drop table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_addr -- 企业地址
    ,corp_crdt_level_cd -- 企业信用等级代码
    ,corp_cotas_name -- 企业联系人姓名
    ,corp_phone_num -- 企业联系电话号码
    ,zip_cd -- 邮政编码
    ,elec_mail_addr -- 电子邮件地址
    ,indit_mercht_flg -- 间接商户标志
    ,corp_status_cd -- 企业状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tszfs_corp_info_para partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tszfs_corp_info_para partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tszfs_corp_info_para partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a68tcorprtninf-
insert into ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_tm(
    corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_addr -- 企业地址
    ,corp_crdt_level_cd -- 企业信用等级代码
    ,corp_cotas_name -- 企业联系人姓名
    ,corp_phone_num -- 企业联系电话号码
    ,zip_cd -- 邮政编码
    ,elec_mail_addr -- 电子邮件地址
    ,indit_mercht_flg -- 间接商户标志
    ,corp_status_cd -- 企业状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CORPRTNID -- 企业编号
    ,P1.CORPRTNNM -- 企业名称
    ,P1.CORPRTNADR -- 企业地址
    ,P1.LVL -- 企业信用等级代码
    ,P1.CTCTNM -- 企业联系人姓名
    ,P1.CTCTTEL -- 企业联系电话号码
    ,P1.PSTCD -- 邮政编码
    ,P1.EMAIL -- 电子邮件地址
    ,P1.DRCTANDINDRCTFLG -- 间接商户标志
    ,P1.STS -- 企业状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a68tcorprtninf' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a68tcorprtninf p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_cl(
            corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_addr -- 企业地址
    ,corp_crdt_level_cd -- 企业信用等级代码
    ,corp_cotas_name -- 企业联系人姓名
    ,corp_phone_num -- 企业联系电话号码
    ,zip_cd -- 邮政编码
    ,elec_mail_addr -- 电子邮件地址
    ,indit_mercht_flg -- 间接商户标志
    ,corp_status_cd -- 企业状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_op(
            corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_addr -- 企业地址
    ,corp_crdt_level_cd -- 企业信用等级代码
    ,corp_cotas_name -- 企业联系人姓名
    ,corp_phone_num -- 企业联系电话号码
    ,zip_cd -- 邮政编码
    ,elec_mail_addr -- 电子邮件地址
    ,indit_mercht_flg -- 间接商户标志
    ,corp_status_cd -- 企业状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.corp_id, o.corp_id) as corp_id -- 企业编号
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 企业名称
    ,nvl(n.corp_addr, o.corp_addr) as corp_addr -- 企业地址
    ,nvl(n.corp_crdt_level_cd, o.corp_crdt_level_cd) as corp_crdt_level_cd -- 企业信用等级代码
    ,nvl(n.corp_cotas_name, o.corp_cotas_name) as corp_cotas_name -- 企业联系人姓名
    ,nvl(n.corp_phone_num, o.corp_phone_num) as corp_phone_num -- 企业联系电话号码
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮政编码
    ,nvl(n.elec_mail_addr, o.elec_mail_addr) as elec_mail_addr -- 电子邮件地址
    ,nvl(n.indit_mercht_flg, o.indit_mercht_flg) as indit_mercht_flg -- 间接商户标志
    ,nvl(n.corp_status_cd, o.corp_status_cd) as corp_status_cd -- 企业状态代码
    ,case when
            n.corp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.corp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.corp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_tm n
    full join (select * from ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.corp_id = n.corp_id
where (
        o.corp_id is null
    )
    or (
        n.corp_id is null
    )
    or (
        o.corp_name <> n.corp_name
        or o.corp_addr <> n.corp_addr
        or o.corp_crdt_level_cd <> n.corp_crdt_level_cd
        or o.corp_cotas_name <> n.corp_cotas_name
        or o.corp_phone_num <> n.corp_phone_num
        or o.zip_cd <> n.zip_cd
        or o.elec_mail_addr <> n.elec_mail_addr
        or o.indit_mercht_flg <> n.indit_mercht_flg
        or o.corp_status_cd <> n.corp_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_cl(
            corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_addr -- 企业地址
    ,corp_crdt_level_cd -- 企业信用等级代码
    ,corp_cotas_name -- 企业联系人姓名
    ,corp_phone_num -- 企业联系电话号码
    ,zip_cd -- 邮政编码
    ,elec_mail_addr -- 电子邮件地址
    ,indit_mercht_flg -- 间接商户标志
    ,corp_status_cd -- 企业状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_op(
            corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_addr -- 企业地址
    ,corp_crdt_level_cd -- 企业信用等级代码
    ,corp_cotas_name -- 企业联系人姓名
    ,corp_phone_num -- 企业联系电话号码
    ,zip_cd -- 邮政编码
    ,elec_mail_addr -- 电子邮件地址
    ,indit_mercht_flg -- 间接商户标志
    ,corp_status_cd -- 企业状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.corp_id -- 企业编号
    ,o.corp_name -- 企业名称
    ,o.corp_addr -- 企业地址
    ,o.corp_crdt_level_cd -- 企业信用等级代码
    ,o.corp_cotas_name -- 企业联系人姓名
    ,o.corp_phone_num -- 企业联系电话号码
    ,o.zip_cd -- 邮政编码
    ,o.elec_mail_addr -- 电子邮件地址
    ,o.indit_mercht_flg -- 间接商户标志
    ,o.corp_status_cd -- 企业状态代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_bk o
    left join ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_op n
        on
            o.corp_id = n.corp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_cl d
        on
            o.corp_id = d.corp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_tszfs_corp_info_para;
alter table ${iml_schema}.ref_tszfs_corp_info_para truncate partition for ('mpcsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_tszfs_corp_info_para exchange subpartition p_mpcsf1_19000101 with table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_cl;
alter table ${iml_schema}.ref_tszfs_corp_info_para exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_tszfs_corp_info_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_tm purge;
drop table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_op purge;
drop table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_tszfs_corp_info_para_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_tszfs_corp_info_para', partname => 'p_mpcsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
