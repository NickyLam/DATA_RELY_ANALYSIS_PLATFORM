/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_fx_cap_cntpty_ctmsf1
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
drop table ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_tm purge;
drop table ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_fx_cap_cntpty add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_fx_cap_cntpty modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_fx_cap_cntpty partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cntpty_id -- 交易对手编号
    ,dept_id -- 部门编号
    ,cn_name -- 中文名称
    ,en_name -- 英文名称
    ,cn_abbr -- 中文简称
    ,en_abbr -- 英文简称
    ,fx_id -- 外汇编号
    ,cust_id -- 客户编号
    ,cntpty_ibank_type -- 交易对手同业类型
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_fx_cap_cntpty
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_fx_cap_cntpty partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_fbs_v_counterparty-
insert into ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cntpty_id -- 交易对手编号
    ,dept_id -- 部门编号
    ,cn_name -- 中文名称
    ,en_name -- 英文名称
    ,cn_abbr -- 中文简称
    ,en_abbr -- 英文简称
    ,fx_id -- 外汇编号
    ,cust_id -- 客户编号
    ,cntpty_ibank_type -- 交易对手同业类型
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    TO_CHAR(P1.COUNTERPARTY_SEQ) -- 当事人编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.COUNTERPARTY_SEQ) -- 交易对手编号
    ,P1.CUS_NUMBER -- 部门编号
    ,P1.COUNTERPARTY_CNAME -- 中文名称
    ,P1.COUNTERPARTY_ENAME -- 英文名称
    ,P1.COUNTERPARTY_SHORT_CNAME -- 中文简称
    ,P1.COUNTERPARTY_SHORT_ENAME -- 英文简称
    ,P1.CFETS_FX_MEMBER_ID -- 外汇编号
    ,P1.label -- 客户编号
    ,P1.INTERBANKTYPE -- 交易对手同业类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_v_counterparty' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_fbs_v_counterparty p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cntpty_id -- 交易对手编号
    ,dept_id -- 部门编号
    ,cn_name -- 中文名称
    ,en_name -- 英文名称
    ,cn_abbr -- 中文简称
    ,en_abbr -- 英文简称
    ,fx_id -- 外汇编号
    ,cust_id -- 客户编号
    ,cntpty_ibank_type -- 交易对手同业类型
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
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门编号
    ,nvl(n.cn_name, o.cn_name) as cn_name -- 中文名称
    ,nvl(n.en_name, o.en_name) as en_name -- 英文名称
    ,nvl(n.cn_abbr, o.cn_abbr) as cn_abbr -- 中文简称
    ,nvl(n.en_abbr, o.en_abbr) as en_abbr -- 英文简称
    ,nvl(n.fx_id, o.fx_id) as fx_id -- 外汇编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cntpty_ibank_type, o.cntpty_ibank_type) as cntpty_ibank_type -- 交易对手同业类型
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.cntpty_id <> n.cntpty_id
                or o.dept_id <> n.dept_id
                or o.cn_name <> n.cn_name
                or o.en_name <> n.en_name
                or o.cn_abbr <> n.cn_abbr
                or o.en_abbr <> n.en_abbr
                or o.fx_id <> n.fx_id
                or o.cust_id <> n.cust_id
                or o.cntpty_ibank_type <> n.cntpty_ibank_type
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
from ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_tm n
    full join ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_fx_cap_cntpty truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_fx_cap_cntpty exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_fx_cap_cntpty drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_fx_cap_cntpty to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_tm purge;
drop table ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_ex purge;
drop table ${iml_schema}.pty_fx_cap_cntpty_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_fx_cap_cntpty', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);