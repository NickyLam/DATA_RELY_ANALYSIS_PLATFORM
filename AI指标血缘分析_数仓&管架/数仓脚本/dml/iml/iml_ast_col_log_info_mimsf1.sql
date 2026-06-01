/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_log_info_mimsf1
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
alter table ${iml_schema}.ast_col_log_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mimsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_log_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_log_info partition for ('mimsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_col_log_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_log_info_mimsf1_op purge;
drop table ${iml_schema}.ast_col_log_info_mimsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_log_info_mimsf1_tm nologging
compress ${option_switch} for query high
as select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,log_id -- 保函编号
    ,log_kind_cd -- 保函种类代码
    ,issue_cty_cd -- 开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,open_org_rgst_cd -- 开立机构注册地代码
    ,stage_guar_flg -- 阶段性担保标志
    ,irevbl_flg -- 不可撤销标志
    ,log_amt -- 保函金额
    ,curr_cd -- 币种代码
    ,log_open_org_ext_rating_rest_cd -- 保函开立机构外部评级结果代码
    ,log_open_org_ext_rating_dt -- 保函开立机构外部评级日期
    ,log_open_org_intnal_rating_rest_cd -- 保函开立机构内部评级结果代码
    ,log_open_org_intnal_rating_dt -- 保函开立机构内部评级日期
    ,log_open_org_rgst_ext_rating_rest_cd -- 保函开立机构注册地外部评级结果代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_log_info partition for ('mimsf1')
where 0=1
;

create table ${iml_schema}.ast_col_log_info_mimsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_log_info partition for ('mimsf1') where 0=1;

create table ${iml_schema}.ast_col_log_info_mimsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_log_info partition for ('mimsf1') where 0=1;

-- 3.1 get new data into table
-- mims_si_loi-1
insert into ${iml_schema}.ast_col_log_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,log_id -- 保函编号
    ,log_kind_cd -- 保函种类代码
    ,issue_cty_cd -- 开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,open_org_rgst_cd -- 开立机构注册地代码
    ,stage_guar_flg -- 阶段性担保标志
    ,irevbl_flg -- 不可撤销标志
    ,log_amt -- 保函金额
    ,curr_cd -- 币种代码
    ,log_open_org_ext_rating_rest_cd -- 保函开立机构外部评级结果代码
    ,log_open_org_ext_rating_dt -- 保函开立机构外部评级日期
    ,log_open_org_intnal_rating_rest_cd -- 保函开立机构内部评级结果代码
    ,log_open_org_intnal_rating_dt -- 保函开立机构内部评级日期
    ,log_open_org_rgst_ext_rating_rest_cd -- 保函开立机构注册地外部评级结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.LOINO -- 保函编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.LOITYPE END -- 保函种类代码
    ,NVL(TRIM(P1.LOICOUNTRY),'XXX') -- 开证国家代码
    ,P1.ORGNAME -- 开立机构名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ORGTYPE END -- 开立机构类型代码
    ,NVL(TRIM(P1.LOICOUNTRY),'XXX') -- 开立机构注册地代码
    ,NVL(TRIM(P1.ISSTAGE),'-') -- 阶段性担保标志
    ,NVL(TRIM(P1.ISCANCEL),'-') -- 不可撤销标志
    ,P1.LOIMONEY -- 保函金额
    ,NVL(TRIM(P1.TDCURRENCY),'-') -- 币种代码
    ,decode(trim(P1.OUTRATINGRESULT),'','-','null','-',P1.OUTRATINGRESULT) -- 保函开立机构外部评级结果代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.OUTRATINGDATE) -- 保函开立机构外部评级日期
    ,NVL(TRIM(P1.INRATINGRESULT),'-') -- 保函开立机构内部评级结果代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.INTATINGDATE) -- 保函开立机构内部评级日期
    ,decode(trim(P1.REGISTCOUNTRYRESULT),'','-','null','-',P1.REGISTCOUNTRYRESULT) -- 保函开立机构注册地外部评级结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_loi' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_loi p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.LOITYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MIMS'
        AND R1.SRC_TAB_EN_NAME= 'MIMS_SI_LOI'
        AND R1.SRC_FIELD_EN_NAME= 'LOITYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AST_COL_LOG_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LOG_KIND_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ORGTYPE= R2.SRC_CODE_VAL                                
        AND R2.SORC_SYS_CD= 'MIMS'                          
        AND R2.SRC_TAB_EN_NAME= 'MIMS_SI_LOI'               
        AND R2.SRC_FIELD_EN_NAME= 'ORGTYPE'                 
        AND R2.TARGET_TAB_EN_NAME= 'AST_COL_LOG_INFO'       
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'OPEN_ORG_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_log_info_mimsf1_tm 
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
        into ${iml_schema}.ast_col_log_info_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,log_id -- 保函编号
    ,log_kind_cd -- 保函种类代码
    ,issue_cty_cd -- 开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,open_org_rgst_cd -- 开立机构注册地代码
    ,stage_guar_flg -- 阶段性担保标志
    ,irevbl_flg -- 不可撤销标志
    ,log_amt -- 保函金额
    ,curr_cd -- 币种代码
    ,log_open_org_ext_rating_rest_cd -- 保函开立机构外部评级结果代码
    ,log_open_org_ext_rating_dt -- 保函开立机构外部评级日期
    ,log_open_org_intnal_rating_rest_cd -- 保函开立机构内部评级结果代码
    ,log_open_org_intnal_rating_dt -- 保函开立机构内部评级日期
    ,log_open_org_rgst_ext_rating_rest_cd -- 保函开立机构注册地外部评级结果代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_log_info_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,log_id -- 保函编号
    ,log_kind_cd -- 保函种类代码
    ,issue_cty_cd -- 开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,open_org_rgst_cd -- 开立机构注册地代码
    ,stage_guar_flg -- 阶段性担保标志
    ,irevbl_flg -- 不可撤销标志
    ,log_amt -- 保函金额
    ,curr_cd -- 币种代码
    ,log_open_org_ext_rating_rest_cd -- 保函开立机构外部评级结果代码
    ,log_open_org_ext_rating_dt -- 保函开立机构外部评级日期
    ,log_open_org_intnal_rating_rest_cd -- 保函开立机构内部评级结果代码
    ,log_open_org_intnal_rating_dt -- 保函开立机构内部评级日期
    ,log_open_org_rgst_ext_rating_rest_cd -- 保函开立机构注册地外部评级结果代码
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
    ,nvl(n.log_id, o.log_id) as log_id -- 保函编号
    ,nvl(n.log_kind_cd, o.log_kind_cd) as log_kind_cd -- 保函种类代码
    ,nvl(n.issue_cty_cd, o.issue_cty_cd) as issue_cty_cd -- 开证国家代码
    ,nvl(n.open_org_name, o.open_org_name) as open_org_name -- 开立机构名称
    ,nvl(n.open_org_type_cd, o.open_org_type_cd) as open_org_type_cd -- 开立机构类型代码
    ,nvl(n.open_org_rgst_cd, o.open_org_rgst_cd) as open_org_rgst_cd -- 开立机构注册地代码
    ,nvl(n.stage_guar_flg, o.stage_guar_flg) as stage_guar_flg -- 阶段性担保标志
    ,nvl(n.irevbl_flg, o.irevbl_flg) as irevbl_flg -- 不可撤销标志
    ,nvl(n.log_amt, o.log_amt) as log_amt -- 保函金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.log_open_org_ext_rating_rest_cd, o.log_open_org_ext_rating_rest_cd) as log_open_org_ext_rating_rest_cd -- 保函开立机构外部评级结果代码
    ,nvl(n.log_open_org_ext_rating_dt, o.log_open_org_ext_rating_dt) as log_open_org_ext_rating_dt -- 保函开立机构外部评级日期
    ,nvl(n.log_open_org_intnal_rating_rest_cd, o.log_open_org_intnal_rating_rest_cd) as log_open_org_intnal_rating_rest_cd -- 保函开立机构内部评级结果代码
    ,nvl(n.log_open_org_intnal_rating_dt, o.log_open_org_intnal_rating_dt) as log_open_org_intnal_rating_dt -- 保函开立机构内部评级日期
    ,nvl(n.log_open_org_rgst_ext_rating_rest_cd, o.log_open_org_rgst_ext_rating_rest_cd) as log_open_org_rgst_ext_rating_rest_cd -- 保函开立机构注册地外部评级结果代码
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
from ${iml_schema}.ast_col_log_info_mimsf1_tm n
    full join (select * from ${iml_schema}.ast_col_log_info_mimsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.log_id <> n.log_id
        or o.log_kind_cd <> n.log_kind_cd
        or o.issue_cty_cd <> n.issue_cty_cd
        or o.open_org_name <> n.open_org_name
        or o.open_org_type_cd <> n.open_org_type_cd
        or o.open_org_rgst_cd <> n.open_org_rgst_cd
        or o.stage_guar_flg <> n.stage_guar_flg
        or o.irevbl_flg <> n.irevbl_flg
        or o.log_amt <> n.log_amt
        or o.curr_cd <> n.curr_cd
        or o.log_open_org_ext_rating_rest_cd <> n.log_open_org_ext_rating_rest_cd
        or o.log_open_org_ext_rating_dt <> n.log_open_org_ext_rating_dt
        or o.log_open_org_intnal_rating_rest_cd <> n.log_open_org_intnal_rating_rest_cd
        or o.log_open_org_intnal_rating_dt <> n.log_open_org_intnal_rating_dt
        or o.log_open_org_rgst_ext_rating_rest_cd <> n.log_open_org_rgst_ext_rating_rest_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_log_info_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,log_id -- 保函编号
    ,log_kind_cd -- 保函种类代码
    ,issue_cty_cd -- 开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,open_org_rgst_cd -- 开立机构注册地代码
    ,stage_guar_flg -- 阶段性担保标志
    ,irevbl_flg -- 不可撤销标志
    ,log_amt -- 保函金额
    ,curr_cd -- 币种代码
    ,log_open_org_ext_rating_rest_cd -- 保函开立机构外部评级结果代码
    ,log_open_org_ext_rating_dt -- 保函开立机构外部评级日期
    ,log_open_org_intnal_rating_rest_cd -- 保函开立机构内部评级结果代码
    ,log_open_org_intnal_rating_dt -- 保函开立机构内部评级日期
    ,log_open_org_rgst_ext_rating_rest_cd -- 保函开立机构注册地外部评级结果代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_log_info_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,log_id -- 保函编号
    ,log_kind_cd -- 保函种类代码
    ,issue_cty_cd -- 开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,open_org_rgst_cd -- 开立机构注册地代码
    ,stage_guar_flg -- 阶段性担保标志
    ,irevbl_flg -- 不可撤销标志
    ,log_amt -- 保函金额
    ,curr_cd -- 币种代码
    ,log_open_org_ext_rating_rest_cd -- 保函开立机构外部评级结果代码
    ,log_open_org_ext_rating_dt -- 保函开立机构外部评级日期
    ,log_open_org_intnal_rating_rest_cd -- 保函开立机构内部评级结果代码
    ,log_open_org_intnal_rating_dt -- 保函开立机构内部评级日期
    ,log_open_org_rgst_ext_rating_rest_cd -- 保函开立机构注册地外部评级结果代码
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
    ,o.log_id -- 保函编号
    ,o.log_kind_cd -- 保函种类代码
    ,o.issue_cty_cd -- 开证国家代码
    ,o.open_org_name -- 开立机构名称
    ,o.open_org_type_cd -- 开立机构类型代码
    ,o.open_org_rgst_cd -- 开立机构注册地代码
    ,o.stage_guar_flg -- 阶段性担保标志
    ,o.irevbl_flg -- 不可撤销标志
    ,o.log_amt -- 保函金额
    ,o.curr_cd -- 币种代码
    ,o.log_open_org_ext_rating_rest_cd -- 保函开立机构外部评级结果代码
    ,o.log_open_org_ext_rating_dt -- 保函开立机构外部评级日期
    ,o.log_open_org_intnal_rating_rest_cd -- 保函开立机构内部评级结果代码
    ,o.log_open_org_intnal_rating_dt -- 保函开立机构内部评级日期
    ,o.log_open_org_rgst_ext_rating_rest_cd -- 保函开立机构注册地外部评级结果代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_log_info_mimsf1_bk o
    left join ${iml_schema}.ast_col_log_info_mimsf1_op n
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_col_log_info_mimsf1_cl d
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
--truncate table ${iml_schema}.ast_col_log_info;
alter table ${iml_schema}.ast_col_log_info truncate partition for ('mimsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ast_col_log_info exchange subpartition p_mimsf1_19000101 with table ${iml_schema}.ast_col_log_info_mimsf1_cl;
alter table ${iml_schema}.ast_col_log_info exchange subpartition p_mimsf1_20991231 with table ${iml_schema}.ast_col_log_info_mimsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_log_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_log_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_log_info_mimsf1_op purge;
drop table ${iml_schema}.ast_col_log_info_mimsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_col_log_info_mimsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_log_info', partname => 'p_mimsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
