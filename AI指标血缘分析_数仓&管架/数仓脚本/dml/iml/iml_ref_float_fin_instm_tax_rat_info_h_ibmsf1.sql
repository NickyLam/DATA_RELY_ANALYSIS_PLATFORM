/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_float_fin_instm_tax_rat_info_h_ibmsf1
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
alter table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ibmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_float_fin_instm_tax_rat_info_h partition for ('ibmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_tm purge;
drop table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_op purge;
drop table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_tm nologging
compress ${option_switch} for query high
as select
    tax_rat_id -- 税率编号
    ,lp_id -- 法人编号
    ,vat_entry_type_cd -- 增值税分录类型代码
    ,tax_rat_pl_type_cd -- 税率损益类型代码
    ,tax_rat -- 税率
    ,prod_type_id -- 产品类型编号
    ,prod_cls_name -- 产品分类名称
    ,open_invoice_request_cd -- 开票要求代码
    ,tax_way_cd -- 计税方式代码
    ,taxable_way_cd -- 应税方式代码
    ,tax_rat_status_cd -- 税率状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_float_fin_instm_tax_rat_info_h partition for ('ibmsf1')
where 0=1
;

create table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_float_fin_instm_tax_rat_info_h partition for ('ibmsf1') where 0=1;

create table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_float_fin_instm_tax_rat_info_h partition for ('ibmsf1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_xcc_instrument_tax_rate-1
insert into ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_tm(
    tax_rat_id -- 税率编号
    ,lp_id -- 法人编号
    ,vat_entry_type_cd -- 增值税分录类型代码
    ,tax_rat_pl_type_cd -- 税率损益类型代码
    ,tax_rat -- 税率
    ,prod_type_id -- 产品类型编号
    ,prod_cls_name -- 产品分类名称
    ,open_invoice_request_cd -- 开票要求代码
    ,tax_way_cd -- 计税方式代码
    ,taxable_way_cd -- 应税方式代码
    ,tax_rat_status_cd -- 税率状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.RATE_ID -- 税率编号
    ,'9999' -- 法人编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TAX_OUTPUT_TYPE END -- 增值税分录类型代码
    ,nvl(trim(P1.TAX_RATE_FIELD),'-') -- 税率损益类型代码
    ,P1.TAX_RATE -- 税率
    ,P1.P_TYPE -- 产品类型编号
    ,P1.P_CLASS -- 产品分类名称
    ,nvl(trim(P1.TAX_BILLREQ),'-') -- 开票要求代码
    ,nvl(trim(P1.TAX_METHODCAL),'-') -- 计税方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TAX_TYPE_RATE END -- 应税方式代码
    ,nvl(trim(P1.STATUS),'-') -- 税率状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.BEG_DATE) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.END_DATE) -- 失效日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_xcc_instrument_tax_rate' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate p1
    left join ${iml_schema}.ref_pub_cd_map r2 on to_char(P1.TAX_OUTPUT_TYPE)= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_XCC_INSTRUMENT_TAX_RATE'
        AND R2.SRC_FIELD_EN_NAME= 'TAX_OUTPUT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'REF_FLOAT_FIN_INSTM_TAX_RAT_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'VAT_ENTRY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on to_char(P1.TAX_TYPE_RATE)= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_XCC_INSTRUMENT_TAX_RATE'
        AND R3.SRC_FIELD_EN_NAME= 'TAX_TYPE_RATE'
        AND R3.TARGET_TAB_EN_NAME= 'REF_FLOAT_FIN_INSTM_TAX_RAT_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TAXABLE_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_tm 
  	                                group by 
  	                                        tax_rat_id
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
        into ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_cl(
            tax_rat_id -- 税率编号
    ,lp_id -- 法人编号
    ,vat_entry_type_cd -- 增值税分录类型代码
    ,tax_rat_pl_type_cd -- 税率损益类型代码
    ,tax_rat -- 税率
    ,prod_type_id -- 产品类型编号
    ,prod_cls_name -- 产品分类名称
    ,open_invoice_request_cd -- 开票要求代码
    ,tax_way_cd -- 计税方式代码
    ,taxable_way_cd -- 应税方式代码
    ,tax_rat_status_cd -- 税率状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_op(
            tax_rat_id -- 税率编号
    ,lp_id -- 法人编号
    ,vat_entry_type_cd -- 增值税分录类型代码
    ,tax_rat_pl_type_cd -- 税率损益类型代码
    ,tax_rat -- 税率
    ,prod_type_id -- 产品类型编号
    ,prod_cls_name -- 产品分类名称
    ,open_invoice_request_cd -- 开票要求代码
    ,tax_way_cd -- 计税方式代码
    ,taxable_way_cd -- 应税方式代码
    ,tax_rat_status_cd -- 税率状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tax_rat_id, o.tax_rat_id) as tax_rat_id -- 税率编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.vat_entry_type_cd, o.vat_entry_type_cd) as vat_entry_type_cd -- 增值税分录类型代码
    ,nvl(n.tax_rat_pl_type_cd, o.tax_rat_pl_type_cd) as tax_rat_pl_type_cd -- 税率损益类型代码
    ,nvl(n.tax_rat, o.tax_rat) as tax_rat -- 税率
    ,nvl(n.prod_type_id, o.prod_type_id) as prod_type_id -- 产品类型编号
    ,nvl(n.prod_cls_name, o.prod_cls_name) as prod_cls_name -- 产品分类名称
    ,nvl(n.open_invoice_request_cd, o.open_invoice_request_cd) as open_invoice_request_cd -- 开票要求代码
    ,nvl(n.tax_way_cd, o.tax_way_cd) as tax_way_cd -- 计税方式代码
    ,nvl(n.taxable_way_cd, o.taxable_way_cd) as taxable_way_cd -- 应税方式代码
    ,nvl(n.tax_rat_status_cd, o.tax_rat_status_cd) as tax_rat_status_cd -- 税率状态代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,case when
            n.tax_rat_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tax_rat_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tax_rat_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_tm n
    full join (select * from ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.tax_rat_id = n.tax_rat_id
            and o.lp_id = n.lp_id
where (
        o.tax_rat_id is null
        and o.lp_id is null
    )
    or (
        n.tax_rat_id is null
        and n.lp_id is null
    )
    or (
        o.vat_entry_type_cd <> n.vat_entry_type_cd
        or o.tax_rat_pl_type_cd <> n.tax_rat_pl_type_cd
        or o.tax_rat <> n.tax_rat
        or o.prod_type_id <> n.prod_type_id
        or o.prod_cls_name <> n.prod_cls_name
        or o.open_invoice_request_cd <> n.open_invoice_request_cd
        or o.tax_way_cd <> n.tax_way_cd
        or o.taxable_way_cd <> n.taxable_way_cd
        or o.tax_rat_status_cd <> n.tax_rat_status_cd
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_cl(
            tax_rat_id -- 税率编号
    ,lp_id -- 法人编号
    ,vat_entry_type_cd -- 增值税分录类型代码
    ,tax_rat_pl_type_cd -- 税率损益类型代码
    ,tax_rat -- 税率
    ,prod_type_id -- 产品类型编号
    ,prod_cls_name -- 产品分类名称
    ,open_invoice_request_cd -- 开票要求代码
    ,tax_way_cd -- 计税方式代码
    ,taxable_way_cd -- 应税方式代码
    ,tax_rat_status_cd -- 税率状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_op(
            tax_rat_id -- 税率编号
    ,lp_id -- 法人编号
    ,vat_entry_type_cd -- 增值税分录类型代码
    ,tax_rat_pl_type_cd -- 税率损益类型代码
    ,tax_rat -- 税率
    ,prod_type_id -- 产品类型编号
    ,prod_cls_name -- 产品分类名称
    ,open_invoice_request_cd -- 开票要求代码
    ,tax_way_cd -- 计税方式代码
    ,taxable_way_cd -- 应税方式代码
    ,tax_rat_status_cd -- 税率状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tax_rat_id -- 税率编号
    ,o.lp_id -- 法人编号
    ,o.vat_entry_type_cd -- 增值税分录类型代码
    ,o.tax_rat_pl_type_cd -- 税率损益类型代码
    ,o.tax_rat -- 税率
    ,o.prod_type_id -- 产品类型编号
    ,o.prod_cls_name -- 产品分类名称
    ,o.open_invoice_request_cd -- 开票要求代码
    ,o.tax_way_cd -- 计税方式代码
    ,o.taxable_way_cd -- 应税方式代码
    ,o.tax_rat_status_cd -- 税率状态代码
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
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
from ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_bk o
    left join ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_op n
        on
            o.tax_rat_id = n.tax_rat_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_cl d
        on
            o.tax_rat_id = d.tax_rat_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h;
--alter table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h truncate partition for ('ibmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_float_fin_instm_tax_rat_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ibmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h modify partition p_ibmsf1 
add subpartition p_ibmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_cl;
alter table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h exchange subpartition p_ibmsf1_20991231 with table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_float_fin_instm_tax_rat_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_tm purge;
drop table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_op purge;
drop table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_float_fin_instm_tax_rat_info_h_ibmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_float_fin_instm_tax_rat_info_h', partname => 'p_ibmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
