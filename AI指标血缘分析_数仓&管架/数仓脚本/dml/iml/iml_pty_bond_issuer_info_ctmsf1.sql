/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_bond_issuer_info_ctmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_bond_issuer_info_ctmsf1_tm purge;
drop table ${iml_schema}.pty_bond_issuer_info_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_bond_issuer_info add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_bond_issuer_info modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_bond_issuer_info_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_bond_issuer_info partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_bond_issuer_info_ctmsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,issuer_id -- 发行人编号
    ,issuer_status_cd -- 发行人状态代码
    ,cn_name -- 中文名称
    ,en_name -- 英文名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_bond_issuer_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_bond_issuer_info_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_bond_issuer_info partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_vs_issuer-
insert into ${iml_schema}.pty_bond_issuer_info_ctmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,issuer_id -- 发行人编号
    ,issuer_status_cd -- 发行人状态代码
    ,cn_name -- 中文名称
    ,en_name -- 英文名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101001'||P1.ISSUER_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.ISSUER_ID -- 发行人编号
    ,P1.STATUS -- 发行人状态代码
    ,P1.ISSUER_NAME_ZH -- 中文名称
    ,P1.ISSUER_NAME_EN -- 英文名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_issuer' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_issuer p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_bond_issuer_info_ctmsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.pty_bond_issuer_info_ctmsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,issuer_id -- 发行人编号
    ,issuer_status_cd -- 发行人状态代码
    ,cn_name -- 中文名称
    ,en_name -- 英文名称
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.issuer_id, o.issuer_id) as issuer_id -- 发行人编号
    ,nvl(n.issuer_status_cd, o.issuer_status_cd) as issuer_status_cd -- 发行人状态代码
    ,nvl(n.cn_name, o.cn_name) as cn_name -- 中文名称
    ,nvl(n.en_name, o.en_name) as en_name -- 英文名称
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.issuer_id <> n.issuer_id
                or o.issuer_status_cd <> n.issuer_status_cd
                or o.cn_name <> n.cn_name
                or o.en_name <> n.en_name
            ) or (
                 case when (
                           n.party_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.party_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_bond_issuer_info_ctmsf1_tm n
    full join ${iml_schema}.pty_bond_issuer_info_ctmsf1_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_bond_issuer_info truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_bond_issuer_info exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.pty_bond_issuer_info_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_bond_issuer_info drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_bond_issuer_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_bond_issuer_info_ctmsf1_tm purge;
drop table ${iml_schema}.pty_bond_issuer_info_ctmsf1_ex purge;
drop table ${iml_schema}.pty_bond_issuer_info_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_bond_issuer_info', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);