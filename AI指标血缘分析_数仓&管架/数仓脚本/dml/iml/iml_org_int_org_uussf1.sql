/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_org_int_org_uussf1
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
drop table ${iml_schema}.org_int_org_uussf1_tm purge;
drop table ${iml_schema}.org_int_org_uussf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.org_int_org add partition p_uussf1 values ('uussf1')(
        subpartition p_uussf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.org_int_org modify partition p_uussf1
    add subpartition p_uussf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.org_int_org_uussf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.org_int_org partition for ('uussf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.org_int_org_uussf1_tm
compress ${option_switch} for query high
as
select
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,org_name -- 机构名称
    ,org_abbr -- 机构简称
    ,org_type_cd -- 机构级别代码
    ,org_found_dt -- 机构成立日期
    ,org_close_dt -- 机构撤销日期
    ,enty_org_flg -- 实体机构标志
    ,accti_org_flg -- 核算机构标志
    ,bus_org_flg -- 营业机构标志
    ,admin_org_flg -- 行政机构标志
    ,acct_instit_flg -- 账务机构标志
    ,vtual_org_flg -- 虚拟机构标志
    ,org_lev_cd -- 机构级别代码
    ,org_status_cd -- 机构状态代码
    ,org_bus_status_cd -- 机构营业状态代码
    ,unify_orgnz_id -- 统一组织机构编号
    ,fin_lics_num -- 金融许可证编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.org_int_org
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.org_int_org_uussf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.org_int_org partition for ('uussf1') where 0=1;

-- 2.1 insert data to tm table
-- uuss_uus_organ-organstatus
insert into ${iml_schema}.org_int_org_uussf1_tm(
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,org_name -- 机构名称
    ,org_abbr -- 机构简称
    ,org_type_cd -- 机构级别代码
    ,org_found_dt -- 机构成立日期
    ,org_close_dt -- 机构撤销日期
    ,enty_org_flg -- 实体机构标志
    ,accti_org_flg -- 核算机构标志
    ,bus_org_flg -- 营业机构标志
    ,admin_org_flg -- 行政机构标志
    ,acct_instit_flg -- 账务机构标志
    ,vtual_org_flg -- 虚拟机构标志
    ,org_lev_cd -- 机构级别代码
    ,org_status_cd -- 机构状态代码
    ,org_bus_status_cd -- 机构营业状态代码
    ,unify_orgnz_id -- 统一组织机构编号
    ,fin_lics_num -- 金融许可证编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ORGANCODE -- 机构编号
    ,'9999' -- 法人编号
    ,P1.ORGANCNFULLNAME -- 机构名称
    ,P1.ORGANCNSHORTNAME -- 机构简称
    ,nvl(trim(P1.ORGANTYPE),'-') -- 机构级别代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.ORGANFOUNDINGDATE) -- 机构成立日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.ORGANCLOSEDATE) -- 机构撤销日期
    ,P1.ISST -- 实体机构标志
    ,P1.ISHS -- 核算机构标志
    ,P1.ISYY -- 营业机构标志
    ,P1.ISXZ -- 行政机构标志
    ,P1.ISZW -- 账务机构标志
    ,P1.ISXNHS -- 虚拟机构标志
    ,P1.ORGANLEVEL -- 机构级别代码
    ,P1.ORGANSTATUS -- 机构状态代码
    ,P1.ORGANSTATECODE -- 机构营业状态代码
    ,P1.ORGANCODEKEY -- 统一组织机构编号
    ,P1.FINANCIALLICNUM -- 金融许可证编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'uuss_uus_organ' -- 源表名称
    ,'uussf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.uuss_uus_organ p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.org_int_org_uussf1_tm 
  	                                group by 
  	                                        org_id
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
insert /*+ append */ into ${iml_schema}.org_int_org_uussf1_ex(
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,org_name -- 机构名称
    ,org_abbr -- 机构简称
    ,org_type_cd -- 机构级别代码
    ,org_found_dt -- 机构成立日期
    ,org_close_dt -- 机构撤销日期
    ,enty_org_flg -- 实体机构标志
    ,accti_org_flg -- 核算机构标志
    ,bus_org_flg -- 营业机构标志
    ,admin_org_flg -- 行政机构标志
    ,acct_instit_flg -- 账务机构标志
    ,vtual_org_flg -- 虚拟机构标志
    ,org_lev_cd -- 机构级别代码
    ,org_status_cd -- 机构状态代码
    ,org_bus_status_cd -- 机构营业状态代码
    ,unify_orgnz_id -- 统一组织机构编号
    ,fin_lics_num -- 金融许可证编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.org_name, o.org_name) as org_name -- 机构名称
    ,nvl(n.org_abbr, o.org_abbr) as org_abbr -- 机构简称
    ,nvl(n.org_type_cd, o.org_type_cd) as org_type_cd -- 机构级别代码
    ,nvl(n.org_found_dt, o.org_found_dt) as org_found_dt -- 机构成立日期
    ,nvl(n.org_close_dt, o.org_close_dt) as org_close_dt -- 机构撤销日期
    ,nvl(n.enty_org_flg, o.enty_org_flg) as enty_org_flg -- 实体机构标志
    ,nvl(n.accti_org_flg, o.accti_org_flg) as accti_org_flg -- 核算机构标志
    ,nvl(n.bus_org_flg, o.bus_org_flg) as bus_org_flg -- 营业机构标志
    ,nvl(n.admin_org_flg, o.admin_org_flg) as admin_org_flg -- 行政机构标志
    ,nvl(n.acct_instit_flg, o.acct_instit_flg) as acct_instit_flg -- 账务机构标志
    ,nvl(n.vtual_org_flg, o.vtual_org_flg) as vtual_org_flg -- 虚拟机构标志
    ,nvl(n.org_lev_cd, o.org_lev_cd) as org_lev_cd -- 机构级别代码
    ,nvl(n.org_status_cd, o.org_status_cd) as org_status_cd -- 机构状态代码
    ,nvl(n.org_bus_status_cd, o.org_bus_status_cd) as org_bus_status_cd -- 机构营业状态代码
    ,nvl(n.unify_orgnz_id, o.unify_orgnz_id) as unify_orgnz_id -- 统一组织机构编号
    ,nvl(n.fin_lics_num, o.fin_lics_num) as fin_lics_num -- 金融许可证编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.org_id is null
                and o.lp_id is null
            ) or (
                o.org_name <> n.org_name
                or o.org_abbr <> n.org_abbr
                or o.org_type_cd <> n.org_type_cd
                or o.org_found_dt <> n.org_found_dt
                or o.org_close_dt <> n.org_close_dt
                or o.enty_org_flg <> n.enty_org_flg
                or o.accti_org_flg <> n.accti_org_flg
                or o.bus_org_flg <> n.bus_org_flg
                or o.admin_org_flg <> n.admin_org_flg
                or o.acct_instit_flg <> n.acct_instit_flg
                or o.vtual_org_flg <> n.vtual_org_flg
                or o.org_lev_cd <> n.org_lev_cd
                or o.org_status_cd <> n.org_status_cd
                or o.org_bus_status_cd <> n.org_bus_status_cd
                or o.unify_orgnz_id <> n.unify_orgnz_id
                or o.fin_lics_num <> n.fin_lics_num
            ) or (
                 case when (
                           n.org_id is null
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
                n.org_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.org_int_org_uussf1_tm n
    full join ${iml_schema}.org_int_org_uussf1_bk o
        on
            o.org_id = n.org_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.org_int_org truncate partition for ('uussf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.org_int_org exchange subpartition p_uussf1_${batch_date} with table ${iml_schema}.org_int_org_uussf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.org_int_org drop subpartition p_uussf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.org_int_org to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.org_int_org_uussf1_tm purge;
drop table ${iml_schema}.org_int_org_uussf1_ex purge;
drop table ${iml_schema}.org_int_org_uussf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'org_int_org', partname => 'p_uussf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);