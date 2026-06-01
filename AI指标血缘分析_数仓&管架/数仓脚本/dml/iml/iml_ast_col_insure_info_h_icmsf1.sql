/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_insure_info_h_icmsf1
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
alter table ${iml_schema}.ast_col_insure_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_insure_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_insure_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_col_insure_info_h_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_insure_info_h_icmsf1_op purge;
drop table ${iml_schema}.ast_col_insure_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_insure_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    insure_rec_id -- 保险记录编号
    ,lp_id -- 法人编号
    ,insu_comp_id -- 保险公司编号
    ,insu_comp_name -- 保险公司名称
    ,policy_num -- 保险单号
    ,guar_amt -- 担保金额
    ,insure_begin_dt -- 保险起始日期
    ,insure_exp_dt -- 保险到期日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_insure_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.ast_col_insure_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_insure_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.ast_col_insure_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_insure_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_clr_insurance_record-1
insert into ${iml_schema}.ast_col_insure_info_h_icmsf1_tm(
    insure_rec_id -- 保险记录编号
    ,lp_id -- 法人编号
    ,insu_comp_id -- 保险公司编号
    ,insu_comp_name -- 保险公司名称
    ,policy_num -- 保险单号
    ,guar_amt -- 担保金额
    ,insure_begin_dt -- 保险起始日期
    ,insure_exp_dt -- 保险到期日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.INSURANCERECORDID -- 保险记录编号
    ,'9999' -- 法人编号
    ,P1.INSURANCECOMPANYCODE -- 保险公司编号
    ,P1.INSURANCECOMPANY -- 保险公司名称
    ,P1.INSURANCEPOLICYID -- 保险单号
    ,P1.INSURANCEAMOUNT -- 担保金额
    ,P1.STARTDATE -- 保险起始日期
    ,P1.ENDDATE -- 保险到期日期
    ,P1.UNDERWRITERS1 -- 第一核保人名称
    ,P1.UNDERWRITERS2 -- 第二核保人名称
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最新更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_clr_insurance_record' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_clr_insurance_record p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_insure_info_h_icmsf1_tm 
  	                                group by 
  	                                        insure_rec_id
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
        into ${iml_schema}.ast_col_insure_info_h_icmsf1_cl(
            insure_rec_id -- 保险记录编号
    ,lp_id -- 法人编号
    ,insu_comp_id -- 保险公司编号
    ,insu_comp_name -- 保险公司名称
    ,policy_num -- 保险单号
    ,guar_amt -- 担保金额
    ,insure_begin_dt -- 保险起始日期
    ,insure_exp_dt -- 保险到期日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_insure_info_h_icmsf1_op(
            insure_rec_id -- 保险记录编号
    ,lp_id -- 法人编号
    ,insu_comp_id -- 保险公司编号
    ,insu_comp_name -- 保险公司名称
    ,policy_num -- 保险单号
    ,guar_amt -- 担保金额
    ,insure_begin_dt -- 保险起始日期
    ,insure_exp_dt -- 保险到期日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.insure_rec_id, o.insure_rec_id) as insure_rec_id -- 保险记录编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.insu_comp_id, o.insu_comp_id) as insu_comp_id -- 保险公司编号
    ,nvl(n.insu_comp_name, o.insu_comp_name) as insu_comp_name -- 保险公司名称
    ,nvl(n.policy_num, o.policy_num) as policy_num -- 保险单号
    ,nvl(n.guar_amt, o.guar_amt) as guar_amt -- 担保金额
    ,nvl(n.insure_begin_dt, o.insure_begin_dt) as insure_begin_dt -- 保险起始日期
    ,nvl(n.insure_exp_dt, o.insure_exp_dt) as insure_exp_dt -- 保险到期日期
    ,nvl(n.fst_ctfer_name, o.fst_ctfer_name) as fst_ctfer_name -- 第一核保人名称
    ,nvl(n.secd_ctfer_name, o.secd_ctfer_name) as secd_ctfer_name -- 第二核保人名称
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.latest_update_dt, o.latest_update_dt) as latest_update_dt -- 最新更新日期
    ,case when
            n.insure_rec_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.insure_rec_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.insure_rec_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_insure_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.ast_col_insure_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.insure_rec_id = n.insure_rec_id
            and o.lp_id = n.lp_id
where (
        o.insure_rec_id is null
        and o.lp_id is null
    )
    or (
        n.insure_rec_id is null
        and n.lp_id is null
    )
    or (
        o.insu_comp_id <> n.insu_comp_id
        or o.insu_comp_name <> n.insu_comp_name
        or o.policy_num <> n.policy_num
        or o.guar_amt <> n.guar_amt
        or o.insure_begin_dt <> n.insure_begin_dt
        or o.insure_exp_dt <> n.insure_exp_dt
        or o.fst_ctfer_name <> n.fst_ctfer_name
        or o.secd_ctfer_name <> n.secd_ctfer_name
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.latest_update_dt <> n.latest_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_insure_info_h_icmsf1_cl(
            insure_rec_id -- 保险记录编号
    ,lp_id -- 法人编号
    ,insu_comp_id -- 保险公司编号
    ,insu_comp_name -- 保险公司名称
    ,policy_num -- 保险单号
    ,guar_amt -- 担保金额
    ,insure_begin_dt -- 保险起始日期
    ,insure_exp_dt -- 保险到期日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_insure_info_h_icmsf1_op(
            insure_rec_id -- 保险记录编号
    ,lp_id -- 法人编号
    ,insu_comp_id -- 保险公司编号
    ,insu_comp_name -- 保险公司名称
    ,policy_num -- 保险单号
    ,guar_amt -- 担保金额
    ,insure_begin_dt -- 保险起始日期
    ,insure_exp_dt -- 保险到期日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.insure_rec_id -- 保险记录编号
    ,o.lp_id -- 法人编号
    ,o.insu_comp_id -- 保险公司编号
    ,o.insu_comp_name -- 保险公司名称
    ,o.policy_num -- 保险单号
    ,o.guar_amt -- 担保金额
    ,o.insure_begin_dt -- 保险起始日期
    ,o.insure_exp_dt -- 保险到期日期
    ,o.fst_ctfer_name -- 第一核保人名称
    ,o.secd_ctfer_name -- 第二核保人名称
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.latest_update_dt -- 最新更新日期
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
from ${iml_schema}.ast_col_insure_info_h_icmsf1_bk o
    left join ${iml_schema}.ast_col_insure_info_h_icmsf1_op n
        on
            o.insure_rec_id = n.insure_rec_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_col_insure_info_h_icmsf1_cl d
        on
            o.insure_rec_id = d.insure_rec_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_col_insure_info_h;
--alter table ${iml_schema}.ast_col_insure_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ast_col_insure_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ast_col_insure_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_insure_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ast_col_insure_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_col_insure_info_h_icmsf1_cl;
alter table ${iml_schema}.ast_col_insure_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.ast_col_insure_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_insure_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_insure_info_h_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_insure_info_h_icmsf1_op purge;
drop table ${iml_schema}.ast_col_insure_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_col_insure_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_insure_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
