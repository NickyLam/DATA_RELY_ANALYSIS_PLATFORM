/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_voucher_svssf1
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
drop table ${iml_schema}.agt_voucher_svssf1_tm purge;
drop table ${iml_schema}.agt_voucher_svssf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_voucher add partition p_svssf1 values ('svssf1')(
        subpartition p_svssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_voucher modify partition p_svssf1
    add subpartition p_svssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_voucher_svssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_voucher partition for ('svssf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_voucher_svssf1_tm
compress ${option_switch} for query high
as
select
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,vouch_type_cd -- 凭证类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_voucher
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_voucher_svssf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_voucher partition for ('svssf1') where 0=1;

-- 2.1 insert data to tm table
-- svss_svs_accadm_sealcard-2
insert into ${iml_schema}.agt_voucher_svssf1_tm(
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,vouch_type_cd -- 凭证类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101011'||P1.CARD_NO||P1.ID -- 凭证编号
    ,'9999' -- 法人编号
    ,'101011' -- 凭证类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.START_DATE) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.END_DATE) -- 失效日期
    ,' ' -- 登记机构编号
    ,' ' -- 登记柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'svss_svs_accadm_sealcard' -- 源表名称
    ,'svssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.svss_svs_accadm_sealcard p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_voucher_svssf1_tm 
  	                                group by 
  	                                        vouch_id
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
insert /*+ append */ into ${iml_schema}.agt_voucher_svssf1_ex(
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,vouch_type_cd -- 凭证类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.vouch_type_cd, o.vouch_type_cd) as vouch_type_cd -- 凭证类型代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.vouch_id is null
                and o.lp_id is null
            ) or (
                o.vouch_type_cd <> n.vouch_type_cd
                or o.effect_dt <> n.effect_dt
                or o.invalid_dt <> n.invalid_dt
                or o.rgst_org_id <> n.rgst_org_id
                or o.rgst_teller_id <> n.rgst_teller_id
            ) or (
                 case when (
                           n.vouch_id is null
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
                n.vouch_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_voucher_svssf1_tm n
    full join ${iml_schema}.agt_voucher_svssf1_bk o
        on
            o.vouch_id = n.vouch_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_voucher truncate partition for ('svssf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_voucher exchange subpartition p_svssf1_${batch_date} with table ${iml_schema}.agt_voucher_svssf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_voucher drop subpartition p_svssf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_voucher to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_voucher_svssf1_tm purge;
drop table ${iml_schema}.agt_voucher_svssf1_ex purge;
drop table ${iml_schema}.agt_voucher_svssf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_voucher', partname => 'p_svssf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);