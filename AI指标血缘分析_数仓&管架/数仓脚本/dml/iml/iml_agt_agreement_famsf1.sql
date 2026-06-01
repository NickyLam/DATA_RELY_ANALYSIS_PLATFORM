/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_agreement_famsf1
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
drop table ${iml_schema}.agt_agreement_famsf1_tm purge;
drop table ${iml_schema}.agt_agreement_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_agreement add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_agreement modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_agreement_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_agreement partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_agreement_famsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_agreement
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_agreement_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_agreement partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_mnm_dldeal-
insert into ${iml_schema}.agt_agreement_famsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224106'||P1.SEQNO -- 协议编号
    ,'9999' -- 法人编号
    ,' ' -- 源协议编号
    ,' ' -- 协议名称
    ,'224106' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.VDATE)) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.MDATE)) -- 协议失效日期
    ,P1.LSTMNTUSER -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_mnm_dldeal' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_mnm_dldeal p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- fams_mnm_dpbodeal-
insert into ${iml_schema}.agt_agreement_famsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224105'||P1.SEQNO -- 协议编号
    ,'9999' -- 法人编号
    ,' ' -- 源协议编号
    ,' ' -- 协议名称
    ,'224105' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.VDATE)) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.MDATE)) -- 协议失效日期
    ,P1.LSTMNTUSER -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_mnm_dpbodeal' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_mnm_dpbodeal p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- fams_rep_deal-
insert into ${iml_schema}.agt_agreement_famsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225106'||P1.REPDUUID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.REPDUUID -- 源协议编号
    ,' ' -- 协议名称
    ,'225106' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.VDATE)) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.MDATE)) -- 协议失效日期
    ,P1.CREATEUSER -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_rep_deal' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_rep_deal p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- fams_sec_trad_deal-
insert into ${iml_schema}.agt_agreement_famsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225101'||P1.SEQNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 源协议编号
    ,' ' -- 协议名称
    ,'225101' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.DEALDATE)) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.VDATE)) -- 协议失效日期
    ,P1.LSTMNTUSER -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_sec_trad_deal' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_sec_trad_deal p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- fams_tru_deal-
insert into ${iml_schema}.agt_agreement_famsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225107'||P1.SEQNO -- 协议编号
    ,'9999' -- 法人编号
    ,' ' -- 源协议编号
    ,' ' -- 协议名称
    ,'225107' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.DEALDATE)) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.MDATE)) -- 协议失效日期
    ,P1.CREATEUSER -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_tru_deal' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_tru_deal p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_agreement_famsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_agreement_famsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
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
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.agt_name, o.agt_name) as agt_name -- 协议名称
    ,nvl(n.agt_type_cd, o.agt_type_cd) as agt_type_cd -- 协议类型代码
    ,nvl(n.agt_effect_dt, o.agt_effect_dt) as agt_effect_dt -- 协议生效日期
    ,nvl(n.agt_invalid_dt, o.agt_invalid_dt) as agt_invalid_dt -- 协议失效日期
    ,nvl(n.sign_teller_id, o.sign_teller_id) as sign_teller_id -- 签约柜员编号
    ,nvl(n.sign_org_id, o.sign_org_id) as sign_org_id -- 签约机构编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.src_agt_id <> n.src_agt_id
                or o.agt_name <> n.agt_name
                or o.agt_type_cd <> n.agt_type_cd
                or o.agt_effect_dt <> n.agt_effect_dt
                or o.agt_invalid_dt <> n.agt_invalid_dt
                or o.sign_teller_id <> n.sign_teller_id
                or o.sign_org_id <> n.sign_org_id
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
from ${iml_schema}.agt_agreement_famsf1_tm n
    full join ${iml_schema}.agt_agreement_famsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_agreement truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_agreement exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.agt_agreement_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_agreement drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_agreement to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_agreement_famsf1_tm purge;
drop table ${iml_schema}.agt_agreement_famsf1_ex purge;
drop table ${iml_schema}.agt_agreement_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_agreement', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);