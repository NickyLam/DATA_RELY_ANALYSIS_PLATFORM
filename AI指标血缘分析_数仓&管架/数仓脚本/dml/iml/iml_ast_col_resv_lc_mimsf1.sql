/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_resv_lc_mimsf1
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
alter table ${iml_schema}.ast_col_resv_lc add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mimsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_resv_lc_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_resv_lc partition for ('mimsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_col_resv_lc_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_resv_lc_mimsf1_op purge;
drop table ${iml_schema}.ast_col_resv_lc_mimsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_resv_lc_mimsf1_tm nologging
compress ${option_switch} for query high
as select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,resv_lc_id -- 备用信用证编号
    ,issue_cty_rg_cd -- 开证国家和地区代码
    ,issue_org_name -- 开证机构名称
    ,issue_org_type_cd -- 开证机构类型代码
    ,issue_org_ext_rating_rest_cd -- 开证机构外部评级结果代码
    ,issue_org_ext_rating_dt -- 开证机构外部评级日期
    ,issue_org_intnal_rating_rest_cd -- 开证机构内部评级结果代码
    ,issue_org_intnal_rating_dt -- 开证机构内部评级日期
    ,issue_org_rgst_cty_rg_cd -- 开证机构注册地国家和地区代码
    ,issue_org_rgst_ext_rating_rest_cd -- 开证机构注册地外部评级结果代码
    ,amt -- 金额
    ,irevbl_flg -- 不可撤销标志
    ,curr_cd -- 币种代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_resv_lc partition for ('mimsf1')
where 0=1
;

create table ${iml_schema}.ast_col_resv_lc_mimsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_resv_lc partition for ('mimsf1') where 0=1;

create table ${iml_schema}.ast_col_resv_lc_mimsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_resv_lc partition for ('mimsf1') where 0=1;

-- 3.1 get new data into table
-- mims_si_slc-
insert into ${iml_schema}.ast_col_resv_lc_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,resv_lc_id -- 备用信用证编号
    ,issue_cty_rg_cd -- 开证国家和地区代码
    ,issue_org_name -- 开证机构名称
    ,issue_org_type_cd -- 开证机构类型代码
    ,issue_org_ext_rating_rest_cd -- 开证机构外部评级结果代码
    ,issue_org_ext_rating_dt -- 开证机构外部评级日期
    ,issue_org_intnal_rating_rest_cd -- 开证机构内部评级结果代码
    ,issue_org_intnal_rating_dt -- 开证机构内部评级日期
    ,issue_org_rgst_cty_rg_cd -- 开证机构注册地国家和地区代码
    ,issue_org_rgst_ext_rating_rest_cd -- 开证机构注册地外部评级结果代码
    ,amt -- 金额
    ,irevbl_flg -- 不可撤销标志
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '500001'||p1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,p1.SCCODE -- 押品编号
    ,p1.SLCNO -- 备用信用证编号
    ,NVL(TRIM(P1.SLCCOUNTRY),'XXX') -- 开证国家和地区代码
    ,p1.ORGNAME -- 开证机构名称
    ,case when R1.TARGET_CD_VAL is not null then R1.TARGET_CD_VAL else '@'||p1.ORGTYPE end -- 开证机构类型代码
    ,nvl(trim(p1.OUTRATINGRESULT),'-') -- 开证机构外部评级结果代码
    ,${iml_schema}.DATEFORMAT_MIN(p1.OUTRATINGDATE) -- 开证机构外部评级日期
    ,nvl(trim(p1.INRATINGRESULT),'-') -- 开证机构内部评级结果代码
    ,${iml_schema}.DATEFORMAT_MIN(p1.INTATINGDATE) -- 开证机构内部评级日期
    ,NVL(TRIM(P1.REGISTCOUNTRY),'XXX') -- 开证机构注册地国家和地区代码
    ,nvl(trim(p1.REGISTCOUNTRYRESULT),'-') -- 开证机构注册地外部评级结果代码
    ,p1.SLCMONEY -- 金额
    ,nvl(trim(p1.ISCANCEL),'-') -- 不可撤销标志
    ,NVL(TRIM(P1.TDCURRENCY),'-') -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_slc' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_slc p1
    left join ${iml_schema}.ref_pub_cd_map r1 on nvl(P1.ORGTYPE,' ')= R1.SRC_CODE_VAL                                
        AND R1.SORC_SYS_CD= 'MIMS'                          
        AND R1.SRC_TAB_EN_NAME= 'MIMS_SI_SLC'               
        AND R1.SRC_FIELD_EN_NAME= 'ORGTYPE'                 
        AND R1.TARGET_TAB_EN_NAME= 'AST_COL_RESV_LC'       
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ISSUE_ORG_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_resv_lc_mimsf1_tm 
  	                                group by 
  	                                        asset_id
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
        into ${iml_schema}.ast_col_resv_lc_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,resv_lc_id -- 备用信用证编号
    ,issue_cty_rg_cd -- 开证国家和地区代码
    ,issue_org_name -- 开证机构名称
    ,issue_org_type_cd -- 开证机构类型代码
    ,issue_org_ext_rating_rest_cd -- 开证机构外部评级结果代码
    ,issue_org_ext_rating_dt -- 开证机构外部评级日期
    ,issue_org_intnal_rating_rest_cd -- 开证机构内部评级结果代码
    ,issue_org_intnal_rating_dt -- 开证机构内部评级日期
    ,issue_org_rgst_cty_rg_cd -- 开证机构注册地国家和地区代码
    ,issue_org_rgst_ext_rating_rest_cd -- 开证机构注册地外部评级结果代码
    ,amt -- 金额
    ,irevbl_flg -- 不可撤销标志
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_resv_lc_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,resv_lc_id -- 备用信用证编号
    ,issue_cty_rg_cd -- 开证国家和地区代码
    ,issue_org_name -- 开证机构名称
    ,issue_org_type_cd -- 开证机构类型代码
    ,issue_org_ext_rating_rest_cd -- 开证机构外部评级结果代码
    ,issue_org_ext_rating_dt -- 开证机构外部评级日期
    ,issue_org_intnal_rating_rest_cd -- 开证机构内部评级结果代码
    ,issue_org_intnal_rating_dt -- 开证机构内部评级日期
    ,issue_org_rgst_cty_rg_cd -- 开证机构注册地国家和地区代码
    ,issue_org_rgst_ext_rating_rest_cd -- 开证机构注册地外部评级结果代码
    ,amt -- 金额
    ,irevbl_flg -- 不可撤销标志
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.col_id, o.col_id) as col_id -- 押品编号
    ,nvl(n.resv_lc_id, o.resv_lc_id) as resv_lc_id -- 备用信用证编号
    ,nvl(n.issue_cty_rg_cd, o.issue_cty_rg_cd) as issue_cty_rg_cd -- 开证国家和地区代码
    ,nvl(n.issue_org_name, o.issue_org_name) as issue_org_name -- 开证机构名称
    ,nvl(n.issue_org_type_cd, o.issue_org_type_cd) as issue_org_type_cd -- 开证机构类型代码
    ,nvl(n.issue_org_ext_rating_rest_cd, o.issue_org_ext_rating_rest_cd) as issue_org_ext_rating_rest_cd -- 开证机构外部评级结果代码
    ,nvl(n.issue_org_ext_rating_dt, o.issue_org_ext_rating_dt) as issue_org_ext_rating_dt -- 开证机构外部评级日期
    ,nvl(n.issue_org_intnal_rating_rest_cd, o.issue_org_intnal_rating_rest_cd) as issue_org_intnal_rating_rest_cd -- 开证机构内部评级结果代码
    ,nvl(n.issue_org_intnal_rating_dt, o.issue_org_intnal_rating_dt) as issue_org_intnal_rating_dt -- 开证机构内部评级日期
    ,nvl(n.issue_org_rgst_cty_rg_cd, o.issue_org_rgst_cty_rg_cd) as issue_org_rgst_cty_rg_cd -- 开证机构注册地国家和地区代码
    ,nvl(n.issue_org_rgst_ext_rating_rest_cd, o.issue_org_rgst_ext_rating_rest_cd) as issue_org_rgst_ext_rating_rest_cd -- 开证机构注册地外部评级结果代码
    ,nvl(n.amt, o.amt) as amt -- 金额
    ,nvl(n.irevbl_flg, o.irevbl_flg) as irevbl_flg -- 不可撤销标志
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_resv_lc_mimsf1_tm n
    full join (select * from ${iml_schema}.ast_col_resv_lc_mimsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
where (
        o.asset_id is null
        and o.lp_id is null
    )
    or (
        n.asset_id is null
        and n.lp_id is null
    )
    or (
        o.col_id <> n.col_id
        or o.resv_lc_id <> n.resv_lc_id
        or o.issue_cty_rg_cd <> n.issue_cty_rg_cd
        or o.issue_org_name <> n.issue_org_name
        or o.issue_org_type_cd <> n.issue_org_type_cd
        or o.issue_org_ext_rating_rest_cd <> n.issue_org_ext_rating_rest_cd
        or o.issue_org_ext_rating_dt <> n.issue_org_ext_rating_dt
        or o.issue_org_intnal_rating_rest_cd <> n.issue_org_intnal_rating_rest_cd
        or o.issue_org_intnal_rating_dt <> n.issue_org_intnal_rating_dt
        or o.issue_org_rgst_cty_rg_cd <> n.issue_org_rgst_cty_rg_cd
        or o.issue_org_rgst_ext_rating_rest_cd <> n.issue_org_rgst_ext_rating_rest_cd
        or o.amt <> n.amt
        or o.irevbl_flg <> n.irevbl_flg
        or o.curr_cd <> n.curr_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_resv_lc_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,resv_lc_id -- 备用信用证编号
    ,issue_cty_rg_cd -- 开证国家和地区代码
    ,issue_org_name -- 开证机构名称
    ,issue_org_type_cd -- 开证机构类型代码
    ,issue_org_ext_rating_rest_cd -- 开证机构外部评级结果代码
    ,issue_org_ext_rating_dt -- 开证机构外部评级日期
    ,issue_org_intnal_rating_rest_cd -- 开证机构内部评级结果代码
    ,issue_org_intnal_rating_dt -- 开证机构内部评级日期
    ,issue_org_rgst_cty_rg_cd -- 开证机构注册地国家和地区代码
    ,issue_org_rgst_ext_rating_rest_cd -- 开证机构注册地外部评级结果代码
    ,amt -- 金额
    ,irevbl_flg -- 不可撤销标志
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_resv_lc_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,resv_lc_id -- 备用信用证编号
    ,issue_cty_rg_cd -- 开证国家和地区代码
    ,issue_org_name -- 开证机构名称
    ,issue_org_type_cd -- 开证机构类型代码
    ,issue_org_ext_rating_rest_cd -- 开证机构外部评级结果代码
    ,issue_org_ext_rating_dt -- 开证机构外部评级日期
    ,issue_org_intnal_rating_rest_cd -- 开证机构内部评级结果代码
    ,issue_org_intnal_rating_dt -- 开证机构内部评级日期
    ,issue_org_rgst_cty_rg_cd -- 开证机构注册地国家和地区代码
    ,issue_org_rgst_ext_rating_rest_cd -- 开证机构注册地外部评级结果代码
    ,amt -- 金额
    ,irevbl_flg -- 不可撤销标志
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.asset_id -- 资产编号
    ,o.lp_id -- 法人编号
    ,o.col_id -- 押品编号
    ,o.resv_lc_id -- 备用信用证编号
    ,o.issue_cty_rg_cd -- 开证国家和地区代码
    ,o.issue_org_name -- 开证机构名称
    ,o.issue_org_type_cd -- 开证机构类型代码
    ,o.issue_org_ext_rating_rest_cd -- 开证机构外部评级结果代码
    ,o.issue_org_ext_rating_dt -- 开证机构外部评级日期
    ,o.issue_org_intnal_rating_rest_cd -- 开证机构内部评级结果代码
    ,o.issue_org_intnal_rating_dt -- 开证机构内部评级日期
    ,o.issue_org_rgst_cty_rg_cd -- 开证机构注册地国家和地区代码
    ,o.issue_org_rgst_ext_rating_rest_cd -- 开证机构注册地外部评级结果代码
    ,o.amt -- 金额
    ,o.irevbl_flg -- 不可撤销标志
    ,o.curr_cd -- 币种代码
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
from ${iml_schema}.ast_col_resv_lc_mimsf1_bk o
    left join ${iml_schema}.ast_col_resv_lc_mimsf1_op n
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_col_resv_lc_mimsf1_cl d
        on
            o.asset_id = d.asset_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_col_resv_lc;
--alter table ${iml_schema}.ast_col_resv_lc truncate partition for ('mimsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ast_col_resv_lc') 
               and substr(subpartition_name,1,8)=upper('p_mimsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ast_col_resv_lc drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ast_col_resv_lc modify partition p_mimsf1 
add subpartition p_mimsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ast_col_resv_lc exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_resv_lc_mimsf1_cl;
alter table ${iml_schema}.ast_col_resv_lc exchange subpartition p_mimsf1_20991231 with table ${iml_schema}.ast_col_resv_lc_mimsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_resv_lc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_resv_lc_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_resv_lc_mimsf1_op purge;
drop table ${iml_schema}.ast_col_resv_lc_mimsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_col_resv_lc_mimsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_resv_lc', partname => 'p_mimsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
