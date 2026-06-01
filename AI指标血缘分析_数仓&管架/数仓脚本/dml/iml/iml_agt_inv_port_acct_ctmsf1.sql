/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_inv_port_acct_ctmsf1
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
drop table ${iml_schema}.agt_inv_port_acct_ctmsf1_tm purge;
drop table ${iml_schema}.agt_inv_port_acct_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_inv_port_acct add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_inv_port_acct modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_inv_port_acct_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_inv_port_acct partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_inv_port_acct_ctmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,subor_inv_port_id -- 从属投资组合编号
    ,dept_id -- 部门编号
    ,haver_id -- 拥有者编号
    ,haver_cd -- 拥有者代码
    ,haver_name -- 拥有者名称
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,deflt_acct_id -- 默认账户ID
    ,deflt_asset_type_id -- 默认资产类型ID
    ,final_modif_tm -- 最后修改时间
    ,data_src_app_set_id -- 数据源应用设置ID
    ,bus_type_cd -- 业务类型代码
    ,status_cd -- 状态代码
    ,non_st_at_cate_cd -- 非标资产类别代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_inv_port_acct
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_inv_port_acct_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_inv_port_acct partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_vs_addonportfolio-
insert into ${iml_schema}.agt_inv_port_acct_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,subor_inv_port_id -- 从属投资组合编号
    ,dept_id -- 部门编号
    ,haver_id -- 拥有者编号
    ,haver_cd -- 拥有者代码
    ,haver_name -- 拥有者名称
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,deflt_acct_id -- 默认账户ID
    ,deflt_asset_type_id -- 默认资产类型ID
    ,final_modif_tm -- 最后修改时间
    ,data_src_app_set_id -- 数据源应用设置ID
    ,bus_type_cd -- 业务类型代码
    ,status_cd -- 状态代码
    ,non_st_at_cate_cd -- 非标资产类别代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160011'||TO_CHAR(P1.ADDONPORTFOLIO_ID)||LPAD(TRIM(P1.NSTD_ID_DEFAULT),5,'0') -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ADDONPORTFOLIO_ID -- 从属投资组合编号
    ,P1.ASPCLIENT_ID -- 部门编号
    ,P1.OWNER_NUMBER -- 拥有者编号
    ,P1.OWNER_CODE -- 拥有者代码
    ,P1.OWNER_NAME -- 拥有者名称
    ,P1.PORTFOLIO_ID -- 投组编号
    ,P1.PORTFOLIONAME -- 投组名称
    ,P1.KEEPFOLDER_ID_DEFAULT -- 默认账户ID
    ,P1.ASSETTYPE_ID_DEFAULT -- 默认资产类型ID
    ,P1.LASTMODIFIED -- 最后修改时间
    ,P1.DATASYMBOL_ID -- 数据源应用设置ID
    ,P1.BUZTYPE_ID_DEFAULT -- 业务类型代码
    ,NVL(TRIM(P1.STATUS),'-') -- 状态代码
    ,P1.NSTD_ID_DEFAULT -- 非标资产类别代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_addonportfolio' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_addonportfolio p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_inv_port_acct_ctmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_inv_port_acct_ctmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,subor_inv_port_id -- 从属投资组合编号
    ,dept_id -- 部门编号
    ,haver_id -- 拥有者编号
    ,haver_cd -- 拥有者代码
    ,haver_name -- 拥有者名称
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,deflt_acct_id -- 默认账户ID
    ,deflt_asset_type_id -- 默认资产类型ID
    ,final_modif_tm -- 最后修改时间
    ,data_src_app_set_id -- 数据源应用设置ID
    ,bus_type_cd -- 业务类型代码
    ,status_cd -- 状态代码
    ,non_st_at_cate_cd -- 非标资产类别代码
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
    ,nvl(n.subor_inv_port_id, o.subor_inv_port_id) as subor_inv_port_id -- 从属投资组合编号
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门编号
    ,nvl(n.haver_id, o.haver_id) as haver_id -- 拥有者编号
    ,nvl(n.haver_cd, o.haver_cd) as haver_cd -- 拥有者代码
    ,nvl(n.haver_name, o.haver_name) as haver_name -- 拥有者名称
    ,nvl(n.portf_id, o.portf_id) as portf_id -- 投组编号
    ,nvl(n.portf_name, o.portf_name) as portf_name -- 投组名称
    ,nvl(n.deflt_acct_id, o.deflt_acct_id) as deflt_acct_id -- 默认账户ID
    ,nvl(n.deflt_asset_type_id, o.deflt_asset_type_id) as deflt_asset_type_id -- 默认资产类型ID
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.data_src_app_set_id, o.data_src_app_set_id) as data_src_app_set_id -- 数据源应用设置ID
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.non_st_at_cate_cd, o.non_st_at_cate_cd) as non_st_at_cate_cd -- 非标资产类别代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.subor_inv_port_id <> n.subor_inv_port_id
                or o.dept_id <> n.dept_id
                or o.haver_id <> n.haver_id
                or o.haver_cd <> n.haver_cd
                or o.haver_name <> n.haver_name
                or o.portf_id <> n.portf_id
                or o.portf_name <> n.portf_name
                or o.deflt_acct_id <> n.deflt_acct_id
                or o.deflt_asset_type_id <> n.deflt_asset_type_id
                or o.final_modif_tm <> n.final_modif_tm
                or o.data_src_app_set_id <> n.data_src_app_set_id
                or o.bus_type_cd <> n.bus_type_cd
                or o.status_cd <> n.status_cd
                or o.non_st_at_cate_cd <> n.non_st_at_cate_cd
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
from ${iml_schema}.agt_inv_port_acct_ctmsf1_tm n
    full join ${iml_schema}.agt_inv_port_acct_ctmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_inv_port_acct truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_inv_port_acct exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.agt_inv_port_acct_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_inv_port_acct drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_inv_port_acct to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_inv_port_acct_ctmsf1_tm purge;
drop table ${iml_schema}.agt_inv_port_acct_ctmsf1_ex purge;
drop table ${iml_schema}.agt_inv_port_acct_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_inv_port_acct', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);