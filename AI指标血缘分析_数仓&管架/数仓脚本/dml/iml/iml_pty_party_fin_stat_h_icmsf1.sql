/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_fin_stat_h_icmsf1
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
alter table ${iml_schema}.pty_party_fin_stat_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_fin_stat_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_fin_stat_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_party_fin_stat_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_party_fin_stat_h_icmsf1_op purge;
drop table ${iml_schema}.pty_party_fin_stat_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_fin_stat_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,rec_id -- 记录编号
    ,lp_id -- 法人编号
    ,rept_curr_cd -- 报表币种代码
    ,rept_corp_cd -- 报表单位代码
    ,rept_cali_type_cd -- 报表口径类型代码
    ,rept_dt -- 财务报表日期
    ,rept_ped_cd -- 报表周期代码
    ,rept_note -- 报表注释
    ,rept_status_cd -- 报表状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,rgst_user_id -- 登记用户编号
    ,audit_flg -- 审计标志
    ,audit_corp -- 审计单位名称
    ,audit_opinion -- 审计意见
    ,fin_rept_type_cd -- 财报类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_fin_stat_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_party_fin_stat_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_fin_stat_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_party_fin_stat_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_fin_stat_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_fina_report-
insert into ${iml_schema}.pty_party_fin_stat_h_icmsf1_tm(
    party_id -- 当事人编号
    ,rec_id -- 记录编号
    ,lp_id -- 法人编号
    ,rept_curr_cd -- 报表币种代码
    ,rept_corp_cd -- 报表单位代码
    ,rept_cali_type_cd -- 报表口径类型代码
    ,rept_dt -- 财务报表日期
    ,rept_ped_cd -- 报表周期代码
    ,rept_note -- 报表注释
    ,rept_status_cd -- 报表状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,rgst_user_id -- 登记用户编号
    ,audit_flg -- 审计标志
    ,audit_corp -- 审计单位名称
    ,audit_opinion -- 审计意见
    ,fin_rept_type_cd -- 财报类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUSTOMERID -- 当事人编号
    ,P1.REPORTNO -- 记录编号
    , '9999' -- 法人编号
    ,P1.CURRENCY -- 报表币种代码
    ,P1.MONETARYUNIT -- 报表单位代码
    ,P1.REPORTSCOPE -- 报表口径类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.ACCOUNTINGMONTH) -- 财务报表日期
    ,P1.REPORTPERIOD -- 报表周期代码
    ,P1.REPORTOPINION -- 报表注释
    ,P1.REPORTSTATUS -- 报表状态代码
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.INPUTUSERID -- 登记用户编号
    ,DECODE(TRIM(P1.AUDITFLAG),NULL,'-','2','0','N','0','Y','1',P1.AUDITFLAG) -- 审计标志
    ,P1.AUDITINGAGENCY -- 审计单位名称
    ,P1.AUDITOPINION -- 审计意见
    ,nvl(trim(P1.REPORTTYPENO),'-') -- 财报类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_fina_report' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_fina_report p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_party_fin_stat_h_icmsf1_tm 
  	                                group by 
  	                                        rec_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_fin_stat_h_icmsf1_cl(
            party_id -- 当事人编号
    ,rec_id -- 记录编号
    ,lp_id -- 法人编号
    ,rept_curr_cd -- 报表币种代码
    ,rept_corp_cd -- 报表单位代码
    ,rept_cali_type_cd -- 报表口径类型代码
    ,rept_dt -- 财务报表日期
    ,rept_ped_cd -- 报表周期代码
    ,rept_note -- 报表注释
    ,rept_status_cd -- 报表状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,rgst_user_id -- 登记用户编号
    ,audit_flg -- 审计标志
    ,audit_corp -- 审计单位名称
    ,audit_opinion -- 审计意见
    ,fin_rept_type_cd -- 财报类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_fin_stat_h_icmsf1_op(
            party_id -- 当事人编号
    ,rec_id -- 记录编号
    ,lp_id -- 法人编号
    ,rept_curr_cd -- 报表币种代码
    ,rept_corp_cd -- 报表单位代码
    ,rept_cali_type_cd -- 报表口径类型代码
    ,rept_dt -- 财务报表日期
    ,rept_ped_cd -- 报表周期代码
    ,rept_note -- 报表注释
    ,rept_status_cd -- 报表状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,rgst_user_id -- 登记用户编号
    ,audit_flg -- 审计标志
    ,audit_corp -- 审计单位名称
    ,audit_opinion -- 审计意见
    ,fin_rept_type_cd -- 财报类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.rec_id, o.rec_id) as rec_id -- 记录编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.rept_curr_cd, o.rept_curr_cd) as rept_curr_cd -- 报表币种代码
    ,nvl(n.rept_corp_cd, o.rept_corp_cd) as rept_corp_cd -- 报表单位代码
    ,nvl(n.rept_cali_type_cd, o.rept_cali_type_cd) as rept_cali_type_cd -- 报表口径类型代码
    ,nvl(n.rept_dt, o.rept_dt) as rept_dt -- 财务报表日期
    ,nvl(n.rept_ped_cd, o.rept_ped_cd) as rept_ped_cd -- 报表周期代码
    ,nvl(n.rept_note, o.rept_note) as rept_note -- 报表注释
    ,nvl(n.rept_status_cd, o.rept_status_cd) as rept_status_cd -- 报表状态代码
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_user_id, o.rgst_user_id) as rgst_user_id -- 登记用户编号
    ,nvl(n.audit_flg, o.audit_flg) as audit_flg -- 审计标志
    ,nvl(n.audit_corp, o.audit_corp) as audit_corp -- 审计单位名称
    ,nvl(n.audit_opinion, o.audit_opinion) as audit_opinion -- 审计意见
    ,nvl(n.fin_rept_type_cd, o.fin_rept_type_cd) as fin_rept_type_cd -- 财报类型代码
    ,case when
            n.rec_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rec_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rec_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_fin_stat_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_party_fin_stat_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.rec_id = n.rec_id
            and o.lp_id = n.lp_id
where (
        o.rec_id is null
        and o.lp_id is null
    )
    or (
        n.rec_id is null
        and n.lp_id is null
    )
    or (
        o.party_id <> n.party_id
        or o.rept_curr_cd <> n.rept_curr_cd
        or o.rept_corp_cd <> n.rept_corp_cd
        or o.rept_cali_type_cd <> n.rept_cali_type_cd
        or o.rept_dt <> n.rept_dt
        or o.rept_ped_cd <> n.rept_ped_cd
        or o.rept_note <> n.rept_note
        or o.rept_status_cd <> n.rept_status_cd
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.rgst_user_id <> n.rgst_user_id
        or o.audit_flg <> n.audit_flg
        or o.audit_corp <> n.audit_corp
        or o.audit_opinion <> n.audit_opinion
        or o.fin_rept_type_cd <> n.fin_rept_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_fin_stat_h_icmsf1_cl(
            party_id -- 当事人编号
    ,rec_id -- 记录编号
    ,lp_id -- 法人编号
    ,rept_curr_cd -- 报表币种代码
    ,rept_corp_cd -- 报表单位代码
    ,rept_cali_type_cd -- 报表口径类型代码
    ,rept_dt -- 财务报表日期
    ,rept_ped_cd -- 报表周期代码
    ,rept_note -- 报表注释
    ,rept_status_cd -- 报表状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,rgst_user_id -- 登记用户编号
    ,audit_flg -- 审计标志
    ,audit_corp -- 审计单位名称
    ,audit_opinion -- 审计意见
    ,fin_rept_type_cd -- 财报类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_fin_stat_h_icmsf1_op(
            party_id -- 当事人编号
    ,rec_id -- 记录编号
    ,lp_id -- 法人编号
    ,rept_curr_cd -- 报表币种代码
    ,rept_corp_cd -- 报表单位代码
    ,rept_cali_type_cd -- 报表口径类型代码
    ,rept_dt -- 财务报表日期
    ,rept_ped_cd -- 报表周期代码
    ,rept_note -- 报表注释
    ,rept_status_cd -- 报表状态代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,rgst_user_id -- 登记用户编号
    ,audit_flg -- 审计标志
    ,audit_corp -- 审计单位名称
    ,audit_opinion -- 审计意见
    ,fin_rept_type_cd -- 财报类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.rec_id -- 记录编号
    ,o.lp_id -- 法人编号
    ,o.rept_curr_cd -- 报表币种代码
    ,o.rept_corp_cd -- 报表单位代码
    ,o.rept_cali_type_cd -- 报表口径类型代码
    ,o.rept_dt -- 财务报表日期
    ,o.rept_ped_cd -- 报表周期代码
    ,o.rept_note -- 报表注释
    ,o.rept_status_cd -- 报表状态代码
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.rgst_user_id -- 登记用户编号
    ,o.audit_flg -- 审计标志
    ,o.audit_corp -- 审计单位名称
    ,o.audit_opinion -- 审计意见
    ,o.fin_rept_type_cd -- 财报类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_fin_stat_h_icmsf1_bk o
    left join ${iml_schema}.pty_party_fin_stat_h_icmsf1_op n
        on
            o.rec_id = n.rec_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_party_fin_stat_h_icmsf1_cl d
        on
            o.rec_id = d.rec_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_party_fin_stat_h;
--alter table ${iml_schema}.pty_party_fin_stat_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_party_fin_stat_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_party_fin_stat_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_party_fin_stat_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_party_fin_stat_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_party_fin_stat_h_icmsf1_cl;
alter table ${iml_schema}.pty_party_fin_stat_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_party_fin_stat_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party_fin_stat_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_party_fin_stat_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_party_fin_stat_h_icmsf1_op purge;
drop table ${iml_schema}.pty_party_fin_stat_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_party_fin_stat_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party_fin_stat_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
