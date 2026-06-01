/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ext_secu_acct_ibmsf1
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
drop table ${iml_schema}.agt_ext_secu_acct_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ext_secu_acct_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ext_secu_acct add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ext_secu_acct modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ext_secu_acct_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ext_secu_acct partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ext_secu_acct_ibmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,tran_market_id -- 交易市场编号
    ,exchg_acct_id -- 交易所账户编号
    ,acct_status_cd -- 账户状态代码
    ,trust_site_id -- 托管场所编号
    ,belong_org_id -- 所属机构编号
    ,stl_site_id -- 结算场所编号
    ,stl_site_name -- 结算场所名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ext_secu_acct
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ext_secu_acct_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ext_secu_acct partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_acc_secu_ext-
insert into ${iml_schema}.agt_ext_secu_acct_ibmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,tran_market_id -- 交易市场编号
    ,exchg_acct_id -- 交易所账户编号
    ,acct_status_cd -- 账户状态代码
    ,trust_site_id -- 托管场所编号
    ,belong_org_id -- 所属机构编号
    ,stl_site_id -- 结算场所编号
    ,stl_site_name -- 结算场所名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '100041'||P1.ACCID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ACCID -- 账户编号
    ,P1.ACCNAME -- 账户名称
    ,P1.MARKET -- 交易市场编号
    ,P1.EXHACC -- 交易所账户编号
    ,CASE WHEN P1.STATUS = 11 THEN '1' ELSE TO_CHAR(P1.STATUS) END -- 账户状态代码
    ,P1.HOST_MARKET -- 托管场所编号
    ,P2.ORG_ID -- 所属机构编号
    ,P1.S_PSET -- 结算场所编号
    ,P1.S_PSET_NAME -- 结算场所名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_acc_secu_ext' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_acc_secu_ext p1
    left join ${iol_schema}.ibms_ttrd_institution p2 on P1.I_ID=P2.I_ID AND P2.start_dt <= to_date('${batch_date}','yyyymmdd') and P2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ext_secu_acct_ibmsf1_tm 
  	                                group by 
  	                                        agt_id
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
insert /*+ append */ into ${iml_schema}.agt_ext_secu_acct_ibmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,tran_market_id -- 交易市场编号
    ,exchg_acct_id -- 交易所账户编号
    ,acct_status_cd -- 账户状态代码
    ,trust_site_id -- 托管场所编号
    ,belong_org_id -- 所属机构编号
    ,stl_site_id -- 结算场所编号
    ,stl_site_name -- 结算场所名称
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.tran_market_id, o.tran_market_id) as tran_market_id -- 交易市场编号
    ,nvl(n.exchg_acct_id, o.exchg_acct_id) as exchg_acct_id -- 交易所账户编号
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.trust_site_id, o.trust_site_id) as trust_site_id -- 托管场所编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.stl_site_id, o.stl_site_id) as stl_site_id -- 结算场所编号
    ,nvl(n.stl_site_name, o.stl_site_name) as stl_site_name -- 结算场所名称
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.acct_id <> n.acct_id
                or o.acct_name <> n.acct_name
                or o.tran_market_id <> n.tran_market_id
                or o.exchg_acct_id <> n.exchg_acct_id
                or o.acct_status_cd <> n.acct_status_cd
                or o.trust_site_id <> n.trust_site_id
                or o.belong_org_id <> n.belong_org_id
                or o.stl_site_id <> n.stl_site_id
                or o.stl_site_name <> n.stl_site_name
            ) or (
                 case when (
                           n.agt_id is null
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
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ext_secu_acct_ibmsf1_tm n
    full join ${iml_schema}.agt_ext_secu_acct_ibmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ext_secu_acct truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ext_secu_acct exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.agt_ext_secu_acct_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ext_secu_acct drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ext_secu_acct to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ext_secu_acct_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ext_secu_acct_ibmsf1_ex purge;
drop table ${iml_schema}.agt_ext_secu_acct_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ext_secu_acct', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);